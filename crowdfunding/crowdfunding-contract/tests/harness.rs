use fuels::{
    prelude::*,
    types::{ContractId, Identity},
};

// Load abi from json
abigen!(Contract(
    name = "CrowdfundingContract",
    abi = "out/debug/crowdfunding-contract-abi.json"
));

async fn get_contract_instance() -> (CrowdfundingContract<WalletUnlocked>, ContractId) {
    // Launch a local network and deploy the contract
    let mut wallets = launch_custom_provider_and_get_wallets(
        WalletsConfig::new(
            Some(1),             /* Single wallet */
            Some(1),             /* Single coin (UTXO) */
            Some(1_000_000_000), /* Amount per coin */
        ),
        None,
        None,
    )
    .await;
    let wallet = wallets.pop().unwrap();

    let id = Contract::load_from(
        "./out/debug/crowdfunding-contract.bin",
        LoadConfiguration::default(),
    )
    .unwrap()
    .deploy(&wallet, TxParameters::default())
    .await
    .unwrap();

    let instance = CrowdfundingContract::new(id.clone(), wallet);

    (instance, id.into())
}

#[tokio::test]
async fn pledge() {
    let (instance, _id) = get_contract_instance().await;
    // get wallets
    let number_of_coins = 1;
    let coin_amount = 1_000_000;
    let number_of_wallets = 3;
    let campaign_id = 1;

    let base_asset = AssetConfig {
        id: AssetId::new([1; 32]),
        num_coins: number_of_coins,
        coin_amount,
    };

    let assets = vec![base_asset];
    let wallet_config = WalletsConfig::new_multiple_assets(number_of_wallets, assets);
    let mut wallets = launch_custom_provider_and_get_wallets(wallet_config, None, None).await;

    let user_wallet = wallets.pop().unwrap();

    // create
    let beneficiary = Identity::Address(user_wallet.address().into());
    instance
        .methods()
        .create_campaign(base_asset.id, beneficiary, 100, 512)
        .call()
        .await
        .unwrap();

    // get info
    let campaign = get_campaign(&instance, campaign_id).await;
    assert_eq!(campaign.total_pledge, 0);

    println!("-------- 👾 campaign {:?}", campaign);
    println!("");

    // // pledge
    let tx_params = TxParameters::new(0, 2_000_000, 0);
    let call_params = CallParameters::new(5, AssetId::from(BASE_ASSET_ID), 1_000_000);

    instance
        .methods()
        .pledge(campaign_id)
        .tx_params(tx_params)
        .call_params(call_params)
        .unwrap()
        .call()
        .await
        .unwrap();

    let campaign2 = get_campaign(&instance, campaign_id).await;

    assert_eq!(campaign2.target_amount, 512);
}

async fn get_campaign(instance: &CrowdfundingContract<WalletUnlocked>, id: u64) -> Campaign {
    instance
        .methods()
        .campaign_info(id)
        .call()
        .await
        .unwrap()
        .value
        .unwrap()
}
