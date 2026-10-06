---
title: Application Programming Interface (API)
type: concept
status: active
classification: public
aliases: ["API", "APIs", "REST", "RESTful"]
tags: ["architecture", "web", "rest"]
sources:
  - "[[Source - Application Programming Interfaces]]"
created: 2026-10-06
updated: 2026-10-06
confidence: high
knowledge_status: current
review_needed: false
---

# Application Programming Interface (API)

## Definition

An Application Programming Interface (API) is a formalized entry point exposed by an application to allow external clients to invoke code or manipulate internal data. Over a network context, these endpoints require strict structural conventions to ensure cohesive team collaboration and predictable client-server integration [[Source - Application Programming Interfaces]].

## RESTful Architecture

Representational State Transfer (REST) is a prevalent, language-and-framework-agnostic architectural style for web APIs. It is uniquely tailored for decoupled, frontend/backend application models [[Source - Application Programming Interfaces]].

### Resource-Oriented Design

In REST, API endpoints are designed around data "resources" rather than arbitrary functions.
- **URLs represent the nouns**: The network address identifies the target entity (e.g., `/student/` to indicate the concept of a student, or `/student/1` to target a specific student by ID) [[Source - Application Programming Interfaces]].
- **HTTP Methods represent the verbs**: To manipulate the resource, REST strictly leverages standardized HTTP request methods to indicate the intent [[Source - Application Programming Interfaces]]:
  - **POST**: Create a new resource.
  - **GET**: Retrieve existing resources.
  - **PUT**: Perform a full replacement/modification of an existing resource.
  - **PATCH**: Perform a localized/partial modification of an existing resource.
  - **DELETE**: Remove an existing resource.

## Relationships

- None
