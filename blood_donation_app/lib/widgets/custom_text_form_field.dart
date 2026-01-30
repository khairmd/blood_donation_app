import '../utilities/app_exports.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final EdgeInsetsGeometry? outerPadding;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String upperLabel;
  final String upperLabelReqStar;
  final String hintValue;
  final String? Function(String?)? validator;
  final TextInputType? type;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final bool obscureText;
  final bool enableInteractiveSelection;
  final bool enabled;
  final bool readOnly;
  final bool isDatePicker;
  final bool enableSuggestions;
  final int? maxLength;
  final int? maxLines;
  final Color? borderColor;

  const CustomTextFormField({
    super.key,
    required this.controller,
    this.outerPadding,
    this.prefixIcon,
    this.suffixIcon,
    required this.upperLabel,
    required this.upperLabelReqStar,
    required this.hintValue,
    this.validator,
    this.type,
    this.inputFormatters,
    this.onChanged,
    this.obscureText = false, // Default to not obscure
    this.enableInteractiveSelection = true, // Default to true
    this.enableSuggestions = true, // Default to true
    this.enabled = true,
    this.readOnly = false,
    this.isDatePicker = false,
    this.maxLength,
    this.maxLines,
    this.borderColor,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool obscureText;

  @override
  void initState() {
    super.initState();
    obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.outerPadding ?? EdgeInsets.only(left: 2.0.w, top: 10.h),
      child: Column(
        spacing: 5,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomText(widget.upperLabel, style: AppTextTheme.bodyMedium),
              CustomText(
                ' ${widget.upperLabelReqStar}',
                style: AppTextTheme.bodyMedium.copyWith(color: Colors.red),
              ),
            ],
          ),
          TextFormField(
            controller: widget.controller,
            enabled: widget.enabled,
            readOnly: widget.readOnly,
            obscureText: obscureText,
            obscuringCharacter: '*',
            keyboardType: widget.type,
            inputFormatters: widget.inputFormatters,
            validator: widget.validator,
            onChanged: widget.onChanged,
            maxLines: obscureText ? 1 : widget.maxLines,
            enableInteractiveSelection: widget.enableInteractiveSelection,
            enableSuggestions: widget.enableSuggestions,
            maxLength: widget.maxLength,
            style: AppTextTheme.bodyLarge,
            decoration: InputDecoration(
              prefixIconConstraints: BoxConstraints(minWidth: 50),
              suffixIconConstraints: BoxConstraints(minWidth: 50),
              hintText: widget.hintValue,
              hintStyle: AppTextTheme.bodyLarge.copyWith(color: Colors.grey),
              filled: true,
              fillColor: AppColors.textFieldFillColor,
              prefixIcon:
                  widget.prefixIcon != null
                      ? Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: widget.prefixIcon,
                      )
                      : null,
              suffixIcon:
                  widget.suffixIcon ??
                  ((widget.obscureText)
                      ? GestureDetector(
                        onTap: () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.only(right: 20.0),
                          child:
                              obscureText
                                  ? SvgPicture.asset(AppConstants.eyeSlash)
                                  : SvgPicture.asset(
                                    AppConstants.eye,
                                    colorFilter: ColorFilter.mode(
                                      AppColors.textSecondary,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                        ),
                      )
                      : null),

              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: widget.borderColor ?? AppColors.textFieldBorderColor,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: widget.borderColor ?? AppColors.textFieldBorderColor,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: widget.borderColor ?? AppColors.textFieldBorderColor,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: widget.borderColor ?? AppColors.textFieldBorderColor,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
          ),
        ],
      ),
    );
  }
}
