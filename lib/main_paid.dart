
import 'package:declarative_route/common/flavor_config.dart';
import 'package:declarative_route/provider.dart';
import 'package:flutter/material.dart';


void main() {
   FlavorConfig(
    flavor: FlavorType.paid,
    color: Colors.blue,
    values: const FlavorValues(
      titleApp: "Paid Mode",
    ),
  );
  runApp(const QuotesApp());
}

