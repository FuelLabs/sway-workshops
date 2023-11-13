import { useConnect } from "@fuel-wallet/react";

export default function ConnectButton() {
  const { connect } = useConnect();

  async function handleConnect() {
    // we will have a wallet connector that replaces this soon
    await connect("");
  }

  return <button onClick={handleConnect}>Connect</button>;
}
