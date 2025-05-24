import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["submit"]

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

}