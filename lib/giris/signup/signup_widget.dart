import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'signup_model.dart';
export 'signup_model.dart';

class SignupWidget extends StatefulWidget {
  const SignupWidget({super.key});

  static String routeName = 'signup';
  static String routePath = '/signup';

  @override
  State<SignupWidget> createState() => _SignupWidgetState();
}

class _SignupWidgetState extends State<SignupWidget> {
  late SignupModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SignupModel());

    _model.emailAddressTextController ??= TextEditingController();
    _model.emailAddressFocusNode ??= FocusNode();

    _model.passwordTextController ??= TextEditingController();
    _model.passwordFocusNode ??= FocusNode();

    _model.passwordConfirmTextController ??= TextEditingController();
    _model.passwordConfirmFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          body: SafeArea(
            top: true,
            child: Stack(
              children: [
                Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(45.0, 0.0, 45.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: AlignmentDirectional(0.0, 1.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: SvgPicture.asset(
                              Theme.of(context).brightness == Brightness.dark
                                  ? 'assets/images/Group.svg'
                                  : 'assets/images/Group_26.svg',
                              width: MediaQuery.sizeOf(context).width * 0.3,
                              height: MediaQuery.sizeOf(context).height * 0.15,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 10.0, 0.0, 0.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(0.0),
                              child: SvgPicture.asset(
                                Theme.of(context).brightness == Brightness.dark
                                    ? 'assets/images/Group1.svg'
                                    : 'assets/images/Group_1.svg',
                                width: MediaQuery.sizeOf(context).width * 0.4,
                                height:
                                    MediaQuery.sizeOf(context).height * 0.045,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(-1.0, -1.0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 30.0, 0.0, 16.0),
                            child: Text(
                              'Sign Up',
                              textAlign: TextAlign.start,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Poppins',
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? FlutterFlowTheme.of(context)
                                            .secondaryText
                                        : FlutterFlowTheme.of(context)
                                            .primaryText,
                                    fontSize: 30.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 6.0, 0.0, 16.0),
                          child: Container(
                            width: double.infinity,
                            child: TextFormField(
                              controller: _model.emailAddressTextController,
                              focusNode: _model.emailAddressFocusNode,
                              autofocus: true,
                              autofillHints: [AutofillHints.email],
                              obscureText: false,
                              decoration: InputDecoration(
                                hintText: 'Email',
                                hintStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Poppins',
                                      letterSpacing: 0.0,
                                    ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                filled: true,
                                fillColor:
                                    FlutterFlowTheme.of(context).secondary,
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Poppins',
                                    letterSpacing: 0.0,
                                  ),
                              keyboardType: TextInputType.emailAddress,
                              validator: _model
                                  .emailAddressTextControllerValidator
                                  .asValidator(context),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 16.0),
                          child: Container(
                            width: double.infinity,
                            child: TextFormField(
                              controller: _model.passwordTextController,
                              focusNode: _model.passwordFocusNode,
                              autofocus: true,
                              autofillHints: [AutofillHints.password],
                              obscureText: !_model.passwordVisibility,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                hintStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Poppins',
                                      letterSpacing: 0.0,
                                    ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                filled: true,
                                fillColor:
                                    FlutterFlowTheme.of(context).secondary,
                                suffixIcon: InkWell(
                                  onTap: () => safeSetState(
                                    () => _model.passwordVisibility =
                                        !_model.passwordVisibility,
                                  ),
                                  focusNode: FocusNode(skipTraversal: true),
                                  child: Icon(
                                    _model.passwordVisibility
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: Color(0xFF57636C),
                                    size: 24.0,
                                  ),
                                ),
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Poppins',
                                    letterSpacing: 0.0,
                                  ),
                              validator: _model.passwordTextControllerValidator
                                  .asValidator(context),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 16.0),
                          child: Container(
                            width: double.infinity,
                            child: TextFormField(
                              controller: _model.passwordConfirmTextController,
                              focusNode: _model.passwordConfirmFocusNode,
                              autofocus: true,
                              autofillHints: [AutofillHints.password],
                              obscureText: !_model.passwordConfirmVisibility,
                              decoration: InputDecoration(
                                hintText: 'Confirm Password',
                                hintStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Poppins',
                                      letterSpacing: 0.0,
                                    ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                filled: true,
                                fillColor:
                                    FlutterFlowTheme.of(context).secondary,
                                suffixIcon: InkWell(
                                  onTap: () => safeSetState(
                                    () => _model.passwordConfirmVisibility =
                                        !_model.passwordConfirmVisibility,
                                  ),
                                  focusNode: FocusNode(skipTraversal: true),
                                  child: Icon(
                                    _model.passwordConfirmVisibility
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    size: 24.0,
                                  ),
                                ),
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Poppins',
                                    letterSpacing: 0.0,
                                  ),
                              validator: _model
                                  .passwordConfirmTextControllerValidator
                                  .asValidator(context),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 16.0),
                          child: FFButtonWidget(
                            onPressed: () async {
                              if (_model.passwordTextController.text ==
                                  _model.passwordConfirmTextController.text) {
                                GoRouter.of(context).prepareAuthEvent();
                                if (_model.passwordTextController.text !=
                                    _model.passwordConfirmTextController.text) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Passwords don\'t match!',
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                final user =
                                    await authManager.createAccountWithEmail(
                                  context,
                                  _model.emailAddressTextController.text,
                                  _model.passwordTextController.text,
                                );
                                if (user == null) {
                                  return;
                                }

                                await UsersRecord.collection
                                    .doc(user.uid)
                                    .update(createUsersRecordData(
                                      email: _model
                                          .emailAddressTextController.text,
                                      password:
                                          _model.passwordTextController.text,
                                      userphoto:
                                          '    <html>      <head>        <style>          /* Disable scrolling in WebView */          body, html {            margin: 0;            padding: 0;            overflow: hidden; /* Disables scroll */            height: 100%;          }          /* Make sure the image fits the WebView size */          img {            width: 100%;            height: 100%;            object-fit: contain; /* Ensures the image maintains aspect ratio */          }        </style>      </head>      <body>        <img src=\"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAN4AAADeCAYAAABSZ763AAAAAXNSR0IArs4c6QAAIABJREFUeF7snQmYXGWVv282soHs+9bIFgNIWMSwdzCOUVHQQUVcCAqKy7iNzjj+RwkzzqAzLhnRETWSoKi4zAiKCiPQzb6oGLYYEEizhX0nZCHLP+9X9VZO31RV31tdnXQg9Tx50t237r3fdr5zzu/8zvmGZC/6z5Asy1asw71c19u/Dg994aaXnyPuWP8ZPCOwTZZl/OPj/1uH5uWvcemhcN2fH67zt9mDp5vrW7Je8NbwGjj11FM7li5d2rF8+fIj58+fnz344IOdDz/8cMcTTzzZsWTJ4gFrzfDhw7ONNtqoZ5tttunZeuut+f/yMWPGZEOHDu2ZMWNG94C9eP2D647AesFr68LobXJMnTq1Y8mSJScuWLCg87bbbktC9vzzz2crVgwe03fIkCHZiBEjMgRyjz326Nliiy26hw8ffvm55567XhjbujZ6P2y94LVxcCdMmIA2O/Hpp5/ufOKJJzoXLlyYLV+xfJ1zMRHG4cOH92y++eY9m222WfeYMWMu/+Mf/7heENu4VgaZ4JV3Uts4FqUfNXHixI7777//xIULF3YuWrSo84UXXkjabPny5enfYNJsZTuH8A0dOjT94+dhw4b1jBo1qmfkyJHdmKmzZ89eL4hlBzV8f5AJXj960uvWgRPg448/vmP+/PknPvbYY9N6enoytNq6LGCtjPioUaOybbfdtmfbbbdFG55zySWXrBfCkgO57grewMnWakOIsD300EMnPvTQQ1Pvu+++jgULFpQc5hfv1wFtdtxxx57tttuue8cddzznvPPOWy+EBaZ73RW8Ap3rz1dAH+fOnXviPffc0/noo492Pvfcc/15XOXeNbhZ9L+x5Z8wevTobLPNNkMTzho3btwaAmjWzUFdL3i59TV58uTOSy655MQsy6aWX3rr78iNQM9KwGnW7NmzTx8UIzOIZHS94FVXxGGHHXba7bffPvWZZ57pWLx44OJpg2IBrsFGEKoYO3YsYYpZd9555+AQwDXY/0aveskL3v7773/ac889N3X+/PnJd1ungZJBtKPnFxwCCCCzySabzBo/fjy+YM8gWP9rrQkvScEjsH3nnXeeeNddd0179NFHs6VLl661CXipvXjYsGHZJpts0rPzzjvP2mOP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\" alt=\"Circular Image\" />      </body>    </html>    ',
                                    ));

                                context.pushNamedAuth(
                                    EditProfileWidget.routeName,
                                    context.mounted);
                              } else {
                                return;
                              }
                            },
                            text: 'Create Account',
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: MediaQuery.sizeOf(context).height * 0.055,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
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
                              elevation: 3.0,
                              borderSide: BorderSide(
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),

                        // You will have to add an action on this rich text to go to your login page.
                        Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 12.0, 0.0, 12.0),
                            child: RichText(
                              textScaler: MediaQuery.of(context).textScaler,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Already have an account? ',
                                    style: TextStyle(
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? FlutterFlowTheme.of(context)
                                              .secondaryText
                                          : FlutterFlowTheme.of(context)
                                              .primaryText,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Sign In here',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Plus Jakarta Sans',
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          fontSize: 14.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                    mouseCursor: SystemMouseCursors.click,
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        context
                                            .pushNamed(LoginWidget.routeName);
                                      },
                                  )
                                ],
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Poppins',
                                      color: Color(0xFF101213),
                                      fontSize: 14.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                              ),
                            ),
                          ),
                        ),

                        // You will have to add an action on this rich text to go to your login page.
                        Align(
                          alignment: AlignmentDirectional(0.0, 1.0),
                          child: RichText(
                            textScaler: MediaQuery.of(context).textScaler,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Hello!\nHere, you\'ll find the ',
                                  style: GoogleFonts.getFont(
                                    'Poppins',
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? FlutterFlowTheme.of(context)
                                            .secondaryText
                                        : FlutterFlowTheme.of(context)
                                            .primaryText,
                                    fontSize: 8.5,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      'membership agreement, privacy policy, terms of use, and all that jazz. ',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Poppins',
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        fontSize: 10.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                  mouseCursor: SystemMouseCursors.click,
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      await launchURL(
                                          'https://youtu.be/XxggzHIV-wE?t=60');
                                    },
                                ),
                                TextSpan(
                                  text:
                                      'Feel free to read everything in detail if you\'d like, but let\'s be honest—we know most of you probably won\'t. 😊\n\nBy clicking the ',
                                  style: GoogleFonts.getFont(
                                    'Poppins',
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? FlutterFlowTheme.of(context)
                                            .secondaryText
                                        : FlutterFlowTheme.of(context)
                                            .primaryText,
                                    fontSize: 8.5,
                                  ),
                                ),
                                TextSpan(
                                  text: '\"Create Account\" ',
                                  style: GoogleFonts.getFont(
                                    'Poppins',
                                    color: FlutterFlowTheme.of(context).primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10.0,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      'button, you confirm that you’ve read, understood, and accepted everything. In short:\n\nYes, I’ve read it.\nYes, I understand.\nYes, I accept.\nShall we move on? 🎉',
                                  style: GoogleFonts.getFont(
                                    'Poppins',
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? FlutterFlowTheme.of(context)
                                            .secondaryText
                                        : FlutterFlowTheme.of(context)
                                            .primaryText,
                                    fontSize: 8.5,
                                  ),
                                )
                              ],
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Poppins',
                                    color: Color(0xFF101213),
                                    fontSize: 12.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                            ),
                            textAlign: TextAlign.start,
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
    );
  }
}
