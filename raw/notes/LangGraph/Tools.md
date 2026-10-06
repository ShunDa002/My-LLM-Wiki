# Tool
Tool is a kind of functions/API that agent can use to get the latest information or perform any actions.

In __Agentic AI__, __tools__ are external functions, APIs, databases, or services that an AI agent can use to perform actions beyond generating text.
A normal LLM can only respond based on its knowledge and the information in the prompt. An AI agent with tools can __search, calculate, retrieve data, execute code, update databases, or interact with other systems__.

## Simple example
Suppose a user asks:
“What is the current weather in Texas?”
The agent does not know the live weather by itself. It can call a weather tool:
get_weather(city="Texas")
The tool returns the current weather, and the agent uses that result to answer the user.

## Common tools in Agentic AI
- Web search tool — searches for current information.
- Calculator tool — performs accurate mathematical calculations.
- Database tool — reads or writes data.
- RAG retriever tool — searches documents or vector databases.
- Python tool — executes code and analyzes data.
- Email tool — reads, drafts, or sends emails.
- Calendar tool — checks availability or creates events.
- API tool — communicates with services such as weather, finance, CRM, or payment systems.
- Custom business tools — create tickets, check inventory, generate reports, or update customer records.

## How tool calling works
The typical workflow is:
1. The user gives a request.
2. The agent understands the goal.
3. The agent decides whether a tool is required.
4. It selects the appropriate tool.
5. It generates the tool arguments.
6. The tool executes the action.
7. The result is returned to the agent.
8. The agent produces the final response.


### Example:

User: What is 25% of 8,500?

Agent decides:
Use calculator tool

Tool call:
8500 * 0.25

Tool result:
2125

Agent response:
25% of 8,500 is 2,125.