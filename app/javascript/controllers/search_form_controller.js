import {ApplicationController, useDebounce} from 'stimulus-use'

// Connects to data-controller="search-form"
export default class extends ApplicationController {
  static targets = ["form", "trigger", "focus"]
  static debounces = ["search"]

  connect() {
    useDebounce(this)
  }

  search() {
    if (this.hasFormTarget) {
      this.formTarget.requestSubmit()
    } else {
      console.log("search-form search: no form target!")
    }
  }

  clear() {
    if (this.hasFormTarget) {
      this.formTarget.reset()
      this.formTarget.requestSubmit()
    } else {
      console.log("search-form clear: no form target!")
    }
  }

  clearinput() {
    if (this.hasFormTarget) {
      this.formTarget.reset()
    } else {
      console.log("search-form clearInput: no form target!")
    }
  }

  focus() {
    if (this.hasFocusTarget) {
      this.focusTarget.focus()
    }
  }

  // we use "trigger" target elements (via Turbo Streams) to trigger form visible input clear
  triggerTargetConnected(_elem) {
    this.clearinput()
    this.focus()
  }
}
