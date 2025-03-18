import 'package:calculator/test.dart';
import 'package:flutter/material.dart';

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
    '×',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    '↻',
    '0',
    '.',
    '=',
  ];
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
                  '×',
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
                      input += buttons[index];
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
