import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="current-user-visibility-controller"
export default class extends Controller {
  static targets = [ 'hideableTurboFrame' ]

  connect() {
    let currentUserUsername = document.querySelector("meta[name='current-user-username']").content
    if (!currentUserUsername) return

    if (this.hideableTurboFrameTarget.dataset.usernameValue == currentUserUsername)
      this.hideableTurboFrameTarget.classList.toggle('d-none')
  }
}
