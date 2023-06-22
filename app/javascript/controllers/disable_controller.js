import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="disable-submit"
export default class extends Controller {
  disable() {
    this.element.setAttribute("disabled", "true")
  }
}
