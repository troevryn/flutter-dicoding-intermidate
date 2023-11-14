import 'package:declarative_route/api/api_service.dart';
import 'package:declarative_route/db/AuthRepository.dart';
import 'package:declarative_route/model/page_configuration.dart';
import 'package:declarative_route/provider/detail_story.dart';
import 'package:declarative_route/provider/list_story_provider.dart';

import 'package:declarative_route/screen/form_screen.dart';
import 'package:declarative_route/screen/login_screen.dart';
import 'package:declarative_route/screen/register_screen.dart';
import 'package:declarative_route/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screen/quote_detail_screen.dart';
import '../screen/quotes_list_screen.dart';

class MyRouterDelegate extends RouterDelegate<PageConfiguration>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;
  final AuthRepository authRepository;
  MyRouterDelegate(
    this.authRepository,
  ) : _navigatorKey = GlobalKey<NavigatorState>() {
    _init();
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  String? selectedQuote;

  /// todo-02-delegate-01: add form page state
  bool isForm = false;
  List<Page> historyStack = [];
  bool? isLoggedIn;
  bool isRegister = false;
  bool? isUnknown;
  _init() async {
    isLoggedIn = await authRepository.isLoggedIn();

    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn == null) {
      historyStack = _splashStack;
    } else if (isLoggedIn == true) {
      historyStack = _loggedInStack;
    } else {
      historyStack = _loggedOutStack;
    }
    return Navigator(
        key: navigatorKey,
        pages: historyStack,
        onPopPage: (route, result) {
          final didPop = route.didPop(result);
          if (!didPop) {
            return false;
          }

          isRegister = false;
          selectedQuote = null;
          isForm = false;
          notifyListeners();

          return true;
        });
  }

  List<Page> get _splashStack => const [
        MaterialPage(
          key: ValueKey("SplashPage"),
          child: SplashScreen(),
        ),
      ];
  List<Page> get _loggedOutStack => [
        MaterialPage(
          key: const ValueKey("LoginPage"),
          child: LoginScreen(
            onLogin: () {
              isLoggedIn = true;
              notifyListeners();
            },
            onRegister: () {
              isRegister = true;
              notifyListeners();
            },
          ),
        ),
        if (isRegister == true)
          MaterialPage(
            key: const ValueKey("RegisterPage"),
            child: RegisterScreen(
              onRegister: () {
                isRegister = false;
                notifyListeners();
              },
              onLogin: () {
                isRegister = false;
                notifyListeners();
              },
            ),
          ),
      ];
  List<Page> get _loggedInStack => [
        MaterialPage(
          key: const ValueKey("QuotesListPage"),
          child: QuotesListScreen(
            onTapped: (String quoteId) {
              selectedQuote = quoteId;
              notifyListeners();
            },
            toFormScreen: () {
              isForm = true;
              notifyListeners();
            },
            onLogout: () {
              isLoggedIn = false;
              notifyListeners();
            },
          ),
        ),
        if (selectedQuote != null)
          MaterialPage(
            key: ValueKey(selectedQuote),
            child: ChangeNotifierProvider(
              create: (_) => StoryProvider(
                  apiService: ApiService(), storyId: selectedQuote ?? ""),
              child: const QuoteDetailsScreen(),
            ),
          ),
        if (isForm == true)
          MaterialPage(
            key: const ValueKey("AddStoryPage"),
            child: Builder(
              builder: (context) => FormScreen(
                onSend: () {
                  isForm = false;
                  notifyListeners();

                  Future.microtask(() {
                    final storiesProvider =
                        Provider.of<StoriesProvider>(context, listen: false);
                    storiesProvider.fetchData();
                  });
                },
              ),
            ),
          ),
      ];
  @override
  Future<void> setNewRoutePath(configuration) async {
    if (configuration.isUnknownPage) {
      isUnknown = true;
      isRegister = false;
    } else if (configuration.isRegisterPage) {
      isRegister = true;
    } else if (configuration.isHomePage ||
        configuration.isLoginPage ||
        configuration.isSplashPage) {
      isUnknown = false;
      selectedQuote = null;
      isForm = false;
      isRegister = false;
    } else if (configuration.isAddStoryPage) {
      isUnknown = false;
      isRegister = false;
      selectedQuote = null;
      isForm = true;
    } else if (configuration.isDetailPage) {
      isUnknown = false;
      isRegister = false;
      isForm = false;
      selectedQuote = configuration.quoteId.toString();
    } else {}
    notifyListeners();
  }

  @override
  PageConfiguration? get currentConfiguration {
    if (isLoggedIn == null) {
      return PageConfiguration.splash();
    } else if (isRegister == true) {
      return PageConfiguration.register();
    } else if (isLoggedIn == false) {
      return PageConfiguration.login();
    } else if (isUnknown == true) {
      return PageConfiguration.unknown();
    } else if (isForm == true) {
      return PageConfiguration.storiesAdd();
    } else if (selectedQuote == null) {
      return PageConfiguration.home();
    } else if (selectedQuote != null) {
      return PageConfiguration.detailQuote(selectedQuote!);
    } else {
      return null;
    }
  }
}
