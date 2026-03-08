import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_app/pages/login_page.dart';
import 'package:team_app/services/auth_service.dart';

class CreateAccountPage extends StatefulWidget {
const CreateAccountPage({super.key});
@override 
State<CreateAccountPage> createState() => _CreateAccountPageState();
}
class _CreateAccountPageState extends State<CreateAccountPage> {
final _emailCtrl = TextEditingController();
final _pwCtrl = TextEditingController();
final _pwConfirmCtrl = TextEditingController();

bool _emailFormatCheck(String email) {
final emailFormat = RegExp(r'^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$', caseSensitive: false);

return emailFormat.hasMatch(email);
}

bool _checkPasswordMatch(String pw1, String pw2) {
    if(pw1 != pw2) {
    return false;
    }
    else{
    return true;
    }
}

void _createAccount() async {
  final email = _emailCtrl.text.trim();
  final pw1 = _pwCtrl.text.trim();
  final pw2 = _pwConfirmCtrl.text.trim();
  final auth = context.read<AuthService>();

  if (!_emailFormatCheck(email)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please enter a valid email')),
    );
    return;
  }

  if (!_checkPasswordMatch(pw1, pw2)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Passwords do not match')),
    );
    return;
  }

  try {
    await auth.register(email, pw1);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );

  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registration failed')),
    );
  }
}

@override 
void dispose() {
_emailCtrl.dispose();
_pwCtrl.dispose();
_pwConfirmCtrl.dispose();
super.dispose();
}
@override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(title: const Text('Create Account')),
    body: Padding( 
        padding: const EdgeInsets.all(16),
        child: Column(children: [
            TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Email')), 
            TextField(
                controller: _pwCtrl, 
                decoration: const InputDecoration(labelText: 'Password'), 
                obscureText: true,
                ), 
            TextField(
                controller: _pwConfirmCtrl, 
                decoration: const InputDecoration(labelText: 'Confirm Password'), 
                obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _createAccount, child: const Text('Create Account')),
            ],
            ),
    ),
  );
}
}
