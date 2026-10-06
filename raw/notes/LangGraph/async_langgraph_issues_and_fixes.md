# Async LangGraph Chat API: Issues and Fixes

## Overview

The FastAPI chatbot endpoint used LangGraph streaming with NDJSON, model selection, tools, and SQLite checkpoint persistence. Several independent issues appeared across the frontend, API layer, agent factory, and persistence layer.

## 1. Model resolver could return `None`

### Issue

`model_and_provider()` returned only inside model lookup branches. When the requested model was missing or invalid, Python could implicitly return `None`.

This could cause an unpacking error:

```text
TypeError: cannot unpack non-iterable NoneType object
```

The declared return type was also incorrect because the function returned a tuple rather than a string.

### Fix

- Accept `str | None`.
- Return `tuple[str, Provider]`.
- Resolve `DEFAULT_MODEL` explicitly.
- Raise a clear configuration error if the default model is unavailable.

```python
def model_and_provider(
    model_map: str | None,
) -> tuple[str, Provider]:
    model_name = (
        model_map.strip().lower()
        if model_map and model_map.strip()
        else DEFAULT_MODEL
    )

    if model_name in GROQ_MODELS:
        return GROQ_MODELS[model_name], "groq"

    if model_name in OPENROUTER_MODELS:
        return OPENROUTER_MODELS[model_name], "openrouter"

    if DEFAULT_MODEL in GROQ_MODELS:
        return GROQ_MODELS[DEFAULT_MODEL], "groq"

    if DEFAULT_MODEL in OPENROUTER_MODELS:
        return OPENROUTER_MODELS[DEFAULT_MODEL], "openrouter"

    raise ValueError(
        f"DEFAULT_MODEL {DEFAULT_MODEL!r} is not configured."
    )
```

## 2. NDJSON was parsed as normal JSON

### Issue

The `/chat` endpoint returns:

```http
Content-Type: application/x-ndjson
```

Its body contains multiple JSON objects separated by newlines:

```json
{"type":"start"}
{"type":"token","content":"Hello"}
{"type":"done"}
```

Calling `response.json()` treats the entire response as one JSON document and fails after the first object.

### Fix

The frontend must:

1. Read `response.body` as a stream.
2. Decode incoming byte chunks.
3. Buffer incomplete lines.
4. Split on newline characters.
5. Run `JSON.parse()` separately for each complete line.
6. Handle `start`, `token`, `tool_call_delta`, `tool_result`, `interrupt`, `done`, `stopped`, and `error` events.

Postman may show NDJSON as raw text but is not a reliable real-time NDJSON parser. `curl -N` is better for testing streaming behavior.

## 3. Windows CMD rejected the Unix curl syntax

### Issue

Unix examples used `\` for line continuation and single quotes for JSON. Windows Command Prompt interpreted each following line as a separate command.

### Fix

Use one line with escaped JSON:

```bat
curl.exe -N -X POST "http://127.0.0.1:8080/chat" -H "Content-Type: application/json" -H "Accept: application/x-ndjson" -d "{\"thread_id\":\"thread-test\",\"user_input\":\"Hello\",\"model\":\"free-model\"}"
```

For multiline CMD commands, use `^` instead of `\`.

## 4. The API accepted `model` but did not use it

### Issue

`ChatRequest` contained a model field, but the route eventually called:

```python
agent = get_agent()
```

The frontend selection therefore had no effect.

### Fix

Pass the model through every layer:

```text
ChatRequest.model
  -> chat_with_thread()
  -> create_chat_streaming_response()
  -> produce_chat_events()
  -> get_agent(model)
```

After making `get_agent()` asynchronous, call it with:

```python
agent = await get_agent(model)
```

For resumed workflows, either include the model in `ChatResumeRequest` or persist the selected model with the thread configuration.

## 5. The generic stream error hid the real exception

### Issue

The server emitted only:

```json
{"type":"error","message":"The chatbot response stream failed."}
```

This confirmed a backend failure but concealed its cause.

### Fix

Log the full traceback and temporarily include exception details during development:

```python
except Exception as exc:
    logger.exception(
        "Chat workflow failed: thread_id=%s run_id=%s operation=%s",
        thread_id,
        run_id,
        operation,
    )

    await queue.put(
        to_ndjson(
            {
                "type": "error",
                "thread_id": thread_id,
                "run_id": run_id,
                "operation": operation,
                "message": error_message,
                "error_type": type(exc).__name__,
                "detail": str(exc),
            }
        )
    )
```

Raw exception details should be disabled in production because they may expose sensitive information.

## 6. `SqliteSaver` was incompatible with `agent.astream()`

### Issue

The traceback showed:

```text
NotImplementedError: The SqliteSaver does not support async methods.
Consider using AsyncSqliteSaver instead.
```

The graph was executed asynchronously using `agent.astream()`, but it was compiled with the synchronous `SqliteSaver`.

### Fix

Install the asynchronous SQLite dependency:

```bat
python -m pip install aiosqlite
```

Replace:

```python
import sqlite3
from langgraph.checkpoint.sqlite import SqliteSaver
```

with:

```python
import aiosqlite
from langgraph.checkpoint.sqlite.aio import AsyncSqliteSaver
```

Create and initialize the asynchronous checkpointer:

```python
connection = await aiosqlite.connect(DATABASE_PATH)
checkpointer = AsyncSqliteSaver(connection)
await checkpointer.setup()

agent = chatbot.compile(checkpointer=checkpointer)
```

## 7. The chat node used blocking model invocation

### Issue

The graph was asynchronous, but the chat node called:

```python
llm_with_tools.invoke(messages)
```

This synchronous call could block the FastAPI event loop.

### Fix

Make the node asynchronous and use `ainvoke()`:

```python
async def chat_node(state: MessagesState) -> dict:
    messages = [
        SystemMessage(content=REM_SYSTEM_PROMPT),
        *state["messages"],
    ]

    response = await llm_with_tools.ainvoke(messages)

    return {"messages": [response]}
```

## 8. Cached agents require persistent connection ownership

### Issue

A compiled agent continues to depend on its checkpointer connection. Creating it inside a short-lived `async with` block and returning the agent would close the database before later graph execution.

### Fix

Cache both objects:

```python
_AGENT_CACHE: dict[tuple[Provider, str], object] = {}
_CONNECTION_CACHE: dict[
    tuple[Provider, str],
    aiosqlite.Connection,
] = {}
```

Use `(provider, selected_model)` as the cache key to avoid provider/model collisions.

Keep connections open while their cached agents are active, then close them during application shutdown.

## 9. Concurrent requests could build duplicate agents

### Issue

Two requests for the same uncached model could both detect a cache miss, construct duplicate agents, and open duplicate database connections.

### Fix

Protect initialization with an asynchronous lock and check the cache again after acquiring it:

```python
_AGENT_CACHE_LOCK = asyncio.Lock()

async def get_agent(model_name: str | None = None):
    selected_model, provider = model_and_provider(model_name)
    cache_key = (provider, selected_model)

    cached_agent = _AGENT_CACHE.get(cache_key)
    if cached_agent is not None:
        return cached_agent

    async with _AGENT_CACHE_LOCK:
        cached_agent = _AGENT_CACHE.get(cache_key)
        if cached_agent is not None:
            return cached_agent

        agent, connection = await build_agent(
            selected_model,
            provider,
        )

        _AGENT_CACHE[cache_key] = agent
        _CONNECTION_CACHE[cache_key] = connection
        return agent
```

## 10. Cached SQLite connections needed shutdown cleanup

### Issue

Long-lived cached connections would remain open unless explicitly closed when FastAPI shuts down.

### Fix

Create a cleanup function:

```python
async def close_agents() -> None:
    async with _AGENT_CACHE_LOCK:
        connections = list(_CONNECTION_CACHE.values())
        _AGENT_CACHE.clear()
        _CONNECTION_CACHE.clear()

    for connection in connections:
        await connection.close()
```

Call it from FastAPI lifespan management:

```python
from contextlib import asynccontextmanager

@asynccontextmanager
async def lifespan(app: FastAPI):
    try:
        yield
    finally:
        await close_agents()

app = FastAPI(lifespan=lifespan)
```

## 11. Additional API cleanup

Recommended supporting fixes:

- Move `uvicorn.run()` to the bottom of the module, after all route definitions, or launch Uvicorn from the command line.
- Remove duplicate imports such as `logging` and `dataclass`.
- Use explicit CORS origins when `allow_credentials=True`.
- Add `expose_headers=["X-Chat-Run-Id"]` if browser code needs that response header.
- Annotate `consume_chat_events()` as `AsyncIterator[str]`.
- Do not send `model: null` unless `ChatRequest.model` is declared as `str | None`.
- Use unique `thread_id` values across unrelated users to prevent state sharing.
- Consider a production database checkpointer if SQLite write contention becomes significant.

## Final architecture

```text
Browser or curl
    |
    | POST /chat
    v
FastAPI NDJSON stream
    |
    | model + thread_id + user input
    v
await get_agent(model)
    |
    | cached by (provider, resolved model)
    v
CompiledStateGraph
    |
    +-- async chat node -> LLM.ainvoke()
    |
    +-- tool node -> tool execution
    |
    +-- AsyncSqliteSaver -> checkpoint persistence
    v
NDJSON events
    start -> token/tool events -> done/error/interrupt
```

## Final validation checklist

- [ ] `aiosqlite` is installed in the active virtual environment.
- [ ] `AsyncSqliteSaver` replaces `SqliteSaver`.
- [ ] `build_agent()` and `get_agent()` are asynchronous.
- [ ] `await get_agent(model)` is used by the stream producer.
- [ ] The chat node uses `await llm_with_tools.ainvoke(...)`.
- [ ] The model value is passed from the request to the agent factory.
- [ ] The frontend parses NDJSON one line at a time.
- [ ] The server logs full exceptions.
- [ ] Cached SQLite connections are closed during FastAPI shutdown.
- [ ] `curl.exe -N` produces `start`, token events, and `done`.
