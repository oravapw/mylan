import {Controller} from "@hotwired/stimulus"

// Connects to data-controller="remove-alert"
export default class extends Controller {
    static targets = ["removal"]

    remove() {
        if (this.hasRemovalTarget) {
            this.removalTarget.remove();
        }
    }
}
