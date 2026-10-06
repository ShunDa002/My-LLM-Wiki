`useEffect` hook lets us perform __side effects__ in __functional components__. The side effects such as updating the DOM, fetching data from an API endpoint, and setting up subscription or timer.
It is a close replacement for __componentDidMount__, __componentDidUpdate__ and __componentWillUnmount__.

## Lifecycle Methods Implementation in Class component
Updating the document title to the current counter value. On initial render, we set the document title to `Clicked 0 times`, so this code goes in `componentDidMount()` lifecycle method which is executed only once in the component lifecycle. When the button of incrementing the count state value was clicked, the count value increments, and we updates the document title again with `componentDidUpdate()` lifecycle method that is called anytime when the component updates.
``` javascript
import React, { Component } from "react";

export class ClassCounterOne extends Component {
  constructor(props) {
    super(props);

    this.state = {
      count: 0,
    };
  }

  componentDidMount() {
    document.title = `Clicked ${this.state.count} times`;
  }

  componentDidUpdate() {
    document.title = `Clicked ${this.state.count} times`;
  }

  render() {
    return (
      <div>
        <button onClick={() => this.setState({ count: this.state.count + 1 })}>
          Click {this.state.count} times
        </button>
      </div>
    );
  }
}

export default ClassCounterOne;
```

## useEffect() Implementation in Functional component
Updating the document title to the current counter value with `useEffect()`.
``` javascript
import React, { useState, useEffect } from "react";

function HookCounterOne() {
  const [count, setCount] = useState(0);

  useEffect(() => {
    document.title = `Clicked ${count} times`;
  });

  return (
    <div>
      <button onClick={() => setCount(count + 1)}>Click {count} times</button>
    </div>
  );
}

export default HookCounterOne;
```
`useEffect()` accepts a function as the parameter which gets executed after every render of the component. `useEffect()` runs after every render of the component.

## Conditionally Run Effects
In some cases, applying the effect after every render might cause a performance problem, so we need to conditionally run an effect.
### Class Component Implementation:
``` javascript
import React, { Component } from "react";

export class ClassCounterOne extends Component {
  constructor(props) {
    super(props);

    this.state = {
      count: 0,
      name: "",
    };
  }

  componentDidMount() {
    document.title = `Clicked ${this.state.count} times`;
  }

  componentDidUpdate(prevProps, prevState) {
    if (prevState.count !== this.state.count) {
      console.log("Updating document title");
      document.title = `Clicked ${this.state.count} times`;
    }
  }

  render() {
    return (
      <div>
        <input
          type="text"
          value={this.state.name}
          onChange={(e) => this.setState({ name: e.target.value })}
        />
        <button onClick={() => this.setState({ count: this.state.count + 1 })}>
          Click {this.state.count} times
        </button>
      </div>
    );
  }
}

export default ClassCounterOne;
```
We include the parameters (prevProps, prevState) for `componentDidUpdate()`, then we check if previous count is different from current state count, and only then update the document title. So we compare the count value before and after the update, and if the count value changed, we then conditionally update the title.

### Functional Component Implementation
`useEffect()` accepts the second parameter of an array, that we specify either `props` or `state` that we watch for. Only if those `props` or `state` specified in this array were to change, the effect will be executed.
``` javascript
import React, { useState, useEffect } from "react";

function HookCounterOne() {
  const [count, setCount] = useState(0);
  const [name, setName] = useState("");

  useEffect(() => {
    console.log("Updating document title");
    document.title = `Clicked ${count} times`;
  }, [count]); // Only re-run the effect if count value changes

  return (
    <div>
      <input
        type="text"
        value={name}
        onChange={(e) => setName(e.target.value)}
      />
      <button onClick={() => setCount(count + 1)}>Click {count} times</button>
    </div>
  );
}

export default HookCounterOne;
```
In this example, we need the effect to be executed only when the count value changes, so within the array we include count.

## Run Effect Only Once on Initial Render
### componentDidMount() in Class Component
``` javascript
import React, { Component } from "react";

class ClassMouse extends Component {
  constructor(props) {
    super(props);

    this.state = {
      x: 0,
      y: 0,
    };
  }

  logMousePosition = (e) => {
    console.log("Mouse event");
    this.setState({ x: e.clientX, y: e.clientY });
  };

  componentDidMount() {
    console.log("ClassMouse component mounted");
    window.addEventListener("mousemove", this.logMousePosition);
  }

  render() {
    return (
      <div>
        X - {this.state.x} Y - {this.state.y}
      </div>
    );
  }
}

export default ClassMouse;
```
We set up the event listener only once and that is in `componentDidMount()` .
### useEffect() in Functional Component
``` javascript
import React, { useState, useEffect } from "react";

function HookMouse() {
  const [x, setX] = useState(0);
  const [y, setY] = useState(0);

  const logMousePosition = (e) => {
    console.log("Mouse event");
    setX(e.clientX);
    setY(e.clientY);
  };

  useEffect(() => {
    console.log("useEffect called");
    window.addEventListener("mousemove", logMousePosition);
  }, []); // Empty array means this effect does not depend on any props or state, so this effect only be called once on initial render.

  return (
    <div>
      Hooks X - {x} Y - {y}
    </div>
  );
}

export default HookMouse;
```
We do not want the effect to depend on anything, we want it to be called once at on initial render only, so we specify an empty array as the second argument to `useEffect()` . Empty array means this particular effect does not depend on any props or state, so there is no reason to call this effect on re-render, so this effect only be called once on initial render.

