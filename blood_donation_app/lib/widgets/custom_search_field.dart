import 'dart:async';
import 'package:flutter/cupertino.dart';
import '../utilities/app_exports.dart';


class CustomSearchField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final Function(String) onSearch;

  const CustomSearchField({
    super.key,
    required this.controller,
    this.hintText,
    required this.onSearch,
  });

  @override
  State<CustomSearchField> createState() => _CustomSearchFieldState();
}

class _CustomSearchFieldState extends State<CustomSearchField> {
  // If you are only searching on submit, you don't need DeBouncer here.
  // If you want to use it for other purposes, keep it.
  // final _deBouncer = DeBouncer(milliseconds: 500); // Uncomment if you still use it for other logic

  @override
  void initState() {
    super.initState();
    // Add a listener to the controller to rebuild the widget when text changes.
    // This is crucial for the suffix to update.
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    // Don't forget to dispose the listener!
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    // This will trigger a rebuild of the widget, updating the suffix visibility.
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
          fillColor: Colors.transparent,
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 6),
            child: const Icon( // Added const if no dynamic properties
              CupertinoIcons.search,
              color: Colors.grey,
            ),
          ),
          prefixIconConstraints: BoxConstraints(maxWidth: 40),
          contentPadding: EdgeInsets.zero,
          hintText: widget.hintText ?? "Search...",
          hintStyle: AppTextTheme.bodyLarge, // Ensure AppTheme is accessible
          suffix: widget.controller.text.isEmpty
              ? const SizedBox.shrink() // Added const
              : GestureDetector(
              onTap: () {
                // No need for setState here if _onControllerChanged handles it
                widget.controller.clear();
                // When cleared, you might still want to trigger an empty search
                widget.onSearch('');
                // setState is already called by _onControllerChanged when controller.clear() changes the text.
              },
              child: const Padding( // Added const
                padding: EdgeInsets.only(right: 8.0),
                child: Icon(
                  CupertinoIcons.clear_circled,
                  color: Colors.grey,
                ),
              )),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: const Color(0xffD0D5DD)),
          borderRadius: BorderRadius.circular(8),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: const Color(0xffD0D5DD)),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: const Color(0xffD0D5DD)),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: const Color(0xffD0D5DD)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      // Remove or keep onChanged based on your debouncing needs.
      // If you only want search on submit, you can remove this.
      // If you want the clear icon to show/hide as you type, this is not directly needed,
      // as the listener on the controller will handle it.
      // onChanged: (value) {
      //   // If you want to debounce the search while typing AND also show/hide the icon,
      //   // you'd typically have the Debouncer here.
      //   // _deBouncer.run(() => widget.onSearch(value));
      //   // setState(() {}); // This setState is now handled by the listener.
      // },

      // Use onFieldSubmitted for search on keyboard "Done" or "Submit"
      onFieldSubmitted: (value) {
        widget.onSearch(value);
        // It's good practice to ensure the UI updates, though the listener
        // might already handle some text changes.
        // setState(() {}); // Optional: if you need a specific rebuild after submission
      },
    );
  }
}

// Keep the DeBouncer class if you use it elsewhere.
// If not, you can remove it.
class DeBouncer {
  final int milliseconds;
  Timer? _timer;

  DeBouncer({required this.milliseconds});

  void run(VoidCallback action) {
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
