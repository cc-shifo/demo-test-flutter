import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/cart_manager.dart';
import '../models/order_manager.dart';

class CheckoutPage extends StatefulWidget {
  final CartManager cartManager;
  final Function() didUpdate;
  final Function(Order) onSubmit;

  const CheckoutPage({
    super.key,
    required this.cartManager,
    required this.didUpdate,
    required this.onSubmit,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final Map<int, Widget> myTabs = const <int, Widget>{
    0: Text('Delivery'),
    1: Text('Self Pick-Up'),
  };
  Set<int> selectedSegment = {0};
  TimeOfDay? selectedTime;
  DateTime? selectedDate;
  final DateTime _firstDate = DateTime(DateTime.now().year - 2);
  final DateTime _lastDate = DateTime(DateTime.now().year + 1);
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Order Details', style: textTheme.headlineSmall),
            const SizedBox(height: 16.0),
            _buildOrderSegmentedType(),
            const SizedBox(height: 16.0),
            _buildTextField(),
            const SizedBox(height: 16.0),
            Row(
              children: [
                TextButton(
                  child: Text(formatDate(selectedDate)),
                  onPressed: () => _selectDate(context),
                ),
                TextButton(
                  child: Text(formatTimeOfDay(selectedTime)),
                  onPressed: () => _selectTime(context),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            const Text('Order Summary'),
            _buildOrderSummary(context),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  String formatDate(DateTime? dateTime) {
    if (dateTime == null) {
      return 'Select Date';
    }
    final formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(dateTime);
  }

  String formatTimeOfDay(TimeOfDay? timeOfDay) {
    if (timeOfDay == null) {
      return 'Select Time';
    }
    final hour = timeOfDay.hour.toString().padLeft(2, '0');
    final minute = timeOfDay.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void onSegmentSelected(Set<int> segmentIndex) {
    setState(() {
      selectedSegment = segmentIndex;
    });
  }

  Widget _buildOrderSegmentedType() {
    return SegmentedButton(
      showSelectedIcon: false,
      segments: const [
        ButtonSegment(
          value: 0,
          label: Text('Delivery'),
          icon: Icon(Icons.pedal_bike),
        ),
        ButtonSegment(
          value: 1,
          label: Text('Pickup'),
          icon: Icon(Icons.local_mall),
        ),
      ],
      selected: selectedSegment,
      onSelectionChanged: onSegmentSelected,
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: _nameController,
      decoration: const InputDecoration(labelText: 'Contact Name'),
    );
  }

  void _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: _firstDate,
      lastDate: _lastDate,
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.input,
      initialTime: selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Widget _buildOrderSummary(BuildContext context) {
    final colorTheme = Theme.of(context).colorScheme;

    return Expanded(
      child: ListView.builder(
        itemCount: widget.cartManager.items.length,
        itemBuilder: (context, index) {
          final item = widget.cartManager.itemAt(index);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Container(
                  decoration: BoxDecoration(
                    color: colorTheme.surfaceContainerHighest.withValues(
                      alpha: 0.35,
                    ), // 条目背景
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Dismissible(
                    key: Key(item.id),
                    direction: DismissDirection.endToStart,
                    background: Container(),
                    // secondaryBackground:  Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [Icon(Icons.delete)],
                    // ),
                    secondaryBackground: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: SizedBox(
                          width: 48,
                          height: 48,
                          child: Icon(Icons.delete),
                        ),
                      ),
                    ),
                    onDismissed: (direction) {
                      setState(() {
                        widget.cartManager.removeItem(item.id);
                      });
                      widget.didUpdate();
                    },
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: colorTheme.primaryContainer,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                          border: Border.all(
                            color: colorTheme.primary,
                            width: 2.0,
                          ),
                        ),
                        // child: ClipRRect(
                        //   borderRadius: const BorderRadius.all(
                        //     Radius.circular(8.0),
                        //   ),
                        child: Text('x${item.quantity}'),
                        // ),
                      ),
                      title: Text(item.name),
                      subtitle: Text('Price: \$${item.price}'),
                    ),
                  ),
                ),
              ),

              // 分隔线，最后一条不显示分割线
              // if (index != widget.cartManager.items.length - 1)
              //   const Divider(
              //     height: 1,
              //     thickness: 1,
              //     indent: 4,
              //     endIndent: 4,
              //   ),
              // TODO: Wrap in a Dismissible Widget
              // return Dismissible(
            ],
          );
        },
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: widget.cartManager.isEmpty
          ? null
          : () {
              final selectedSegment = this.selectedSegment;
              final selectedTime = this.selectedTime;
              final selectedDate = this.selectedDate;
              final name = _nameController.text;
              final items = widget.cartManager.items;
              final order = Order(
                selectedSegment: selectedSegment,
                selectedTime: selectedTime,
                selectedDate: selectedDate,
                name: name,
                items: items,
              );
              widget.cartManager.resetCart();
              widget.onSubmit(order);
            },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          '''Submit Order - \$${widget.cartManager.totalCost.toStringAsFixed(2)}''',
        ),
      ),
    );
  }
}
