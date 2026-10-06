A Hook is just a special function that lets us hook into React features. So `useState()` is a hook that lets us add React state to functional component.

## React state in Class component
### Three steps to implement the state:
1. Create component, which is class component in this case.
2. Create a state variable, which is initialized to `0` in this case.
3. Create a method that is capable of setting the state value.
### Code implementation:
``` javascript
import React, { Component } from "react";
// Class component
class ClassCounter extends Component {
  constructor(props) {
    super(props);
// State variable was defined
    this.state = {
      count: 0,
    };
  }

// Method updating state was defined
  incrementCount = () => {
    this.setState({ count: this.state.count + 1 });
  };

  render() {
    return (
      <div>
        <button onClick={this.incrementCount}>Count {this.state.count}</button>
      </div>
    );
  }
}

export default ClassCounter;
```

## React useState() hook in Functional component
`useState()` receives an argument which is the initial value of the state property, and returns the current value of the state property and a method that is capable of updating that state property.
### Code implementation (unsafe):
``` javascript
import React, { useState } from "react";

// Functional component
function HookCounter() {
  // State variable and method updating state were defined
  const [count, setCount] = useState(0);

  return (
    <div>
      <button onClick={() => setCount(count + 1)}>Count {count}</button>
    </div>
  );
}

export default HookCounter;
```
When first time the component was rendered, a state variable is created and initialized with the default value of `0`. The default value is never used on re-render. When the button was clicked, the `setCount()` method is called which will `add 1` to the current count value. On first click, count is incremented to `1` from `0`. After that the `setCount()` will cause the component to re-render. After re-render, the count will contain a value of `1` , which is displayed as part of the inner text in the browser.

### Set State based on the previous state value
### Implementation of the counter that has increment, decrement, and reset buttons (unsafe):
``` javascript
import React, { useState } from "react";

function HookCounterTwo() {
  const initialCount = 0;
  const [count, setCount] = useState(initialCount);

  const incrementFive = () => {
    for (let i = 0; i < 5; i++) {
      setCount(count + 1); // "1" is displayed because setCount() is reading the state value of the state variable
      console.log(count);
    }
  };

  return (
    <div>
      Count: {count}
      <button onClick={() => setCount(initialCount)}>Reset</button>
      <button onClick={() => setCount(count + 1)}>Increment</button>
      <button onClick={() => setCount(count - 1)}>Decrement</button>
      <button onClick={incrementFive}>Increment 5</button>
    </div>
  );
}

export default HookCounterTwo;
```
This implementation and the previous code implementation both are unsafe. 
Instead of passing a value of the new state variable, we pass in a function that has access to the old state value.
### Implementation of Set State that has access to previous state
#### Functional component:
``` javascript
import React, { useState } from "react";

function HookCounterTwo() {
  const initialCount = 0;
  const [count, setCount] = useState(initialCount);

  const incrementFive = () => {
    for (let i = 0; i < 5; i++) {
      setCount((prevCount) => prevCount + 1); // Pass in a function that has access to the old value
      console.log(count);
    }
  };

  return (
    <div>
      Count: {count}
      <button onClick={() => setCount(initialCount)}>Reset</button>
      <button onClick={() => setCount((prevCount) => prevCount + 1)}>
        Increment
      </button>
      <button onClick={() => setCount((prevCount) => prevCount - 1)}>
        Decrement
      </button>
      <button onClick={incrementFive}>Increment 5</button>
    </div>
  );
}

export default HookCounterTwo;
```
setCount() accepts a function that has access to the old count. `prevCount` is the argument, and the function body is `prevCount + 1` .
When we have to update state based on the previous state value, the Safer option is passing in a function that will set the new state value to the state setter.
#### Class component:
``` javascript
import React, { Component } from "react";

class ClassCounterTwo extends Component {
  constructor(props) {
    super(props);

    this.state = {
      count: 0,
    };
  }

  incrementCount = () => {
    this.setState((prevState) => ({ count: prevState.count + 1 }));
  };

  render() {
    return (
      <div>
        <button onClick={this.incrementCount}>Count {this.state.count}</button>
      </div>
    );
  }
}

export default ClassCounterTwo;
```

### Object as state variable
The setter function inside `useState()` does not automatically merge and update the object. This is different to the `setState()` inside Class component, `setState()` will merge the state, whereas the `useState()` hook set function will not merge the state.
#### Incorrect code:
``` javascript
import React, { useState } from "react";

function HookCounterThree() {
  const [name, setName] = useState({ firstName: "", lastName: "" });
  return (
    <form>
      <input
        type="text"
        value={name.firstName}
        onChange={(e) => setName({ firstName: e.target.value })}
      />
      <input
        type="text"
        value={name.lastName}
        onChange={(e) => setName({ lastName: e.target.value })}
      />
      <h2>Your first name is - {name.firstName}</h2>
      <h2>Your last name is - {name.lastName}</h2>
      <h2>{JSON.stringify(name)}</h2>
    </form>
  );
}

export default HookCounterThree;
```

#### Correct code:
``` javascript
import React, { useState } from "react";

function HookCounterThree() {
  const [name, setName] = useState({ firstName: "", lastName: "" });
  return (
    <form>
      <input
        type="text"
        value={name.firstName}
        onChange={(e) => setName({ ...name, firstName: e.target.value })}
      />
      <input
        type="text"
        value={name.lastName}
        onChange={(e) => setName({ ...name, lastName: e.target.value })}
      />
      <h2>Your first name is - {name.firstName}</h2>
      <h2>Your last name is - {name.lastName}</h2>
      <h2>{JSON.stringify(name)}</h2>
    </form>
  );
}

export default HookCounterThree;
```
We use `spread operator (...objectName)` to manually merge the state.
`setName({ ...name, firstName: e.target.value })}` copies every property in the `name` object, and then just overwrite the `firstName` field with a different value, similarly for `lastName` .

### Array as state variable
In the case of an array, the setter function does not automatically append the item to the end of the list. 
``` javascript
import React, { useState } from "react";

function HookCounterFour() {
  const [items, setItems] = useState([]);

  const addItem = () => {
    setItems([
      ...items,
      { id: items.length, value: Math.floor(Math.random() * 10) + 1 },
    ]);
  };

  return (
    <div>
      <button onClick={addItem}>Add a number</button>
      <ul>
        {items.map((item) => (
          <li key={item.id}>{item.value}</li>
        ))}
      </ul>
    </div>
  );
}

export default HookCounterFour;
```
The argument to the `setItems()` is an array `[]` . Similar to the object, first we spread the items array, and then we push a new item. Whenever `addItem` is called, we make a copy of all the items in the array using the `spread operator (...arrayName)` , to that list of copied items we simply append the new item.

## Summary - useState()
- The useState hook lets us add state to functional components
- In classes, the state is always an object.
- With the `useState` hook, the state doesn't have to be an object.
- The `useState` hook returns an array with 2 elements.
- The first element is the current value of the state, and the second element is a state setter function.
- New state value depends on the previous state value? We can pass a function to the setter function.
- When dealing with objects or arrays, always make sure to spread the state variable and then call the setter function
