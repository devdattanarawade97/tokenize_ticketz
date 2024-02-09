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
	let allTickets;
    
	/**
	 * @type {any}
	 */
	let checkTicketId;

	/**
	 * @type {{ eventName: any; isEventExpired: any; tokenId: any; eventId: any; eventPrice: any; venueDetails: any; eventStartTimestamp: string; eventEndTimestamp: string; isBurned: any; } | undefined}
	 */
	let ticket;

	onMount(async () => {
		// @ts-ignore
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

			allTickets= await contract.getAllTickets();

			//  console.log(`all events : ${allEvents}`);
		} else {
			console.log('please connect metamask');
			alertStore.showError('Invalid Input or Ensure Metamask Connected');
		}
	});
      

	  //async function 
	  async function handleCheckTicket() {

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

	   ticket= await contract.checkTicketById(checkTicketId);

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

<main>
	<div class="container">

		{#if allTickets !== undefined}
			{#each allTickets as eachTicket}
				<div class="mt-5 d-flex justify-content-center">
					<Card class="w-50 border-dark">
						<CardHeader>
							<CardTitle
								>
                               {eachTicket.eventName}
							   {#if eachTicket.isEventExpired}
							   <Badge color="secondary">Expired</Badge>
						         {:else}
								 <Badge color="success">yet to live</Badge>
								{/if}
							</CardTitle>
						</CardHeader>
						<CardBody class="text-dark-emphasis fw-bold">
							<div>Ticket No : {eachTicket.tokenId}</div>
							<div>Event Id : {eachTicket.eventId}</div>
							<div>Price : {eachTicket.eventPrice} in Wei</div>
							<div>Event Place : {eachTicket.venueDetails}</div>
							<div>
								Event Start : {new Date(
									parseInt(eachTicket.eventStartTimestamp)
								).toLocaleString()}
							</div>
							<div>
								Event End : {new Date(
									parseInt(eachTicket.eventEndTimestamp)
								).toLocaleString()}
							</div>
							<div>
								 Ticket Used : {eachTicket.isBurned}
							</div>
							
						</CardBody>
					</Card>
				</div>
			{/each}
		{/if}
		<div class="mt-5 d-flex justify-content-center">
			<Card class="w-50  border-dark">
				<CardHeader>
					<CardTitle
						>
					  Check Ticket
					</CardTitle>
				</CardHeader>
				<CardBody class="text-dark">
					<label for="" class="">Ticket Id</label>
					<input bind:value={checkTicketId} type="text"  class="form-control shadow-none  border-dark">
					
				</CardBody>
				<CardFooter>
					<button class="btn btn-warning" on:click={handleCheckTicket}>Check</button>
				</CardFooter>
			</Card>
		</div>
		{#if ticket!==undefined}
		<div class="mt-5 d-flex justify-content-center ">
		
			<Card class="w-50 bg-success-subtle">
				<CardHeader class="d-flex flex-row justify-content-center align-items-center">
					<CardTitle
					
						class="text-dark">{ticket.eventName}
						{#if ticket.isEventExpired}
						<Badge color="secondary">Expired</Badge>
						  {:else}
						  <Badge color="success">yet to live</Badge>
						 {/if}
					</CardTitle>
					<button class="btn btn-dark ms-auto" on:click={toggle}>check</button>
				</CardHeader>
			</Card>
		</div>
		

		<Modal isOpen={open} {toggle} header={ticket.eventName} body >
			    
				<div><span class="text-dark">Event Id</span> : {ticket.eventId}</div>
					<div><span class="text-dark">Event Price</span>: {ticket.eventPrice} in Wei</div>
					<div><span class="text-dark">Venue</span> : {ticket.venueDetails}</div>
					<div><span class="text-dark">Event Start</span>
						 : {new Date(
							parseInt(ticket.eventStartTimestamp)
						).toLocaleString()}
					</div>
					<div><span class="text-dark">Event End</span>
						 : {new Date(
							parseInt(ticket.eventEndTimestamp)
						).toLocaleString()}
					</div>
					<div>
						Ticket Used : {ticket.isBurned}
				   </div>
	
		</Modal>
		
		{/if}
	</div>

</main>
