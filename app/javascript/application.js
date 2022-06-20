// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

import { Turbo } from "@hotwired/turbo-rails"
Turbo.session.drive = false
