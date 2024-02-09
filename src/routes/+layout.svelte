<script>

    import Navbar from '../components/Navbar.svelte'
    import ToastAlert from '../components/ToastAlert.svelte'
    import alertStore from "../store/alertStore";
    </script>
    
    <main>
        <Navbar></Navbar>
        {#if $alertStore.show}
            <ToastAlert></ToastAlert>
        {/if}
        <slot />
    </main>