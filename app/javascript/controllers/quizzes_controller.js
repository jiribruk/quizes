import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["submit", "destroyField", "preview", "fileInput"]

  connect() {
    this.submitTargets.forEach(button => {
      button.addEventListener("click", this.handleClick)
    })
  }

  disconnect() {
    this.submitTargets.forEach(button => {
      button.removeEventListener("click", this.handleClick)
    })
  }

  handleClick = (event) => {
    window.scrollTo({ top: 0, behavior: 'smooth' })
  }

  remove() {
    if (this.hasDestroyFieldTarget) {
      this.destroyFieldTarget.value = "1"
    }

    this.element.style.display = "none"
  }

  previewImage(event) {
    const input = event.target
    const file = input.files[0]
    if (!file) return

    const reader = new FileReader()
    reader.onload = (e) => {
      const previewEl = this.previewTarget
      previewEl.src = e.target.result
      previewEl.classList.remove("d-none")
    }
    reader.readAsDataURL(file)
  }

}