import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="pin-comment"
export default class extends Controller {
  static targets = [ 'comment' ]

  toggleClass() {
    this.commentTarget.classList.toggle('pinned-comment')
  }
}
