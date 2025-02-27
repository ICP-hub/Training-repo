### **🗳️ Secure Voting System - Solidity**
A **secure voting smart contract** in Solidity that prevents **re-entrancy attacks, double voting, and manipulation.**  
Includes both a **secure implementation** and a **vulnerable contract** for learning purposes.  

---

## **🚀 Features**
✅ **Admin Role**: Only the owner can start/stop voting.  
✅ **One-Person-One-Vote**: Each voter can vote only once.  
✅ **Secure Against Re-Entrancy**: Uses `nonReentrant` modifier.  
✅ **Prevents Double Voting**: Mapping ensures one vote per address.  
✅ **Transparent Results**: Anyone can check the election results.  
✅ **Time-Based Voting**: Voting is only allowed during a set period.  

---

## **📂 Project Structure**
```
📁 SecureVoting
│── 📄 VulnerableVoting.sol   // 🚨 Prone to re-entrancy attack
│── 📄 VotingAttack.sol       // 🦠 Re-entrancy attack contract
│── 📄 SecureVoting.sol       // 🔒 Secure voting system (protected)
│── 📄 README.md              // 📜 Project documentation
```

---

## **🔍 Re-Entrancy Attack Explanation**
The **vulnerable contract** (`VulnerableVoting.sol`) allows an attacker to re-enter the `vote()` function multiple times before the vote status (`hasVoted[msg.sender]`) is updated.

### **🚨 How the Attack Works**
1. The attacker deploys `VotingAttack.sol` and calls `attack(candidateIndex)`.  
2. The `vote()` function in `VulnerableVoting` **sends ETH before updating state**, which triggers `receive()` in the attacker contract.  
3. `receive()` re-enters `vote()` and repeats the process multiple times before the state is updated.  
4. The attacker **votes multiple times**, manipulating the results.  

---

## **🔒 Security Fixes**
✅ **Uses "Checks-Effects-Interactions" Pattern**  
✅ **Prevents Re-Entrancy with `nonReentrant`**  
✅ **State Updates Before External Calls**  
✅ **Blocks Double Voting via `hasVoted[msg.sender]`**  

---

## **🛠️ Installation & Deployment**
### **1️⃣ Prerequisites**
- Install [Node.js](https://nodejs.org/) and [Hardhat](https://hardhat.org/)  
- Install dependencies:  
  ```sh
  npm install -g hardhat
  ```

### **2️⃣ Deploy the Secure Contract**
```sh
npx hardhat compile
npx hardhat run scripts/deploy.js --network localhost
```

### **3️⃣ Interact with the Contract**
- **Cast a Vote:**  
  ```sh
  vote(candidateIndex)
  ```
- **End Voting (Admin Only):**  
  ```sh
  endVoting()
  ```
- **Check Winner:**  
  ```sh
  getWinner()
  ```

---

## **📜 License**
This project is licensed under the **MIT License**.

---

## **📌 Conclusion**
🚀 The **secure contract** ensures fair elections by blocking **re-entrancy attacks, multiple voting, and vote manipulation.**  
❌ The **vulnerable contract** demonstrates a **real-world security flaw** for educational purposes.  

🔒 **Always use re-entrancy guards and follow secure Solidity best practices!** ✅  