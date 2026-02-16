import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["link", "pane", "select"]
  static values = {
    linkClass: String,
    activeLinkClass: String
  }

  connect() {
    this.linkClasses = this.linkClassValue.split(" ")
    this.activeLinkClasses = this.activeLinkClassValue.split(" ")
  }

  select(event) {
    event.preventDefault() & event.stopPropagation()

    const index = parseInt(event.target.dataset.tabIndex ?? event.target.value ?? '0')

    this.linkTargets.forEach((link, i) => {
      link.classList.remove(...this.activeLinkClasses)
      const classes = i === index ? this.activeLinkClasses : this.linkClasses
      link.classList.add(...classes)
    })

    this.paneTargets.forEach((pane, i) => {
      pane.classList.toggle("block", i === index)
      pane.classList.toggle("hidden", i !== index)
    })

    this.selectTarget.selectedIndex = index
  }
}
