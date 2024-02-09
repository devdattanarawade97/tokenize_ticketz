<script>
	//import
	import { onMount } from 'svelte';
	import { ethers } from 'ethers';

	import alertStore from '../../store/alertStore';

	import TokenizeTicketzJson from '../../artifacts/contracts/TokenTicketz.sol/TokenTicketz.json';

	import { PUBLIC_CONTRACT_ADDRESS } from '$env/static/public';
	const tokenTicketzContractAddress = PUBLIC_CONTRACT_ADDRESS;
	import {
		// @ts-ignore
		Button,
		Card,
		CardBody,
		CardFooter,
		CardHeader,
		// @ts-ignore
		CardSubtitle,
		// @ts-ignore
		CardText,
		CardTitle,
		// @ts-ignore
		FormGroup,
		// @ts-ignore
		Input,
		Badge
	} from '@sveltestrap/sveltestrap';

	// @ts-ignore
	/**
	 * @type {any | ethers.Overrides}
	 */
	let tokenId;
	// @ts-ignore
	/**
	 * @type {any | ethers.Overrides}
	 */
	let tokenOwnerAddress;
	// @ts-ignore
	/**
	 * @type {any | ethers.Overrides}
	 */
	let eventId;

	let signerAddress;

	//async function
	async function handleRedeemTicketNFT() {
		try {
			// @ts-ignore
			const ethereumObject = await window.ethereum;

			if (ethereumObject != undefined) {
				const provider = await new ethers.BrowserProvider(ethereumObject);
				const signer = await provider.getSigner();

				const contract = await new ethers.Contract(
					tokenTicketzContractAddress,
					TokenizeTicketzJson.abi,
					signer
				);

				const redeemNFT = await contract.redeemTicketNFT(tokenId, tokenOwnerAddress, eventId);

				await redeemNFT.wait();
                alertStore.showSuccess('Token redeemed successfully');
				//  console.log(`all events : ${allEvents}`);
			} else {
				console.log('please connect metamask');
				alertStore.showError('Invalid Input or Ensure Metamask Connected');
			}
		} catch (error) {
			// @ts-ignore
			console.log(`error occured : ${error.message}`);
		}
	}
</script>

<main>
	<div class="container">
		<div class="mt-5 d-flex justify-content-center">
			<Card class="w-50 border-dark">
				<CardHeader>
					<CardTitle>Redeem Token</CardTitle>
				</CardHeader>
				<CardBody class="">
                   
                    <div class="mt-3">
                        <label for="" class="text-dark">Token Id</label>
                        <input
                            bind:value={tokenId}
                            type="text"
                      
                            class="form-control shadow-none border-dark"
                        />
                    </div>
					
                    <div class="mt-3">
                        <label for="" class="text-dark">Token Owner Address</label>
                        <input
						bind:value={tokenOwnerAddress}
						type="text"
                    
						class="form-control shadow-none border-dark"
					/>
                    </div>
                    <div class="mt-3">
                        <label for="" class="text-dark">Event Id</label>
                        <input
						bind:value={eventId}
						type="text"
				
						class="form-control shadow-none border-dark"
					/>
                    </div>
					
				</CardBody>
				<CardFooter>
					<button class="btn btn-warning" on:click={handleRedeemTicketNFT}>Redeem Ticket</button>
				</CardFooter>
			</Card>
		</div>
	</div>
</main>
