// Conditional export: use IO implementation on native, web implementation on web
export 'cart_storage_io.dart' if (dart.library.html) 'cart_storage_web.dart';
