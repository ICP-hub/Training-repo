// src/WalletConnect.jsx
import { useWallet } from "@aptos-labs/wallet-adapter-react";

const WalletConnect = () => {
  const { connect, disconnect, connected, account } = useWallet();

  const handleConnect = () => {
    connect("Petra"); // Connects to Petra wallet
  };

  const handleDisconnect = () => {
    disconnect();
  };

  // Safely get the address as a string
  const address = account?.address?.toString() || "No address available";

  return (
    <div>
      {connected ? (
        <div>
          <p>Connected to: {address}</p>
          <button onClick={handleDisconnect}>Disconnect</button>
        </div>
      ) : (
        <button onClick={handleConnect}>Connect Petra Wallet</button>
      )}
    </div>
  );
};

export default WalletConnect;