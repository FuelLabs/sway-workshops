library;

/// Errors related to the campaign's creation.
pub enum CreationError {
    /// The campaign's deadline must be in the future.
    DeadlineMustBeInTheFuture: (),
    /// The campaign's target amount must be greater than zero.
    TargetAmountCannotBeZero: (),
}
