---
title: React Hooks
type: concept
status: active
classification: public
aliases: ["Hooks"]
tags: ["react", "frontend", "architecture"]
sources:
  - "[[Source - React Hooks Intro]]"
created: 2026-10-06
updated: 2026-10-06
confidence: high
knowledge_status: current
review_needed: false
---

# React Hooks

## Definition

React Hooks are functional APIs introduced in React version 16.8 that allow developers to use state, lifecycle events, and other core React features directly inside functional components without having to write class-based components.

## Key points

- **Simplifying Component Logic**: Hooks eliminate the confusion associated with the JavaScript `this` keyword and the necessity of manually binding event handlers, which are persistent pain points in class components [[Source - React Hooks Intro]].
- **Reusability**: Before Hooks, reusing stateful component logic required complex patterns like Higher-Order Components (HOCs) or render props, which made code harder to follow. Hooks provide a direct API to abstract and reuse stateful logic seamlessly [[Source - React Hooks Intro]].
- **Code Organization**: In class components, related code (such as data fetching or setting up and tearing down event subscriptions) is often forcibly split across different lifecycle methods (like `componentDidMount` and `componentWillUnmount`). Hooks allow developers to organize related logic into single, isolated, and cohesive units [[Source - React Hooks Intro]].
- **Compatibility**: Hooks are entirely opt-in and 100% backwards-compatible. They do not replace existing React concepts or remove class components; they simply offer a more direct interface to the React ecosystem [[Source - React Hooks Intro]].

## Relationships

- Related: [[useEffect (React)]]
- Related: [[useState (React)]]
