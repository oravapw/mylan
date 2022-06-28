import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="disable-submit"
export default class extends Controller {
  disable() {
    console.log("called!");
    this.element.setAttribute("disabled", "true")
  }
}
