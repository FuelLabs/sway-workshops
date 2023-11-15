import { bn } from "fuels";
import { useState } from "react";

interface CreateCampaignProps {
  contract: ContractAbi | null;
  wallet: FuelWalletLocked | null;
}

export default function CreateCampaign({ contract, wallet }: CreateCampaignProps) {
  const [status, setStatus] = useState<
    "none" | "loading" | "success" | "error"
  >("none");
  const [showForm, setShowForm] = useState<boolean>(false);
  const [beneficiaryAddress, setBeneficiaryAddress] = useState<string>();
  const [deadline, setDeadline] = useState<string>();
  const [targetAmount, setTargetAmount] = useState<string>("0");

  function toggle() {
    setShowForm((s) => !s);
  }

  async function handleSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault();
    if (!contract) {
      console.log("MISSING CONTRACT");
      setStatus("error");
    } else {
      try {
        setStatus("loading");
        console.log("beneficiaryAddress:", beneficiaryAddress);
        console.log("deadline:", deadline);
        console.log("targetAmount:", targetAmount);
        console.log("SUBMITTED");
        const id: IdentityInput = { Address: wallet };
        const amountInput = bn.parseUnits(targetAmount);
        await contract.functions.create_campaign(amountInput);
        setStatus("success");
      } catch (error) {
        console.log("ERROR:", error);
        setStatus("error");
      }
    }
  }

  return (
    <>
      <button onClick={toggle}>Create Campaign</button>

      {showForm && (
        <div className="form-container">

      {status === "success" && (
        <div>Success! You just created a new campaign.</div>
      )}
      {status === "error" && <div>Oops, something went wrong.</div>}

      {status === "loading" && <div>Loading...</div>}

      {status === "none" && (
          <form onSubmit={handleSubmit}>
            <div className="close-button-container">
              <button onClick={toggle}>X</button>
            </div>

            <div className="form-control">
              <label htmlFor="beneficiary-address">
                Beneficiary Fuel Address:
              </label>
              <input
                id="beneficiary-address"
                type="text"
                required
                onChange={(e) => setBeneficiaryAddress(e.target.value)}
              />
            </div>

            <div className="form-control">
              <label htmlFor="deadline">Funding Deadline:</label>
              <input
                id="deadline"
                type="datetime-local"
                required
                onChange={(e) => setDeadline(e.target.value)}
              />
            </div>

            <div className="form-control">
              <label htmlFor="target-amount">Target Amount:</label>
              <input
                id="target-amount"
                type="number"
                min="0"
                step="any"
                inputMode="decimal"
                placeholder="0.00"
                required
                onChange={(e) => setTargetAmount(e.target.value)}
              />{" "}
              ETH
            </div>

            <button type="submit">Create</button>
          </form>
      )}
        </div>
      )}
    </>
  );
}
