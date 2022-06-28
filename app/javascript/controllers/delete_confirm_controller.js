import {Controller} from "@hotwired/stimulus"

// Connects to data-controller="delete-confirm"
export default class extends Controller {

  static values = {
    action: String
  }

  do(event) {
    let msg = "Are you sure?"
    if (this.hasActionValue) {
      msg = `Are you sure you want to ${this.actionValue}?`
    }
    let confirmed = confirm(msg)
    if (!confirmed) {
      event.preventDefault()
    }
  }

}
