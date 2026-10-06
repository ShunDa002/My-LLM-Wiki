# LangSmith
LangSmith is a LLMOps tool, used for monitoring and evaluation. 
## Observability with LangSmith
LangSmith is a debugging, monitoring, and evaluation platform for applications built with LLMs and AI agents. It is made by the LangChain team, but it can also work with applications that do not use LangChain.
### Why it is useful?
When your chatbot receives a question, several hidden operations may happen:
User question => Prompt construction => LLM call => Tool or database call => Memory/checkpoint retrieval => Final response
### What happen when using LangSmith
LangSmith records this complete execution as a trace, allowing you to inspect every step, including inputs, outputs, errors, execution time, token usage, tool calls, and model behavior.
For your LangGraph Agentic chatbot, LangSmith can help you:
- Find why an agent selected the wrong tool.
- Inspect the exact prompt sent to the model.
- Debug failed nodes in the LangGraph workflow.
- Measure response latency and token costs.
- Review conversations and multi-turn threads.
- Compare different prompts or model versions.
- Evaluate chatbot quality before and after deployment.
## Enable LangSmith
1. Add .env variable
```
LANGSMITH_TRACING="true"
LANGSMITH_ENDPOINT="https://api.smith.langchain.com"
LANGSMITH_API_KEY="<YOUR_LANGSMITH_API_KEY>"
LANGSMITH_PROJECT="<project-name>"
```
2. Separate out the threads inside LangSmith by passing the configuration when invoking chatbot/workflow
``` python
CONFIG = {
    "configurable": {"thread_id": thread_id},
    "metadata": {
        "thread_id": thread_id
    },  # These extra params are to separate out the threads inside LangSmith
    "run_name": "chat_trace",
}
```





# LangServe
Langserve is used for deployment and it can create API for the LLM application. It actually uses FastAPI in the backend.



# LangGraph
Langgraph is used to create agent and multi agents. Agent is a LLM that is connecting third party tools. 