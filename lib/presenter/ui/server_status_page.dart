import 'package:flutter/material.dart';
import 'package:flutter_base_rootstrap/devices/permissions/abstract/permission_manager.dart';
import 'package:flutter_base_rootstrap/devices/platform/abstract/platform_info.dart';
import 'package:flutter_base_rootstrap/domain/services/abstract/service_class.dart';
import 'package:flutter_base_rootstrap/presenter/resources/resources.dart';
import 'package:flutter_base_rootstrap/utils/data_state.dart';
import 'package:flutter_base_rootstrap/utils/globals.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServerStatusPage extends StatelessWidget {
  ServiceExample get _service => getIt();
  PermissionManager get _permissions => getIt();

  PlatformInfo get _platform => getIt();

  const ServerStatusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        //ExampleWithBloc
        Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: spacing.l),
              child: Text(
                _platform.isWeb
                    ? "Web"
                    : _platform.isAppOS
                        ? "Mobile"
                        : "Desktop",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32.0),
              child: BlocProvider(
                create: (_) => _service.blocServerStatus,
                child: BlocBuilder<Cubit<Data<bool>>, Data<bool>>(
                  builder: (context, data) {
                    return (data.isLoading)
                        ? const SizedBox(
                            width: 32.0,
                            height: 32.0,
                            child: CircularProgressIndicator(),
                          )
                        : Text(
                            data.isInitial ? '' : data.data.toString(),
                            style: Theme.of(context).textTheme.headline4,
                          );
                  },
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                //Example
                _permissions.requestCameraPermission();
                //_service.checkState();
              },
              child: const Text("Check Server Status"),
            ),
          ],
        ),
      ],
    );
  }
}
