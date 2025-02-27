import { useEffect, useState } from "react";
import { Connection, PublicKey, clusterApiUrl } from "@solana/web3.js";

const NETWORK = clusterApiUrl("devnet");

const WalletBalance = ({ walletAddress }) => {
    const [balance, setBalance] = useState(null);

    useEffect(() => {
        if (walletAddress) {
            const fetchBalance = async () => {
                try {
                    const connection = new Connection(NETWORK);
                    const pubKey = new PublicKey(walletAddress);
                    const lamports = await connection.getBalance(pubKey);
                    setBalance(lamports / 1e9); // Convert lamports to SOL
                } catch (error) {
                    console.error("Error fetching balance:", error);
                }
            };
            fetchBalance();
        }
    }, [walletAddress]);

    return (
        <div>
            {balance !== null ? <p>Balance: {balance.toFixed(4)} SOL</p> : <p>Loading balance...</p>}
        </div>
    );
};

export default WalletBalance;
