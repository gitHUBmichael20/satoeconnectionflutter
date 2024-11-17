import 'package:flutter/material.dart';
import 'package:satoe_connection/screen/wrapper.dart';
import 'package:satoe_connection/screen/login/sign_in.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    // Add listeners to check form validity
    _emailController.addListener(_checkFormValidity);
    _passwordController.addListener(_checkFormValidity);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _checkFormValidity() {
    setState(() {
      _isFormValid = _emailController.text.isNotEmpty && 
                     _passwordController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Image.asset(
              'assets/logo.png',
              height: 60,
              width: 60,
              color: const Color(0xFF1D7874), // Teal/green color similar to image
            ),
            const SizedBox(height: 12),
            
            // Login Text
            const Text(
              'Sign up to SatoeConnection',
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            
            // Welcome Text
            const Text(
              'Welcome back! Sign up using your \naccount or email to continue us',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins',
                color: Colors.black54,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            
            // Email Field
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your email',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    color: Color(0xFF1D7874),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    hintStyle: const TextStyle(
                      color: Colors.black26,
                      fontFamily: 'Poppins',
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey.shade200,
                      ),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF1D7874),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Password Field
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    color: Color(0xFF1D7874),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    hintStyle: const TextStyle(
                      color: Colors.black26,
                      fontFamily: 'Poppins',
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey.shade200,
                      ),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF1D7874),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            // Login Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isFormValid ? () {
                  // Handle login
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Wrapper()),
                  );
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D7874),
                  disabledBackgroundColor: Colors.grey[200],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Log in',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: _isFormValid ? Colors.white : Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Forgot Password
            TextButton(
              onPressed: () {
                // Handle forgot password
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignIn()),
                );
              },
              child: const Text(
                'Already have an account? Sign in',
                style: TextStyle(
                  color: Color(0xFF1D7874),
                  fontFamily: 'Poppins',
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}