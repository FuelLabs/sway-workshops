library;

use core::ops::Eq;

pub enum CampaignState {
    Claimed: (),
    Funding: (),
}

impl Eq for CampaignState {
    fn eq(self, other: CampaignState) -> bool {
        match (self, other) {
            (CampaignState::Claimed, CampaignState::Claimed) => true,
            (CampaignState::Funding, CampaignState::Funding) => true,
            _ => false,
        }
    }
}

/// General data structure containing information about a campaign.
pub struct Campaign {
    asset: AssetId,
    author: Identity,
    beneficiary: Identity,
    state: CampaignState,
    deadline: u64,
    target_amount: u64,
    total_pledge: u64,
}

impl Campaign {
    /// Creates a new campaign.
    ///
    /// # Arguments
    ///
    /// * `asset`: [AssetId] - The asset that this campaign accepts as a deposit.
    /// * `author`: [Identity] - The user who has created the campaign.
    /// * `beneficiary`: [Identity] - The user to whom the funds will be sent to upon a successful campaign.
    /// * `deadline`: [u64] - The end time for the campaign after which it becomes locked.
    /// * `target_amount`: [u64] - The amount needed to deem the campaign a success.
    ///
    /// # Returns
    ///
    /// * [Campaign] - The newly created campaign.
    pub fn new(
        asset: AssetId,
        author: Identity,
        beneficiary: Identity,
        deadline: u64,
        target_amount: u64,
    ) -> Self {
        Self {
            asset,
            author,
            beneficiary,
            state: CampaignState::Funding,
            deadline,
            target_amount,
            total_pledge: 0,
        }
    }
}
