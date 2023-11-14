// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable

import 'package:declarative_route/model/stories.dart';
import 'package:declarative_route/utils/format_date.dart';
import 'package:flutter/material.dart';

class CardStory extends StatelessWidget {
  final ListStory story;
  final Function onTap;

  const CardStory({Key? key, required this.story, required this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
        // color: primaryColor,
        child: Card(
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            leading: Hero(
              tag: story.id,
              child: ClipRRect(
                clipBehavior: Clip.antiAlias,
                child: Image.network(
                  story.photoUrl,
                  width: 100,
                  fit: BoxFit.fill,
                  errorBuilder: (ctx, error, _) => Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey, // Warna latar belakang
                    child: const Center(child: Icon(Icons.error)),
                  ),
                ),
              ),
            ),
            title: Text(
              story.name,
            ),
            subtitle:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                story.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: [
                  Text(FormatDate()
                      .konversiFormatTanggal(story.createdAt.toString())),
                ],
              )
            ]),
            onTap: () => onTap(),
          )),
    ));
  }
}
