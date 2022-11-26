import { Controller } from '@hotwired/stimulus'
import { get, post } from '@rails/request.js'

// Connects to data-controller="turbo"
export default class extends Controller {
  getTurboStream(event) {
    event.preventDefault()

    get(event.target.href, {
      contentType: 'text/vnd.turbo-stream.html',
      responseKind: 'turbo-stream'
    })
  }

  postTurboStream(event) {
    event.preventDefault()

    post(event.target.href, {
      contentType: 'text/vnd.turbo-stream.html',
      responseKind: 'turbo-stream'
    })
  }
}
