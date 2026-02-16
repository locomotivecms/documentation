import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["icon", "button"]

  connect() {
    this.setInitialTheme()
  }

  toggle() {
    const currentTheme = this.getCurrentTheme()
    const newTheme = currentTheme === 'dark' ? 'light' : 'dark'
    this.setTheme(newTheme)
  }

  setInitialTheme() {
    // Check if user has a saved preference
    const savedTheme = localStorage.getItem('theme')

    if (savedTheme) {
      this.setTheme(savedTheme)
    } else {
      // Check system preference
      const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches
      this.setTheme(prefersDark ? 'dark' : 'light')
    }
  }

  setTheme(theme) {
    // Update document class
    if (theme === 'dark') {
      document.documentElement.classList.add('dark')
    } else {
      document.documentElement.classList.remove('dark')
    }

    // Save to localStorage
    localStorage.setItem('theme', theme)

    // Update button state
    this.updateButtonState(theme)
  }

  getCurrentTheme() {
    return document.documentElement.classList.contains('dark') ? 'dark' : 'light'
  }

  updateButtonState(theme) {
    if (this.hasIconTarget) {
      // Update icon visibility based on theme
      this.iconTargets.forEach(icon => {
        if (icon.dataset.theme === theme) {
          icon.classList.remove('hidden')
        } else {
          icon.classList.add('hidden')
        }
      })
    }
  }
}
