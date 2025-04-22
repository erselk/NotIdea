import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/coming_soon_widget.dart';
import '/components/notification_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_web_view.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'profile_widget.dart' show ProfileWidget;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class ProfileModel extends FlutterFlowModel<ProfileWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for ComingSoon component.
  late ComingSoonModel comingSoonModel;
  // Model for Notification component.
  late NotificationModel notificationModel;

  @override
  void initState(BuildContext context) {
    comingSoonModel = createModel(context, () => ComingSoonModel());
    notificationModel = createModel(context, () => NotificationModel());
  }

  @override
  void dispose() {
    comingSoonModel.dispose();
    notificationModel.dispose();
  }
}
