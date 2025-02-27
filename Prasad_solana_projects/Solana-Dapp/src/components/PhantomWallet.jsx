import { useState, useEffect } from "react";

const PhantomWallet = ({ setWalletAddress }) => {
    const [wallet, setWallet] = useState(null);

    useEffect(() => {
        if (window.solana && window.solana.isPhantom) {
            window.solana.connect({ onlyIfTrusted: true })
                .then(res => {
                    setWallet(res.publicKey.toString());
                    setWalletAddress(res.publicKey.toString());
                })
                .catch(() => console.log("Wallet not connected"));
        }
    }, [setWalletAddress]);

    const connectWallet = async () => {
        try {
            if (!window.solana) return alert("Install Phantom Wallet!");
            const res = await window.solana.connect();
            setWallet(res.publicKey.toString());
            setWalletAddress(res.publicKey.toString());
        } catch (error) {
            console.error("Connection failed:", error);
        }
    };

    return (
        <div>
            {wallet ? (
                <p>Connected: {wallet}</p>
            ) : (
                <button onClick={connectWallet}>Connect Phantom Wallet</button>
            )}
        </div>
    );
};

export default PhantomWallet;
