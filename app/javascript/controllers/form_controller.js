import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="form"
export default class extends Controller {
  static targets = ["form"]

  submitAndRemove() {
    if (this.hasFormTarget) {
      this.formTarget.requestSubmit()
      this.formTarget.remove()
    } else {
      console.log("no form target!")
    }
  }

  submit() {
    if (this.hasFormTarget) {
      this.formTarget.requestSubmit()
    } else {
      console.log("no form target!")
    }
  }
}
