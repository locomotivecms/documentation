import { Application } from "@hotwired/stimulus"
import ThemeController from "./controllers/theme_controller"
import TabsController from "./controllers/tabs_controller"
import CopyCodeController from "./controllers/copy_code_controller"
import SearchController from "./controllers/search_controller"

// Initialize Stimulus application
const application = Application.start()

// Register controllers
application.register("theme", ThemeController)
application.register("tabs", TabsController)
application.register("copy-code", CopyCodeController)
application.register("search", SearchController)

// Export for potential use elsewhere
window.Stimulus = application
