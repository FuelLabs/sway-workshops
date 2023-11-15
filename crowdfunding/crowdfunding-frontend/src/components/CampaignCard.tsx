import { useState } from "react";

interface CampaignCardProps {
  contract: ContractAbi | null;
  campaign: any | null;
  readOnly: boolean;
}

export default function CampaignCard({
  contract,
  campaign,
  readOnly,
}: CampaignCardProps) {
  const [pledgeStatus, setPledgeStatus] = useState<
    "none" | "loading" | "success" | "error"
  >("none");
  const [claimStatus, setClaimStatus] = useState<
    "none" | "loading" | "success" | "error"
  >("none");

  console.log("campaign:", campaign);

  async function pledgeMoney() {
    if (!contract) {
      console.log("MISSING CONTRACT");
      setPledgeStatus("error");
    } else {
      try {
        // await contract.functions.pledge_money();
        setPledgeStatus("success");
      } catch (error) {
        console.log("ERROR:", error);
        setPledgeStatus("error");
      }
    }
  }

  async function claimPledgedMoney() {
    if (!contract) {
      console.log("MISSING CONTRACT");
      setClaimStatus("error");
    } else {
      try {
        // await contract.functions.claim_pledged_money();
        setClaimStatus("success");
      } catch (error) {
        console.log("ERROR:", error);
        setClaimStatus("error");
      }
    }
  }

  return (
    <div>
      <h3>Campaign #0</h3>

      <div className="pledged-container">
        <div className="pledged-amount">$10,000</div>
        <div className="pledged-description">pledged so far</div>
      </div>

      {!readOnly && (
        <>
          {pledgeStatus === "none" && (
            <button onClick={pledgeMoney}>Pledge Money</button>
          )}
          {pledgeStatus === "success" && (
            <div>Success! You just pledged funds to this campaign.</div>
          )}
          {pledgeStatus === "error" && <div>Oops, something went wrong.</div>}

          {claimStatus === "none" && (
            <button onClick={claimPledgedMoney}>Claim Pledged Money</button>
          )}
          {claimStatus === "success" && (
            <div>Success! You claimed this campaign's funds.</div>
          )}
          {claimStatus === "error" && <div>Oops, something went wrong.</div>}
        </>
      )}
    </div>
  );
}
