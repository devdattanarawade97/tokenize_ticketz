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
		Badge, 
		Modal
	} from '@sveltestrap/sveltestrap';
 
	let open=false;
	const toggle= async ()=>{
		open=!open;
		
	}


	
	// @ts-ignore
	/**
	 * @type {undefined}
	 */
	let allEvents;

	// @ts-ignore
	/**
	 * @type {{ eventName: any; isSaleLive: any; isSaleExpired: any; eventId: any; eventPrice: any; venueDetails: any; eventStartTimestamp: string; eventEndTimestamp: string; saleStartTimestamp: string; saleEndTimestamp: string; } | undefined}
	 */
	let checkedEvent;

	// @ts-ignore
	/**
	 * @type {any | ethers.Overrides}
	 */
	let eventId;

	// @ts-ignore
	let selectedEventId;
	// @ts-ignore
	let eventPrice;
	// @ts-ignore
	$: if (selectedEventId) {
		console.log(`selected event id : ${selectedEventId}`);
	}
	let signerAddress;

	async function handleCheckEvents() {
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
				await contract.refreshEvents();

				allEvents = await contract.getAllEvents();

				//  console.log(`all events : ${allEvents}`);
			} else {
				console.log('please connect metamask');
				alertStore.showError('Invalid Input or Ensure Metamask Connected');
			}
		} catch (error) {
			// @ts-ignore
			console.log(error);
			// @ts-ignore
			alertStore.showError(error.message);
		}
	}

	//async function handle get events

	async function handleBuyTicket() {
		try {
			// @ts-ignore
			const ethereumObject = await window.ethereum;

			if (ethereumObject != undefined) {
				const provider = await new ethers.BrowserProvider(ethereumObject);
				const signer = await provider.getSigner();

				if (signer) {
					signerAddress = await signer.getAddress();

					console.log(`signer address : ${signerAddress}`);
					const contract = await new ethers.Contract(
						tokenTicketzContractAddress,
						TokenizeTicketzJson.abi,
						signer
					);

					// @ts-ignore
					console.log(`selected event id : ${selectedEventId}`);
					// @ts-ignore
					const buyTicketFunction = await contract.mintTicketNFT(selectedEventId, {
						// @ts-ignore
						value: eventPrice
					});

					await buyTicketFunction.wait();
					// @ts-ignore
					alertStore.showSuccess('ticket purchased successfully');
				}
			}
		} catch (error) {
			// @ts-ignore
			console.log(error);
			// @ts-ignore
			alertStore.showError(error.message);
		}
	}

	//async function
	async function handleCheckEvent() {
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

				checkedEvent = await contract.checkEventById(eventId);

				//  console.log(`all events : ${allEvents}`);
			} else {
				console.log('please connect metamask');
				alertStore.showError('Invalid Input or Ensure Metamask Connected');
			}
		} catch (error) {
			console.log(`error occured : ${error.message}`);
		}
	}
</script>

<main class="">
	<div class="container">
		<!--
		   uint256 eventId;
        string eventName;
        uint256 eventPrice;
        string venueDetails;
        string eventStartTime;
        string eventEndTime;
        uint256 saleStartTimestamp;
        uint256 saleEndTimestamp;
        bool isEventExpired;
        bool isSaleExpired;
           address tokenRedeemerAddress;
	  -->
	  
		<div class="mt-5 d-flex justify-content-center ">
		
			<Card class="w-50  border-dark">
				<CardHeader>
					<CardTitle>Check Event</CardTitle>
				</CardHeader>
				<CardBody class="">
					<button class="btn btn-warning d-flex mx-auto " on:click={handleCheckEvents}>check events</button>
				</CardBody>
			
			</Card>
		</div>
	 
		{#if allEvents !== undefined}
			{#each allEvents as eachEvent}
			<Card class="w-50 bg-success-subtle mt-3 mx-auto">
				<CardHeader class="d-flex flex-row justify-content-center align-items-center">
				
					<CardTitle
					
						class="text-dark">{eachEvent.eventName}
						<span>{#if eachEvent.isSaleLive}
							<Badge color="danger" >Live</Badge>
						
						{:else if eachEvent.isSaleExpired}
							<Badge color="secondary">Expired</Badge>
						{:else}
							<Badge color="success">Yet to Live</Badge>
						{/if}</span>
							
					</CardTitle>
					<button class="btn btn-dark ms-auto" on:click={
			
					toggle
					}
					
					>check</button>
				</CardHeader>
			</Card>
	
			<Modal isOpen={open} {toggle} header={eachEvent.eventName} body >
			    
				<div><span class="text-dark">Event Id</span> : {eachEvent.eventId}</div>
					<div><span class="text-dark">Event Price</span>: {eachEvent.eventPrice} in Wei</div>
					<div><span class="text-dark">Venue</span> : {eachEvent.venueDetails}</div>
					<div><span class="text-dark">Event Start</span>
						 : {new Date(
							parseInt(eachEvent.eventStartTimestamp)
						).toLocaleString()}
					</div>
					<div><span class="text-dark">Event End</span>
						 : {new Date(
							parseInt(eachEvent.eventEndTimestamp)
						).toLocaleString()}
					</div>
					<div><span class="text-dark">Sale Start</span>
						 : {new Date(
							parseInt(eachEvent.saleStartTimestamp)
						).toLocaleString()}
					</div>
					<div>
						<span class="text-dark">Sale End</span> : {new Date(parseInt(eachEvent.saleEndTimestamp)).toLocaleString()}
					</div>
		
				
		
				<button
						class="btn btn-dark"
						on:click={() => {
							selectedEventId = eachEvent.eventId;
							eventPrice = eachEvent.eventPrice;
							handleBuyTicket();
						}}>Buy</button
					>
	
		</Modal>
					

			<!--


				<div class="mt-5 d-flex justify-content-center ">
					<Card class="w-50 ">
						<CardHeader>
							<CardTitle
								>{eachEvent.eventName}
								{#if eachEvent.isSaleLive}
									<Badge color="danger">Live</Badge>
								{:else if eachEvent.isSaleExpired}
									<Badge color="secondary">Expired</Badge>
								{:else}
									<Badge color="success">Yet to Live</Badge>
								{/if}
							</CardTitle>
						</CardHeader>
						<CardBody class="text-dark-emphasis fw-bold">
							<div>Event_Id : {eachEvent.eventId}</div>
							<div>Price : {eachEvent.eventPrice} in Wei</div>
							<div>Event_Place : {eachEvent.venueDetails}</div>

							<div>
								Event :{new Date(parseInt(eachEvent.eventStartTimestamp)).toLocaleString()} to {new Date(
									parseInt(eachEvent.eventEndTimestamp)
								).toLocaleString()}
							</div>
							<div>
								Sale : {new Date(parseInt(eachEvent.saleStartTimestamp)).toLocaleString()} to {new Date(
									parseInt(eachEvent.saleEndTimestamp)
								).toLocaleString()}
							</div>
						</CardBody>
						<CardFooter>
							<button
								class="btn btn-dark"
								on:click={() => {
									selectedEventId = eachEvent.eventId;
									eventPrice = eachEvent.eventPrice;
									handleBuyTicket();
								}}>Buy</button
							>
						</CardFooter>
					</Card>
				</div>
			-->
			
			{/each}
		{/if}

		

		<div class="mt-5 d-flex justify-content-center ">
		
			<Card class="w-50  border-dark">
				<CardHeader>
					<CardTitle>Check Event</CardTitle>
				</CardHeader>
				<CardBody class="">
					<label for="" class="text-dark">Event Id</label>
					<input bind:value={eventId} type="text" class="form-control shadow-none  border-dark" />
				</CardBody>
				<CardFooter>
					<button class="btn btn-warning" on:click={handleCheckEvent}>Check</button>
				</CardFooter>
			</Card>
		</div>
		{#if checkedEvent !== undefined}

		<div class="mt-5 d-flex justify-content-center ">
		
			<Card class="w-50 bg-success-subtle">
				<CardHeader class="d-flex flex-row justify-content-center align-items-center">
					<CardTitle
					
						class="text-dark">{checkedEvent.eventName}
						{#if checkedEvent.isSaleLive}
							<Badge color="danger" >Live</Badge>
						{:else if checkedEvent.isSaleExpired}
							<Badge color="secondary">Expired</Badge>
						{:else}
							<Badge color="success">Yet to Live</Badge>
						{/if}
					</CardTitle>
					<button class="btn btn-dark ms-auto" on:click={toggle}>check</button>
				</CardHeader>
			</Card>
		</div>
		

		<Modal isOpen={open} {toggle} header={checkedEvent.eventName} body >
			    
				<div><span class="text-dark">Event Id</span> : {checkedEvent.eventId}</div>
					<div><span class="text-dark">Event Price</span>: {checkedEvent.eventPrice} in Wei</div>
					<div><span class="text-dark">Venue</span> : {checkedEvent.venueDetails}</div>
					<div><span class="text-dark">Event Start</span>
						 : {new Date(
							parseInt(checkedEvent.eventStartTimestamp)
						).toLocaleString()}
					</div>
					<div><span class="text-dark">Event End</span>
						 : {new Date(
							parseInt(checkedEvent.eventEndTimestamp)
						).toLocaleString()}
					</div>
					<div><span class="text-dark">Sale Start</span>
						 : {new Date(
							parseInt(checkedEvent.saleStartTimestamp)
						).toLocaleString()}
					</div>
					<div>
						<span class="text-dark">Sale End</span> : {new Date(parseInt(checkedEvent.saleEndTimestamp)).toLocaleString()}
					</div>
		
				
		
				<button
						class="btn btn-dark"
						on:click={() => {
							selectedEventId = checkedEvent.eventId;
							eventPrice = checkedEvent.eventPrice;
							handleBuyTicket();
						}}>Buy</button
					>
	
		</Modal>
      {/if}
		<!--
			{#if checkedEvent !== undefined}
			<div class="mt-5 d-flex justify-content-center">
				<Card class="w-50">
					<CardHeader>
						<CardTitle
							class="text-dark">{checkedEvent.eventName}
							{#if checkedEvent.isSaleLive}
								<Badge color="danger" >Live</Badge>
							{:else if checkedEvent.isSaleExpired}
								<Badge color="secondary">Expired</Badge>
							{:else}
								<Badge color="success">Yet to Live</Badge>
							{/if}
						</CardTitle>
					</CardHeader>
					<CardBody class="text-dark-emphasis">
						<div><span class="text-dark">Event Id</span> : {checkedEvent.eventId}</div>
						<div><span class="text-dark">Event Price</span>: {checkedEvent.eventPrice} in Wei</div>
						<div><span class="text-dark">Venue</span> : {checkedEvent.venueDetails}</div>
						<div><span class="text-dark">Event Start</span>
							 : {new Date(
								parseInt(checkedEvent.eventStartTimestamp)
							).toLocaleString()}
						</div>
						<div><span class="text-dark">Event End</span>
							 : {new Date(
								parseInt(checkedEvent.eventEndTimestamp)
							).toLocaleString()}
						</div>
						<div><span class="text-dark">Sale Start</span>
							 : {new Date(
								parseInt(checkedEvent.saleStartTimestamp)
							).toLocaleString()}
						</div>
						<div>
							<span class="text-dark">Sale End</span> : {new Date(parseInt(checkedEvent.saleEndTimestamp)).toLocaleString()}
						</div>
					</CardBody>
					<CardFooter>
						<button
							class="btn btn-dark"
							on:click={() => {
								selectedEventId = checkedEvent.eventId;
								eventPrice = checkedEvent.eventPrice;
								handleBuyTicket();
							}}>Buy</button
						>
					</CardFooter>
				</Card>
			</div>
		{/if}
		-->
	</div>
</main>
