contract;

mod interface;
use ::interface::CrowdfundingABI;

storage {
    // The number of campaigns created by all users
    total_campaigns: u64 = 0,

}

impl CrowdfundingABI for Contract {
      #[storage(read)]
    fn total_campaigns() -> u64 {
        storage.total_campaigns.read()
    }
}
#[test]
fn test_success() {
    let caller = abi(CrowdfundingABI, CONTRACT_ID);
    let result = caller.total_campaigns {}();
    assert(result == 0)
}
