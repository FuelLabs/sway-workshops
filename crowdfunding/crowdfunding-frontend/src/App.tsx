import "./App.css";
import CreateCampaign from "./components/CreateCampaign";
import ExploreCampaigns from "./components/ExploreCampaigns";
import ConnectButton from "./components/ConnectButton";
import { useAccount, useIsConnected, useWallet } from "@fuel-wallet/react";
import { useMemo } from "react";

const CONTRACT_ID = "0x...";

function App() {
  const { isConnected } = useIsConnected();
  const { account } = useAccount();
  const { wallet } = useWallet({ address: account });

  const contract = useMemo(() => {
    if (wallet) {
      // const contract = ContractAbi__factory.connect(CONTRACT_ID, wallet);
      // return contract;
    }
    return null;
  }, [wallet]);

  return (
    <div className="App">
      {isConnected ? <CreateCampaign contract={contract} /> : <ConnectButton />}

      <ExploreCampaigns />
    </div>
  );
}

export default App;
