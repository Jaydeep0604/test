import 'package:flutter/material.dart';
import '../../base/base_stateful_widget_state.dart';
import '../../resources/colors.dart';
import '../../resources/strings.dart';
import '../main/main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends BaseStatefulWidgetState<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordObscured = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _performLogin() {
    FocusScope.of(context).unfocus();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainScreen(index: 0)),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),

          // Logo / Header
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: colorPrimary.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.show_chart, color: colorPrimary, size: 28),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'The',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colorBlack,
                    ),
                  ),
                  Text(
                    'Fixed Income',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colorPrimary,
                      height: 1.0,
                    ),
                  ),
                  Text(
                    'Tips for Better Wealth',
                    style: TextStyle(
                      fontSize: 11,
                      color: colorGreen,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 48),

          // Title
          const Text(
            Strings.welcomeBack,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: colorBlack,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            Strings.loginToContinue,
            style: TextStyle(
              fontSize: 14,
              color: colorGrey,
            ),
          ),

          const SizedBox(height: 32),

          // Username Field
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(
              hintText: Strings.username,
              filled: true,
              fillColor: const Color(0xFFF3F4F6),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Password Field
          TextField(
            controller: _passwordController,
            obscureText: _isPasswordObscured,
            decoration: InputDecoration(
              hintText: Strings.password,
              filled: true,
              fillColor: const Color(0xFFF3F4F6),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: colorGrey,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordObscured = !_isPasswordObscured;
                  });
                },
              ),
            ),
          ),

          const SizedBox(height: 28),

          // Login Button
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: _performLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: const Text(
                Strings.login,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colorWhite,
                ),
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Demo credentials hint card
          GestureDetector(
            onTap: () {
              _usernameController.text = 'emilys';
              _passwordController.text = 'emilyspass';
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: colorBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    Strings.demoCredentialsHint,
                    style: TextStyle(fontSize: 12, color: colorGrey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    Strings.demoUsername,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: colorDarkGrey),
                  ),
                  SizedBox(height: 4),
                  Text(
                    Strings.demoPassword,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: colorDarkGrey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
