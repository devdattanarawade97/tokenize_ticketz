<script>

	//import 
	import {ethers} from 'ethers';
    
	import alertStore from '../../store/alertStore';

	import TokenizeTicketzJson from '../../artifacts/contracts/TokenTicketz.sol/TokenTicketz.json';
     
	import {PUBLIC_CONTRACT_ADDRESS} from '$env/static/public';
	const tokenTicketzContractAddress=PUBLIC_CONTRACT_ADDRESS;
	import {
		Button,
		Card,
		CardBody,
		CardFooter,
		CardHeader,
		CardSubtitle,
		CardText,
		CardTitle,
		FormGroup,
		Input , 
		Form
	} from '@sveltestrap/sveltestrap';

	/**
	 * @type {any}
	 */
	let _eventName;
	/**
	 * @type {any}
	 */
	let _eventPrice;
	/**
	 * @type {any}
	 */
	let eventPriceInInteger;
	$:if(_eventPrice){
     
		eventPriceInInteger=parseInt(_eventPrice);
	}

	/**
	 * @type {string | number | Date}
	 */
	let _eventStartTime;
		/**
	 * @type {any}
	 */
	 // @ts-ignore
	 let _venueDetails;

	/**
	 * @type {any}
	 */
	let _eventStartTimestamp;
	$:if(_eventStartTime){
         
		const date= new Date(_eventStartTime);
		_eventStartTimestamp=date.getTime();

		console.log(`event start time : ${_eventStartTimestamp}`);
	}
	/**
	 * @type {any}
	 */
	 // @ts-ignore
	 let _eventEndTime;
	/**
	 * @type {any}
	 */
	let _eventEndTimestamp;
	$:if(_eventEndTime){


		const date= new Date(_eventEndTime);
		_eventEndTimestamp=date.getTime();


console.log(`event end time : ${_eventEndTimestamp}`);
}



	/**
	 * @type {any}
	 */
	 let _saleStartTime;
	 /**
	 * @type {any}
	 */
	 let _saleStartTimestamp;
	$:if(_saleStartTime){
        
		const date= new Date(_saleStartTime);
		_saleStartTimestamp=date.getTime();

		console.log(`event start time : ${_saleStartTimestamp}`);
	}
	/**
	 * @type {any}
	 */
	 let _saleEndTime;
	 /**
	 * @type {any}
	 */
	 let _saleEndTimestamp;
	$:if(_saleEndTime){
        
		const date= new Date(_saleEndTime);
		_saleEndTimestamp=date.getTime();

		console.log(`event start time : ${_saleEndTimestamp}`);
	}
	/**
	 * @type {any}
	 */
	let _TokenRedeemerAddress;


	//async function handle click

	async function handleCreateEvent() {

		try {

			// @ts-ignore
			const ethereumObject= await window.ethereum;

			if(ethereumObject!==undefined){

				const provider= await new ethers.BrowserProvider(ethereumObject);
				const signer= await provider.getSigner();

			    console.log(`signer : ${signer}`);
               
				 /*
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
				  */

				  if(signer){
					const contract= await new ethers.Contract(tokenTicketzContractAddress , TokenizeTicketzJson.abi ,signer );
					console.log(`contract : ${contract}`);
					const createEventFunction=await contract.createEventForUser(_eventName , eventPriceInInteger,_venueDetails 
					,_eventStartTimestamp, _eventEndTimestamp,_saleStartTimestamp ,_saleEndTimestamp,_TokenRedeemerAddress
				 )
                  
				
				 await createEventFunction.wait();
	
				 alertStore.showSuccess("Event created successfully");
				  }
			}else{

				console.log('please connect metamask');
				alertStore.showError("Invalid Input or Ensure Metamask Connected");
			}
			
			
		} catch (error) {
			
			// @ts-ignore
			console.log(error);
			// @ts-ignore
			alertStore.showError(error.message);            
		}
	}
</script>

<main class="" style="">
	<div class="container">
		<div class="pt-5  d-flex justify-content-center">
			<Card class="w-50  text-dark border-dark ">
				<CardHeader>
					<CardTitle >Create Event</CardTitle>
				</CardHeader>
				<CardBody class=" fs-6">
					<label for="event-name" class="">Event Name</label>
					<input
						bind:value={_eventName}
						type="text"
						id="event-name"
						class="form-control shadow-none mb-3 border-dark "
						placeholder=""
					/>

					<label for="event-price" class="">Event Price in ETH</label>
					<input
						bind:value={_eventPrice}
						type="text"
						id="event-price"
						class="form-control shadow-none mb-3 border-dark "
				
					/>

					<label for="venue-details" class="">Venue</label>
					<input
						bind:value={_venueDetails}
						type="text"
						id="venue-details"
			
						class="form-control shadow-none mb-3 border-dark "
					/>

					<div class="d-flex flex-column justify-content-center">
						<div class="d-flex flex-row">
							<div class="me-auto">
								<label for="" class="">Sale Start</label>
								<input
									bind:value={_saleStartTime}
									type="datetime-local"
							
									class="form-control shadow-none mb-3 border-dark "
								/>
							</div>
							<div class="ms-auto">
								<label for="" class="">Sale End</label>
								<input
									bind:value={_saleEndTime}
									type="datetime-local"
									class="form-control shadow-none mb-3 border-dark"
								/>
							</div>
						</div>
						<div class="d-flex flex-row">
							<div class="me-auto">
								<label for="" class="">Event Start</label>
								<input
									bind:value={_eventStartTime}
									type="datetime-local"
									class="form-control shadow-none mb-3 border-dark "
								/>
							</div>
							<div class="ms-auto">
								<label for="" class="">Event End</label>
								<input
									bind:value={_eventEndTime}
									type="datetime-local"
									class="form-control shadow-none mb-3 border-dark "
								
								/>
							</div>
						</div>
						
					</div>
					<label for="" class="">Token Redeemer Address</label>
					<input bind:value={_TokenRedeemerAddress} type="text" class="form-control shadow-none mb-3 border-dark " />
				</CardBody>
				<CardFooter>
					<button class=" btn btn-warning" type="submit" on:click={handleCreateEvent}>Create</button>
				</CardFooter>
			</Card>
		</div>
	</div>
</main>
