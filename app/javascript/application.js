// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "bootstrap"
import * as bootstrap from "bootstrap"
import "controllers"
import "@hotwired/turbo-rails"

// TODO: remove these 2 lines(@rails/ujs) and replace link_to delete with buttons
import Rails from '@rails/ujs'
Rails.start()

import "trix"
import "@rails/actiontext"

// Disable Trix attachments
window.addEventListener("trix-file-accept", function(event) {
  event.preventDefault()
  alert("File attachment not supported!")
})
import "@rails/request.js"
