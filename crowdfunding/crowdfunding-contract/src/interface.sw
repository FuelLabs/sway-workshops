library;

use ::data_structures::CampaignInfo;

abi CrowdfundingABI {
    #[storage(read)]
    fn total_campaigns() -> u64;
    #[storage(read, write)]
    fn create_campaign(beneficiary: Identity, deadline: u64, target_amount: u64);
    #[payable, storage(read, write)]
    fn pledge(id: u64);
}
abi Info {
    #[storage(read)]
    fn campaign_info(id: u64) -> Option<CampaignInfo>;
}
