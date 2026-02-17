import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/app_theme.dart';

class PhoneAuthScreen extends StatefulWidget {
  final String role;

  const PhoneAuthScreen({
    super.key,
    required this.role,
  });

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isSendingOTP = false;
  bool _showOTPField = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phone Authentication')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Verify Your Phone',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  
                  // Name Field
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      hintText: 'Enter your name',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Phone Number Field
                  TextField(
                    controller: _phoneController,
                    enabled: !_showOTPField,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      hintText: '+1 (555) 000-0000',
                      prefixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 24),

                  // Send OTP Button
                  if (!_showOTPField)
                    ElevatedButton(
                      onPressed: authProvider.isLoading ? null : _sendOTP,
                      child: authProvider.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Send OTP'),
                    ),

                  // OTP Field
                  if (_showOTPField) ...[
                    TextField(
                      controller: _otpController,
                      decoration: InputDecoration(
                        labelText: 'OTP Code',
                        hintText: '000000',
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: authProvider.isLoading ? null : _verifyOTP,
                      child: authProvider.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Verify OTP'),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Error Message
                  if (authProvider.error != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red[200]!),
                      ),
                      child: Text(
                        authProvider.error!,
                        style: TextStyle(color: Colors.red[700]),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _sendOTP() {
    if (_phoneController.text.isEmpty || _nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter phone and name')),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    authProvider.signInWithPhone(
      phoneNumber: _phoneController.text,
      onCodeSent: (verificationId) {
        setState(() => _showOTPField = true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP sent!')),
        );
      },
      onError: (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: Colors.red),
        );
      },
      onVerificationComplete: (credential) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Auto-verified!')),
        );
      },
    );
  }

  void _verifyOTP() {
    if (_otpController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter OTP')),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    authProvider.verifyOTP(
      otp: _otpController.text,
      name: _nameController.text,
      role: widget.role,
    ).then((success) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verified!')),
        );
        Navigator.pop(context);
      }
    });
  }
}
