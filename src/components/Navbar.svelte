<script>

    //import

	import {ethers } from 'ethers';
	import alertStore from '../store/alertStore';


    //signer address to show on header 
	/**
	 * @type {string | undefined}
	 */
	let signerAddress;
  
   
    /**
	 * @type {number | bigint}
	 */
    let metamaskWalletBalance;
	/**
	 * @type {any}
	 */
	let metamaskWalletBalanceInEth;
	$:if(metamaskWalletBalance){
		// @ts-ignore
		metamaskWalletBalanceInEth=metamaskWalletBalance/BigInt(10**18);
		console.log(`wallet balance in ether : ${metamaskWalletBalanceInEth}`);
	}


    //handle metamask connection 
	async function handleConnectMetamask() {
		try {
			// @ts-ignore
			const ethereumObject = await window.ethereum;
			console.log(`window ethereum : ${ethereumObject}`);
			// @ts-ignore
			if ((await window.ethereum) == null) {
				console.log('metamask not installed');
                alertStore.showError("please Connect to metamask");
			} else {
				// @ts-ignore
				let provider = await new ethers.BrowserProvider(window.ethereum);
				let signer = await provider.getSigner();
				//    console.log(`signer : ${signer}`);
				signerAddress = await signer.getAddress();
				metamaskWalletBalance=await provider.getBalance(signerAddress);
			// 	const contract = await new ethers.Contract(
			// 		BlockBazzarContractAddress,
			// 		BlockBazzarContractJson.abi,
			// 	signer
			// );
			
			// 	decenCartWalletBalance=await contract.getWalletBalance();
			// 	count = await contract.getAllProductsLength();
				//    console.log(`signed in as ${signerAddress}`);
                alertStore.showSuccess("Connected to Metamask Successfully");
			}
		} catch (error) {
			console.log(`error is ${error}`);
            // @ts-ignore
            alertStore.showError(error.message);
		}
	}
</script>

<main >
	<nav class="nav text-dark-emphasis  fs-3 p-2 border-bottom  ">
		<nav class="navbar-brand fw-bold d-flex ps-4">TokenizeTicketz</nav>
		
		{#if signerAddress !== undefined}
		<div class="me-auto d-flex mx-4 justify-content-center align-content-center ">
			<div class="px-3">
				<a href="/" class="text-decoration-none fs-6 text-dark">Home</a>
			</div>
			<div class="px-3">
				<a href="/tokenize" class="text-decoration-none fs-6 text-dark">Tokenize</a>
			</div>
			<div class="px-3">
				<a href="/sale" class="text-decoration-none fs-6 text-dark">Sale</a>
			</div>
			<div class="px-3">
				<a href="/tickets" class="text-decoration-none fs-6 text-dark">Tickets</a>
			</div>
			<div class="px-3">
				<a href="/redeem" class="text-decoration-none fs-6 text-dark">Redeem</a>
			</div>
			<div class="px-3">
				<a href="/gift" class="text-decoration-none fs-6 text-dark">Gift</a>
			</div>
		
		
		</div>
			<div class="ms-auto bg-dark text-white p-2 rounded-2 ">
				<div class=" fs-6 ">Your Account : {signerAddress.substring(0 , 2)}...{signerAddress.substring(38 , 42)}
					<span class=" px-2 fs-6 ">{metamaskWalletBalanceInEth} ETH</span>
				</div>
				
			</div>

		{:else}
		<div class="me-auto d-flex mx-4 justify-content-center align-content-center ">
			<div class="px-3">
				<a href="/" class="text-decoration-none fs-6  text-dark">Home</a>
			</div>
			<div class="px-3">
				<a href="/tokenize" class="text-decoration-none fs-6  text-dark">Tokenize</a>
			</div>
			<div class="px-3">
				<a href="/sale" class="text-decoration-none fs-6  text-dark">Sale</a>
			</div>
			<div class="px-3">
				<a href="/tickets" class="text-decoration-none fs-6  text-dark">Tickets</a>
			</div>
			<div class="px-3">
				<a href="/redeem" class="text-decoration-none fs-6  text-dark">Redeem</a>
			</div>
			<div class="px-3">
				<a href="/gift" class="text-decoration-none fs-6  text-dark">Gift</a>
			</div>
		
		
		</div>
			<button class="btn btn-outline-dark  ms-auto " on:click={handleConnectMetamask}
				>Connect metamask</button
			>
			<!-- <button class="btn btn-outline-light mx-2" on:click={handleConnectMetamask}
				>Contribute</button
			>
			<button class="btn btn-outline-light mx-2" on:click={handleConnectMetamask}
				>Contact us</button
			> -->
		{/if}
	</nav>
</main>
