import '../utilities/app_exports.dart';
import 'package:flutter/cupertino.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class CustomDropDownButton extends StatefulWidget {
  final String? initialValue;
  final List<String> items;
  final ValueChanged<String> onChanged;
  final double? width;
  final double? height;
  final bool enabled;
  final Widget? prefixIcon;

  const CustomDropDownButton(
      {super.key,
      required this.initialValue,
      required this.items,
      required this.onChanged,
      this.width,
      this.height,
      this.enabled=true,
        this.prefixIcon,
      });

  @override
  State<CustomDropDownButton> createState() => _CustomDropDownButtonState();
}

class _CustomDropDownButtonState extends State<CustomDropDownButton> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: !widget.enabled,
      child: Container(
        width: widget.width ?? 200,
        height: widget.height ?? 55,
        padding: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: AppColors.textFieldFillColor,
          border: Border.all(
            color: AppColors.textFieldBorderColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Row(
            children: [
              widget.prefixIcon??SizedBox.shrink(),
              Expanded(
                child: DropdownButton2<String>(
                  isExpanded: true,
                  value: _selectedValue,
                  hint: Text("Select"),
                  items: widget.items.map((item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: CustomText(
                        item,
                        style: AppTextTheme.bodyLarge,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = value;
                    });
                    widget.onChanged(value!);
                  },
                  iconStyleData:  IconStyleData(
                    icon: Visibility(
                      visible: widget.enabled,
                      child: Icon(
                        CupertinoIcons.chevron_down,
                        color: AppColors.surface,
                      ),
                    ),
                  ),
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                      color: AppColors.textFieldFillColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.textFieldBorderColor,
                        width: 1,
                      ),
                    ),
                  ),
                  underline: SizedBox(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
