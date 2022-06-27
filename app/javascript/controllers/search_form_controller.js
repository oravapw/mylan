import {ApplicationController, useDebounce} from 'stimulus-use'

// Connects to data-controller="search-form"
export default class extends ApplicationController {
  static targets = ["form", "trigger"]
  static debounces = ["search"]

  connect() {
    useDebounce(this)
  }

  search() {
    if (this.hasFormTarget) {
      this.formTarget.requestSubmit()
    } else {
      console.log("no form target!")
    }
  }

  clear() {
    if (this.hasFormTarget) {
      this.formTarget.reset()
      this.formTarget.requestSubmit()
    } else {
      console.log("no form target!")
    }
  }

  clearinput() {
    if (this.hasFormTarget) {
      this.formTarget.reset()
    } else {
      console.log("no form target!")
    }
  }

  // we use "trigger" target elements (via Turbo Streams) to trigger form visible input clear
  triggerTargetConnected(_elem) {
    this.clearinput()
  }
}
