import 'package:cartzen/controllers/navigation/navigation_bloc.dart';
import 'package:cartzen/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DefaultBackButton extends StatelessWidget {
  const DefaultBackButton({
    Key? key,
    this.isBack = false,
  }) : super(key: key);
  final bool isBack;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 32,
      left: 16,
      child: IconButton(
        icon: const Icon(
          Icons.arrow_back_outlined,
          size: 36,
        ),
        onPressed: () {
          if (isBack) {
            Navigator.of(context).pop();
          } else {
            BlocProvider.of<NavigationBloc>(context)
                .add(ChnangePage(pageIndex: previousIndex));
          }
        },
      ),
    );
  }
}
