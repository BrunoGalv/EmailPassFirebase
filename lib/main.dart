import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Firebase Auth',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ChangePass(),
    );
  }
}



// Criar User

class SignUpUser extends StatefulWidget {
  @override
  _SignUpUserState createState() => _SignUpUserState();
}

class _SignUpUserState extends State<SignUpUser> {
  static MediaQueryData _mediaQueryData;
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _pass2Controller = TextEditingController();
  final _formKeyEmail = GlobalKey<FormState>();
  final _formKeyPass = GlobalKey<FormState>();
  final _formKeyPass2 = GlobalKey<FormState>();
  bool passwordVisible = false;
  bool passwordVisible2 = false;
  bool logado = false;

  @override
  Widget build(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    double screenWidth = _mediaQueryData.size.width;
    double screenHeight = _mediaQueryData.size.height;

    if(FirebaseAuth.instance.currentUser != null){
      logado = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Auth"),
        centerTitle: true,
      ),
      body: logado ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Logado!", style: TextStyle(fontSize: 23, color: Theme.of(context).primaryColor),),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Container(
              height: screenHeight * 0.06,
              width: screenWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                gradient: LinearGradient(
                    colors:
                    [Color(0xFF6a7bd9), Color(0xff3f51b5)],
                    begin: Alignment.centerLeft,
                    end: Alignment.bottomRight
                ),
              ),
              child: FlatButton(
                child: Center(child: Text("Sair", style: TextStyle(fontSize: 20, color: Colors.white),)),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut().then((value) {
                    setState(() {
                      logado = false;
                    });
                  }).catchError((e) => print(e.toString()));
                },
              ),
            ),
          ),
        ],
      ) : Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: screenWidth * 0.15,
                child: Form(
                  key: _formKeyEmail,
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                    ),
                    validator: (text){
                      if(text.isEmpty || !text.contains('@'))
                        return 'Email inválido';
                      else{
                        return null;
                      }
                    },
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                height: screenWidth * 0.15,
                child: Form(
                    key: _formKeyPass,
                    child: TextFormField(
                      controller: _passController,
                      keyboardType: TextInputType.text,
                      obscureText: !passwordVisible,
                      validator: (text){
                        if(text.isEmpty || text.length < 6)
                          return 'Senha inválida';
                        else{
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                          labelText: "Senha",
                          labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              // Based on passwordVisible state choose the icon
                              passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: () {
                              // Update the state i.e. toogle the state of passwordVisible variable
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                          )
                      ),
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    )
                ),
              ),
              SizedBox(height: 20,),
              Container(
                height: screenWidth * 0.15,
                child: Form(
                    key: _formKeyPass2,
                    child: TextFormField(
                      controller: _pass2Controller,
                      keyboardType: TextInputType.text,
                      obscureText: !passwordVisible2,
                      validator: (text){
                        if(_passController.text != _pass2Controller.text)
                          return 'As senhas não coincidem';
                        else{
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                          labelText: "Repita a senha",
                          labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              // Based on passwordVisible state choose the icon
                              passwordVisible2
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: () {
                              // Update the state i.e. toogle the state of passwordVisible variable
                              setState(() {
                                passwordVisible2 = !passwordVisible2;
                              });
                            },
                          )
                      ),
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    )
                ),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(),
                child: Container(
                  height: screenHeight * 0.065,
                  width: screenWidth * 0.50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    gradient: LinearGradient(
                        colors:
                        [Color(0xFF6a7bd9), Color(0xff3f51b5)],
                        begin: Alignment.centerLeft,
                        end: Alignment.bottomRight
                    ),
                  ),
                  child: FlatButton(
                    child: Center(child: Text("Cadastrar", style: TextStyle(fontSize: 20, color: Colors.white),)),
                    onPressed: (){
                      if( _formKeyEmail.currentState.validate() && _formKeyPass.currentState.validate() && _formKeyPass2.currentState.validate()) {
                        //SignUp
                        FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailController.text, password: _passController.text).then((value) {
                          print("Registrado com sucesso!");
                          setState(() {
                            logado = true;
                          });
                        }).catchError((e) => print(e.toString()));
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



//Autenticação pelo Email e Senha

class EmailPassPage extends StatefulWidget {
  @override
  _EmailPassPage createState() => _EmailPassPage();
}

class _EmailPassPage extends State<EmailPassPage> {
  static MediaQueryData _mediaQueryData;
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _formKeyEmail = GlobalKey<FormState>();
  final _formKeyPass = GlobalKey<FormState>();
  bool passwordVisible = false;
  bool logado = false;

  @override
  Widget build(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    double screenWidth = _mediaQueryData.size.width;
    double screenHeight = _mediaQueryData.size.height;

    if(FirebaseAuth.instance.currentUser != null){
      logado = true;
    }
    FirebaseAuth auth = FirebaseAuth.instance;

    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Auth"),
        centerTitle: true,
      ),
      body: logado ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Logado!", style: TextStyle(fontSize: 23, color: Theme.of(context).primaryColor),),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Container(
              height: screenHeight * 0.06,
              width: screenWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                gradient: LinearGradient(
                    colors:
                    [Color(0xFF6a7bd9), Color(0xff3f51b5)],
                    begin: Alignment.centerLeft,
                    end: Alignment.bottomRight
                ),
              ),
              child: FlatButton(
                child: Center(child: Text("Sair", style: TextStyle(fontSize: 20, color: Colors.white),)),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut().then((value) {
                    setState(() {
                      logado = false;
                    });
                  });
                },
              ),
            ),
          ),
        ],
      ) : Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      height: screenWidth * 0.15,
                      child: Form(
                        key: _formKeyEmail,
                        child: TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              labelText: "Email",
                              labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                                  borderRadius: BorderRadius.all(Radius.circular(20))
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                                  borderRadius: BorderRadius.all(Radius.circular(20))
                              )
                          ),
                          validator: (text){
                            if(text.isEmpty || !text.contains('@'))
                              return "Email inválido";
                            else{
                              return null;
                            }
                          },
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      height: screenWidth * 0.15,
                      child: Form(
                          key: _formKeyPass,
                          child: TextFormField(
                            controller: _passController,
                            keyboardType: TextInputType.text,
                            obscureText: !passwordVisible,
                            validator: (text){
                              if(text.isEmpty || text.length < 6)
                                return "Preencha o campo";
                              else{
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                                labelText: "Senha",
                                labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Theme.of(context).primaryColor),
                                    borderRadius: BorderRadius.all(Radius.circular(20))
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Theme.of(context).primaryColor),
                                    borderRadius: BorderRadius.all(Radius.circular(20))
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    // Based on passwordVisible state choose the icon
                                    passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  onPressed: () {
                                    // Update the state i.e. toogle the state of passwordVisible variable
                                    setState(() {
                                      passwordVisible = !passwordVisible;
                                    });
                                  },
                                )
                            ),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )
                      ),
                    ),
                    SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.only(),
                      child: Container(
                        height: screenHeight * 0.065,
                        width: screenWidth * 0.50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          gradient: LinearGradient(
                              colors:
                              [Color(0xFF6a7bd9), Color(0xff3f51b5)],
                              begin: Alignment.centerLeft,
                              end: Alignment.bottomRight
                          ),
                        ),
                        child: FlatButton(
                          child: Center(child: Text("Login", style: TextStyle(fontSize: 17, color: Colors.white),)),
                          onPressed: () async {
                            if(_formKeyEmail.currentState.validate() && _formKeyPass.currentState.validate()) {
                              // Login
                              auth.signInWithEmailAndPassword(email: _emailController.text, password: _passController.text).then((value) {
                                print("Logou com sucesso!");
                                setState(() {
                                  logado = true;
                                });
                              }).catchError((e) => print(e.toString()));
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      color: Colors.transparent,
                      alignment: Alignment.center,
                      child: InkWell(
                        child: Text("Esqueceu a senha?", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),),
                        onTap: (){
                          _formKeyPass.currentState.reset();
                          if(_formKeyEmail.currentState.validate()) {
                            // Forgot Pass
                            auth.sendPasswordResetEmail(email: _emailController.text).then((value) {
                              print("Email enviado com sucesso!");
                            }).catchError((e) => print(e.toString()));
                          }
                        },
                      )
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}



// Trocar Senha

class ChangePass extends StatefulWidget {
  @override
  _ChangePassState createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> {
  static MediaQueryData _mediaQueryData;
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _newPassController = TextEditingController();
  final _newPass2Controller = TextEditingController();
  final _formKeyEmail = GlobalKey<FormState>();
  final _formKeyPass = GlobalKey<FormState>();
  final _formKeyNewPass = GlobalKey<FormState>();
  final _formKeyNewPass2 = GlobalKey<FormState>();
  bool passwordVisible = false;
  bool newPasswordVisible = false;
  bool newPasswordVisible2 = false;


  @override
  Widget build(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    double screenWidth = _mediaQueryData.size.width;
    double screenHeight = _mediaQueryData.size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Auth"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: screenWidth * 0.15,
              child: Form(
                  key: _formKeyPass,
                  child: TextFormField(
                    controller: _passController,
                    keyboardType: TextInputType.text,
                    obscureText: !passwordVisible,
                    validator: (text){
                      if(text.isEmpty || text.length < 6)
                        return 'Senha inválida';
                      else{
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        labelText: "Senha Atual",
                        labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: () {
                            // Update the state i.e. toogle the state of passwordVisible variable
                            setState(() {
                              passwordVisible = !passwordVisible;
                            });
                          },
                        )
                    ),
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  )
              ),
            ),
            SizedBox(height: 20,),
            Container(
              height: screenWidth * 0.15,
              child: Form(
                  key: _formKeyNewPass,
                  child: TextFormField(
                    controller: _newPassController,
                    keyboardType: TextInputType.text,
                    obscureText: !newPasswordVisible,
                    validator: (text){
                      if(text.isEmpty || text.length < 6)
                        return "Senha inválida";
                      else{
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        labelText: "Nova Senha",
                        labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            newPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: () {
                            // Update the state i.e. toogle the state of passwordVisible variable
                            setState(() {
                              newPasswordVisible = !newPasswordVisible;
                            });
                          },
                        )
                    ),
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  )
              ),
            ),
            SizedBox(height: 20,),
            Container(
              height: screenWidth * 0.15,
              child: Form(
                  key: _formKeyNewPass2,
                  child: TextFormField(
                    controller: _newPass2Controller,
                    keyboardType: TextInputType.text,
                    obscureText: !newPasswordVisible2,
                    validator: (text){
                      if((text.isEmpty || text.length < 6) || _newPassController.text != _newPass2Controller.text)
                        return 'As senhas não coincidem';
                      else{
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        labelText: "Repita a nova senha",
                        labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            newPasswordVisible2
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: () {
                            // Update the state i.e. toogle the state of passwordVisible variable
                            setState(() {
                              newPasswordVisible2 = !newPasswordVisible2;
                            });
                          },
                        )
                    ),
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  )
              ),
            ),
            SizedBox(height: 20,),
            Container(
              height: screenHeight * 0.065,
              width: screenWidth * 0.50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                gradient: LinearGradient(
                    colors:
                    [Color(0xFF6a7bd9), Color(0xff3f51b5)],
                    begin: Alignment.centerLeft,
                    end: Alignment.bottomRight
                ),
              ),
              child: FlatButton(
                onPressed: (){
                  if(_formKeyPass.currentState.validate() && _formKeyNewPass.currentState.validate() && _formKeyNewPass2.currentState.validate()){
                    // Att Senha
                    User user = FirebaseAuth.instance.currentUser;
                    AuthCredential credential = EmailAuthProvider.credential(email: user.email, password: _passController.text);
                    user.reauthenticateWithCredential(credential).then((value) {
                      user.updatePassword(_newPassController.text).then((value) => print("Senha atualizada com sucesso!")).catchError((e) => print(e.toString()));
                    }).catchError((e) => print(e.toString()));
                  }
                },
                child: Text("Atualizar", style: TextStyle(fontSize: 20, color: Colors.white),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



//Autenticação pelo número de celular

class PhoneAuthPage extends StatefulWidget {
  @override
  _PhoneAuthPageState createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  static MediaQueryData _mediaQueryData;
  PhoneNumber number = PhoneNumber(isoCode: 'BR');
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  final _formKeyPhone = GlobalKey<FormState>();
  final _formKeyCode = GlobalKey<FormState>();
  String warningText = '', verificationId = '';
  bool logado = false;

  @override
  Widget build(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    double screenWidth = _mediaQueryData.size.width;
    double screenHeight = _mediaQueryData.size.height;
    String verification_expired = 'Expirou o tempo da verificação!\nReenviar código';

    Future<String> getPhoneNumber(String phoneNumber) async {
      PhoneNumber number =
      await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, this.number.isoCode);
      return number.phoneNumber;
    }

    void signPhone(String phone){
      // Login with Phone
      FirebaseAuth.instance.verifyPhoneNumber(phoneNumber: phone, verificationCompleted: (AuthCredential credential){
        FirebaseAuth.instance.signInWithCredential(credential).then((value) {
          setState(() {
            logado = true;
          });
        }).catchError((e) => print(e.toString()));
      }, verificationFailed: (e){
        print(e.toString());
      }, codeSent: (String code, [int forceResendingToken]){
        print("Codigo enviado!");
        setState(() {
          this.verificationId = code;
        });
      }, codeAutoRetrievalTimeout: (string){
        setState(() {
          warningText = verification_expired;
        });
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Auth"),
        centerTitle: true,
      ),
      body: logado ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Logado!", style: TextStyle(fontSize: 23, color: Theme.of(context).primaryColor),),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Container(
              height: screenHeight * 0.06,
              width: screenWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                gradient: LinearGradient(
                    colors:
                    [Color(0xFF6a7bd9), Color(0xff3f51b5)],
                    begin: Alignment.centerLeft,
                    end: Alignment.bottomRight
                ),
              ),
              child: FlatButton(
                child: Center(child: Text("Sair", style: TextStyle(fontSize: 20, color: Colors.white),)),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut().then((value) {
                    setState(() {
                      logado = false;
                    });
                  });
                },
              ),
            ),
          ),
        ],
      ) : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    height: screenHeight * 0.04,
                    child: Text(verificationId != '' ? "Insira o código" : "Insira seu número de celular", style: TextStyle(fontSize: 23, color: Theme.of(context).primaryColor),)
                ),
                SizedBox(
                  height: 20,
                ),
                verificationId != '' ? Container(
                  height: screenWidth * 0.15,
                  child: Form(
                    key: _formKeyCode,
                    child: TextFormField(
                      controller: _codeController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Código",
                          labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.all(Radius.circular(20))
                          )
                      ),
                      validator: (text){
                        if(text.isEmpty)
                          return "Insira o código";
                        else{
                          return null;
                        }
                      },
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ) : Container(
                  height: screenWidth * 0.15,
                  child: Form(
                    key: _formKeyPhone,
                    child: InternationalPhoneNumberInput(
                      onInputChanged: (PhoneNumber number) {
                        if(this.number.isoCode != number.isoCode) {
                          setState(() {
                            this.number = number;
                          });
                        }
                      },
                      ignoreBlank: false,
                      autoValidate: false,
                      selectorTextStyle: TextStyle(color: Colors.black),
                      initialValue: number,
                      textFieldController: _phoneController,
                      inputDecoration: InputDecoration(
                          labelText: verificationId != '' ? "Código" : "Número do celular",
                          labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.all(Radius.circular(20))
                          )
                      ),
                      errorMessage: "O número tem formato inválido",
                      selectorType: PhoneInputSelectorType.DIALOG,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(),
                  child: Container(
                    height: screenHeight * 0.06,
                    width: screenWidth * 0.50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      gradient: LinearGradient(
                          colors:
                          [Color(0xFF6a7bd9), Color(0xff3f51b5)],
                          begin: Alignment.centerLeft,
                          end: Alignment.bottomRight
                      ),
                    ),
                    child: FlatButton(
                      child: Center(child: Text("Avançar", style: TextStyle(fontSize: 20, color: Colors.white),)),
                      onPressed: () async {
                        if(verificationId == ''){
                          if(_formKeyPhone.currentState.validate()) {
                            getPhoneNumber(_phoneController.text).then((value) {
                              signPhone(value);
                            });
                          }
                        }else{
                          // Verificar Codigo
                          AuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: _codeController.text);
                          FirebaseAuth.instance.signInWithCredential(credential).then((value) {
                            setState(() {
                              logado = true;
                            });
                          }).catchError((e) => print(e.toString()));
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
              alignment: Alignment.center,
              height: warningText.isEmpty ? 0 : screenHeight * 0.06,
              child: InkWell(
                onTap: (){
                  if(warningText == verification_expired) {
                    setState(() {
                      warningText = 'Codigo reenviado';
                    });
                    getPhoneNumber(_phoneController.text).then((value) {
                      signPhone(value);
                    });
                  }
                },
                child: Text(warningText, style: TextStyle(fontSize: 20, color: Colors.red), textAlign: TextAlign.center,),
              )
          ),
        ],
      ),
    );
  }
}

