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
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'profile_model.dart';
export 'profile_model.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  static String routeName = 'Profile';
  static String routePath = '/profile';

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  late ProfileModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfileModel());
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
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          drawer: Container(
            width: 250.0,
            child: Drawer(
              elevation: 16.0,
              child: WebViewAware(
                child: Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 30.0, 0.0, 10.0),
                            child: Container(
                              width: 210.0,
                              height: 200.0,
                              decoration: BoxDecoration(),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Flexible(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  50.0, 0.0, 0.0, 0.0),
                                          child: AuthUserStreamWidget(
                                            builder: (context) =>
                                                FlutterFlowWebView(
                                              content: valueOrDefault(
                                                  currentUserDocument
                                                      ?.userphoto,
                                                  ''),
                                              width: 115.0,
                                              height: 115.0,
                                              verticalScroll: false,
                                              horizontalScroll: false,
                                              html: true,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              AlignmentDirectional(1.0, 1.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              Navigator.pop(context);
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(0.0),
                                              child: SvgPicture.asset(
                                                Theme.of(context).brightness ==
                                                        Brightness.dark
                                                    ? 'assets/images/Group_331.svg'
                                                    : 'assets/images/Group_33.svg',
                                                width: 35.0,
                                                height: 35.0,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional(0.0, 1.0),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 10.0),
                                      child: AuthUserStreamWidget(
                                        builder: (context) => Text(
                                          currentUserDisplayName,
                                          textAlign: TextAlign.center,
                                          style: FlutterFlowTheme.of(context)
                                              .labelMedium
                                              .override(
                                                fontFamily: 'Poppins',
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText
                                                    : FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                fontSize: 16.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(0.0, -1.0),
                          child: Container(
                            width: MediaQuery.sizeOf(context).width * 0.35,
                            height: 3.0,
                            decoration: BoxDecoration(
                              color: Color(0xFF06A74D),
                              borderRadius: BorderRadius.circular(24.0),
                              shape: BoxShape.rectangle,
                            ),
                            alignment: AlignmentDirectional(0.0, 0.0),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              5.0, 10.0, 5.0, 0.0),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Align(
                                  alignment: AlignmentDirectional(-1.0, 0.0),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      context
                                          .pushNamed(AnasayfaWidget.routeName);
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                              0.057,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    12.0, 0.0, 20.0, 0.0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: SvgPicture.asset(
                                                'assets/images/allnotes.svg',
                                                width: 24.0,
                                                height: 24.0,
                                                fit: BoxFit.contain,
                                                alignment: Alignment(0.0, 0.0),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            'All Notes',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Poppins',
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.dark
                                                      ? FlutterFlowTheme.of(
                                                              context)
                                                          .secondaryText
                                                      : FlutterFlowTheme.of(
                                                              context)
                                                          .primaryText,
                                                  fontSize: 17.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional(-1.0, 0.0),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      context
                                          .pushNamed(FavoritesWidget.routeName);
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                              0.057,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 10.0, 0.0, 5.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      12.0, 0.0, 20.0, 0.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                child: SvgPicture.asset(
                                                  'assets/images/favorites.svg',
                                                  width: 24.0,
                                                  height: 24.0,
                                                  fit: BoxFit.contain,
                                                  alignment:
                                                      Alignment(0.0, 0.0),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              'Favorites',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily: 'Poppins',
                                                    color: Theme.of(context)
                                                                .brightness ==
                                                            Brightness.dark
                                                        ? FlutterFlowTheme.of(
                                                                context)
                                                            .secondaryText
                                                        : FlutterFlowTheme.of(
                                                                context)
                                                            .primaryText,
                                                    fontSize: 17.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional(-1.0, 0.0),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      context.pushNamed(TrashWidget.routeName);
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                              0.057,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 10.0, 0.0, 5.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      12.0, 0.0, 20.0, 0.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                child: SvgPicture.asset(
                                                  'assets/images/trash.svg',
                                                  width: 24.0,
                                                  height: 24.0,
                                                  fit: BoxFit.contain,
                                                  alignment:
                                                      Alignment(0.0, 0.0),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              'Trash',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily: 'Poppins',
                                                    color: Theme.of(context)
                                                                .brightness ==
                                                            Brightness.dark
                                                        ? FlutterFlowTheme.of(
                                                                context)
                                                            .secondaryText
                                                        : FlutterFlowTheme.of(
                                                                context)
                                                            .primaryText,
                                                    fontSize: 17.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: AlignmentDirectional(0.0, 1.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if ((Theme.of(context).brightness ==
                                  Brightness.dark) ==
                              false)
                            Align(
                              alignment: AlignmentDirectional(0.0, 1.0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 30.0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    setDarkModeSetting(context, ThemeMode.dark);
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: SvgPicture.asset(
                                      'assets/images/tema.svg',
                                      width: MediaQuery.sizeOf(context).width *
                                          0.2,
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                              0.045,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          if ((Theme.of(context).brightness ==
                                  Brightness.dark) ==
                              true)
                            Align(
                              alignment: AlignmentDirectional(0.0, 1.0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 30.0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    setDarkModeSetting(
                                        context, ThemeMode.light);
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: SvgPicture.asset(
                                      'assets/images/tema2.svg',
                                      width: MediaQuery.sizeOf(context).width *
                                          0.2,
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                              0.045,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(-1.0, -1.0),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            15.0, 50.0, 0.0, 0.0),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            if (scaffoldKey.currentState!.isDrawerOpen ||
                                scaffoldKey.currentState!.isEndDrawerOpen) {
                              Navigator.pop(context);
                            }
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: SvgPicture.asset(
                              'assets/images/geri.svg',
                              width: 22.0,
                              height: 19.0,
                              fit: BoxFit.contain,
                              alignment: Alignment(0.0, 0.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: Stack(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.sizeOf(context).height * 0.18,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primary,
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(20.0, 82.0, 0.0, 0.0),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          scaffoldKey.currentState!.openDrawer();
                        },
                        child: Container(
                          width: MediaQuery.sizeOf(context).width * 0.15,
                          height: MediaQuery.sizeOf(context).height * 0.05,
                          decoration: BoxDecoration(),
                          child: Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(0.0),
                                bottomRight: Radius.circular(0.0),
                                topLeft: Radius.circular(0.0),
                                topRight: Radius.circular(0.0),
                              ),
                              child: SvgPicture.asset(
                                Theme.of(context).brightness == Brightness.dark
                                    ? 'assets/images/nav-left-1.svg'
                                    : 'assets/images/nav-left.svg',
                                width: MediaQuery.sizeOf(context).width * 0.12,
                                height:
                                    MediaQuery.sizeOf(context).height * 0.03,
                                fit: BoxFit.contain,
                                alignment: Alignment(0.0, 0.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: double.infinity,
                      height: MediaQuery.sizeOf(context).height * 0.078,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primary,
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(-0.01, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(0.0, -1.0),
                            child: AuthUserStreamWidget(
                              builder: (context) => FlutterFlowWebView(
                                content: valueOrDefault(
                                    currentUserDocument?.userphoto, ''),
                                width: 175.0,
                                height: 175.0,
                                verticalScroll: false,
                                horizontalScroll: false,
                                html: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width * 0.2,
                      height: 20.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                    ),
                    AuthUserStreamWidget(
                      builder: (context) => Text(
                        currentUserDisplayName,
                        style: FlutterFlowTheme.of(context)
                            .headlineSmall
                            .override(
                              fontFamily: 'Poppins',
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? FlutterFlowTheme.of(context).secondaryText
                                  : FlutterFlowTheme.of(context).primaryText,
                              letterSpacing: 0.0,
                            ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 25.0),
                      child: AuthUserStreamWidget(
                        builder: (context) => Text(
                          valueOrDefault(currentUserDocument?.username, ''),
                          style: FlutterFlowTheme.of(context)
                              .bodyLarge
                              .override(
                                fontFamily: 'Poppins',
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? FlutterFlowTheme.of(context).secondaryText
                                    : FlutterFlowTheme.of(context).primaryText,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w300,
                              ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            FutureBuilder<int>(
                              future: queryNotesRecordCount(
                                queryBuilder: (notesRecord) =>
                                    notesRecord.where(
                                  'owner',
                                  isEqualTo: currentUserUid,
                                ),
                              ),
                              builder: (context, snapshot) {
                                // Customize what your widget looks like when it's loading.
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: SizedBox(
                                      width: 50.0,
                                      height: 50.0,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          FlutterFlowTheme.of(context).primary,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                int textCount = snapshot.data!;

                                return Text(
                                  textCount.toString(),
                                  style: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Poppins',
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? FlutterFlowTheme.of(context)
                                                .secondaryText
                                            : FlutterFlowTheme.of(context)
                                                .primaryText,
                                        letterSpacing: 0.0,
                                      ),
                                );
                              },
                            ),
                            Text(
                              'Notes',
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
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            FutureBuilder<int>(
                              future: queryNotesRecordCount(
                                queryBuilder: (notesRecord) => notesRecord
                                    .where(
                                      'owner',
                                      isEqualTo: currentUserUid,
                                    )
                                    .where(
                                      'favorited',
                                      isEqualTo: true,
                                    ),
                              ),
                              builder: (context, snapshot) {
                                // Customize what your widget looks like when it's loading.
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: SizedBox(
                                      width: 50.0,
                                      height: 50.0,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          FlutterFlowTheme.of(context).primary,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                int textCount = snapshot.data!;

                                return Text(
                                  textCount.toString(),
                                  style: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Poppins',
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? FlutterFlowTheme.of(context)
                                                .secondaryText
                                            : FlutterFlowTheme.of(context)
                                                .primaryText,
                                        letterSpacing: 0.0,
                                      ),
                                );
                              },
                            ),
                            Text(
                              'Favorites',
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
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              'Coming',
                              style: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: 'Poppins',
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? FlutterFlowTheme.of(context)
                                            .secondaryText
                                        : FlutterFlowTheme.of(context)
                                            .primaryText,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                            Text(
                              'Soon',
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
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 2.0,
                      indent: 66.0,
                      endIndent: 66.0,
                      color: FlutterFlowTheme.of(context).primary,
                    ),
                    Align(
                      alignment: AlignmentDirectional(-1.0, -1.0),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            90.0, 20.0, 0.0, 0.0),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            context.pushNamed(EditProfileWidget.routeName);
                          },
                          child: Container(
                            width: 120.0,
                            height: 26.0,
                            decoration: BoxDecoration(),
                            child: Align(
                              alignment: AlignmentDirectional(-1.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Align(
                                    alignment: AlignmentDirectional(-1.0, 0.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: SvgPicture.asset(
                                        'assets/images/user-profile-02.svg',
                                        width: 24.0,
                                        height: 24.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional(-1.0, 0.0),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          10.0, 0.0, 0.0, 0.0),
                                      child: Text(
                                        'Edit Profile',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyLarge
                                            .override(
                                              fontFamily: 'Poppins',
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? FlutterFlowTheme.of(context)
                                                      .secondaryText
                                                  : FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(-1.0, 0.0),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            90.0, 20.0, 0.0, 0.0),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            FFAppState().notification = true;
                            safeSetState(() {});
                          },
                          child: Container(
                            width: 199.0,
                            height: 26.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                            child: Align(
                              alignment: AlignmentDirectional(-1.0, -1.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: AlignmentDirectional(-1.0, 0.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: SvgPicture.asset(
                                        'assets/images/bell-04.svg',
                                        width: 24.0,
                                        height: 24.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional(-1.0, 0.0),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          10.0, 0.0, 0.0, 0.0),
                                      child: Text(
                                        'Notification settings',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyLarge
                                            .override(
                                              fontFamily: 'Poppins',
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? FlutterFlowTheme.of(context)
                                                      .secondaryText
                                                  : FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(-1.0, 0.0),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            90.0, 20.0, 0.0, 0.0),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            FFAppState().comingSoon = true;
                            safeSetState(() {});
                          },
                          child: Container(
                            width: 98.0,
                            height: 26.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                            child: Align(
                              alignment: AlignmentDirectional(-1.0, -1.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: AlignmentDirectional(-1.0, 0.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: SvgPicture.asset(
                                        'assets/images/users-profiles-02.svg',
                                        width: 24.0,
                                        height: 24.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional(-1.0, 0.0),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          10.0, 0.0, 0.0, 0.0),
                                      child: Text(
                                        'Friends',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyLarge
                                            .override(
                                              fontFamily: 'Poppins',
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? FlutterFlowTheme.of(context)
                                                      .secondaryText
                                                  : FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0.0, 1.0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 35.0),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      GoRouter.of(context).prepareAuthEvent();
                      await authManager.signOut();
                      GoRouter.of(context).clearRedirectLocation();

                      context.pushNamedAuth(
                          LoginWidget.routeName, context.mounted);
                    },
                    child: Container(
                      width: MediaQuery.sizeOf(context).width * 0.237,
                      height: MediaQuery.sizeOf(context).height * 0.031,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      child: Align(
                        alignment: AlignmentDirectional(-1.0, -1.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: SvgPicture.asset(
                                  'assets/images/logout-02.svg',
                                  width: 24.0,
                                  height: 24.0,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    10.0, 0.0, 0.0, 0.0),
                                child: Text(
                                  'Logout',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyLarge
                                      .override(
                                        fontFamily: 'Poppins',
                                        color: Color(0xFFA70609),
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (FFAppState().comingSoon)
                wrapWithModel(
                  model: _model.comingSoonModel,
                  updateCallback: () => safeSetState(() {}),
                  child: ComingSoonWidget(),
                ),
              if (FFAppState().notification)
                wrapWithModel(
                  model: _model.notificationModel,
                  updateCallback: () => safeSetState(() {}),
                  child: NotificationWidget(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
