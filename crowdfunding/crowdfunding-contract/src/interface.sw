library;

abi CrowdfundingABI {
    #[storage(read)]
    fn total_campaigns() -> u64;
}