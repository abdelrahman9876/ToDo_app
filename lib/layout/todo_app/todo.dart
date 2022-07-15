import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../shared/components/componants.dart';
import '../../shared/components/constants.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';

//1-create datebase
//2-create tables
//3-open datebase
//4-insert to datebase
//5-get from datebase
//6-update in datebase
//7-delet from datebase
class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  //
  // @override
  // void initState() {
  //   super.initState();
  //   createDatabase();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => AppCubit()..createDatabase(),
        child: BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {
            if (state is AppInsertDatabaseState) {
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            AppCubit cubit = AppCubit.get(context);
            return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                title: Text(cubit.titles[cubit.currentindex]),
              ),
              body: ConditionalBuilder(
                condition: state is! AppGetDatabaseLoadingState,
                builder: (context) => cubit.screens[cubit.currentindex],
                fallback: (context) => //فى حالة عدم تحقق الكوندشن
                    Center(child: CircularProgressIndicator()),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (cubit.isBottomSheetShown) {
                    if (formkey.currentState!.validate()) {
                      cubit.insertToDatabase(
                          title: titleController.text,
                          time: timeController.text,
                          date: dateController.text);
                      // insertToDatabase(
                      //     time: timeController.text,
                      //     date: dateController.text,
                      //     title: titleController.text
                      //
                      // ).then((value)
                      // {
                      //   getDataFromDatabase(database).then((value)
                      //   {
                      //     Navigator.pop(context);
                      //     // setState(()
                      //     // {
                      //     //   isBottomSheetShown=false;
                      //     //   fabIcon=Icons.edit;
                      //     //   tasks=value;
                      //     // });
                      //
                      //   });
                      //
                      // });

                    }
                  } else {
                    scaffoldKey.currentState
                        ?.showBottomSheet(
                          (context) => Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(20.0),
                            child: Form(
                              key: formkey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  defaultFormField(
                                      label: 'Task Title',
                                      prefix: Icons.title,
                                      type: TextInputType.text,
                                      controller: titleController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'title must not be empty';
                                        }
                                        return null;
                                      }),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  defaultFormField(
                                      label: 'Task Time',
                                      prefix: Icons.watch_later_outlined,
                                      type: TextInputType.datetime,
                                      controller: timeController,
                                      onTap: () {
                                        showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now())
                                            .then((value) {
                                          timeController.text =
                                              value!.format(context).toString();
                                          print(value.format(context));
                                        });
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'time must not be empty';
                                        }
                                        return null;
                                      }),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  defaultFormField(
                                      label: 'Task Date',
                                      prefix: Icons.calendar_today,
                                      type: TextInputType.datetime,
                                      controller: dateController,
                                      onTap: () {
                                        showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime.parse(
                                                    '2022-06-25'))
                                            .then((value) {
                                          dateController.text =
                                              DateFormat.yMMMd().format(value!);
                                          print(
                                              DateFormat.yMMMd().format(value));
                                        });
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'date must not be empty';
                                        }
                                        return null;
                                      }),
                                ],
                              ),
                            ),
                          ),
                          elevation: 15.0,
                        )
                        .closed
                        .then((value) {
                      cubit.changeBottomSheetState(
                          isShow: false, icon: Icons.edit);
                    });

                    cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                  }
                },
                child: Icon(cubit.fabIcon),
              ),
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: cubit.currentindex,
                onTap: (index) {
                  cubit.ChangeIndex(index);
                  // setState(() {
                  //   currentindex = index;
                  // });
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.menu),
                    label: 'Tasks',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.check_circle_outline,
                    ),
                    label: 'Done',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined),
                    label: 'Archives',
                  )
                ],
              ),
            );
          },
        ));
  }

  // Future<String> getName() async {
  //   return 'Ahmed Ali';
  // }

}
