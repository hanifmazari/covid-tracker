// ignore_for_file: must_be_immutable

import 'package:covid_tracker/Model/worldstatModal.dart';
import 'package:covid_tracker/Services/stateServices.dart';
import 'package:covid_tracker/View/countries_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';


class WorldStatesScreen extends StatefulWidget {
  const WorldStatesScreen({Key? key}) : super(key: key);

  @override
  State<WorldStatesScreen> createState() => _WorldStatesScreenState();
}

class _WorldStatesScreenState extends State<WorldStatesScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(duration: const Duration(seconds: 3), vsync: this)
        ..repeat();

  final colorList = <Color>[
    const Color(0xff4285F4),
    const Color(0xff1aa260),
    const Color(0xffde5246)
  ];

  @override
  void dispose() {
    
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    StatesServices statesServices = StatesServices();
    return Scaffold(
      body: SafeArea(
          child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            FutureBuilder(
                future: statesServices.fetchWorldStatesRecord(),
                builder: ((context, AsyncSnapshot<WorldStatModel> snapshot) {
                  if (!snapshot.hasData) {
                    return Expanded(
                        flex: 1,
                        child: SpinKitFadingCircle(
                          color: Colors.white,
                          size: 50,
                          controller: _controller,
                        ));
                  } else {
                    return Column(
                      children: [
                        PieChart(
                          dataMap: {
                            "Total": double.parse(snapshot.data!.cases.toString()),
                            
                            "Recovered": double.parse(snapshot.data!.recovered.toString()),
                            "Deaths": double.parse(snapshot.data!.deaths.toString()),
                          },
                          chartValuesOptions:const ChartValuesOptions(
                            showChartValuesInPercentage: true
                          ),
                          chartRadius: MediaQuery.of(context).size.width / 3.2,
                          legendOptions: const LegendOptions(
                              legendPosition: LegendPosition.left),
                          animationDuration: const Duration(microseconds: 1200),
                          chartType: ChartType.ring,
                          colorList: colorList,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height * 0.06,
                          ),
                          child: Card(
                            child: Column(
                              children: [
                                ReuseableRow(title: "Total", value: snapshot.data!.cases.toString()),
                                ReuseableRow(title: "Recovered", value: snapshot.data!.recovered.toString()),
                                ReuseableRow(title: "Deaths", value: snapshot.data!.deaths.toString()),
                                ReuseableRow(title: "Active", value: snapshot.data!.active.toString()),
                                ReuseableRow(title: "Critical", value: snapshot.data!.critical.toString()),
                                ReuseableRow(title: "Today Deaths", value: snapshot.data!.todayDeaths.toString()),
                                ReuseableRow(title: "Today Recovered", value: snapshot.data!.todayRecovered.toString())
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context, 
                              MaterialPageRoute(
                                builder: (context)=>const CountriesListScreen()));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color(0xff1aa260),
                                borderRadius: BorderRadius.circular(10)),
                            height: 50,
                            child: const Center(
                              child: Text('Track Countries'),
                            ),
                          ),
                        )
                      ],
                    );
                  }
                })),
          ],
                ),
              )),
    );
  }
}

class ReuseableRow extends StatelessWidget {
  String title, value;
  ReuseableRow({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(title), Text(value)],
          ),
          const SizedBox(
            height: 5,
          ),
          const Divider()
        ],
      ),
    );
  }
}
