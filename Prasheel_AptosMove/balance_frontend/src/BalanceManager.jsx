// src/BalanceManager.jsx
import { useWallet } from "@aptos-labs/wallet-adapter-react";
import { Aptos, AptosConfig, Network } from "@aptos-labs/ts-sdk";
import { useState, useEffect } from "react";

// Initialize Aptos client for Devnet
const config = new AptosConfig({ network: Network.DEVNET });
const aptos = new Aptos(config);

const MODULE_ADDRESS =
  "0x52a0ea3bd50d3e7ca95e6580f7e49e9c0a6f78b435ad527037c06474cb3b4648";

const BalanceManager = () => {
  const { account, signAndSubmitTransaction, connected } = useWallet();
  const [balance, setBalance] = useState(null);
  const [amount, setAmount] = useState("");

  // Fetch balance when account changes
  useEffect(() => {
    if (connected && account) {
      fetchBalance();
    }
  }, [connected, account]);

  const fetchBalance = async () => {
    try {
      const balance = await aptos.view({
        payload: {
          function: `${MODULE_ADDRESS}::balance::get_balance`,
          typeArguments: [],
          functionArguments: [account?.address?.toString()], // Ensure address is a string
        },
      });
      setBalance(balance[0]); // First return value from view function
    } catch (error) {
      console.error("Error fetching balance:", error);
      setBalance("Not initialized");
    }
  };

  const initializeBalance = async () => {
    if (!connected || !account) return;
    const transaction = {
      sender: account?.address?.toString(), // Ensure sender is a string
      data: {
        function: `${MODULE_ADDRESS}::balance::initialize`,
        typeArguments: [],
        functionArguments: [],
      },
    };
    try {
      const response = await signAndSubmitTransaction(transaction);
      await aptos.waitForTransaction({ transactionHash: response.hash });
      fetchBalance(); // Refresh balance after initialization
    } catch (error) {
      console.error("Error initializing balance:", error);
    }
  };

  const deposit = async () => {
    if (!connected || !account || !amount) return;
    const transaction = {
      sender: account?.address?.toString(), // Ensure sender is a string
      data: {
        function: `${MODULE_ADDRESS}::balance::deposit`,
        typeArguments: [],
        functionArguments: [parseInt(amount)],
      },
    };
    try {
      const response = await signAndSubmitTransaction(transaction);
      await aptos.waitForTransaction({ transactionHash: response.hash });
      setAmount(""); // Clear input
      fetchBalance(); // Refresh balance
    } catch (error) {
      console.error("Error depositing:", error);
    }
  };

  const withdraw = async () => {
    if (!connected || !account || !amount) return;
    const transaction = {
      sender: account?.address?.toString(), // Ensure sender is a string
      data: {
        function: `${MODULE_ADDRESS}::balance::withdraw`,
        typeArguments: [],
        functionArguments: [parseInt(amount)],
      },
    };
    try {
      const response = await signAndSubmitTransaction(transaction);
      await aptos.waitForTransaction({ transactionHash: response.hash });
      setAmount(""); // Clear input
      fetchBalance(); // Refresh balance
    } catch (error) {
      console.error("Error withdrawing:", error);
    }
  };

  return (
    <div>
      {connected ? (
        <>
          <h2>Balance: {balance === null ? "Loading..." : balance}</h2>
          {balance === "Not initialized" && (
            <button onClick={initializeBalance}>Initialize Balance</button>
          )}
          {balance !== "Not initialized" && (
            <>
              <input
                type="number"
                value={amount}
                onChange={(e) => setAmount(e.target.value)}
                placeholder="Enter amount"
              />
              <button onClick={deposit}>Deposit</button>
              <button onClick={withdraw}>Withdraw</button>
            </>
          )}
        </>
      ) : (
        <p>Please connect your Petra wallet to manage your balance.</p>
      )}
    </div>
  );
};

export default BalanceManager;