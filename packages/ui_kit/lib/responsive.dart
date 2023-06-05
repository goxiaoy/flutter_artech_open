import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

bool isMobile(BuildContext context) => getValueForScreenType<bool>(
      context: context,
      mobile: true,
      tablet: false,
      desktop: false,
      watch: false,
    );

bool isTablet(BuildContext context) => getValueForScreenType<bool>(
      context: context,
      mobile: false,
      tablet: true,
      desktop: false,
      watch: false,
    );

bool isDesktop(BuildContext context) => getValueForScreenType<bool>(
      context: context,
      mobile: false,
      tablet: false,
      desktop: true,
      watch: false,
    );

bool isWatch(BuildContext context) => getValueForScreenType<bool>(
      context: context,
      mobile: false,
      tablet: false,
      desktop: false,
      watch: true,
    );
