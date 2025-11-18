# Success Criteria for Union Shop Coursework

This document lists clear, testable success criteria derived from the project README and marking criteria. Use these as a checklist while developing and before demo/submission.

## General / Submission
- [ ] Repository named `union_shop` and fork is public and accessible
- [ ] Submit fork URL on Moodle before the deadline
- [ ] Application runs from a fresh clone (instructions in `README.md`)
- [ ] Able to run the app in Chrome mobile view via `flutter run -d chrome`

## Demo Requirements
- [ ] Demonstrate implemented features in a 10-minute live demo
- [ ] The app runs from a fresh clone during the demo

## Basic Features (target: 40% of application marks)
- [ ] Static homepage present with header, hero and products section (mobile view)
- [ ] Static navbar present with menu and icons (mobile view)
- [ ] About Us page accessible
- [ ] Footer present on at least one page with dummy links/info
- [ ] Collections page (hardcoded/dummy) showing collections
- [ ] Collection page showing products with dropdowns/filters (UI present)
- [ ] Product page showing product details, images, and controls (UI present)
- [ ] Sale collection page present with discounted price display
- [ ] Authentication UI (login/signup screens) present (UI only acceptable)

## Intermediate Features (target: 35% of application marks)
- [ ] Navigation works across pages (buttons, navbar, and routes)
- [ ] Collections populated from local data models/services with sorting/filter UI
- [ ] Collection listings display correctly from data models/services
- [ ] Product pages populated from models with functioning dropdowns and counters
- [ ] Shopping cart: add items, view cart page, edit quantities and remove items
- [ ] Personalisation page updates form dynamically based on selections
- [ ] Responsiveness: app adapts layout for mobile and wider screens

## Advanced Features (target: 25% of application marks)
- [ ] Full authentication and account management implemented (external providers acceptable)
- [ ] Full cart management with persistence and correct price calculations
- [ ] Working search system integrated into navbar and pages

## Software Development Practices (25% of marks)
- [ ] Regular, small, meaningful commits with clear messages
- [ ] Comprehensive and accurate `README.md` documenting setup and external services
- [ ] Tests covering major UI and logic paths; tests pass locally (`flutter test`)
- [ ] Integration with at least two external services documented in README
- [ ] Code formatted and free of analyzer errors/warnings

## Testing / CI / Test Environment
- [ ] Widget tests do not depend on real network resources (network/image calls mocked)
- [ ] All tests pass locally with `flutter test`
- [ ] Network images in tests are wrapped using a mock helper or `HttpOverrides`

## Quality / Non-functional
- [ ] UI is functional and usable on mobile view
- [ ] No runtime errors when navigating implemented pages
- [ ] Images used are copyright-free or AI-generated and documented in README

---

Use this checklist during development and before the demo to confirm completion of required items. For any item that is partially implemented, document the limitation in `README.md` so demonstrators and markers can find it quickly.
