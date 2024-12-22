import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_gpt/presentation/blocs/model/model_bloc.dart';
import 'package:flutter_chat_gpt/presentation/widgets/text_widget.dart';
import '../../constants/constants.dart';

class ModelDropdown extends StatelessWidget {
  const ModelDropdown({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ModelBloc>().state;
    return DropdownButton<String>(
      dropdownColor: scaffoldBackgroundColor,
      iconEnabledColor: Colors.white,
      value: state.currentModel,
      items: state.models.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: TextWidget(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            label: value,
          ),
        );
      }).toList(),
      onChanged: (String? value) {
        if (value != null) {
          context.read<ModelBloc>().add(SelectModel(value));
        }
      },
    );
  }
}
