import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/di/injection_container.dart' as di;
import 'core/navigation/navigation_service.dart';
import 'core/navigation/route_generator.dart';
import 'core/app/app_wrapper.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/inventory/presentation/bloc/inventory_bloc.dart';
import 'features/inventory/presentation/bloc/inventory_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<AuthBloc>()..add(CheckAuthStatusEvent()),
        ),
        BlocProvider(
          create: (_) => di.sl<InventoryBloc>()..add(LoadSpacesEvent()),
        ),
      ],
      child: MaterialApp(
        title: '4th',
        debugShowCheckedModeBanner: false,
        
        // Navigation
        navigatorKey: NavigationService.navigatorKey,
        onGenerateRoute: RouteGenerator.generateRoute,
        home: const AppWrapper(), // Use AppWrapper instead of initialRoute
        
        // Theme
        theme: ThemeData(
          // Use Outfit font from Google Fonts
          textTheme: GoogleFonts.outfitTextTheme(),
          colorScheme: const ColorScheme.light(
            primary: Colors.black,
            onPrimary: Colors.white,
            secondary: Color(0xFFD2D2D2), // Your custom grey
            onSecondary: Colors.black,
            surface: Colors.white,
            onSurface: Colors.black,
            error: Colors.red,
            onError: Colors.white,
          ),
          useMaterial3: true,
          cardTheme: CardThemeData(
            color: Colors.white,
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          appBarTheme: AppBarTheme(
            centerTitle: false,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 2,
            titleTextStyle: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          scaffoldBackgroundColor: Colors.white,
        ),
      ),
    );
  }
}
