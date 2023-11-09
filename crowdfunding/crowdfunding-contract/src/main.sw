contract;

mod errors;
mod data_structures;
mod interface;

use ::interface::{CrowdfundingABI, Info};
use ::errors::{CampaignError, CreationError};
use ::data_structures::CampaignInfo;
// import hash to use storage map
use std::hash::*;
use std::identity::Identity;
use std::{
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
impl CrowdfundingABI for Contract {
    #[storage(read)]
    fn total_campaigns() -> u64 {
        storage.total_campaigns.read()
    }
    #[storage(read, write)]
    fn create_campaign(beneficiary: Identity, deadline: u64, target_amount: u64) {
        require(deadline > height().as_u64(), CreationError::DeadlineMustBeInTheFuture);
        require(target_amount > 0, CreationError::TargetAmountCannotBeZero);

        let author = msg_sender().unwrap();

        let campaign_info = CampaignInfo::new(author, beneficiary, deadline, target_amount);

        storage.campaign_info.insert(storage.total_campaigns.read(), campaign_info);
        storage.total_campaigns.write(storage.total_campaigns.read() + 1);
    }

    #[payable]
    #[storage(read, write)]
    fn pledge(campaign_id: u64) {
        let mut campaign_info = storage.campaign_info.get(campaign_id).try_read().unwrap();

        require(campaign_info.deadline > height().as_u64(), CampaignError::CampaignEnded);

        // The user has pledged therefore zwe increment the total amount that this campaign has
        // received.
        campaign_info.total_pledge += msg_amount();

        // Campaign state has been updated therefore overwrite the previous version with the new
        storage.campaign_info.insert(campaign_id, campaign_info);
    }
}

impl Info for Contract {
    #[storage(read)]
    fn campaign_info(campaign_id: u64) -> Option<CampaignInfo> {
        storage.campaign_info.get(campaign_id).try_read()
    }
}

#[test]
fn test_total_campaigns() {
    let caller = abi(CrowdfundingABI, CONTRACT_ID);
    let result = caller.total_campaigns {}();
    assert(result == 0)
}
#[test]
fn test_create_campaign() {
    let address = 0x0000000000000000000000000000000000000000000000000000000000000001;
    let user = Identity::Address(Address::from(address));
    let caller = abi(CrowdfundingABI, CONTRACT_ID);
    caller.create_campaign {}(user, 100, 200);
    let result = caller.total_campaigns {}();
    assert(result == 1)
}
#[test]
fn test_pledge() {
    let callerCrowdfunding = abi(CrowdfundingABI, CONTRACT_ID);
    callerCrowdfunding.pledge {}(0);
    let callerInfo = abi(Info, CONTRACT_ID);
    let result = callerInfo.campaign_info {}(0).unwrap();
    log(result.total_pledge);
    assert(result.total_pledge == 100)
}
