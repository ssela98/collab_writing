// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "bootstrap"
import * as bootstrap from "bootstrap"
import "controllers"
import "@hotwired/turbo-rails"

// TODO: remove @rails/ujs and replace link_to delete with buttons
// https://www.youtube.com/watch?v=dr8AbCCXuEw
import Rails from '@rails/ujs'
Rails.start()
