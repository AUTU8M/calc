import 'package:calculator/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String input = "0";
  final List<String> buttons = [
    'C',
    '±',
    '%',
    '÷',
    '7',
    '8',
    '9',
    'x',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    'ce',
    '0',
    '.',
    '=',
  ];

  void _onButtonPressed(String buttontext) {
    setState(() {
      if (buttontext == "C") {
        input = "0"; //clear everything
      } else if (buttontext == "ce") {
        input = input.length > 1 ? input.substring(0, input.length - 1) : "0";
      } else if (buttontext == "%") {
        // Convert number to percentage
        if (input.isNotEmpty) {
          double num = double.tryParse(input) ?? 0;
          input = (num / 100).toString();
        }
      } else if (buttontext == "±") {
        //toggle sign
        if (input.startsWith("-")) {
          input = input.substring(1);
        } else if (input != "0") {
          input = "-$input";
        }
      } else if (buttontext == "=") {
        _calculateResult();
      } else {
        //prevent duplicate operators
        if (["+", "-", "÷", "x"].contains(buttontext) &&
            ["+", "-", "÷", "x"].contains(input[input.length - 1])) {
          return;
        }
        if (input == "0") {
          input = buttontext;
        } else {
          input += buttontext;
        }
      }
    });
  }

  void _calculateResult() {
    try {
      String expression = input.replaceAll('×', '*').replaceAll('÷', '/');
      double result = _evaluateExpression(expression);
      setState(() {
        input = result.toString();
      });
    } catch (e) {
      setState(() {
        input = "Error";
      });
    }
  }

  double _evaluateExpression(String expression) {
    try {
      final parser = ShuntingYardParser(); // Use the new parser
      final exp = parser.parse(expression);
      final contextModel = ContextModel();
      return exp.evaluate(EvaluationType.REAL, contextModel);
    } catch (e) {
      return double.nan; // Return NaN if an error occurs
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(115, 65, 63, 63),
      body: Column(
        children: [
          //display section
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.all(20),
              child: Text(
                input,
                style: TextStyle(fontSize: 48, color: Colors.white),
              ),
            ),
          ),
          Expanded(
            //this is the calculator section
            flex: 3,
            child: GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 1.3,
              ),
              itemCount: buttons.length,
              itemBuilder: (context, index) {
                //assign colors based on button type
                bool isOperator = [
                  '+',
                  '÷',
                  'x',
                  '-',
                  '=',
                ].contains(buttons[index]);

                bool isSpecial = ['C', '±', '%'].contains(buttons[index]);
                return CalcButton(
                  label: buttons[index],
                  color:
                      isOperator
                          ? Colors.orange
                          : isSpecial
                          ? Colors.grey
                          : Colors.grey[800]!,
                  textColor: Colors.white,
                  onTap: () {
                    setState(() {
                      _onButtonPressed(buttons[index]);
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
