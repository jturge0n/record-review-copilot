import { Controller } from "@hotwired/stimulus";
import FindingsTable from "../components/FindingsTable.svelte";

export default class extends Controller {
  connect() {
    let findings = [];

    const script = document.getElementById("findings-json");
    if (script?.textContent) {
      try {
        findings = JSON.parse(script.textContent);
      } catch (e) {
        console.error("Failed to parse #findings-json", e, script.textContent.slice(0, 200));
      }
    } else {
      const raw = this.element.getAttribute("data-findings-table-data-value");
      if (raw) {
        try {
          findings = JSON.parse(raw);
        } catch (e) {
          console.error("Bad findings JSON in data attribute:", e, raw.slice(0, 200));
        }
      }
    }

    this.app = new FindingsTable({
      target: this.element,
      props: { findings }
    });
  }

  disconnect() {
    this.app?.$destroy?.();
  }
}
