import 'package:chat_app/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginPage();
  }

}

class _LoginPage extends State<LoginPage> with SingleTickerProviderStateMixin{
  final _form = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  bool hidePass = true;
  
  
  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut)
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
            return const Scaffold(
              body: Center(child: CircularProgressIndicator(),),
            );
          }
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.blue.shade50, Colors.green]
                ),
                boxShadow: [
                  BoxShadow(color: Colors.grey.shade200, blurRadius: 10),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                child:  FadeTransition(
                  opacity: _fadeAnimation,
                  child: Form(
                    key: _form,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Đăng nhập",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                offset: Offset(2, 2),
                                blurRadius: 3
                              )
                            ]
                          ),
                        ),
                        const SizedBox(height: 20,),
                        TextFormField(
                          controller: _email,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            label: const Text("Nhập email"),
                            prefixIcon:const Icon(Icons.email),
                            border: OutlineInputBorder()
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
                              if(_form.currentState!.validate()){
                                context.read<AuthBloc>().add(LoginEvent(_email.text, _pass.text));
                              }
                            },
                            label: const Text("Đăng nhập"),
                            icon: const Icon(Icons.login),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(10)),
                              elevation: 4
                            ),
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton.icon(
                                onPressed: (){
                                  context.go('/register');
                                },
                                icon: const Icon(Icons.app_registration),
                                label: const Text("Đăng ký"),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  textStyle: TextStyle(fontSize: 18)
                                ),
                            ),
                            TextButton.icon(
                              onPressed: (){},
                              icon: const Icon(Icons.lock_reset),
                              label: const Text("Quên mật khẩu"),
                              style: TextButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  textStyle: TextStyle(fontSize: 18)
                              ),
                            )
                          ],
                        ),
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
            // showDialog(
            //     context: context,
            //     builder: (context){
            //       return AlertDialog(
            //         title: const Text("Xong"),
            //         content: Text("Đăng nhập thành công: ${state.user.displayName}"),
            //         actions: [
            //           TextButton(
            //               onPressed: () => Navigator.of(context).pop(),
            //               child: const Text("Đóng")
            //           )
            //         ],
            //       );
            //     }
            // );
            context.go("/groups");
          }
        }
    );
  }

}