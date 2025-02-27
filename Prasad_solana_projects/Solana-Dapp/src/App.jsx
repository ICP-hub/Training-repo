import { useState } from "react";
import PhantomWallet from "./components/PhantomWallet";
import WalletBalance from "./components/WalletBalance";
import SendSol from "./components/SendSol";
import './App.css';

function App() {
    const [walletAddress, setWalletAddress] = useState(null);

    return (
        <div>
            <h1>Solana dApp with Phantom Wallet</h1>
            <PhantomWallet setWalletAddress={setWalletAddress} />
            {walletAddress && <WalletBalance walletAddress={walletAddress} />}
            {walletAddress && <SendSol sender={walletAddress} />}
        </div>
    );
}

export default App;
