import {Controller} from "@hotwired/stimulus"

// Connects to data-controller="timed-remove"
export default class extends Controller {

  static targets = ["remove"]
  static values = {
    timeout: { type: Number, default: 5000 }
  }

  connect() {
    if (this.hasRemoveTarget) {
      this.removeTargets.forEach((target) => {
        setTimeout(() => {
          target?.remove()
        }, this.timeoutValue)
      })
    } else {
      setTimeout(() => {
        this.element?.remove()
      }, this.timeoutValue)
    }
  }

}
