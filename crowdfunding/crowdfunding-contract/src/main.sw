contract;

mod errors;
mod interface;
mod data_structures;

use ::interface::CrowdfundingABI;
use ::errors::CreationError;
use ::data_structures::CampaignInfo;
// import hash to use storage map
use std
::hash::*;
use std::identity::Identity;
use std
::{
    auth::msg_sender,
    block::height,
    call_frames::msg_asset_id,
    constants::BASE_ASSET_ID,
    context::msg_amount,
    token::transfer,
};
storage {

    // The number of campaigns created by all users
    total_campaigns: u64 = 0,
    /// Data describing the content of a campaign
    /// Map(Campaign ID => CampaignInfo)
    campaign_info: StorageMap<u64, CampaignInfo> = StorageMap::<u64, CampaignInfo> {},
}
impl CrowdfundingABI
 for Contract {
    #[storage(read)]
    fn total_campaigns() -> u64 {
        storage.total_campaigns.read()
    }
    #[storage(read, write)]
    fn create_campaign(beneficiary: Identity, deadline: u32, target_amount: u32) {
        // Users cannot interact with a campaign that has already ended (is in the past)
        require(deadline > height(), CreationError::DeadlineMustBeInTheFuture);
        // A campaign must have a target to reach and therefore 0 is an invalid amount
        require(
target_amount > 0, CreationError::TargetAmountCannotBeZero);
        let author
 = msg_sender().unwrap();
        // Create an internal representation of a campaign
        let campaign_info
 = CampaignInfo::new(author, beneficiary, deadline, target_amount);
        storage.
campaign_info.insert(storage.total_campaigns.read(), campaign_info);
        storage.total_campaigns.write(storage.total_campaigns.read() + 1);
        log(campaign_info);
    }
}
#[
test]
fn test_total_campaigns() {
    let caller = abi(CrowdfundingABI, CONTRACT_ID);
    let result = caller.total_campaigns {}();
    assert(result == 0)
}
#[
test]
fn test_create_campaign() {
    let address = 0x0000000000000000000000000000000000000000000000000000000000000001;
    let user = Identity::Address(Address::from(address));
    let caller
 = abi(CrowdfundingABI, CONTRACT_ID);
    caller.create_campaign {}(user, 100, 200);
    let result
 = caller.total_campaigns {}();
    assert(result == 1)
}
