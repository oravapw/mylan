## Changelog

### 1.0.0
- switched over to semantic versioning.
- update to Rails 8.0.0.
- got rid of old Capistrano deployment code, replaced it with Docker-based system.
- tournament player view now shows decklist number-of-lines as a tooltip on the checkmark, and checkmark becomes an orange '?' if the decklist has 10 or less lines.
- various small UI tweaks

### 1.0.1
- small fixes for production

### 1.0.2
- update to Rails 8.1.4.1, Ruby 4.0.10
- CI tweaks
- added test suite to verify user-facing functionality
- removed changelog functionality
- various small fixes and cleanups

### 1.0.3
- added paging to tournaments and decklists

### 1.0.4
- some checks to prohibit player entries with duplicate VEKN/email info

### 1.0.5
- added JSON export/import utility for database data

### 1.0.6
- optionally use Solid Queue for background email sends (if `SOLID_QUEUE_IN_PUMA` is set)
