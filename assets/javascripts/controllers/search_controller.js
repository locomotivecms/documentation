import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results", "button", "dropdown", "toggle"]
  static values = { indexUrl: String }

  connect() {
    this.index = null
    this.docs = []
    this.flex = null
    this.dropdownOpen = false
    this.loadFlexSearch().then(() => this.loadIndex())
    this.handleDocumentClick = this.handleDocumentClick.bind(this)
    this.handleEscape = this.handleEscape.bind(this)
  }

  async loadFlexSearch() {
    if (!window.FlexSearch) {
      await new Promise((resolve, reject) => {
        const script = document.createElement('script')
        script.src = "https://cdn.jsdelivr.net/npm/flexsearch@0.7.31/dist/flexsearch.bundle.js"
        script.onload = resolve
        script.onerror = reject
        document.head.appendChild(script)
      })
    }
  }

  async loadIndex() {
    const res = await fetch(this.indexUrlValue)
    this.docs = await res.json()
    this.flex = new window.FlexSearch.Document({
      tokenize: "forward",
      document: {
        id: "id",
        index: ["title", "headings", "content"]
      }
    })
    for (const doc of this.docs) this.flex.add(doc)
  }

  search(event) {
    const query = this.inputTarget.value.trim()
    if (!query || !this.flex) {
      this.resultsTarget.innerHTML = ''
      this.resultsTarget.classList.add('hidden')
      return
    }
    // Use FlexSearch's suggest for fuzzy/partial matching
    const results = this.flex.search(query, {
      suggest: true,
      limit: 8
    })
    const found = [...new Set([].concat(...results.map(r => r.result)))].map(id => this.docs.find(d => d.id === id))
    this.renderResults(found, query)
  }

  renderResults(results, query) {
    if (!results.length) {
      this.resultsTarget.innerHTML = `<li class='px-4 py-2 text-zinc-500 dark:text-zinc-400'>No results found.</li>`
      this.resultsTarget.classList.remove('hidden')
      return
    }
    this.resultsTarget.innerHTML = results.slice(0, 8).map((doc, i) => `
      <li class="${i > 0 ? 'border-t border-zinc-100 dark:border-zinc-800' : ''}">
        <a href="${doc.url}" class="block px-4 py-2 hover:bg-zinc-100 dark:hover:bg-zinc-800 rounded transition">
          <div class="font-semibold text-zinc-900 dark:text-zinc-100">${this.highlight(doc.title, query)}</div>
          <div class="text-xs text-zinc-500 dark:text-zinc-400 mb-1">${doc.headings.map(h => this.highlight(h, query)).join(' · ')}</div>
          <div class="prose prose-sm dark:prose-invert line-clamp-2">${this.snippet(doc.content, query)}</div>
        </a>
      </li>
    `).join('')
    this.resultsTarget.classList.remove('hidden')
  }

  highlight(text, query) {
    if (!text) return ''
    const re = new RegExp(`(${query.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')})`, 'gi')
    return text.replace(re, '<mark class="bg-yellow-200 dark:bg-yellow-700">$1</mark>')
  }

  snippet(html, query) {
    // Extract a short snippet around the first match
    const div = document.createElement('div')
    div.innerHTML = html
    const text = div.textContent || ''
    const idx = text.toLowerCase().indexOf(query.toLowerCase())
    if (idx === -1) return div.innerHTML.slice(0, 120) + '...'
    const start = Math.max(0, idx - 40)
    const end = Math.min(text.length, idx + 80)
    let snippet = text.slice(start, end)
    snippet = this.highlight(snippet, query)
    return snippet + '...'
  }

  clear() {
    this.inputTarget.value = ''
    this.resultsTarget.innerHTML = ''
    this.resultsTarget.classList.add('hidden')
    this.inputTarget.focus()
  }

  toggleDropdown() {
    this.dropdownOpen = !this.dropdownOpen
    this.dropdownTarget.classList.toggle('hidden', !this.dropdownOpen)
    if (this.dropdownOpen) {
      setTimeout(() => this.inputTarget.focus(), 10)
      document.addEventListener('mousedown', this.handleDocumentClick)
      document.addEventListener('keydown', this.handleEscape)
    } else {
      document.removeEventListener('mousedown', this.handleDocumentClick)
      document.removeEventListener('keydown', this.handleEscape)
    }
  }

  handleDocumentClick(event) {
    if (!this.element.contains(event.target)) {
      this.dropdownOpen = false
      this.dropdownTarget.classList.add('hidden')
      document.removeEventListener('mousedown', this.handleDocumentClick)
      document.removeEventListener('keydown', this.handleEscape)
    }
  }

  handleEscape(event) {
    if (event.key === 'Escape') {
      this.dropdownOpen = false
      this.dropdownTarget.classList.add('hidden')
      document.removeEventListener('mousedown', this.handleDocumentClick)
      document.removeEventListener('keydown', this.handleEscape)
    }
  }
}
