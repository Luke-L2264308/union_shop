# Union Shop

A small multi-platform Flutter shopping demo app that demonstrates product pages, collection lists, and a simple persistent cart. The app is intended as a lightweight example of managing product UI and cross-platform persistence (mobile, desktop and web).

1. Project Title and Description
--

- **Project Title:** Union Shop
- **Description:** A demo Flutter storefront showcasing product pages, collections, and a persistent shopping cart. Supports platform-appropriate storage (file-based on native platforms and localStorage on web) and includes unit and widget tests.
- **Key features:**
	- Product pages with images, sizes, colours and quantity controls.
	- Add-to-cart behavior with merge-on-same-item semantics.
	- Persistent cart storage (native file I/O and web localStorage via JS interop).
	- Collection listing and deep route to product pages.
	- Unit and widget tests for UI and storage behaviors.

2. Installation and Setup Instructions
--

- **Prerequisites:**
	- Flutter SDK (stable channel) and Dart (see https://flutter.dev/docs/get-started/install)
	- For Android: Android SDK and an emulator or device
	- For iOS/macOS: Xcode (macOS only)
	- For web: Chrome or another supported browser
	- Recommended: Visual Studio Code or Android Studio for editing and debugging

- **Clone the repository:**

```powershell
git clone https://github.com/Luke-L2264308/union_shop.git
cd union_shop
```

- **Install dependencies:**

```powershell
flutter pub get
```

- **Run the app:**

Run on the default device:

```powershell
flutter run
```

Run on Chrome (web):

```powershell
flutter run -d chrome
```

3. Usage Instructions
--

- **Main flows:**
	- Browse collections or use the home route to find products.
	- Open a product page to view details, choose a colour and size, set quantity, and use "Add to Cart".
	- The app merges added items with identical title/size/colour combinations (quantities summed).
	- Open the cart page to view persisted items (cart file on native, localStorage on web).

- **Configuration / Options:**
	- Platform storage selection is automatic. `lib/cart_storage/` contains platform-specific implementations (`cart_storage_io.dart` and `cart_storage_web.dart`).
	- Tests use mocked path_provider in `test/` to isolate file-system interactions.

- **Run tests:**

Run all tests:

```powershell
flutter test
```

Run a single test file (example):

```powershell
flutter test test/productpagetemplates/product_dropdown_test.dart --reporter expanded
```

4. Project Structure and technologies used
--

- **Top-level folders:**
	- `lib/` — application source code
		- `productpagetemplates/` — product and collection UI
		- `cart_storage/` — platform storage implementations (native file I/O and web interop)
		- `headerandfooter/` — shared UI header/footer
	- `assets/` — images and `collection_list.json` used by the app
	- `test/` — widget and unit tests

- **Key files:**
	- `lib/main.dart` — app entry point
	- `lib/productpagetemplates/product_page.dart` — product details, dropdowns, add-to-cart
	- `lib/cart_storage/cart_storage_io.dart` — native storage helpers
	- `lib/cart_storage/cart_storage_web.dart` — web storage via JS interop

- **Technologies & packages:**
	- Flutter & Dart
	- `path_provider` (for native storage helpers)
	- `package:js` / `dart:js_interop` (used for web localStorage interop)
	- `flutter_test` for unit and widget tests

5. Known Issues or Limitations
--

- The app is a demo and not production-ready. Known limitations:
	- No authentication, payment integration, or backend sync — cart persistence is local only.
	- Product data is provided from local assets (`assets/collection_list.json`) rather than a remote API.
	- Some UI elements are placeholders (e.g., certain buttons call a placeholder handler).
	- Web code uses JS interop; ensure build target is `web` when testing web-only behavior.





