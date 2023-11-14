import 'package:declarative_route/provider/auth_provider.dart';
import 'package:declarative_route/provider/list_story_provider.dart';
import 'package:declarative_route/widget/card_story.dart';
import 'package:declarative_route/widget/flag_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:declarative_route/widget/platform_widget.dart';
import 'package:declarative_route/common.dart';
import 'package:flutter/cupertino.dart';

class QuotesListScreen extends StatelessWidget {
  final Function(String) onTapped;
  final Function toFormScreen;
  final Function onLogout;

  const QuotesListScreen({
    Key? key,
    required this.onTapped,
    required this.toFormScreen,
    required this.onLogout,
  }) : super(key: key);

  Widget _buildList() {
    return Consumer<StoriesProvider>(builder: (context, state, _) {
      if (state.state == ResultState.loading) {
        return const Center(
            child: CircularProgressIndicator(color: Colors.black));
      } else if (state.state == ResultState.hasData) {
        return ListView.builder(
            shrinkWrap: true,
            itemCount: state.result.listStory.length,
            itemBuilder: (context, index) {
              var story = state.result.listStory[index];

              return CardStory(
                story: story,
                onTap: () {
                  // state.setRefesh(true);
                  onTapped(story.id);
                },
              );
            });
      } else if (state.state == ResultState.noData) {
        return Center(
          child: Material(
            child: Text(state.message),
          ),
        );
      } else if (state.state == ResultState.error) {
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
    });
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
              if (result) onLogout();
            },
            icon: authWatch.isLoadingLogout
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : const Icon(Icons.logout),
          ),
        ],
      ),
      body: _buildList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          toFormScreen();
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
                if (result) onLogout();
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
