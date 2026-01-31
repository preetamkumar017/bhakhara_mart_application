import 'package:get/get.dart';
import 'routes_name.dart';
import '../../modules/splash/view/splash_view.dart';
import '../../modules/onboarding/view/onboarding_view.dart';
import '../../modules/auth/view/login_view.dart';
import '../../modules/auth/view/register_view.dart';
import '../../modules/navigation/view/main_nav_view.dart';
import '../../modules/product/view/product_detail_view.dart';
import '../../modules/cart/view/cart_view.dart';
import '../../modules/profile/view/profile_view.dart';
import '../../modules/profile/view/edit_profile_view.dart';
import '../../modules/profile/view/address_view.dart';
import '../../modules/search/view/search_view.dart';
import '../../modules/checkout/view/checkout_view.dart';
import '../../modules/orders/view/orders_view.dart';
import '../../modules/orders/view/order_detail_view.dart';

class AppRoutes {
  static List<GetPage<dynamic>> appRoutes() => [
    GetPage(
      name: RoutesName.splash,
      page: () => SplashView(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 250),
    ),
    GetPage(
      name: RoutesName.onboarding,
      page: () => OnboardingView(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: RoutesName.login,
      page: () => LoginView(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: RoutesName.register,
      page: () => RegisterView(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: RoutesName.home,
      page: () => MainNavView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: RoutesName.search,
      page: () => SearchView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: RoutesName.productDetail,
      page: () => ProductDetailView(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: RoutesName.cart,
      page: () => CartView(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: RoutesName.profile,
      page: () => ProfileView(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: '/edit-profile',
      page: () => EditProfileView(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: '/address',
      page: () => AddressView(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: RoutesName.checkout,
      page: () => CheckoutView(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: RoutesName.orders,
      page: () => OrdersView(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: '/orders/:orderId',
      page: () => OrderDetailView(),
      transition: Transition.rightToLeftWithFade,
    ),
  ];
}

