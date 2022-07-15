import 'package:application1/shared/cubit/cubit.dart';
import 'package:application1/shared/cubit/states.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/components/componants.dart';

class NewTasksScreen extends StatelessWidget {
  const NewTasksScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer <AppCubit,AppStates>(
      listener:(context,state) {} ,
          builder: (context,state)
          {
            var tasks=AppCubit.get(context).newTasks;
           return tasksBuilder(
             tasks: tasks
           );
          },
    );
  }
}
