library;

use core::ops::Eq;

/// Represents the current state of the campaign.
pub enum CampaignState {
    /// The campaign has been cancelled.
    Cancelled: (),
    /// The campain was successful and the funds have been claimed.
    Claimed: (),
    /// The campaign is still accepting funds.
    Funding: (),
}

impl Eq for CampaignState {
    fn eq(self, other: CampaignState) -> bool {
        match (self, other) {
            (CampaignState::Cancelled, CampaignState::Cancelled) => true,
            (CampaignState::Claimed, CampaignState::Claimed) => true,
            (CampaignState::Funding, CampaignState::Funding) => true,
            _ => false,
        }
    }
}

/// General data structure containing information about a campaign.
pub struct CampaignInfo {
    /// The user who has created the campaign.
    author: Identity,
    /// The user to whom the funds will be sent to upon a successful campaign.
    beneficiary: Identity,
    // Whether the campaign is currently: Funding, Claimed, Cancelled.
    state: CampaignState,
    /// The end time for the campaign after which it becomes locked.
    deadline: u64,
    /// The amount needed to deem the campaign a success.
    target_amount: u64,
    /// The current amount pledged used to measure against the target_amount.
    total_pledge: u64,
}

impl CampaignInfo {
    /// Creates a new campaign.
    ///
    /// # Arguments
    ///
    /// * `asset`: [ContractId] - The asset that this campaign accepts as a deposit.
    /// * `author`: [Identity] - The user who has created the campaign.
    /// * `beneficiary`: [Identity] - The user to whom the funds will be sent to upon a successful campaign.
    /// * `deadline`: [u64] - The end time for the campaign after which it becomes locked.
    /// * `target_amount`: [u64] - The amount needed to deem the campaign a success.
    ///
    /// # Returns
    ///
    /// * [CampaignInfo] - The newly created campaign.
    pub fn new(
        author: Identity,
        beneficiary: Identity,
        deadline: u64,
        target_amount: u64,
    ) -> Self {
        Self {
            author,
            beneficiary,
            state: CampaignState::Funding,
            deadline,
            target_amount,
            total_pledge: 0,
        }
    }
}
