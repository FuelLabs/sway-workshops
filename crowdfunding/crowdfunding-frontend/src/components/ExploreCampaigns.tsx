import { useEffect, useState } from "react";
import CampaignCard from "./CampaignCard";

interface ExploreCampaignsProps {
  contract: ContractAbi | null;
}

export default function ExploreCampaigns({ contract }: ExploreCampaignsProps) {
  const [status, setStatus] = useState<"loading" | "success" | "error">(
    "loading"
  );
  const [totalCampaigns, setTotalCampaigns] = useState<number>(0);
  const [campaigns, setCampaigns] = useState<any[]>([]);

  useEffect(() => {
    async function getLatestCampaigns() {
      if (!contract) {
        console.log("MISSING CONTRACT");
        setStatus("error");
      } else {
        try {
          // get total number of campaigns
          //   await contract.functions.get_total_campaigns;
          setTotalCampaigns(0);
          // if 5 or less, get them all
          // if more than 5, get the last 5
          setCampaigns([]);
          setStatus("success");
        } catch (error) {
          console.log("ERROR:", error);
          setStatus("error");
        }
      }
    }

    getLatestCampaigns();
  }, [contract]);

  return (
    <>
      <h2>Explore Campaigns</h2>

      <div>Total Campaigns: {totalCampaigns}</div>

      {campaigns.length > 0 ? (
        <>
          {campaigns.map((campaign) => (
            <CampaignCard campaign={campaign} />
          ))}
        </>
      ) : (
        <>No campaigns posted yet.</>
      )}
    </>
  );
}
