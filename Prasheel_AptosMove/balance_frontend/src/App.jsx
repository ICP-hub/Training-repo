// src/App.jsx
import "./App.css";
import WalletConnect from "./WalletConnect.jsx";
import BalanceManager from "./BalanceManager.jsx";

function App() {
  return (
    <div className="App">
      <h1>My Aptos Balance Dapp</h1>
      <WalletConnect />
      <BalanceManager />
    </div>
  );
}

export default App;