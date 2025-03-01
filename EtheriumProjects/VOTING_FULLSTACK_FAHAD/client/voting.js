import { ethers } from "https://cdn.jsdelivr.net/npm/ethers/dist/ethers.esm.min.js";
let contractAdd = "0x525C2072F55C6BBF45DF26640EDb519324004aad";
let contractABI = `[
    {
      "inputs": [
        {
          "internalType": "string",
          "name": "_title",
          "type": "string"
        },
        {
          "internalType": "string",
          "name": "_description",
          "type": "string"
        }
      ],
      "stateMutability": "nonpayable",
      "type": "constructor"
    },
    {
      "inputs": [
        {
          "internalType": "string",
          "name": "_title",
          "type": "string"
        }
      ],
      "name": "addChoice",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "getChoices",
      "outputs": [
        {
          "internalType": "string[]",
          "name": "",
          "type": "string[]"
        },
        {
          "internalType": "uint256[]",
          "name": "",
          "type": "uint256[]"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "newPoll",
      "outputs": [
        {
          "internalType": "string",
          "name": "title",
          "type": "string"
        },
        {
          "internalType": "bool",
          "name": "status",
          "type": "bool"
        },
        {
          "internalType": "string",
          "name": "description",
          "type": "string"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "_id",
          "type": "uint256"
        }
      ],
      "name": "showChoices",
      "outputs": [
        {
          "internalType": "string",
          "name": "",
          "type": "string"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "_id",
          "type": "uint256"
        }
      ],
      "name": "vote",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    }
  ]`

let provider, signer, contract, address;

const connectWallet = async () => {
    try{
    if(window.ethereum) {
    provider = new ethers.providers.Web3Provider(window.ethereum);
    signer = provider.getSigner();
    address = await signer.getAddress();
    contract = new ethers.Contract(contractAdd, contractABI, signer);
    document.getElementById('pollSection').style.display = 'block';
    console.log("Wallet connected successfully:", address);
    connectWalletButton.style.display="none";
	const [title, status, description] = await contract.newPoll();
		const pollTitle = document.querySelector('.poll-title');
		const pollStatus = document.querySelector('.poll-status');
		const pollDescription = document.querySelector('.poll-description');

		pollTitle.innerText = title;
		pollStatus.innerText = status? "Open" : "Closed";
		pollDescription.innerText = description;
    await fetchOptions();

    }
}
catch(e){
    console.log(e);
}
}

const connectWalletButton = document.getElementById('connectWallet');
connectWalletButton.addEventListener('click', connectWallet);

const pollDiv = document.getElementById('pollSection');
const choicesDiv = document.getElementById('choices');

const fetchOptions = async () => {
    try {
        const optionsData = await contract.getChoices(); 

        const titles = optionsData[0];
        const votes = optionsData[1];  

        choicesDiv.innerHTML = ""; 

        titles.forEach((title, index) => {
            const optionDiv = document.createElement('div');
            optionDiv.classList.add("options");
			
            optionDiv.innerHTML = `
                <span class="option">${title} - Votes: ${votes[index]}</span>
            `;
            choicesDiv.appendChild(optionDiv);
        });
        addListener()
    } catch (error) {
        console.error("Error fetching poll options:", error);
    }
};

const addListener = ()=>{
const options = document.querySelectorAll('.options');
options.forEach((option, index) => {
    option.addEventListener('click', async () => {
        try {
            const tx = await contract.vote(index);
			await tx.wait();
			await fetchOptions();
        } catch (error) {
            console.error("Error voting:", error);
        }
    });
});
};
