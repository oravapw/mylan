import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search-form"
export default class extends Controller {
    static targets = ["form", "trigger"];

    search() {
        if (this.hasFormTarget) {
            clearTimeout(this.timeout);
            this.timeout = setTimeout(() => {
                this.formTarget.requestSubmit();
            }, 200)
        } else {
            console.log("no form target!");
        }
    }

    clear() {
        if (this.hasFormTarget) {
            this.formTarget.reset();
            this.formTarget.requestSubmit();
        } else {
            console.log("no form target!");
        }
    }

    clearinput() {
        if (this.hasFormTarget) {
            this.formTarget.reset();
        } else {
            console.log("no form target!");
        }
    }

    // we use "trigger" target elements (via Turbo Streams) to trigger form visible input clear
    triggerTargetConnected(_elem) {
        this.clearinput();
    }
}
