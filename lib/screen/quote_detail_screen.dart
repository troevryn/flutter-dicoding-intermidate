import 'package:declarative_route/provider/detail_story.dart';
import 'package:declarative_route/utils/format_date.dart';
import 'package:declarative_route/widget/platform_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

class QuoteDetailsScreen extends StatelessWidget {
  const QuoteDetailsScreen({
    Key? key,
  }) : super(key: key);

  Widget _buildList() {
    return Consumer<StoryProvider>(builder: (context, state, _) {
      if (state.state == ResultState.loading) {
        return const Center(
            child: CircularProgressIndicator(color: Colors.black));
      } else if (state.state == ResultState.hasData) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Hero(
                    tag: state.result.story.photoUrl,
                    child: Image.network(
                      state.result.story.photoUrl,
                      fit: BoxFit.cover,
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                      errorBuilder: (ctx, error, _) =>
                          const Center(child: Icon(Icons.error)),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.result.story.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 10),
                      Text(state.result.story.description),
                      const SizedBox(height: 10),
                      Text(FormatDate().konversiFormatTanggal(
                          state.result.story.createdAt.toString())),
                    ]),
              )
            ],
          ),
        );
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Story"),
      ),
      body: _buildList(),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Detail Story"),
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
