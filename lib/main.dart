
import 'package:declarative_route/common/flavor_config.dart';
import 'package:declarative_route/provider.dart';
import 'package:flutter/material.dart';


void main() {
   FlavorConfig(
    flavor: FlavorType.free,
    color: Colors.blue,
    values: const FlavorValues(
      titleApp: "Free Mode",
    ),
  );
  runApp(const QuotesApp());
}

