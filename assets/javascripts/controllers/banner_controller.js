import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { key: { type: String, default: "banner-dismissed" } }

  connect() {
    if (localStorage.getItem(this.keyValue)) {
      this.element.remove()
    }
  }

  dismiss() {
    localStorage.setItem(this.keyValue, "1")
    this.element.remove()
  }
}
