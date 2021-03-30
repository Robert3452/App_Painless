import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:painless_app/bloc/phrase/phrase_bloc.dart';
import 'package:painless_app/bloc/phrase/phrase_logic.dart';
import 'package:painless_app/constants.dart';
import 'package:painless_app/screens/register/register.dart';
import 'package:painless_app/screens/signin/signin.dart';
import 'package:painless_app/size_config.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Map<String, dynamic>> _phrases = [];
  List<Map<String, dynamic>> _posPhrases = [];
  List<Map<String, dynamic>> _negPhrases = [];
  bool loading = true;
  int numbPositive;
  int numbNegative;
  PhraseBloc _phraseBloc = PhraseBloc(phraseLogic: HttpPhraseLogic());

  @override
  void initState() {
    loading = true;
    super.initState();
    _phraseBloc.add(GetPhrase());
  }

  void toggleAdvice() {
    String message = "Debe inicar sesión primero";
    String title = "Inicie sesión";

    List<Widget> signInAdvice = [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text('Home'),
      ),
      TextButton(
        onPressed: () {
          Navigator.of(context).pushNamed(Signin.routeName);
        },
        child: Text('Iniciar sesión'),
      ),
    ];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: signInAdvice,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PhraseBloc(phraseLogic: HttpPhraseLogic()),
      child: BlocListener(
        cubit: _phraseBloc,
        listener: (context, state) {
          if (state is GotPhrases) {
            setState(() {
              _phrases = state.phrases;
              for (Map<String, dynamic> phrase in _phrases) {
                if (phrase['classified_as'])
                  _posPhrases.add(phrase);
                else
                  _negPhrases.add(phrase);
              }
              numbPositive = _posPhrases.length;
              numbNegative = _negPhrases.length;
              loading = false;
            });
          }
          if (state is PhraseException) {
            toggleAdvice();
          }
        },
        child: Expanded(
          flex: 3,
          child: loading
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    DashboardItem(
                      type: false,
                      qty: numbNegative,
                      phrase: _negPhrases,
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.03),
                    DashboardItem(
                      type: true,
                      qty: numbPositive,
                      phrase: _posPhrases,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class DashboardItem extends StatelessWidget {
  final int qty;
  final bool type;
  final List<Map<String, dynamic>> phrase;

  const DashboardItem({
    Key key,
    this.qty,
    this.type,
    this.phrase,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: InkWell(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(40)),
          child: Container(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(30),
                  vertical: getProportionateScreenHeight(20)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Frases ${type ? "positivas" : "negativas"}",
                        style: TextStyle(
                            fontSize: getProportionateScreenWidth(18)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.04,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$qty',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: getProportionateScreenWidth(50)),
                      ),
                    ],
                  )
                ],
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: kbtnRed,
            ),
          ),
        ),
      ),
    );
  }
}
