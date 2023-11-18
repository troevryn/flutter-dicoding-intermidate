import 'package:declarative_route/provider/auth_provider.dart';
import 'package:declarative_route/provider/list_story_provider.dart';
import 'package:declarative_route/widget/card_story.dart';
import 'package:declarative_route/widget/flag_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:declarative_route/widget/platform_widget.dart';
import 'package:declarative_route/common.dart';
import 'package:flutter/cupertino.dart';

class QuotesListScreen extends StatefulWidget {
  final Function(String) onTapped;
  final Function toFormScreen;
  final Function onLogout;

  const QuotesListScreen({
    Key? key,
    required this.onTapped,
    required this.toFormScreen,
    required this.onLogout,
  }) : super(key: key);

  @override
  State<QuotesListScreen> createState() => _QuotesListScreenState();
}

class _QuotesListScreenState extends State<QuotesListScreen> {
  final ScrollController scrollController = ScrollController();
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  @override
  void initState() {
    super.initState();
    final storiesProvider = context.read<StoriesProvider>();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        storiesProvider.incrementPageItems();
        storiesProvider.getStories();
      }
    });

    // Future.microtask(() async => storiesProvider.getStories());
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Widget _buildList() {
    return Consumer<StoriesProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.loading && state.pageItems == 1) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.black),
          );
        } else if (state.state == ResultState.hasData) {
          final stories = state.listStory;

          return ListView.builder(
            controller: scrollController,
            shrinkWrap: true,
            itemCount: stories.length + (state.pageItems != 1 ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == stories.length && state.pageItems != 1) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              var story = stories[index];

              return CardStory(
                story: story,
                onTap: () {
                  // state.setRefesh(true);
                  widget.onTapped(story.id);
                },
              );
            });
        } else if (state.state == ResultState.noData ||
            state.state == ResultState.error) {
          return Center(
            child: Material(
              child: Text(state.message),
            ),
          );
        } else {
          return const Center(
            child: Material(
              child: Text(''),
            ),
          );
        }
      },
    );
  }

  Widget _buildAndroid(BuildContext context) {
    final authWatch = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.titleAppBar,
        ),
        actions: [
          const FlagIconWidget(),
          IconButton(
            onPressed: () async {
              final authRead = context.read<AuthProvider>();
              final result = await authRead.logout();
              if (result) widget.onLogout();
            },
            icon: authWatch.isLoadingLogout
                ? const CircularProgressIndicator(
                    
                  )
                : const Icon(Icons.logout),
          ),
        ],
      ),
      body: _buildList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.toFormScreen();
        },
        tooltip: "add",
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildIos(BuildContext context) {
    final authWatch = context.watch<AuthProvider>();
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          AppLocalizations.of(context)!.titleAppBar,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const FlagIconWidget(),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () async {
                final authRead = context.read<AuthProvider>();
                final result = await authRead.logout();
                if (result) widget.onLogout();
              },
              child: authWatch.isLoadingLogout
                  ? const CupertinoActivityIndicator()
                  : const Icon(CupertinoIcons.square_arrow_left),
            ),
          ],
        ),
      ),
      child: _buildList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}
