import { useState } from "react";
import { Connection, PublicKey, Transaction, SystemProgram, clusterApiUrl } from "@solana/web3.js";

const NETWORK = clusterApiUrl("devnet");

const SendSol = ({ sender }) => {
    const [recipient, setRecipient] = useState("");
    const [amount, setAmount] = useState("");

    const sendSol = async () => {
        try {
            if (!sender) return alert("Connect your wallet first!");
            if (!recipient) return alert("Enter a valid recipient address!");
            if (!amount || isNaN(Number(amount))) return alert("Enter a valid amount!");

            const provider = window.solana;
            if (!provider) return alert("Phantom Wallet not found!");

            const connection = new Connection(NETWORK);
            const senderPubKey = new PublicKey(sender);
            const recipientPubKey = new PublicKey(recipient);

            const transaction = new Transaction().add(
                SystemProgram.transfer({
                    fromPubkey: senderPubKey,
                    toPubkey: recipientPubKey,
                    lamports: Number(amount) * 1e9, // Convert SOL to lamports
                })
            );

            const { blockhash } = await connection.getLatestBlockhash();
            transaction.recentBlockhash = blockhash;
            transaction.feePayer = senderPubKey;

            const signedTransaction = await provider.signTransaction(transaction);
            const signature = await connection.sendRawTransaction(signedTransaction.serialize());
            await connection.confirmTransaction(signature);

            console.log("Transaction successful:", signature);
            alert(`Transaction successful! Tx: ${signature}`);
        } catch (error) {
            console.error("Transaction failed:", error);
        }
    };

    return (
        <div>
            <input
                type="text"
                placeholder="Recipient Wallet Address"
                value={recipient}
                onChange={(e) => setRecipient(e.target.value)}
            />
            <input
                type="text"
                placeholder="Amount (SOL)"
                value={amount}
                onChange={(e) => setAmount(e.target.value)}
            />
            <button onClick={sendSol}>Send SOL</button>
        </div>
    );
};

export default SendSol;
