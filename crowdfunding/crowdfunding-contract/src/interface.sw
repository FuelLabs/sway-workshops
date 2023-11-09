library;


abi CrowdfundingABI {
    #[storage(read)]
    fn total_campaigns() -> u64;

    #[storage(read, write)]
    fn create_campaign(beneficiary: Identity, deadline: u32, target_amount: u32);
}
