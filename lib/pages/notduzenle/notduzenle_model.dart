import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/coming_soon_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_toggle_icon.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_web_view.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'notduzenle_widget.dart' show NotduzenleWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class NotduzenleModel extends FlutterFlowModel<NotduzenleWidget> {
  ///  Local state fields for this page.

  bool renksecmenuackapa = false;

  bool favori = false;

  bool pinned = false;

  Color color = Color(4293257956);

  String? ortitle;

  String? orcontent;

  bool hakkinda = false;

  bool deleted = false;

  String? imageBase64;

  ///  State fields for stateful widgets in this page.

  // State field(s) for baslik widget.
  FocusNode? baslikFocusNode;
  TextEditingController? baslikTextController;
  String? Function(BuildContext, String?)? baslikTextControllerValidator;
  // State field(s) for content widget.
  FocusNode? contentFocusNode;
  TextEditingController? contentTextController;
  String? Function(BuildContext, String?)? contentTextControllerValidator;
  // Model for ComingSoon component.
  late ComingSoonModel comingSoonModel;
  bool isDataUploading = false;
  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));

  // Stores action output result for [Custom Action - convertToBase64] action in Image widget.
  String? base64;
  AudioPlayer? soundPlayer1;
  // Stores action output result for [Custom Action - fetchImageBase64] action in IconButton widget.
  String? aigeneratedimage;
  AudioPlayer? soundPlayer2;

  @override
  void initState(BuildContext context) {
    comingSoonModel = createModel(context, () => ComingSoonModel());
  }

  @override
  void dispose() {
    baslikFocusNode?.dispose();
    baslikTextController?.dispose();

    contentFocusNode?.dispose();
    contentTextController?.dispose();

    comingSoonModel.dispose();
  }
}
