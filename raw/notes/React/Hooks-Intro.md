# What are Hooks?
- Hooks are a new feature addition in React version 16.8 which allow you to use React features without having to write a class.
	- Ex: State of a component
- Hooks don't work inside classes

# Why Hooks?
## Reason Set 1
- Understand how __this__ keyword works in JavaScript
- Remember to bind event handlers in class components
- Classes don't minify very well and make hot reloading very unreliable
## Reason Set 2
- There is no particular way to reuse stateful component logic
- HOC and render props patterns do address this problem
- Makes the code harder to follow
- There is a need to share stateful logic in a better way
## Reason Set 3
- Create components for complex scenarios such as data fetching and subscribing to events
- Related code is not organized in one place
	- Ex: Data fetching - In componentDidMount and componentDidUpdate
	- Ex: Event listeners - In componentDidMount and componentWillUnmount
- Because of stateful logic - Cannot break components into smaller ones

# Noteworthy Points
- React version 16.8 or higher
- Completely opt in
- Hooks don't contain any breaking changes and the release is 100% backwards-compatible.
- Classes won't be removed from React
- Can't use Hooks inside of a class component
- Hooks don't replace your existing knowledge of React concepts
- Instead, Hooks provide a more direct API to the React concepts you already know

# Summary
- Hooks are a new feature addition in React version 16.8
- They allow you to use React features without having to write a class
- Avoid the whole confusion with 'this' keyword
- Allow you to reuse stateful logic
- Organize the logic inside a component into reusable isolated units