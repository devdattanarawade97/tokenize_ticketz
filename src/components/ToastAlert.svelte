<script>
	
   
    //imports
	import { Icon, Toast, ToastBody, ToastHeader } from '@sveltestrap/sveltestrap';
	import { onMount } from 'svelte';
	import { fade, blur, slide } from 'svelte/transition';
	import alertStore from '../store/alertStore';

	let errorShow = $alertStore.alertType === 'error' ? 'bg-danger-subtle' : 'bg-success-subtle';

	//on mount- to hide error after some time
	onMount(() => {
		if ($alertStore.show) {
			const timeoutId = setTimeout(() => {
				alertStore.hideError();
			}, 6000);

			return () => {
				clearTimeout(timeoutId);
			};
		}
	});
</script>


<div transition:blur class=" d-flex justify-content-center">
	
	<Toast autohide class=" position-fixed top-0 end-0 ">
		<ToastBody bind:class={errorShow}>
			<span class="fw-bold">{$alertStore.alertType}</span> : {$alertStore.alertMessage}
		</ToastBody>
	</Toast>
</div>
