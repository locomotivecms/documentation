import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const currentPath = window.location.pathname.replace(/\/$/, '')
    const links = this.element.querySelectorAll('a[href]')

    for (const link of links) {
      const linkPath = link.getAttribute('href').replace(/\/$/, '')
      if (linkPath === currentPath) {
        requestAnimationFrame(() => {
          link.scrollIntoView({ block: 'center', behavior: 'instant' })
        })
        break
      }
    }
  }
}
