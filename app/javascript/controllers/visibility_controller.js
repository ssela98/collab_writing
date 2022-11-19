import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "hideable" ]

  initialize() {
    console.log(this.hideableTargets)
  }

  showTargets() {
    this.hideableTargets.forEach(el => {
      el.hidden = false
    });
  }

  hideTargets() {
    this.hideableTargets.forEach(el => {
      el.hidden = true
    });
  }

  toggleTargets() {
    console.log('bla')
    this.hideableTargets.forEach((el) => {
      el.hidden = !el.hidden
    });
  }
}
