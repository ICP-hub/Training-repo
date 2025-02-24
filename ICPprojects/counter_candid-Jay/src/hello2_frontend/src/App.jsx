import { useState, useEffect } from "react";
import { hello2_backend } from "declarations/hello2_backend";

function App() {
  const [count, setCount] = useState(0);

  // Fetch initial counter value when the component loads
  useEffect(() => {
    hello2_backend.get_count().then(setCount);
  }, []);

  const increment = () => {
    hello2_backend.increment().then(() => {
      // Only fetch the count after incrementing
      hello2_backend.get_count().then(setCount);
    });
  };

  const decrement = () => {
    hello2_backend.decrement().then(() => {
      // Only fetch the count after decrementing
      hello2_backend.get_count().then(setCount);
    });
  };

  return (
    <main>
      <img src="/logo2.svg" alt="DFINITY logo" />
      <h1>Counter: {count}</h1>
      <button onClick={increment}>Increment</button>
      <button onClick={decrement}>Decrement</button>
    </main>
  );
}

export default App;
