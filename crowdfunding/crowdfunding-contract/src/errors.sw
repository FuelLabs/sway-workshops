library;

/// Errors related to the campaign's creation.
pub enum CreationError {
    /// The campaign's deadline must be in the future.
    DeadlineMustBeInTheFuture: (),
    /// The campaign's target amount must be greater than zero.
    TargetAmountCannotBeZero: (),
}

/// Errors related to the campaign.
pub enum CampaignError {
    /// The campaign has already ended.
    CampaignEnded: (),
    /// The campaign has been cancelled.
    CampaignHasBeenCancelled: (),
    /// The campaign's deadline has not been reached yet.
    DeadlineNotReached: (),
    /// The campaign's target was not reached.
    TargetNotReached: (),
}