import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Find the closest pre parent
    const pre = this.element.closest('pre');
    if (!pre) return;
    // Prevent duplicate buttons if hot reloading
    if (pre.querySelector('.copy-btn-stimulus')) return;

    // Create the button
    const button = document.createElement('button');
    button.type = 'button';
    button.textContent = 'Copy';
    button.setAttribute('aria-label', 'Copy code');
    button.className = `copy-btn-stimulus absolute top-2 right-2 px-2 py-1 rounded bg-gray-100 text-gray-600 text-xs font-medium border border-gray-300 hover:bg-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-400 transition opacity-0 group-hover:opacity-100
      dark:bg-gray-800 dark:text-gray-300 dark:border-gray-700 dark:hover:bg-gray-700`;
    button.style.zIndex = 10;

    // Add event listener
    button.addEventListener('click', (event) => {
      event.preventDefault();
      this.copyCode(pre);
      button.textContent = 'Copied!';
      setTimeout(() => {
        button.textContent = 'Copy';
      }, 1200);
    });

    // Ensure the pre block is relatively positioned and a group for hover
    pre.classList.add('relative', 'group');
    pre.appendChild(button);
  }

  copyCode(pre) {
    // Find the code element inside pre
    const code = pre.querySelector('code');
    if (!code) return;
    navigator.clipboard.writeText(code.innerText);
  }
}
