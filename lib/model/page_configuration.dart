class PageConfiguration {
  final bool unknown;
  final bool register;
  final bool? loggedIn;
  final String? quoteId;
  final bool isForm;
  PageConfiguration.splash()
      : unknown = false,
        register = false,
        loggedIn = false,
        quoteId = null,
        isForm = false;

  PageConfiguration.login()
      : unknown = false,
        register = false,
        loggedIn = false,
        quoteId = null,
        isForm = false;

  PageConfiguration.register()
      : unknown = false,
        register = true,
        loggedIn = false,
        quoteId = null,
        isForm = false;

  PageConfiguration.home()
      : unknown = false,
        register = false,
        loggedIn = true,
        quoteId = null,
        isForm = false;

  PageConfiguration.storiesAdd()
      : unknown = false,
        register = false,
        loggedIn = true,
        quoteId = null,
        isForm = true;

  PageConfiguration.detailQuote(String id)
      : unknown = false,
        register = false,
        loggedIn = true,
        quoteId = id,
        isForm = false;

  PageConfiguration.unknown()
      : unknown = true,
        register = false,
        loggedIn = null,
        quoteId = null,
        isForm = false;

  bool get isSplashPage =>
      unknown == false &&
      register == false &&
      loggedIn == null &&
      quoteId == null &&
      isForm == false;

  bool get isLoginPage =>
      unknown == false &&
      register == false &&
      loggedIn == false &&
      quoteId == null &&
      isForm == false;

  bool get isRegisterPage =>
      unknown == false &&
      register == true &&
      loggedIn == false &&
      quoteId == null &&
      isForm == false;

  bool get isHomePage =>
      unknown == false &&
      register == false &&
      loggedIn == true &&
      quoteId == null &&
      isForm == false;

  bool get isAddStoryPage =>
      unknown == false &&
      register == false &&
      loggedIn == true &&
      quoteId == null &&
      isForm == true;

  bool get isDetailPage =>
      unknown == false &&
      register == false &&
      loggedIn == true &&
      quoteId != null &&
      isForm == false;

  bool get isUnknownPage =>
      unknown == true &&
      register == false &&
      loggedIn == null &&
      quoteId == null &&
      isForm == false;
}
