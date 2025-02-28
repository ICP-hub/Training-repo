// src/WalletProvider.jsx
import { AptosWalletAdapterProvider } from "@aptos-labs/wallet-adapter-react";
import { Network } from "@aptos-labs/ts-sdk";

/* eslint-disable react/prop-types */
const WalletProvider = ({ children }) => {
  return (
    <AptosWalletAdapterProvider
      plugins={[]}
      autoConnect={true}
      dappConfig={{ network: Network.MAINNET }}
      onError={(error) => console.log("Wallet Error:", error)}
    >
      {children}
    </AptosWalletAdapterProvider>
  );
};

export default WalletProvider;