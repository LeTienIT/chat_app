import 'package:chat_app/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatefulWidget{
  const RegisterPage({super.key});
  @override
  State<StatefulWidget> createState() {
    return _RegisterPage();
  }
}
class _RegisterPage extends State<RegisterPage> with SingleTickerProviderStateMixin{
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _fullName = TextEditingController();

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  bool hidePass = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1)
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut)
    );

    _controller.forward();

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
        builder: (context, state){
          if(state is AuthLoading){
            return Scaffold(
              body: const Center(child: CircularProgressIndicator(),),
            );
          }
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade50, Colors.green],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                            "Đăng ký tài khoản",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  offset: Offset(2, 2),
                                  blurRadius: 2
                                )
                              ]
                            ),
                        ),
                        const SizedBox(height: 20,),
                        TextFormField(
                          controller: _email,
                          decoration: InputDecoration(
                            label: const Text("Nhập email"),
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value){
                            if(value == null || value.isEmpty){
                              return "Email không được để trống";
                            }
                            final emailRegex = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
                            );

                            if (!emailRegex.hasMatch(value)) {
                              return "Email không hợp lệ";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10,),
                        TextFormField(
                          controller: _fullName,
                          decoration: InputDecoration(
                            label: const Text("Nhập tên hiển thị"),
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value){
                            if(value == null || value.isEmpty){
                              return "Tên không được để trống";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10,),
                        TextFormField(
                          controller: _pass,
                          obscureText: hidePass,
                          decoration: InputDecoration(
                              label: const Text("Nhâp mật khẩu"),
                              prefixIcon: const Icon(Icons.password),
                              suffixIcon: IconButton(
                                  onPressed: (){
                                    setState(() {
                                      hidePass = !hidePass;
                                    });
                                  },
                                  icon: Icon(hidePass ? Icons.visibility : Icons.visibility_off)
                              ),
                              border: OutlineInputBorder()
                          ),
                          validator: (value){
                            if(value == null || value.isEmpty || value.length <= 6){
                              return "Mật khẩu không được trống và dài hơn 6 k tự";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10,),
                        ElevatedButton.icon(
                            onPressed: (){
                              if(_formKey.currentState!.validate()){
                                context.read<AuthBloc>().add(RegisterEvent(_email.text, _fullName.text, _pass.text));
                              }
                            },
                            label: const Text("Đăng ký tài khoản"),
                            icon: const Icon(Icons.add),
                            style: ElevatedButton.styleFrom(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadiusGeometry.circular(12)
                                )
                            ),
                        ),
                        const SizedBox(height: 10,),
                        TextButton(
                            onPressed: (){
                              context.go('/login');
                            },
                            child: const Text("Tôi đã có tài khoản")
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        listener: (context, state){
          if(state is AuthError){
            showDialog(
                context: context,
                builder: (context){
                  return AlertDialog(
                    title: const Text("Lỗi"),
                    content: Text(state.message),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("Đóng")
                      )
                    ],
                  );
                }
            );
          }
          if(state is AuthAuthenticated){
            showDialog(
                context: context,
                builder: (context){
                  return AlertDialog(
                    title: const Text("Xong"),
                    content: Text("Đăng ký thành công"),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("Đóng")
                      )
                    ],
                  );
                }
            );
          }
        }
    );
  }

}