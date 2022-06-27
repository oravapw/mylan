import { Controller } from "@hotwired/stimulus"

// Idea from https://boringrails.com/articles/self-destructing-stimulus-controllers/

// Connects to data-controller="grab-focus"
export default class extends Controller {
  static values = {
    selector: String
  }

  connect() {
    this.grabFocus()
    this.element.remove()
  }

  grabFocus() {
    if (this.hasSelectorValue) {
      document.querySelector(this.selectorValue)?.focus()
    }
  }
}
