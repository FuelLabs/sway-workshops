import "./App.css";
import CreateCampaign from "./components/CreateCampaign";
import ExploreCampaigns from "./components/ExploreCampaigns";
import ConnectButton from "./components/ConnectButton";
import { useAccount, useIsConnected, useWallet } from "@fuel-wallet/react";
import { useMemo } from "react";
import { Wallet } from "fuels";

const CONTRACT_ID = "0x...";

function App() {
  const { isConnected } = useIsConnected();
  const { account } = useAccount();
  const { wallet } = useWallet({ address: account });

  const contract = useMemo(() => {
    // if the user's wallet is connected use that.
    // otherwise, create a new empty wallet for read-only functions
    if (wallet) {
      // const contract = ContractAbi__factory.connect(CONTRACT_ID, wallet);
      // return contract;
    } else {
      // const newWallet = new Wallet();
      // const contract = ContractAbi__factory.connect(CONTRACT_ID, newWallet);
      // return contract;
    }
  }, [wallet]);

  return (
    <div className="App">
      {isConnected ? <CreateCampaign contract={contract} wallet={wallet} /> : <ConnectButton />}

      <ExploreCampaigns contract={contract} readOnly={!wallet} />
    </div>
  );
}

export default App;
