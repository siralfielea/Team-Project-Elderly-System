
import 'package:flutter/material.dart';
import 'package:team_app/pages/create_account_page.dart';
import '../services/user_dao_service.dart';
import '../pages/home_page.dart';
import '../services/auth_service.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
    const LoginPage({super.key});

    @override
        State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    final userDao = UserDao();

    void _register() async {
    // final auth = context.read<AuthService>();
    Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const CreateAccountPage()),
    );

    }

    void _login() async {
        final auth = context.read<AuthService>();

        try {
            await auth.login(_emailController.text.trim(), _passwordController.text.trim());


            Navigator.push( 
                    context,
                    MaterialPageRoute(builder: (_) => const HomePage()),
                    );
        } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login failed')),
                    );
        }
    }

    @override
        Widget build(BuildContext context) {
            return Scaffold(
                    appBar: AppBar(title: const Text('Login')),
                    body: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                            children: [
                            TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email')),
                            TextField(controller: _passwordController, decoration: const InputDecoration(labelText: 'Password')),
                            const SizedBox(height: 16),
                            ElevatedButton(onPressed: _login, child: const Text('Login')),
                            TextButton(onPressed: _register, child: const Text('Create account')),
                            ],
                            ),
                        ),
                    );
        }
}
