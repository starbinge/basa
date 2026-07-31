import 'package:flutter/material.dart';
import 'package:m3e_core/m3e_core.dart';

class SegmentedButtonTimeSelection extends StatefulWidget {
  const SegmentedButtonTimeSelection({
    super.key,
    required int selectedPage,
    required this.onSelectedIndexChanged,
  }) : _selectedPage = selectedPage;
  final int _selectedPage;
  final void Function(int selectedIndex) onSelectedIndexChanged;

  @override
  State<SegmentedButtonTimeSelection> createState() =>
      _SegmentedButtonTimeSelectionState();
}

class _SegmentedButtonTimeSelectionState
    extends State<SegmentedButtonTimeSelection> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: M3EToggleButtonGroup(
        onSelectedIndexChanged: (selectedIndex) =>
            widget.onSelectedIndexChanged(selectedIndex!),
        selectedIndex: widget._selectedPage,
        type: M3EButtonGroupType.connected,
        actions: [
          M3EToggleButtonGroupAction(
            icon: const Icon(Icons.calendar_month_rounded),
            label: null,
            checkedLabel: Text(
              "Daily",
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
            decoration: M3EToggleButtonDecoration(
              backgroundColor: WidgetStatePropertyAll(
                widget._selectedPage == 0
                    ? Theme.of(context).primaryColorDark
                    : Colors.grey.withValues(alpha: 0.2),
              ),
            ),
          ),

          M3EToggleButtonGroupAction(
            icon: const Icon(Icons.calendar_view_month),
            label: null,
            checkedLabel: Text(
              "Monthly",
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
            decoration: M3EToggleButtonDecoration(
              backgroundColor: WidgetStatePropertyAll(
                widget._selectedPage == 1
                    ? Theme.of(context).primaryColorDark
                    : Colors.grey.withValues(alpha: 0.2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
