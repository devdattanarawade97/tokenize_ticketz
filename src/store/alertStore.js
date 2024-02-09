import { writable } from "svelte/store";




const alertObject = {
    
    show: false,
    alertType: "error",
    alertMessage:"hello"
}

const alertStore = writable(alertObject);



export default {


    subscribe: alertStore.subscribe,
    // @ts-ignore
    showError: (message) => {
        alertObject.show = true;
        alertObject.alertType = "error";
        alertObject.alertMessage=message
        alertStore.set(alertObject);
    }, 
    // @ts-ignore
    showSuccess: (message) => {
        alertObject.show = true;
        alertObject.alertType = "success";
        alertObject.alertMessage=message
        alertStore.set(alertObject);

    },
    hideError: () => {
        alertObject.show = false;
        alertObject.alertType = "error";
        alertObject.alertMessage=""
        alertStore.set(alertObject);

    }
}