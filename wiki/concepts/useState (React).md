---
title: useState (React)
type: concept
status: active
classification: public
aliases: ["useState"]
tags: ["react", "frontend", "architecture"]
sources:
  - "[[Source - React useState Hook]]"
created: 2026-10-06
updated: 2026-10-06
confidence: high
knowledge_status: current
review_needed: false
---

# useState (React)

## Definition

`useState` is a React Hook that allows functional components to maintain internal state. It returns an array containing the current state value and a function to update it. 

## Key points

- **Primitive Support**: Unlike legacy class component state which mandates an object structure, `useState` natively supports storing non-object primitives (strings, integers, booleans) directly [[Source - React useState Hook]].
- **Functional Updates**: When computing a new state that depends on the previous state value, passing a callback function to the setter (e.g., `setCount((prevCount) => prevCount + 1)`) is the correct and safe implementation [[Source - React useState Hook]].
- **No Automatic Merging**: A critical difference between `useState` and class `setState` is that the `useState` setter function does *not* automatically merge properties when dealing with objects or arrays. Updating an object or array state requires manual merging, conventionally done using the JavaScript spread operator (`...`) before applying the new fields [[Source - React useState Hook]].

## Relationships

- Related: [[React Hooks]]
