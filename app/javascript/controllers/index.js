import { Application } from "@hotwired/stimulus";
import FindingsTableController from "./findings_table_controller";

window.Stimulus = Application.start();
Stimulus.register("findings-table", FindingsTableController);
