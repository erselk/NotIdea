import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'coming_soon_model.dart';
export 'coming_soon_model.dart';

class ComingSoonWidget extends StatefulWidget {
  const ComingSoonWidget({super.key});

  @override
  State<ComingSoonWidget> createState() => _ComingSoonWidgetState();
}

class _ComingSoonWidgetState extends State<ComingSoonWidget> {
  late ComingSoonModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ComingSoonModel());
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
            width: 563.0,
            height: 359.0,
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
                Align(
                  alignment: AlignmentDirectional(0.0, -0.35),
                  child: Container(
                    width: double.infinity,
                    height: 3.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primary,
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(-1.0, 0.0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              15.0, 5.0, 0.0, 0.0),
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
                                  child: Image.asset(
                                    'assets/images/icon.png',
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
                      Container(
                        width: 122.0,
                        height: 81.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).alternate,
                        ),
                        child: Text(
                          'Coming\nSoon',
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context)
                              .headlineMedium
                              .override(
                                fontFamily: 'Poppins',
                                letterSpacing: 0.0,
                              ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 0.0),
                        child: Text(
                          'We know you’re just as excited about this feature as we are! 🛠️\n\nWe\'re working hard to bring it to life, and we can’t wait to roll it out soon.\n\nStay tuned—it’ll be worth the wait!',
                          textAlign: TextAlign.center,
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
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
                                FFAppState().comingSoon = false;
                                _model.updatePage(() {});
                              },
                              text: 'I Can’t Wait!',
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
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
