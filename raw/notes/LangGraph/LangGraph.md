# LangGraph helps solve the **limitations of using LangChain alone for complex workflows**:
### 1. Control Flow Complexity
- Conditional branches, loops, and jumps
- LangChain does not provide built-in graph-based functionality for defining complex workflow blocks. Therefore, extra manual code, also known as glue code, may need to be written to implement conditional branches, loops, or jumps back to previous steps.
- LangGraph provides nodes, edges, and conditional edges to represent these execution paths explicitly.
### 2. Handling State
- State is structured data that is shared across the entire workflow.
- The workflow or agent refers to the state data to determine the next step.
- The state data may be updated after each node execution.
- LangChain has memory features for storing conversation history and agent context, but it does not provide the same explicit graph-state model for storing and updating key-value data across a custom workflow.
- LangGraph allows each node to read the current state and return updates that can be used by subsequent nodes.  
### 3. Event-Driven Execution
- A workflow can be sequential or event-driven.
- Sequential execution is similar to a chain in LangChain, where the chain links runnables or executables together. The execution generally moves from one step to the next according to the defined sequence.
- An interruptible or event-driven workflow can pause at a particular step, wait for human input or an external event, and resume later.
- LangGraph supports persistent state and interrupts, allowing the workflow to preserve its data while it is paused and use that data when execution resumes.
- External triggers and event scheduling may still depend on the deployment platform or surrounding application infrastructure.
### 4. Fault Tolerance
- A workflow-level fault can occur during execution. For example, a runnable or executable may fail because a third-party API is temporarily unavailable.
- An infrastructure-level fault can occur when the environment hosting the workflow becomes unavailable. For example, the application infrastructure on AWS may experience an outage.
- A LangChain chain may stop if one of its steps fails. Without custom retry or persistence logic, rerunning the workflow may cause it to start again from the beginning.
- LangGraph supports durable execution and checkpoint-based recovery. This allows a workflow to preserve its progress and resume from an appropriate checkpoint after an interruption or recoverable failure.
- LangGraph handles this using checkpointing and persistent state. A checkpointer saves snapshots of the workflow state as execution progresses.
- However, LangGraph does not automatically protect against every infrastructure failure. Recovery from a complete AWS region, database, or storage outage depends on how the application and checkpoint storage are deployed.
- Retries, checkpointing, and infrastructure recovery serve different purposes:
- Retries attempt a failed operation again.
- Checkpointing saves the workflow’s progress.
- Infrastructure recovery ensures that the application and its stored checkpoints remain available after a larger outage.
### 5. Human in the Loop (HITL)
- LangChain can accept human input through custom application logic or supported agent hooks, but pausing and resuming a complex workflow requires additional implementation.
- LangGraph provides first-class human-in-the-loop support through interrupts.
- A LangGraph workflow can pause at a specific point, save its current state, wait for human input, and resume after receiving the input.
### 6. Nested Workflows
- LangGraph allows a graph to be embedded as a node within another graph. This is known as a subgraph.
- Subgraphs make it possible to divide a large workflow into smaller, reusable workflows.
- This is useful for multi-agent systems, where each specialist agent may have its own subgraph.
### 7. Observability
- LangChain has an observability platform called LangSmith.
- However, implementing a complex workflow with LangChain and ordinary application code may result in a large amount of glue code, LangSmith does not monitor those glue code.
- LangSmith can trace applications built with both LangChain and LangGraph.
- Because a LangGraph workflow is divided into nodes and transitions, the execution of each node can be traced more clearly in LangSmith.
- This makes it easier to monitor:
	- Node inputs and outputs
	- Model and tool calls
	- State updates
	- Conditional routing
	- Execution time
	- Errors and failed nodes
	- Subgraph execution

# 1. What is LangGraph?
- Think of LangGraph as a flowchart engine for LLMs - you define the steps (nodes), how they're connected (edges), and the logic that governs the transitions.
- LangGraph takes care of state management, conditional branching, looping, pausing/resuming, memory, and fault recovery - features essential for building robust, production-grade Al systems.
- It models your logic as a graph of nodes (tasks) and edges (routing) instead of a linear chain.
# 2. When to Use What?
- Use LangChain when you're building simple, linear workflows - like a prompt chain, summarizer, or a basic retrieval system.
- Use LangGraph when your use case involves complex, non-linear workflows that need:
    - Conditional paths
    - Loops
    - Human-in-the-loop steps
    - Multi-agent coordination
    - Asynchronous or event-driven execution
# 3. Should we still use LangChain?
__Yes__. LangGraph is built __on top of LangChain__ - it doesn't replace it.
You'll still use __LangChain components__ like:
- ChatOpenAI (LLMs)
- PromptTemplate
- Retrievers
- DocumentLoaders
- Tools, etc.
LangGraph handles __workflow orchestration__, while LangChain provides the __building blocks__ for each step in that workflow.