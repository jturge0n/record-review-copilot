import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["button", "label", "spinner"]

  start() {
    if (this.buttonTarget) {
      this.buttonTarget.disabled = true;
      if (this.labelTarget) this.labelTarget.classList.add("hidden");
      if (this.spinnerTarget) this.spinnerTarget.classList.remove("hidden");
    }
  }

  end() {
    if (this.buttonTarget) {
      this.buttonTarget.disabled = false;
      if (this.labelTarget) this.labelTarget.classList.remove("hidden");
      if (this.spinnerTarget) this.spinnerTarget.classList.add("hidden");
    }
  }
}
