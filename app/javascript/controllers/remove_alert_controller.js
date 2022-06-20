import {Controller} from "@hotwired/stimulus"

// Connects to data-controller="remove-alert"
export default class extends Controller {
  do() {
      this.element.parentElement.remove();
    }
}
