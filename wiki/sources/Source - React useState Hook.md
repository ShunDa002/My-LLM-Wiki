---
title: Source - React useState Hook
type: source
raw_file: "[[raw/notes/React/useState-Hook.md]]"
source_id: a29b0bbd2ff40698def1aba0348fc1755bd7394b97b08fcba7b4d75e9b41622b
source_kind: notes
author: Unknown
classification: public
captured: 2026-10-06
ingested: 2026-10-06
status: processed
---

# Source - React useState Hook

## What this source is

A technical note detailing the purpose and implementation patterns of the `useState` Hook in React.

## Claims taken from it

- `useState` allows developers to add state to functional components. Unlike class component state, which must be an object, `useState` supports non-object primitives.
- The hook returns an array containing exactly two elements: the current state value, and a state setter function.
- If the new state depends on the previous state value, it is safer to pass a callback function to the state setter (which receives the previous state) rather than passing the raw new value.
- Unlike the `setState` method in class components, the setter function returned by `useState` does not automatically merge properties in objects or arrays. Developers must manually merge them, typically using the JavaScript spread operator (`...`).

## What it changed in the Wiki

- Created: [[useState (React)]]
- Updated: [[React Hooks]] — added relationships link.

## Not used

- Literal code implementations of `HookCounterOne` through `HookCounterFour`, as the core architectural limitations and patterns they demonstrate are abstracted into the concept page directly.
