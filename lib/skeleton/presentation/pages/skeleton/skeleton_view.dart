import 'package:flutter/material.dart';
import 'package:flutter_base_rootstrap/devices/platform/abstract/platform_info.dart';
import 'package:flutter_base_rootstrap/presenter/resources/spacing_on_widget.dart';
import 'package:flutter_base_rootstrap/skeleton/presentation/bloc/skeleton/skeleton_cubit.dart';
import 'package:flutter_base_rootstrap/utils/cubit_status.dart';
import 'package:flutter_base_rootstrap/utils/globals.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SkeletonView extends StatelessWidget {
  PlatformInfo get _platform => getIt();

  const SkeletonView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                Text(
                  'Platform: ${_platform.isWeb ? "Web" : _platform.isAppOS ? "Mobile" : "Desktop"}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: spacing.xxxxl),
                  child: BlocBuilder<SkeletonCubit, SkeletonState>(
                    builder: (context, state) {
                      switch (state.status) {
                        case CubitStatus.initial:
                          return const SizedBox.shrink();
                        case CubitStatus.loading:
                          return const CircularProgressIndicator();
                        case CubitStatus.success:
                          return Text(
                            'Server Status: ${state.isOnline ? "Online" : "Offline"}',
                            style: Theme.of(context).textTheme.headline4,
                          );
                        case CubitStatus.error:
                          return Text(
                            'Error',
                            style: Theme.of(context).textTheme.headline4,
                          );
                      }
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<SkeletonCubit>().checkServerStatus();
                  },
                  child: const Text("Check Server Status"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
