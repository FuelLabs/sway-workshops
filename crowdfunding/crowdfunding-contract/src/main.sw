contract;

mod data_structures;
mod interface;

use ::interface::{CrowdfundingABI, Info};
use ::data_structures::{Campaign, CampaignState};

// import hash to use storage map
use std::hash::*;

use std::{
    auth::msg_sender,
    block::height,
    call_frames::msg_asset_id,
    constants::BASE_ASSET_ID,
    context::msg_amount,
    identity::Identity,
    token::transfer,
};

storage {
    total_campaigns: u64 = 0,
    campaigns: StorageMap<u64, Campaign> = StorageMap::<u64, Campaign> {},
    pledge_count: StorageMap<Identity, u64> = StorageMap::<Identity, u64> {},
}

impl CrowdfundingABI for Contract {
    #[storage(read, write)]
    fn create_campaign(
        asset: AssetId,
        beneficiary: Identity,
        deadline: u64,
        target_amount: u64,
    ) {
        require(deadline > height().as_u64(), "DeadlineMustBeInTheFuture");

        let author = msg_sender().unwrap();
        let campaign = Campaign::new(asset, author, beneficiary, deadline, target_amount);

        storage.total_campaigns.write(storage.total_campaigns.read() + 1);
        storage.campaigns.insert(storage.total_campaigns.read(), campaign);
    }

    #[storage(read, write), payable]
    fn pledge(campaign_id: u64) {
        let mut campaign = storage.campaigns.get(campaign_id).try_read().unwrap();

        require(campaign.asset == msg_asset_id(), "IncorrectAssetSent");
        require(campaign.deadline > height().as_u64(), "CampaignEnded");
        require(campaign.state != CampaignState::Claimed, "CampaignHasBeenClaimed");

        campaign.total_pledge += msg_amount();
        storage.campaigns.insert(campaign_id, campaign);
    }

    #[storage(read, write)]
    fn claim_pledges(campaign_id: u64) {
        log(campaign_id);
    }
}

impl Info for Contract {
    #[storage(read)]
    fn total_campaigns() -> u64 {
        storage.total_campaigns.read()
    }

    #[storage(read)]
    fn campaign_info(campaign_id: u64) -> Option<Campaign> {
        storage.campaigns.get(campaign_id).try_read()
    }

    #[storage(read)]
    fn pledge_count(user: Identity) -> u64 {
        storage.pledge_count.get(user).try_read().unwrap_or(0)
    }
}

const BASE_TOKEN: AssetId = AssetId {
    value: 0x0000000000000000000000000000000000000000000000000000000000000000,
};

#[test]
fn test_total_campaigns() {
    let caller = abi(Info, CONTRACT_ID);
    let result = caller.total_campaigns {}();
    assert(result == 0);
}

#[test]
fn test_create_campaign() {
    let user = Identity::Address(Address::from(0x0000000000000000000000000000000000000000000000000000000000000001));

    let caller = abi(CrowdfundingABI, CONTRACT_ID);
    caller.create_campaign {}(BASE_TOKEN, user, 100, 200);
    let caller_info = abi(Info, CONTRACT_ID);
    let result = caller_info.total_campaigns {}();
    assert(result == 1);
}

#[test]
fn test_campaign_info() {
    let user = Identity::Address(Address::from(0x0000000000000000000000000000000000000000000000000000000000000001));
    let caller = abi(CrowdfundingABI, CONTRACT_ID);
    caller.create_campaign {}(BASE_TOKEN, user, 100, 200);

    let caller_info = abi(Info, CONTRACT_ID);
    let result = caller_info.campaign_info {}(1).unwrap();
    assert(result.beneficiary == user);
}
