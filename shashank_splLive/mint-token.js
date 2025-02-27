import { Keypair, Connection } from "@solana/web3.js";
import { createMint } from "@solana/spl-token";


(async () => {
    const connection = new Connection("http://127.0.0.1:8899");
    const feePayer = Keypair.generate();


    const tx = await connection.requestAirdrop(feePayer.publicKey, 1e9);


    const confirmationOptions = {
        signature: tx,
        commitment: "confirmed"
    };
    await connection.confirmTransaction(confirmationOptions);
    console.log("Airdrop completed successfully");


    const tokenMintAccountKp = Keypair.generate();


    const tokenMintAddress = await createMint(
        connection,
        feePayer,
        feePayer.publicKey,
        feePayer.publicKey,
        2,
        tokenMintAccountKp,
    )


    console.log("Token Mint Pub Address:", tokenMintAddress.toBase58());
    console.log("tokenMintAccountKp Pub Address:", tokenMintAccountKp.publicKey.toBase58());
    console.log("feePayer Pub Address:", feePayer.publicKey.toBase58());
})();