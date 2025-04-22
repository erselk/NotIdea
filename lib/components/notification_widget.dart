import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'notification_model.dart';
export 'notification_model.dart';

class NotificationWidget extends StatefulWidget {
  const NotificationWidget({super.key});

  @override
  State<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  late NotificationModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NotificationModel());
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
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(),
        ),
        Align(
          alignment: AlignmentDirectional(0.0, 0.0),
          child: Container(
            width: 556.0,
            height: 207.0,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).alternate,
              boxShadow: [
                BoxShadow(
                  blurRadius: 4.0,
                  color: FlutterFlowTheme.of(context).primaryText,
                  offset: Offset(
                    0.0,
                    2.0,
                  ),
                )
              ],
              borderRadius: BorderRadius.circular(24.0),
              shape: BoxShape.rectangle,
              border: Border.all(
                color: FlutterFlowTheme.of(context).primaryText,
              ),
            ),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Align(
                      alignment: AlignmentDirectional(-1.0, 0.0),
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(15.0, 5.0, 0.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 9.0, 0.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(0.0),
                                child: SvgPicture.asset(
                                  'assets/images/Group_26.svg',
                                  width: 44.66,
                                  height: 48.18,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0.0, 1.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(0.0),
                                child: SvgPicture.asset(
                                  'assets/images/Group_1.svg',
                                  width: 115.88,
                                  height: 25.0,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 0.0),
                      child: Text(
                        'This is a notification area, but unfortunately, there’s no button! 🚫😅\nYes, we won\'t be sending any notifications at all!',
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Poppins',
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          FFButtonWidget(
                            onPressed: () async {
                              FFAppState().notification = false;
                              _model.updatePage(() {});
                            },
                            text: 'Oh Thanks!',
                            options: FFButtonOptions(
                              height: 40.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: FlutterFlowTheme.of(context).primary,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                    letterSpacing: 0.0,
                                  ),
                              elevation: 0.0,
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
