import {Controller} from "@hotwired/stimulus"

// Connects to data-controller="delete-confirm"
export default class extends Controller {

  do(event) {
    let target = this.data.get("target")
    let confirmed = confirm(`Are you sure you want to delete ${target}?`)
    if (!confirmed) {
      event.preventDefault()
    }
  }

}
