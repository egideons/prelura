import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prelura_app/views/widgets/app_button.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/auth_text_field.dart'; // for 12.sp

// Assuming you have the PreluraAuthTextField and PreluraButtonWithLoader defined
class DiscountItem extends ConsumerStatefulWidget {
  DiscountItem(
      {super.key,
      required this.title,
      required this.isEditing,
      this.onChange,
      required this.percentageValue});
  final String title;
  final bool isEditing;
  StateProvider<String> percentageValue;
  final Function()? onChange;

  @override
  _EditSaveExampleState createState() => _EditSaveExampleState();
}

class _EditSaveExampleState extends ConsumerState<DiscountItem> {
  bool isEditing = false;
  final TextEditingController _controller = TextEditingController();
  String value = "0%";

  @override
  void initState() {
    super.initState();
    _controller.text = ref.read(widget.percentageValue) ?? "0%";
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final text = _controller.text;

    // Ensure the cursor always remains after the current text
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: text.length - 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    final percentage = ref.watch(widget.percentageValue);

    // Keep controller in sync with the latest percentageValue
    if (_controller.text != percentage) {
      _controller.text = percentage;
    }
    return Center(
      // Wrap the Column with Center
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.title,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontWeight: FontWeight.w600, fontSize: 12.sp),
                ),
                Container(
                  // color: Colors.red,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      PreluraAuthTextField(
                        textAlign: TextAlign.center,
                        hintText: "0%",
                        keyboardType: TextInputType.number,
                        maxLength: 3,
                        prefixIcon: Icon(Icons.percent),
                        textInputAction: TextInputAction.done,
                        controller: _controller,
                        height: 45,
                        padding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 7),
                        onFieldTap: () {
                          int cursorPosition =
                              calculateCursorPosition(_controller.text);

                          _controller.selection = TextSelection.fromPosition(
                            TextPosition(offset: cursorPosition),
                          );
                        },
                        onChanged: (newValue) {
                          log(" new value : ${newValue.toString()}");
                          widget.onChange?.call();
                          setState(() {
                            String numericValue =
                                newValue.replaceAll(RegExp(r'[^0-9]'), '');
                            log("numeric value is $numericValue");
                            numericValue = numericValue.isEmpty
                                ? "0"
                                : int.parse(numericValue).toString();

                            value = numericValue;

                            ref.read(widget.percentageValue.notifier).state =
                                "$value%";
                            _controller.value = TextEditingValue(
                              text: "$value%",
                              selection: TextSelection.collapsed(
                                  offset: "$value%".length - 1),
                            );
                          });
                        },
                        minWidth: 50,
                        enabled: widget.isEditing,
                      ),
                      // PreluraButtonWithLoader(
                      //   onPressed: () {
                      //     HapticFeedback.lightImpact();
                      //     setState(() {
                      //       if (isEditing) {}
                      //       isEditing = !isEditing;
                      //     });
                      //   },
                      //   buttonTitle: isEditing ? "Done" : "Edit",
                      //   showLoadingIndicator: false,
                      //   buttonColor: Colors.transparent,
                      //   buttonTitleTextStyle: Theme.of(context)
                      //       .textTheme
                      //       .bodyMedium
                      //       ?.copyWith(
                      //           color: PreluraColors.primaryColor,
                      //           fontWeight: FontWeight.w500),
                      //   butttonWidth: 70,
                      //   newButtonHeight: 25,
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          buildDivider(context),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int calculateCursorPosition(String text) {
    if (text.isEmpty) {
      return 0; // Start at the beginning if text is empty
    }
    // Example: Set cursor to the middle of the text
    return text.length - 1.floor();
  }
}
