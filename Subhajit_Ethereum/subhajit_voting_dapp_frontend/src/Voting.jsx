import React, { useState, useEffect } from 'react';
import Web3 from 'web3';

const Voting = () => {
  // State variables
  const [voteCounts, setVoteCounts] = useState([0, 0]); // Vote counts for 2 candidates
  const [hasVoted, setHasVoted] = useState(false); // User’s voting status
  const [message, setMessage] = useState(''); // Feedback messages
  const [loading, setLoading] = useState(true); // Loading state
  const [account, setAccount] = useState(''); // Current user’s address

  // Initialize Web3 with MetaMask
  const web3 = new Web3(window.ethereum || "http://localhost:8545");

  // Replace these with your contract’s details
  const contractAddress = '0xe01dcad922176d8864095a38db1712c401000417'; // Deployed contract address
  const abi = [
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "candidateId",
          "type": "uint256"
        }
      ],
      "name": "vote",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "CANDIDATE_COUNT",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "voter",
          "type": "address"
        }
      ],
      "name": "checkHasVoted",
      "outputs": [
        {
          "internalType": "bool",
          "name": "",
          "type": "bool"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "candidateId",
          "type": "uint256"
        }
      ],
      "name": "getVoteCount",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "",
          "type": "address"
        }
      ],
      "name": "hasVoted",
      "outputs": [
        {
          "internalType": "bool",
          "name": "",
          "type": "bool"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "name": "voteCounts",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    }
  ];

  const contract = new web3.eth.Contract(abi, contractAddress);

  // Fetch initial data (vote counts and user status)
  const fetchData = async () => {
    try {
      const accounts = await web3.eth.requestAccounts(); // Prompt MetaMask connection
      const userAddress = accounts[0];
      setAccount(userAddress);

      // Check if user has voted
      const voted = await contract.methods.checkHasVoted(userAddress).call();
      setHasVoted(voted);

      // Fetch vote counts for each candidate (assuming 2 candidates)
      const counts = [];
      for (let i = 0; i < 2; i++) {
        const count = await contract.methods.getVoteCount(i).call();
        counts.push(Number(count));
      }
      setVoteCounts(counts);
      setLoading(false);
    } catch (error) {
      setMessage('Error loading data: ' + error.message);
      setLoading(false);
    }
  };

  // Handle voting action
  const handleVote = async (candidateId) => {
    setMessage('');
    try {
      const accounts = await web3.eth.getAccounts();
      setLoading(true);
      await contract.methods.vote(candidateId).send({ from: accounts[0] });
      setMessage(`Successfully voted for Candidate ${candidateId}!`);
      await fetchData(); // Refresh data after voting
    } catch (error) {
      setMessage('Voting failed: ' + error.message);
      setLoading(false);
    }
  };

  // Load data when component mounts
  useEffect(() => {
    if (window.ethereum) {
      fetchData();
      // Listen for account changes
      window.ethereum.on('accountsChanged', () => fetchData());
    } else {
      setMessage('Please install MetaMask to use this DApp.');
      setLoading(false);
    }
  }, []);

  // Render loading state
  if (loading) {
    return <div>Loading voting data...</div>;
  }

  return (
    <div style={{ padding: '20px', fontFamily: 'Arial' }}>
      <h1>Secure Voting DApp</h1>
      <p><strong>Your Address:</strong> {account}</p>
      <p>
        <strong>Status:</strong>{' '}
        {hasVoted ? 'You have already voted.' : 'You can vote now!'}
      </p>

      <h2>Candidates</h2>
      <ul style={{ listStyleType: 'none', padding: 0 }}>
        {voteCounts.map((count, index) => (
          <li
            key={index}
            style={{
              margin: '10px 0',
              padding: '10px',
              border: '1px solid #ccc',
              borderRadius: '5px',
              display: 'flex',
              justifyContent: 'space-between',
              alignItems: 'center'
            }}
          >
            <span>Candidate {index}: {count} vote{count !== 1 ? 's' : ''}</span>
            {!hasVoted && (
              <button
                onClick={() => handleVote(index)}
                style={{
                  padding: '5px 10px',
                  backgroundColor: '#4CAF50',
                  color: 'white',
                  border: 'none',
                  borderRadius: '3px',
                  cursor: 'pointer'
                }}
              >
                Vote
              </button>
            )}
          </li>
        ))}
      </ul>

      {message && (
        <p style={{ color: message.includes('Error') ? 'red' : 'green' }}>
          {message}
        </p>
      )}
    </div>
  );
};

export default Voting;