import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import '/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'notcard_model.dart';
export 'notcard_model.dart';

class NotcardWidget extends StatefulWidget {
  const NotcardWidget({
    super.key,
    this.title,
    this.color,
    this.favorited,
    this.pinned,
    this.content,
    this.notesdoc,
    this.deleted,
  });

  final String? title;
  final Color? color;
  final bool? favorited;
  final bool? pinned;
  final String? content;
  final NotesRecord? notesdoc;
  final bool? deleted;

  @override
  State<NotcardWidget> createState() => _NotcardWidgetState();
}

class _NotcardWidgetState extends State<NotcardWidget> {
  late NotcardModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NotcardModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(4.0),
          child: InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              context.pushNamed(
                NotduzenleWidget.routeName,
                queryParameters: {
                  'notesDoc': serializeParam(
                    widget!.notesdoc,
                    ParamType.Document,
                  ),
                }.withoutNulls,
                extra: <String, dynamic>{
                  'notesDoc': widget!.notesdoc,
                },
              );
            },
            onLongPress: () async {
              _model.basilimenu = true;
              safeSetState(() {});
            },
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: widget!.color,
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (widget!.title != null && widget!.title != '')
                        Align(
                          alignment: AlignmentDirectional(-1.0, -1.0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                10.0, 6.0, 35.0, 0.0),
                            child: Text(
                              widget!.title!,
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Poppins',
                                    color: (widget!.color ==
                                                Color(0xFF613F75)) ||
                                            (widget!.color ==
                                                Color(0xFF77A6B6)) ||
                                            (widget!.color == Color(0xFF1A759F))
                                        ? Colors.white
                                        : Color(0xFF374241),
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ),
                      if (widget!.content != null && widget!.content != '')
                        Align(
                          alignment: AlignmentDirectional(-1.0, -1.0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                10.0, 5.0, 0.0, 6.0),
                            child: Text(
                              widget!.content!,
                              maxLines: 7,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Poppins',
                                    color: (widget!.color ==
                                                Color(0xFF613F75)) ||
                                            (widget!.color ==
                                                Color(0xFF77A6B6)) ||
                                            (widget!.color == Color(0xFF1A759F))
                                        ? Colors.white
                                        : Color(0xFF374241),
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 10.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (widget!.favorited ?? true)
                          Align(
                            alignment: AlignmentDirectional(1.0, -1.0),
                            child: Icon(
                              Icons.favorite_sharp,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 12.0,
                            ),
                          ),
                        if (widget!.pinned ?? true)
                          Align(
                            alignment: AlignmentDirectional(1.0, -1.0),
                            child: Icon(
                              Icons.push_pin,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 12.0,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_model.basilimenu == true)
          Align(
            alignment: AlignmentDirectional(1.0, -1.0),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 2.0, 2.0, 0.0),
              child: Container(
                width: 100.0,
                height: 80.0,
                decoration: BoxDecoration(
                  color: Color(0xFFA6A6A6),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Stack(
                  children: [
                    ListView(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: [
                        Align(
                          alignment: AlignmentDirectional(-1.0, -1.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              if (widget!.pinned == true) {
                                await widget!.notesdoc!.reference
                                    .update(createNotesRecordData(
                                  pinned: false,
                                ));
                              } else {
                                await widget!.notesdoc!.reference
                                    .update(createNotesRecordData(
                                  pinned: true,
                                ));
                              }

                              _model.basilimenu = false;
                              safeSetState(() {});
                            },
                            child: Container(
                              width: 100.0,
                              height: 25.0,
                              decoration: BoxDecoration(),
                              child: Align(
                                alignment: AlignmentDirectional(-1.0, 0.0),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      8.0, 2.5, 0.0, 0.0),
                                  child: Text(
                                    'Pin',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Poppins',
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(-1.0, -1.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              if (widget!.favorited == true) {
                                await widget!.notesdoc!.reference
                                    .update(createNotesRecordData(
                                  favorited: false,
                                ));
                              } else {
                                await widget!.notesdoc!.reference
                                    .update(createNotesRecordData(
                                  favorited: true,
                                ));
                              }

                              _model.basilimenu = false;
                              safeSetState(() {});
                            },
                            child: Container(
                              width: 100.0,
                              height: 25.0,
                              decoration: BoxDecoration(),
                              child: Align(
                                alignment: AlignmentDirectional(-1.0, 0.0),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      8.0, 2.0, 0.0, 0.0),
                                  child: Text(
                                    'Favorite',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Poppins',
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(-1.0, -1.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              if (widget!.deleted == true) {
                                await widget!.notesdoc!.reference.delete();
                              } else {
                                await widget!.notesdoc!.reference
                                    .update(createNotesRecordData(
                                  deleted: true,
                                ));
                              }

                              _model.basilimenu = false;
                              _model.updatePage(() {});
                            },
                            child: Container(
                              width: 100.0,
                              height: 25.0,
                              decoration: BoxDecoration(),
                              child: Align(
                                alignment: AlignmentDirectional(-1.0, 0.0),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      8.0, 2.0, 0.0, 2.5),
                                  child: Text(
                                    'Delete',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Poppins',
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                              ),
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
      ],
    );
  }
}
