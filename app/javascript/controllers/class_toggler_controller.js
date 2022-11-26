import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="class-toggler"
export default class extends Controller {
  static targets = [ 'togglee' ]

  toggle(event) {
    event.preventDefault()
    this.toggleeTarget.classList.toggle(this.toggleeTarget.dataset.toggleClassValue)
  }
}
