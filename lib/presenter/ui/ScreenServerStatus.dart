import 'package:flutter/material.dart';
import 'package:flutter_base_rootstrap/domain/services/abstract/service_class.dart';
import 'package:flutter_base_rootstrap/utils/data_state.dart';
import 'package:flutter_base_rootstrap/utils/globals.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServerStatus extends StatelessWidget {
  ServiceExample get _service => getIt();

  const ServerStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        //ExampleWithBloc
        Column(
          children: [
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
                            data.data.toString(),
                            style: Theme.of(context).textTheme.headline4,
                          );
                  },
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _service.checkState();
              },
              child: Text("Check Status Bloc"),
            ),
          ],
        ),
      ],
    );
  }
}
