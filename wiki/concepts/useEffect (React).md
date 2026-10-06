---
title: useEffect (React)
type: concept
status: active
classification: public
aliases: ["useEffect"]
tags: ["react", "frontend", "architecture"]
sources:
  - "[[Source - React useEffect Hook]]"
created: 2026-10-06
updated: 2026-10-06
confidence: high
knowledge_status: current
review_needed: false
---

# useEffect (React)

## Definition

`useEffect` is a React Hook that enables functional components to perform side effects, acting as a unified API replacement for class-based lifecycle methods like `componentDidMount`, `componentDidUpdate`, and `componentWillUnmount`.

## Key points

- **Side Effects**: It manages operations outside of standard React rendering flow, such as DOM updates, API data fetching, setting up subscriptions, or configuring timers [[Source - React useEffect Hook]].
- **Dependency Arrays for Performance**: To avoid running effects unnecessarily after every render, `useEffect` accepts a dependency array as a second argument. The effect will selectively re-run only if the state variables or props specified within this array have changed [[Source - React useEffect Hook]].
- **Initial Mount execution**: Passing an empty dependency array (`[]`) to `useEffect` guarantees the effect will execute exactly once during the component's initial render, closely mirroring the behavior of the legacy `componentDidMount` method [[Source - React useEffect Hook]].

## Relationships

- Related: [[React Hooks]]
