import './styles/App.css';
import { ethers } from "ethers";
import React, { useEffect, useState } from "react";
import BohringElements from './utils/BohringElements.json';

const CONTRACT_ADDRESS = "0xEa21F841753015EFB3071764dc4EC1A086718EB0";

const App = () => {

    const [currentAccount, setCurrentAccount] = useState("");
    
    const checkIfWalletIsConnected = async () => {
      const { ethereum } = window;

      if (!ethereum) {
          console.log("Make sure you have metamask!");
          return;
      } else {
          console.log("We have the ethereum object", ethereum);
      }
      const accounts = await ethereum.request({ method: 'eth_accounts' });
      if (accounts.length !== 0) {
          const account = accounts[0];
          console.log("Found an authorized account:", account);
					setCurrentAccount(account)
          setupEventListener()
      } else {
          console.log("No authorized account found")
      }
  }

  const connectWallet = async () => {
    try {
      const { ethereum } = window;
      if (!ethereum) {
        alert("Get MetaMask!");
        return;
      }
      const accounts = await ethereum.request({ method: "eth_requestAccounts" });
      console.log("Connected", accounts[0]);
      setCurrentAccount(accounts[0]);
      setupEventListener() 
    } catch (error) {
      console.log(error)
    }
  }

  const setupEventListener = async () => {
    try {
      const { ethereum } = window;

      if (ethereum) {
        const provider = new ethers.providers.Web3Provider(ethereum);
        const signer = provider.getSigner();
        const connectedContract = new ethers.Contract(CONTRACT_ADDRESS, BohringElements.abi, signer);

        connectedContract.on("NewElementMinted", (from, tokenId) => {
          console.log(from, tokenId.toNumber())
          alert(`Hey there! We've minted your NFT and sent it to your wallet. It may be blank right now. It can take a max of 10 min to show up on OpenSea. Here's the link: https://testnets.opensea.io/assets/${CONTRACT_ADDRESS}/${tokenId.toNumber()}`)
        });

        console.log("Setup event listener!")

      } else {
        console.log("Ethereum object doesn't exist!");
      }
    } catch (error) {
      console.log(error)
    }
  }

  const askContractToMintNft = async () => {
    try {
      const { ethereum } = window;

      if (ethereum) {
        const provider = new ethers.providers.Web3Provider(ethereum);
        const signer = provider.getSigner();
        const connectedContract = new ethers.Contract(CONTRACT_ADDRESS, BohringElements.abi, signer);

        console.log("Going to pop wallet now to pay gas...")
        let nftTxn = await connectedContract.mint();

        console.log("Mining...please wait.")
        await nftTxn.wait();
        console.log(nftTxn);

      } else {
        console.log("Ethereum object doesn't exist!");
      }
    } catch (error) {
      console.log(error)
    }
  }
  
  useEffect(() => {
    checkIfWalletIsConnected();
  }, [])

  const renderNotConnectedContainer = () => (
    <button onClick={connectWallet} className="connect-wallet-button">
      Connect to Wallet
    </button>
  );

  const renderMintUI = () => (
    <button onClick={askContractToMintNft} className="connect-wallet-button">
      Mint NFT
    </button>
  )

  return (
    <div className="App">
      <div className="container">
        <ul class="scifiUI">
          <li>
            <input type="radio" name="tab" id="tab1" checked/>
            <label for="tab1">Bohring Elements</label>
            <div class="section">
              The Bohring Elements are an experiment of on-chain generative artworks on the Polygon blockchain.
              <br>
              </br>
              <br>
              </br>
              Elements are randomly minted based on their weighted abundance in the universe and display as animated Bohr Models.
              <br>
              </br>
              <br>
              </br>
              The project was inspired by Niels Henrik David Bohr whom developed the namesake model of the atom, in which he proposed that energy levels of electrons are discrete and that the electrons revolve in stable orbits around the atomic nucleus but can jump from one energy level (or orbit) to another.
              <div class="footer-container">
                {currentAccount === "" ? renderNotConnectedContainer() : renderMintUI()}
              </div>
            </div>
          </li>
        </ul>
      </div>
    </div>
  );
};

export default App;