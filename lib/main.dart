import 'package:declarative_route/api/api_service.dart';
import 'package:declarative_route/db/AuthRepository.dart';
import 'package:declarative_route/provider/auth_provider.dart';
import 'package:declarative_route/provider/image_provider.dart';
import 'package:declarative_route/provider/list_story_provider.dart';
import 'package:declarative_route/provider/localizations_provider.dart';
import 'package:declarative_route/provider/upload_provider.dart';
import 'package:declarative_route/routes/route_information_parser.dart';
import 'package:declarative_route/routes/router_delegate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:declarative_route/common.dart';

void main() {
  runApp(const QuotesApp());
}

class QuotesApp extends StatefulWidget {
  const QuotesApp({Key? key}) : super(key: key);

  @override
  State<QuotesApp> createState() => _QuotesAppState();
}

class _QuotesAppState extends State<QuotesApp> {
  late MyRouterDelegate myRouterDelegate;
  late AuthProvider authProvider;
  late MyRouteInformationParser myRouteInformationParser;
  @override
  void initState() {
    super.initState();
    final authRepository = AuthRepository();

    authProvider = AuthProvider(authRepository);
    myRouterDelegate = MyRouterDelegate(authRepository);
    myRouteInformationParser = MyRouteInformationParser();
  }

  @override
  Widget build(BuildContext context) {
    /// todo-03-manager-05: cover MaterialApp with PageManager

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UploadProvider>(
            create: (_) => UploadProvider(
                  apiService: ApiService(),
                )),
        ChangeNotifierProvider<ShowImageProvider>(
            create: (_) => ShowImageProvider()),
        ChangeNotifierProvider<StoriesProvider>(
            create: (_) => StoriesProvider(apiService: ApiService())),
      ],
      child: ChangeNotifierProvider(
          create: (context) => authProvider,
          child: ChangeNotifierProvider<LocalizationProvider>(
              create: (context) => LocalizationProvider(),
              builder: (context, child) {
                final provider = Provider.of<LocalizationProvider>(context);
                return MaterialApp.router(
                  title: 'Stories App',
                  locale: provider.locale,
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  routerDelegate: myRouterDelegate,
                  routeInformationParser: myRouteInformationParser,
                  backButtonDispatcher: RootBackButtonDispatcher(),
                );
              })),
    );
  }
}
