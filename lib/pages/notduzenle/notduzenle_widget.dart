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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'notduzenle_model.dart';
export 'notduzenle_model.dart';

class NotduzenleWidget extends StatefulWidget {
  const NotduzenleWidget({
    super.key,
    this.notesDoc,
  });

  final NotesRecord? notesDoc;

  static String routeName = 'notduzenle';
  static String routePath = '/notduzenle';

  @override
  State<NotduzenleWidget> createState() => _NotduzenleWidgetState();
}

class _NotduzenleWidgetState extends State<NotduzenleWidget> {
  late NotduzenleModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NotduzenleModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.color = valueOrDefault<Color>(
        widget!.notesDoc?.color,
        FlutterFlowTheme.of(context).secondary,
      );
      _model.pinned = widget!.notesDoc!.pinned;
      _model.favori = widget!.notesDoc!.favorited;
      _model.ortitle = widget!.notesDoc?.title;
      _model.orcontent = widget!.notesDoc?.content;
      _model.deleted = widget!.notesDoc!.deleted;
      _model.imageBase64 = widget!.notesDoc?.image;
      safeSetState(() {});
    });

    _model.baslikTextController ??=
        TextEditingController(text: widget!.notesDoc?.title);
    _model.baslikFocusNode ??= FocusNode();

    _model.contentTextController ??=
        TextEditingController(text: widget!.notesDoc?.content);
    _model.contentFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: _model.color,
          body: SafeArea(
            top: true,
            child: Stack(
              children: [
                Stack(
                  children: [
                    Align(
                      alignment: AlignmentDirectional(1.0, -1.0),
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Align(
                              alignment: AlignmentDirectional(1.0, -1.0),
                              child: ToggleIcon(
                                onPressed: () async {
                                  safeSetState(
                                      () => _model.deleted = !_model.deleted);
                                  if (widget!.notesDoc!.deleted) {
                                    await widget!.notesDoc!.reference.update({
                                      ...createNotesRecordData(
                                        deleted: false,
                                      ),
                                      ...mapToFirestore(
                                        {
                                          'lastEditTime':
                                              FieldValue.serverTimestamp(),
                                        },
                                      ),
                                    });

                                    context.pushNamed(AnasayfaWidget.routeName);
                                  } else {
                                    await widget!.notesDoc!.reference.update({
                                      ...createNotesRecordData(
                                        deleted: true,
                                      ),
                                      ...mapToFirestore(
                                        {
                                          'lastEditTime':
                                              FieldValue.serverTimestamp(),
                                        },
                                      ),
                                    });

                                    context.pushNamed(TrashWidget.routeName);
                                  }
                                },
                                value: _model.deleted,
                                onIcon: FaIcon(
                                  FontAwesomeIcons.trashRestore,
                                  color: (widget!.notesDoc?.color ==
                                              Color(0xFF613F75)) ||
                                          (widget!.notesDoc?.color ==
                                              Color(0xFF77A6B6)) ||
                                          (widget!.notesDoc?.color ==
                                              Color(0xFF1A759F))
                                      ? Colors.white
                                      : Color(0xFF374241),
                                  size: 24.0,
                                ),
                                offIcon: FaIcon(
                                  FontAwesomeIcons.trashAlt,
                                  color: (widget!.notesDoc?.color ==
                                              Color(0xFF613F75)) ||
                                          (widget!.notesDoc?.color ==
                                              Color(0xFF77A6B6)) ||
                                          (widget!.notesDoc?.color ==
                                              Color(0xFF1A759F))
                                      ? Colors.white
                                      : Color(0xFF374241),
                                  size: 24.0,
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(1.0, -1.0),
                              child: ToggleIcon(
                                onPressed: () async {
                                  safeSetState(
                                      () => _model.pinned = !_model.pinned);
                                },
                                value: _model.pinned,
                                onIcon: Icon(
                                  Icons.push_pin,
                                  color: (widget!.notesDoc?.color ==
                                              Color(0xFF613F75)) ||
                                          (widget!.notesDoc?.color ==
                                              Color(0xFF77A6B6)) ||
                                          (widget!.notesDoc?.color ==
                                              Color(0xFF1A759F))
                                      ? Colors.white
                                      : Color(0xFF374241),
                                  size: 24.0,
                                ),
                                offIcon: Icon(
                                  Icons.push_pin_outlined,
                                  color: (widget!.notesDoc?.color ==
                                              Color(0xFF613F75)) ||
                                          (widget!.notesDoc?.color ==
                                              Color(0xFF77A6B6)) ||
                                          (widget!.notesDoc?.color ==
                                              Color(0xFF1A759F))
                                      ? Colors.white
                                      : Color(0xFF374241),
                                  size: 24.0,
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(1.0, -1.0),
                              child: Builder(
                                builder: (context) => FlutterFlowIconButton(
                                  borderRadius: 8.0,
                                  buttonSize: 40.0,
                                  icon: Icon(
                                    Icons.share,
                                    color: !((widget!.notesDoc?.color ==
                                                Color(0xFF613F75)) ||
                                            (widget!.notesDoc?.color ==
                                                Color(0xFF77A6B6)) ||
                                            (widget!.notesDoc?.color ==
                                                Color(0xFF1A759F)))
                                        ? Color(0xFF374241)
                                        : FlutterFlowTheme.of(context)
                                            .secondaryText,
                                    size: 24.0,
                                  ),
                                  onPressed: () async {
                                    await Share.share(
                                      'Title:${_model.baslikTextController.text}${''}Content:${_model.contentTextController.text}',
                                      sharePositionOrigin:
                                          getWidgetBoundingBox(context),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(1.0, -1.0),
                              child: ToggleIcon(
                                onPressed: () async {
                                  safeSetState(
                                      () => _model.favori = !_model.favori);
                                },
                                value: _model.favori,
                                onIcon: Icon(
                                  Icons.favorite_sharp,
                                  color: (widget!.notesDoc?.color ==
                                              Color(0xFF613F75)) ||
                                          (widget!.notesDoc?.color ==
                                              Color(0xFF77A6B6)) ||
                                          (widget!.notesDoc?.color ==
                                              Color(0xFF1A759F))
                                      ? Colors.white
                                      : Color(0xFF374241),
                                  size: 24.0,
                                ),
                                offIcon: Icon(
                                  Icons.favorite_border_sharp,
                                  color: (widget!.notesDoc?.color ==
                                              Color(0xFF613F75)) ||
                                          (widget!.notesDoc?.color ==
                                              Color(0xFF77A6B6)) ||
                                          (widget!.notesDoc?.color ==
                                              Color(0xFF1A759F))
                                      ? Colors.white
                                      : Color(0xFF374241),
                                  size: 24.0,
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(1.0, -1.0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 20.0, 0.0),
                                child: FlutterFlowIconButton(
                                  borderRadius: 8.0,
                                  buttonSize: 40.0,
                                  icon: Icon(
                                    Icons.repeat_sharp,
                                    color: (widget!.notesDoc?.color ==
                                                Color(0xFF613F75)) ||
                                            (widget!.notesDoc?.color ==
                                                Color(0xFF77A6B6)) ||
                                            (widget!.notesDoc?.color ==
                                                Color(0xFF1A759F))
                                        ? Colors.white
                                        : Color(0xFF374241),
                                    size: 24.0,
                                  ),
                                  onPressed: () async {
                                    _model.favori = widget!.notesDoc!.favorited;
                                    _model.pinned = widget!.notesDoc!.pinned;
                                    _model.color = valueOrDefault<Color>(
                                      widget!.notesDoc?.color,
                                      FlutterFlowTheme.of(context).secondary,
                                    );
                                    _model.imageBase64 =
                                        widget!.notesDoc?.image;
                                    safeSetState(() {});
                                    safeSetState(() {
                                      _model.baslikTextController?.text =
                                          widget!.notesDoc!.title;

                                      _model.contentTextController?.text =
                                          widget!.notesDoc!.content;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ].divide(SizedBox(width: 10.0)),
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(0.0, -1.0),
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 78.0, 0.0, 0.0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Align(
                                alignment: AlignmentDirectional(0.0, -1.0),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      45.0, 0.0, 45.0, 0.0),
                                  child: Container(
                                    width: double.infinity,
                                    child: TextFormField(
                                      controller: _model.baslikTextController,
                                      focusNode: _model.baslikFocusNode,
                                      autofocus: false,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        hintText: 'Title',
                                        hintStyle: TextStyle(
                                          color: (_model.color ==
                                                      Color(0xFF613F75)) ||
                                                  (_model.color ==
                                                      Color(0xFF77A6B6)) ||
                                                  (_model.color ==
                                                      Color(0xFF1A759F))
                                              ? FlutterFlowTheme.of(context)
                                                  .secondaryText
                                              : FlutterFlowTheme.of(context)
                                                  .primaryText,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .override(
                                            fontFamily: 'Poppins',
                                            color: (_model.color ==
                                                        Color(0xFF613F75)) ||
                                                    (_model.color ==
                                                        Color(0xFF77A6B6)) ||
                                                    (_model.color ==
                                                        Color(0xFF1A759F))
                                                ? FlutterFlowTheme.of(context)
                                                    .secondaryText
                                                : FlutterFlowTheme.of(context)
                                                    .primaryText,
                                            letterSpacing: 0.0,
                                          ),
                                      textAlign: TextAlign.start,
                                      maxLines: null,
                                      validator: _model
                                          .baslikTextControllerValidator
                                          .asValidator(context),
                                    ),
                                  ),
                                ),
                              ),
                              Opacity(
                                opacity: 0.5,
                                child: Align(
                                  alignment: AlignmentDirectional(0.0, -1.0),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 10.0, 0.0, 10.0),
                                    child: Container(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.75,
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                              0.003,
                                      decoration: BoxDecoration(
                                        color: (_model.color ==
                                                    Color(0xFF613F75)) ||
                                                (_model.color ==
                                                    Color(0xFF77A6B6)) ||
                                                (_model.color ==
                                                    Color(0xFF1A759F))
                                            ? FlutterFlowTheme.of(context)
                                                .secondaryText
                                            : FlutterFlowTheme.of(context)
                                                .primaryText,
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                        shape: BoxShape.rectangle,
                                      ),
                                      alignment: AlignmentDirectional(0.0, 0.0),
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(0.0, -1.0),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      45.0, 0.0, 45.0, 0.0),
                                  child: Container(
                                    width: double.infinity,
                                    child: TextFormField(
                                      controller: _model.contentTextController,
                                      focusNode: _model.contentFocusNode,
                                      autofocus: false,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        hintText: 'Content',
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Poppins',
                                              color: (_model.color ==
                                                          Color(0xFF613F75)) ||
                                                      (_model.color ==
                                                          Color(0xFF77A6B6)) ||
                                                      (_model.color ==
                                                          Color(0xFF1A759F))
                                                  ? FlutterFlowTheme.of(context)
                                                      .secondaryText
                                                  : FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              letterSpacing: 0.0,
                                            ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Poppins',
                                            color: (_model.color ==
                                                        Color(0xFF613F75)) ||
                                                    (_model.color ==
                                                        Color(0xFF77A6B6)) ||
                                                    (_model.color ==
                                                        Color(0xFF1A759F))
                                                ? FlutterFlowTheme.of(context)
                                                    .secondaryText
                                                : FlutterFlowTheme.of(context)
                                                    .primaryText,
                                            letterSpacing: 0.0,
                                          ),
                                      textAlign: TextAlign.start,
                                      maxLines: null,
                                      validator: _model
                                          .contentTextControllerValidator
                                          .asValidator(context),
                                    ),
                                  ),
                                ),
                              ),
                              if (_model.imageBase64 != null &&
                                  _model.imageBase64 != '')
                                Flexible(
                                  child: Align(
                                    alignment: AlignmentDirectional(-1.0, -1.0),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          45.0, 10.0, 45.0, 0.0),
                                      child: FlutterFlowWebView(
                                        content: _model.imageBase64!,
                                        width: 256.0,
                                        height: 256.0,
                                        verticalScroll: false,
                                        horizontalScroll: false,
                                        html: true,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(25.0, 30.0, 0.0, 0.0),
                      child: FlutterFlowIconButton(
                        borderRadius: 8.0,
                        buttonSize: 40.0,
                        icon: Icon(
                          Icons.arrow_back,
                          color: (_model.color == Color(0xFF613F75)) ||
                                  (_model.color == Color(0xFF77A6B6)) ||
                                  (_model.color == Color(0xFF1A759F))
                              ? FlutterFlowTheme.of(context).secondaryText
                              : FlutterFlowTheme.of(context).primaryText,
                          size: 24.0,
                        ),
                        onPressed: () async {
                          if (widget!.notesDoc != null ? true : false) {
                            await widget!.notesDoc!.reference.update({
                              ...createNotesRecordData(
                                color: _model.color,
                                pinned: _model.pinned,
                                favorited: _model.favori,
                                deleted: false,
                                title: _model.baslikTextController.text,
                                content: _model.contentTextController.text,
                                image: _model.imageBase64,
                              ),
                              ...mapToFirestore(
                                {
                                  'lastEditTime': FieldValue.serverTimestamp(),
                                },
                              ),
                            });
                          } else {
                            if ((_model.baslikTextController.text != null &&
                                    _model.baslikTextController.text != '') ||
                                (_model.contentTextController.text != null &&
                                    _model.contentTextController.text != '')) {
                              await NotesRecord.collection.doc().set({
                                ...createNotesRecordData(
                                  color: _model.color,
                                  pinned: _model.pinned,
                                  favorited: _model.favori,
                                  deleted: false,
                                  title: _model.baslikTextController.text,
                                  content: _model.contentTextController.text,
                                  owner: currentUserUid,
                                  image: _model.imageBase64,
                                ),
                                ...mapToFirestore(
                                  {
                                    'createTime': FieldValue.serverTimestamp(),
                                    'lastEditTime':
                                        FieldValue.serverTimestamp(),
                                  },
                                ),
                              });
                            } else {
                              context.safePop();
                            }
                          }

                          context.safePop();
                        },
                      ),
                    ),
                    if (FFAppState().comingSoon)
                      wrapWithModel(
                        model: _model.comingSoonModel,
                        updateCallback: () => safeSetState(() {}),
                        child: ComingSoonWidget(),
                      ),
                    Align(
                      alignment: AlignmentDirectional(0.0, 1.0),
                      child: SingleChildScrollView(
                        primary: false,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_model.hakkinda == true)
                              Align(
                                alignment: AlignmentDirectional(-1.0, 0.0),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      19.0, 0.0, 0.0, 0.0),
                                  child: Container(
                                    width: 280.0,
                                    height: 140.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Align(
                                            alignment:
                                                AlignmentDirectional(-1.0, 0.0),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      15.0, 5.0, 5.0, 0.0),
                                              child: Wrap(
                                                spacing: 0.0,
                                                runSpacing: 0.0,
                                                alignment: WrapAlignment.start,
                                                crossAxisAlignment:
                                                    WrapCrossAlignment.center,
                                                direction: Axis.horizontal,
                                                runAlignment:
                                                    WrapAlignment.start,
                                                verticalDirection:
                                                    VerticalDirection.down,
                                                clipBehavior: Clip.none,
                                                children: [
                                                  Text(
                                                    'Owner: ',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                  ),
                                                  AuthUserStreamWidget(
                                                    builder: (context) => Text(
                                                      currentUserDisplayName,
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                'Poppins',
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryText,
                                                            fontSize: 12.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                          ),
                                                    ),
                                                  ),
                                                  AuthUserStreamWidget(
                                                    builder: (context) => Text(
                                                      valueOrDefault(
                                                          currentUserDocument
                                                              ?.username,
                                                          ''),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                'Poppins',
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryText,
                                                            fontSize: 10.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w100,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment:
                                                AlignmentDirectional(-1.0, 0.0),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      15.0, 5.0, 5.0, 0.0),
                                              child: Wrap(
                                                spacing: 0.0,
                                                runSpacing: 0.0,
                                                alignment: WrapAlignment.start,
                                                crossAxisAlignment:
                                                    WrapCrossAlignment.center,
                                                direction: Axis.horizontal,
                                                runAlignment:
                                                    WrapAlignment.start,
                                                verticalDirection:
                                                    VerticalDirection.down,
                                                clipBehavior: Clip.none,
                                                children: [
                                                  Text(
                                                    'Creation time: ',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                  ),
                                                  Text(
                                                    dateTimeFormat(
                                                      "yMMMd",
                                                      widget!.notesDoc!
                                                          .createTime!,
                                                      locale:
                                                          FFLocalizations.of(
                                                                  context)
                                                              .languageCode,
                                                    ),
                                                    textAlign: TextAlign.start,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment:
                                                AlignmentDirectional(-1.0, 0.0),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      15.0, 5.0, 5.0, 0.0),
                                              child: Wrap(
                                                spacing: 0.0,
                                                runSpacing: 0.0,
                                                alignment: WrapAlignment.start,
                                                crossAxisAlignment:
                                                    WrapCrossAlignment.center,
                                                direction: Axis.horizontal,
                                                runAlignment:
                                                    WrapAlignment.start,
                                                verticalDirection:
                                                    VerticalDirection.down,
                                                clipBehavior: Clip.none,
                                                children: [
                                                  Text(
                                                    'Last edited time: ',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                  ),
                                                  Text(
                                                    dateTimeFormat(
                                                      "yMMMd",
                                                      widget!.notesDoc!
                                                          .lastEditTime!,
                                                      locale:
                                                          FFLocalizations.of(
                                                                  context)
                                                              .languageCode,
                                                    ),
                                                    textAlign: TextAlign.start,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment:
                                                AlignmentDirectional(-1.0, 0.0),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      15.0, 5.0, 5.0, 0.0),
                                              child: Wrap(
                                                spacing: 0.0,
                                                runSpacing: 0.0,
                                                alignment: WrapAlignment.start,
                                                crossAxisAlignment:
                                                    WrapCrossAlignment.center,
                                                direction: Axis.horizontal,
                                                runAlignment:
                                                    WrapAlignment.start,
                                                verticalDirection:
                                                    VerticalDirection.down,
                                                clipBehavior: Clip.none,
                                                children: [
                                                  Text(
                                                    'Editors & Viewers: ',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                  ),
                                                  Text(
                                                    'Looks like you\'re all alone here',
                                                    textAlign: TextAlign.start,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                        ),
                                                  ),
                                                  Text(
                                                    'no editor or viewer in sight!',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          fontSize: 10.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w100,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            Flexible(
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (_model.renksecmenuackapa)
                                    Align(
                                      alignment: AlignmentDirectional(0.0, 1.0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 32.0),
                                        child: Container(
                                          width: 355.0,
                                          height: 57.0,
                                          decoration: BoxDecoration(
                                            color: Color(0xFF374241),
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                          child: Align(
                                            alignment:
                                                AlignmentDirectional(0.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: InkWell(
                                                    splashColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    hoverColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    onTap: () async {
                                                      _model.color =
                                                          Color(0xFFE5EAE4);
                                                      safeSetState(() {});
                                                    },
                                                    child: Container(
                                                      width: 24.0,
                                                      height: 24.0,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFFE5EAE4),
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: InkWell(
                                                    splashColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    hoverColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    onTap: () async {
                                                      _model.color =
                                                          Color(0xFFF7EF81);
                                                      safeSetState(() {});
                                                    },
                                                    child: Container(
                                                      width: 24.0,
                                                      height: 24.0,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFFF7EF81),
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: InkWell(
                                                    splashColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    hoverColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    onTap: () async {
                                                      _model.color =
                                                          Color(0xFFD9ED92);
                                                      safeSetState(() {});
                                                    },
                                                    child: Container(
                                                      width: 24.0,
                                                      height: 24.0,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFFD9ED92),
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: InkWell(
                                                    splashColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    hoverColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    onTap: () async {
                                                      _model.color =
                                                          Color(0xFF79B669);
                                                      safeSetState(() {});
                                                    },
                                                    child: Container(
                                                      width: 24.0,
                                                      height: 24.0,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFF79B669),
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: InkWell(
                                                    splashColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    hoverColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    onTap: () async {
                                                      _model.color =
                                                          Color(0xFFFFDCE0);
                                                      safeSetState(() {});
                                                    },
                                                    child: Container(
                                                      width: 24.0,
                                                      height: 24.0,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFFFFDCE0),
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: InkWell(
                                                    splashColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    hoverColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    onTap: () async {
                                                      _model.color =
                                                          Color(0xFFCDB4DB);
                                                      safeSetState(() {});
                                                    },
                                                    child: Container(
                                                      width: 24.0,
                                                      height: 24.0,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFFCDB4DB),
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: InkWell(
                                                    splashColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    hoverColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    onTap: () async {
                                                      _model.color =
                                                          Color(0xFF613F75);
                                                      safeSetState(() {});
                                                    },
                                                    child: Container(
                                                      width: 24.0,
                                                      height: 24.0,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFF613F75),
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: InkWell(
                                                    splashColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    hoverColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    onTap: () async {
                                                      _model.color =
                                                          Color(0xFF77A6B6);
                                                      safeSetState(() {});
                                                    },
                                                    child: Container(
                                                      width: 24.0,
                                                      height: 24.0,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFF77A6B6),
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: InkWell(
                                                    splashColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    hoverColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    onTap: () async {
                                                      _model.color =
                                                          Color(0xFF1A759F);
                                                      safeSetState(() {});
                                                    },
                                                    child: Container(
                                                      width: 24.0,
                                                      height: 24.0,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFF1A759F),
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: InkWell(
                                                    splashColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    hoverColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    onTap: () async {
                                                      _model.renksecmenuackapa =
                                                          false;
                                                      safeSetState(() {});
                                                    },
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      child: SvgPicture.asset(
                                                        'assets/images/paletyesil.svg',
                                                        width: 24.0,
                                                        height: 24.0,
                                                        fit: BoxFit.contain,
                                                        alignment:
                                                            Alignment(0.0, 0.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ].divide(SizedBox(width: 7.0)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (!_model.renksecmenuackapa)
                                    Align(
                                      alignment: AlignmentDirectional(0.0, 1.0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 32.0),
                                        child: Container(
                                          width: 355.0,
                                          height: 57.0,
                                          decoration: BoxDecoration(
                                            color: Color(0xFF374241),
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Align(
                                                alignment: AlignmentDirectional(
                                                    0.0, 0.0),
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    if (widget!.notesDoc!
                                                        .hasCreateTime()) {
                                                      _model.hakkinda =
                                                          !_model.hakkinda;
                                                      safeSetState(() {});
                                                    } else {
                                                      return;
                                                    }
                                                  },
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: SvgPicture.asset(
                                                      'assets/images/hakkinda.svg',
                                                      width: 24.0,
                                                      height: 24.0,
                                                      fit: BoxFit.contain,
                                                      alignment:
                                                          Alignment(0.0, 0.0),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: AlignmentDirectional(
                                                    0.0, 0.0),
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    FFAppState().comingSoon =
                                                        true;
                                                    safeSetState(() {});
                                                  },
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: SvgPicture.asset(
                                                      'assets/images/madde.svg',
                                                      width: 24.0,
                                                      height: 24.0,
                                                      fit: BoxFit.contain,
                                                      alignment:
                                                          Alignment(0.0, 0.0),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: AlignmentDirectional(
                                                    0.0, 0.0),
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    FFAppState().comingSoon =
                                                        true;
                                                    safeSetState(() {});
                                                  },
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: SvgPicture.asset(
                                                      'assets/images/fontkalin.svg',
                                                      width: 24.0,
                                                      height: 24.0,
                                                      fit: BoxFit.contain,
                                                      alignment:
                                                          Alignment(0.0, 0.0),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: AlignmentDirectional(
                                                    0.0, 0.0),
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    FFAppState().comingSoon =
                                                        true;
                                                    safeSetState(() {});
                                                  },
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: SvgPicture.asset(
                                                      'assets/images/fontitalik.svg',
                                                      width: 24.0,
                                                      height: 24.0,
                                                      fit: BoxFit.contain,
                                                      alignment:
                                                          Alignment(0.0, 0.0),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: AlignmentDirectional(
                                                    0.0, 0.0),
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    FFAppState().comingSoon =
                                                        true;
                                                    safeSetState(() {});
                                                  },
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: SvgPicture.asset(
                                                      'assets/images/alticizili.svg',
                                                      width: 24.0,
                                                      height: 24.0,
                                                      fit: BoxFit.contain,
                                                      alignment:
                                                          Alignment(0.0, 0.0),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: AlignmentDirectional(
                                                    0.0, 0.0),
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    FFAppState().comingSoon =
                                                        true;
                                                    safeSetState(() {});
                                                  },
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: SvgPicture.asset(
                                                      'assets/images/font.svg',
                                                      width: 24.0,
                                                      height: 24.0,
                                                      fit: BoxFit.contain,
                                                      alignment:
                                                          Alignment(0.0, 0.0),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: AlignmentDirectional(
                                                    0.0, 0.0),
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    final selectedMedia =
                                                        await selectMediaWithSourceBottomSheet(
                                                      context: context,
                                                      maxWidth: 512.00,
                                                      maxHeight: 512.00,
                                                      allowPhoto: true,
                                                      pickerFontFamily:
                                                          'Poppins',
                                                    );
                                                    if (selectedMedia != null &&
                                                        selectedMedia.every((m) =>
                                                            validateFileFormat(
                                                                m.storagePath,
                                                                context))) {
                                                      safeSetState(() => _model
                                                              .isDataUploading =
                                                          true);
                                                      var selectedUploadedFiles =
                                                          <FFUploadedFile>[];

                                                      try {
                                                        selectedUploadedFiles =
                                                            selectedMedia
                                                                .map((m) =>
                                                                    FFUploadedFile(
                                                                      name: m
                                                                          .storagePath
                                                                          .split(
                                                                              '/')
                                                                          .last,
                                                                      bytes: m
                                                                          .bytes,
                                                                      height: m
                                                                          .dimensions
                                                                          ?.height,
                                                                      width: m
                                                                          .dimensions
                                                                          ?.width,
                                                                      blurHash:
                                                                          m.blurHash,
                                                                    ))
                                                                .toList();
                                                      } finally {
                                                        _model.isDataUploading =
                                                            false;
                                                      }
                                                      if (selectedUploadedFiles
                                                              .length ==
                                                          selectedMedia
                                                              .length) {
                                                        safeSetState(() {
                                                          _model.uploadedLocalFile =
                                                              selectedUploadedFiles
                                                                  .first;
                                                        });
                                                      } else {
                                                        safeSetState(() {});
                                                        return;
                                                      }
                                                    }

                                                    _model.base64 =
                                                        await actions
                                                            .convertToBase64(
                                                      _model.uploadedLocalFile,
                                                    );
                                                    _model.imageBase64 =
                                                        _model.base64;
                                                    safeSetState(() {});

                                                    safeSetState(() {});
                                                  },
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: SvgPicture.asset(
                                                      'assets/images/gorsel.svg',
                                                      width: 24.0,
                                                      height: 24.0,
                                                      fit: BoxFit.contain,
                                                      alignment:
                                                          Alignment(0.0, 0.0),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: AlignmentDirectional(
                                                    0.0, 0.0),
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    _model.renksecmenuackapa =
                                                        true;
                                                    safeSetState(() {});
                                                  },
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: SvgPicture.asset(
                                                      'assets/images/palet.svg',
                                                      width: 24.0,
                                                      height: 24.0,
                                                      fit: BoxFit.contain,
                                                      alignment:
                                                          Alignment(0.0, 0.0),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ].divide(SizedBox(width: 16.0)),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(0.0, 1.0),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            305.25, 0.0, 0.0, 89.0),
                        child: FlutterFlowIconButton(
                          borderRadius: 8.0,
                          buttonSize: 50.0,
                          fillColor: Color(0xFF374241),
                          icon: FaIcon(
                            FontAwesomeIcons.robot,
                            color: Color(0xFFB8B8B8),
                            size: 24.0,
                          ),
                          onPressed: () async {
                            var _shouldSetState = false;
                            if (_model.contentTextController.text != null &&
                                    _model.contentTextController.text != ''
                                ? true
                                : false) {
                              _model.soundPlayer1 ??= AudioPlayer();
                              if (_model.soundPlayer1!.playing) {
                                await _model.soundPlayer1!.stop();
                              }
                              _model.soundPlayer1!.setVolume(1.0);
                              _model.soundPlayer1!
                                  .setAsset('assets/audios/uzun.mp3')
                                  .then((_) => _model.soundPlayer1!.play());

                              _model.aigeneratedimage =
                                  await actions.fetchImageBase64(
                                _model.contentTextController.text,
                              );
                              _shouldSetState = true;
                              _model.imageBase64 = _model.aigeneratedimage;
                              safeSetState(() {});
                              _model.soundPlayer2 ??= AudioPlayer();
                              if (_model.soundPlayer2!.playing) {
                                await _model.soundPlayer2!.stop();
                              }
                              _model.soundPlayer2!.setVolume(1.0);
                              _model.soundPlayer2!
                                  .setAsset('assets/audios/ksa.mp3')
                                  .then((_) => _model.soundPlayer2!.play());

                              _model.soundPlayer1?.stop();
                              _model.soundPlayer2?.stop();
                            } else {
                              if (_shouldSetState) safeSetState(() {});
                              return;
                            }

                            if (_shouldSetState) safeSetState(() {});
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
