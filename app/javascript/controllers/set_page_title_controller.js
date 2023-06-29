import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="set-page-title"
export default class extends Controller {
  static values = {
    title: String
  }

  connect() {
    if (this.hasTitleValue) {
      document.title = this.titleValue
    }
  }
}
