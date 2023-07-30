import 'dart:math';

import 'package:flutter/material.dart';
import '../models/http_exception.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

enum AuthMode { signUp, login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  const Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: SizedBox(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20.0),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 94.0),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      // ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'MyShop',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 50,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: const AuthCard(),
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

class AuthCard extends StatefulWidget {
  const AuthCard({super.key});

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.login;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  late AnimationController _controller;
  late Animation<Size> _heightAnimation;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _heightAnimation = Tween<Size>(
            begin: const Size(
              double.infinity,
              260,
            ),
            end: const Size(double.infinity, 320))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
    //_heightAnimation.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _showErrorDialogue(String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('An Error Occurred!'),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Close'))
              ],
            ));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false)
            .logIn(_authData['email']!, _authData['password']!);
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false)
            .signUp(_authData['email']!, _authData['password']!);
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication Failed';
      if (error.message.contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.message.contains('INVALID_EMAIL')) {
        errorMessage = 'Email is Invalid';
      } else if (error.message.contains('WEAK_PASSWORD')) {
        errorMessage = 'Your password is weak';
      } else if (error.message.contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find the user with that email';
      } else if (error.message.contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid Password';
      }
      _showErrorDialogue(errorMessage);
    } catch (error) {
      var errorMessage = error.toString();
      _showErrorDialogue(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signUp;
        _controller.forward();
      });
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: AnimatedContainer(
            height: _authMode == AuthMode.signUp ? 320 : 260,
            //height: _heightAnimation.value.height,
            constraints:
                BoxConstraints(minHeight: _authMode == AuthMode.signUp ? 320 : 260),
            width: deviceSize.width * 0.75,
            padding: const EdgeInsets.all(16.0),
            curve: Curves.easeIn,
            duration: const Duration(milliseconds: 300),
            child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value!;
                  },
                ),
                if (_authMode == AuthMode.signUp)
                  TextFormField(
                    enabled: _authMode == AuthMode.signUp,
                    decoration:
                        const InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: _authMode == AuthMode.signUp
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match!';
                            }
                            return null;
                          }
                        : null,
                  ),
                const SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      foregroundColor:
                          Theme.of(context).primaryTextTheme.labelLarge?.color,
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 8.0),
                    ),
                    child:
                        Text(_authMode == AuthMode.login ? 'LOGIN' : 'SIGN UP'),
                  ),
                TextButton(
                  onPressed: _switchAuthMode,
                  style: TextButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 6),
                  ),
                  child: Text(
                      '${_authMode == AuthMode.login ? 'SIGNUP' : 'LOGIN'} INSTEAD',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}