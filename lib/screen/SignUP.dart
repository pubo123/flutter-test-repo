import 'package:flutter/material.dart';
import 'package:first_project/const/colors.dart';
import 'package:first_project/data/auth_data.dart';

class SignUp_Screen extends StatefulWidget {
  final VoidCallback show;
  const SignUp_Screen(this.show, {super.key});

  @override
  State<SignUp_Screen> createState() => _SignUp_ScreenState();
}

class _SignUp_ScreenState extends State<SignUp_Screen> {
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController passwordConfirm = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  final Color backgroundColors = Colors.grey[200]!;

  @override
  void dispose() {
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    email.dispose();
    password.dispose();
    passwordConfirm.dispose();
    super.dispose();
  }

  void _handleSignUp() async {
    final String emailText = email.text.trim();
    final String passText = password.text.trim();
    final String confirmText = passwordConfirm.text.trim();

    if (passText != confirmText) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❗ Passwords do not match")),
      );
      return;
    }

    try {
      await AuthenticationRemote().register(emailText, passText, confirmText);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Account created successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColors,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildImage(),
              const SizedBox(height: 50),
              _buildTextField(email, _focusNode1, 'Email', Icons.email),
              const SizedBox(height: 10),
              _buildTextField(password, _focusNode2, 'Password', Icons.lock, obscure: _obscurePassword, toggle: () {
                setState(() => _obscurePassword = !_obscurePassword);
              }),
              const SizedBox(height: 10),
              _buildTextField(passwordConfirm, _focusNode3, 'Confirm Password', Icons.lock_outline, obscure: _obscureConfirm, toggle: () {
                setState(() => _obscureConfirm = !_obscureConfirm);
              }),
              const SizedBox(height: 8),
              _buildAccountSwitch(),
              const SizedBox(height: 20),
              _buildSignUpButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountSwitch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text("Already have an account?", style: TextStyle(color: Colors.grey[700], fontSize: 14)),
          const SizedBox(width: 5),
          GestureDetector(
            onTap: widget.show,
            child: const Text(
              'Login',
              style: TextStyle(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSignUpButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: GestureDetector(
        onTap: _handleSignUp,
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: custom_green,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text(
            'Sign Up',
            style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    FocusNode focusNode,
    String hint,
    IconData icon, {
    bool obscure = false,
    VoidCallback? toggle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          obscureText: obscure,
          style: const TextStyle(fontSize: 18, color: Colors.black),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: focusNode.hasFocus ? custom_green : const Color(0xffc5c5c5)),
            suffixIcon: toggle != null
                ? IconButton(
                    icon: Icon(
                      obscure ? Icons.visibility_off : Icons.visibility,
                      color: Colors.black,
                    ),
                    onPressed: toggle,
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            hintText: hint,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xffc5c5c5), width: 2.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: custom_green, width: 2.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        width: double.infinity,
        height: 300,
        decoration: BoxDecoration(
          color: backgroundColors,
          image: const DecorationImage(
            image: AssetImage('images/2.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
