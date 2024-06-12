import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="clipboard"
export default class extends Controller {
  static targets = [ "source" ]

  copy(event) {
    this.copyContent(this.sourceTarget.textContent)
  }

  async copyContent(text) {
    try {
      await navigator.clipboard.writeText(text)
      // console.log('Content copied to clipboard ' + text);
    } catch (err) {
      console.error('Failed to copy: ', err);
    }
  }

}
