import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  toggle(event) {
    event.preventDefault()
    event.stopPropagation()
    const button = this.element
    const svg = button.querySelector('svg')
    
    fetch(`/recipes/${button.dataset.recipeId}/toggle_favorite`, {
      method: 'PATCH',
      headers: { 'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content }
    }).then(() => {
      if (svg.classList.contains('unfavorited')) {
        svg.classList.remove('unfavorited')
        svg.classList.add('favorited')
      } else {
        svg.classList.remove('favorited')
        svg.classList.add('unfavorited')
      }
    })
  }
} 