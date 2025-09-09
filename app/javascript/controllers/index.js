import { Application } from "@hotwired/stimulus";
import FindingsTableController from "./findings_table_controller";
import LoadingController from "./loading_controller";

window.Stimulus = Application.start();
Stimulus.register("findings-table", FindingsTableController);
Stimulus.register("loading", LoadingController);
