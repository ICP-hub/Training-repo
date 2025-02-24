import { html, render } from 'lit-html';
import { counter_app_backend } from 'declarations/counter-app-backend';
import './styles.css';

class App {
  count = 0;

  constructor() {
    this.#fetchCount();
  }

  async #fetchCount() {
    this.count = await counter_app_backend.get_count();
    this.#render();
  }

  async #increment() {
    await counter_app_backend.increment();
    this.#fetchCount();
  }

  async #decrement() {
    await counter_app_backend.decrement();
    this.#fetchCount();
  }

  async #reset() {
    await counter_app_backend.reset();
    this.#fetchCount();
  }

  #render() {
    let body = html`
      <div class="container">
        <h1>Counter-App</h1>
        <div class="counter">${this.count}</div>
        <div class="buttons">
          <button class="btn increment" @click=${() => this.#increment()}>Increase</button>
          <button class="btn decrement" @click=${() => this.#decrement()}>Decrease</button>
          <button class="btn reset" @click=${() => this.#reset()}>🔄 Reset</button>
        </div>
      </div>
    `;
    render(body, document.getElementById('root'));
  }
}

export default App;
