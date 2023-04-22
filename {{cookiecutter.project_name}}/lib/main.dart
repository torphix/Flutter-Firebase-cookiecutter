import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:{{cookiecutter.project_name}}/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;

import 'blocs/auth/auth_cubit.dart';
import 'blocs/inapp_purchases/inapp_purchases_cubit.dart';
import 'blocs/settings/settings_cubit.dart';

Future<void> main() async {
  // Init
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
        light: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.teal,
        ),
        dark: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.purple,
        ),
        initial: AdaptiveThemeMode.dark,
        builder: (theme, darkTheme) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                      create: (context) =>
                          AuthCubit()..subscribeToAuthChanges()),
                  BlocProvider(create: (context) => SettingsCubit()),
                  BlocProvider(create: (context) => InappPurchasesCubit())
                ],
                child: BlocBuilder<SettingsCubit, SettingsState>(
                  builder: (context, settingsState) => MaterialApp(
                    debugShowCheckedModeBanner: false,
                    theme: theme,
                    darkTheme: darkTheme,
                    routes: {
                      '/home': (context) => const HomeScreen(),
                      '/sign-in': (context) => SignInScreen(
                            providers: [EmailAuthProvider()],
                            actions: [
                              AuthStateChangeAction<SignedIn>((context, state) {
                                Navigator.pushReplacementNamed(
                                    context, '/home');
                              }),
                            ],
                          )
                    },
                    initialRoute:
                        context.read<AuthCubit>().state.currentUser == null
                            ? '/sign-in'
                            : '/home',
                  ),
                )));
  }
}
