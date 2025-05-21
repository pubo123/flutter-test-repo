import 'package:flutter/material.dart';
import 'package:first_project/const/colors.dart';
import 'package:first_project/data/auth_data.dart';

class LogIN_Screen extends StatefulWidget {
  final VoidCallback show;
  const LogIN_Screen(this.show, {super.key});

  @override
  State<LogIN_Screen> createState() => _LogIN_ScreenState();
}

class _LogIN_ScreenState extends State<LogIN_Screen> {
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  final Color backgroundColors = Colors.grey[200]!;

  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _focusNode1.addListener(() => setState(() {}));
    _focusNode2.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focusNode1.dispose();
    _focusNode2.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
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
              _buildTextField(password, _focusNode2, 'Password', Icons.lock, obscure: _obscurePassword, isPasswordField: true),
              const SizedBox(height: 8),
              _buildAccountSwitch(),
              const SizedBox(height: 20),
              _buildLoginButton(),
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
          Text("Don't have an account?", style: TextStyle(color: Colors.grey[700], fontSize: 14)),
          const SizedBox(width: 5),
          GestureDetector(
            onTap: widget.show,
            child: const Text(
              'Sign UP',
              style: TextStyle(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLoginButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: GestureDetector(
        onTap: () {
          AuthenticationRemote().login(email.text.trim(), password.text.trim(),);
        },
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: custom_green,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text(
            'Log In',
            style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, FocusNode focusNode,
      String hint, IconData icon,
      {bool obscure = false, bool isPasswordField = false}) {
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
            suffixIcon: isPasswordField
                ? IconButton(
                    icon: Icon(
                      obscure ? Icons.visibility_off : Icons.visibility,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
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
            image: AssetImage('images/1.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
