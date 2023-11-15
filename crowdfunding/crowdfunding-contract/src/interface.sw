library;

use ::data_structures::Campaign;

abi CrowdfundingABI {
    #[storage(read, write)]
    fn create_campaign(asset: AssetId, beneficiary: Identity, deadline: u64, target_amount: u64);

    #[payable, storage(read, write)]
    fn pledge(id: u64);

    #[storage(read, write)]
    fn claim_pledges(id: u64);
}
abi Info {
    #[storage(read)]
    fn total_campaigns() -> u64;

    #[storage(read)]
    fn campaign_info(id: u64) -> Option<Campaign>;

    #[storage(read)]
    fn pledge_count(user: Identity) -> u64;
}
