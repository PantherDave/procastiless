import 'package:calendar_appbar/calendar_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:procastiless/components/project/bloc/project_bloc.dart';
import 'package:procastiless/components/project/bloc/project_state.dart';
import 'package:procastiless/components/project/data/project.dart';

class CalendarScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CalendarScreenState();
  }
}

class CalendarScreenState extends State<CalendarScreen> {
  List<Project?> projects = List.empty();
  bool firstLoad = true;
  DateTime? currentDateSelected = DateTime.now();
  late DateTime lastDate = DateTime(DateTime.now().year);
  List<DateTime>? date = List.empty(growable: true);
  @override
  void didChangeDependencies() {
    // TODO: implement initState
    super.didChangeDependencies();
    final projectBloc =
        (BlocProvider.of<ProjectBloc>(context).state) is ProjectZeroState
            ? BlocProvider.of<ProjectBloc>(context).state as ProjectZeroState
            : BlocProvider.of<ProjectBloc>(context).state as ProjectLoadedState;
    if (projectBloc is ProjectLoadedState) {
      date?.addAll(
          projectBloc.projects.map((e) => e!.deadline!.toDate()).toList());
    }
    if (date?.length != 0) {
      date?.sort((a, b) => a.compareTo(b));
      lastDate = date![date!.length - 1];
    } else {
      lastDate = DateTime.now();
    }
    if (ProjectBloc is ProjectLoadedState) {
      (projectBloc as ProjectLoadedState).projects.where((element) {
        var projectDate = element?.deadline?.toDate();
        if ((projectDate?.day == currentDateSelected?.day) &&
                (projectDate?.month == currentDateSelected?.month) ||
            projectDate?.day == lastDate.day &&
                projectDate?.month == lastDate.month) {
          return true;
        } else {
          return false;
        }
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return BlocBuilder<ProjectBloc, ProjectBaseState>(
      builder: (context, state) {
        print(projects);
        return Scaffold(
          backgroundColor: Color(0xff243C51),
          appBar: CalendarAppBar(
            backButton: false,
            accent: Color(0xff243C51),
            firstDate: DateTime.now().subtract(Duration(days: 365)),
            lastDate: lastDate != null ? lastDate : DateTime.now(),
            selectedDate: DateTime.now(),
            events: date,
            onDateChanged: (DateTime? value) {
              setState(() {
                currentDateSelected = value;
                projects =
                    (state as ProjectLoadedState).projects.where((element) {
                  var projectDate = element?.deadline?.toDate();
                  if ((projectDate?.day == value?.day) &&
                      (projectDate?.month == value?.month)) {
                    return true;
                  } else {
                    return false;
                  }
                }).toList();
              });
            },
          ),
          body: Container(
            alignment: Alignment.center,
            // constraints: BoxConstraints.expand(height: 100, width: 100),
            decoration: BoxDecoration(
              color: Color(0xff2d4a63),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                  bottomLeft: Radius.zero,
                  bottomRight: Radius.zero),
            ),
            child: Column(
              children: [
                Expanded(
                  child: projects.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "No projects or task due on this date",
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            CircularProgressIndicator()
                          ],
                        )
                      : ListView.builder(
                          itemCount: projects.length,
                          itemBuilder: (context, i) {
                            print(projects.length);

                            return Container(
                              margin: EdgeInsets.only(top: 20),
                              padding: const EdgeInsets.all(30),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${projects[i]?.name}",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    "${DateFormat.yMMMMEEEEd().format(projects[i]!.deadline!.toDate())}",
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
