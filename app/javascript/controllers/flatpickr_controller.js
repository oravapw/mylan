import { Controller } from "@hotwired/stimulus"

import flatpickr from "flatpickr"

// Connects to data-controller="flatpickr"
export default class extends Controller {
  connect() {
    flatpickr(".tournament-start", {
      enableTime: true,
      time_24hr: true,
      minDate: Date.now(),
      locale: {
        firstDayOfWeek: 1
      }
    })
  }
}
