// import 'package:flutter/material.dart';
// import 'package:orderly/core/ui/theme/colors.dart';
// import 'package:table_calendar/table_calendar.dart';


// class DateRangePicker extends StatefulWidget {
//   const DateRangePicker({
//     super.key,
//     required this.onRangeSelected,
//     this.initialStartDate,
//     this.initialEndDate,
//   });

//   final void Function(DateTime start, DateTime end) onRangeSelected;
//   final DateTime? initialStartDate;
//   final DateTime? initialEndDate;

//   @override
//   State<DateRangePicker> createState() => _DateRangePickerState();
// }

// class _DateRangePickerState extends State<DateRangePicker> {
//   static const int _maxFutureMonths = 6;
//   static const int _maxRangeDays = 5;

//   DateTime now = DateTime.now();
//   late DateTime today = DateTime(now.year, now.month, now.day);
//   late DateTime lastSelectableDate = DateTime(
//     now.year,
//     now.month + _maxFutureMonths,
//     now.day,
//   );
//   late DateTime? startDate = today;
//   late DateTime? endDate = today;
//   String? errorMessage;

//   String formatDateForDisplay(DateTime date) {
//     return DateFormat("dd/MM/y").format(date);
//   }

//   @override
//   void initState() {
//     super.initState();

//     startDate = widget.initialStartDate;
//     endDate = widget.initialEndDate;

//     if (startDate != null && endDate != null) {
//       if (endDate!.isBefore(startDate!)) {
//         endDate = startDate;
//       }
//     }

//     startDate ??= today;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       contentPadding: const EdgeInsets.all(24.0),
//       title: Text(
//         "Select Date",
//         style: Theme.of(context).textTheme.bodyMedium!.copyWith(
//               color: AppColors.chineseBlue,
//               fontWeight: FontWeight.w600,
//             ),
//       ),
//       content: SizedBox(
//         height: 430,
//         width: 300,
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Text(
//                 "You can select up to a $_maxRangeDays-day max range.",
//                 style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                       color: AppColors.greyColor,
//                       fontWeight: FontWeight.w400,
//                     ),
//               ),
//               const SizedBox(height: 10),
//               TableCalendar(
//                 currentDay: DateTime.now(),
//                 firstDay: today,
//                 lastDay: lastSelectableDate,
//                 focusedDay: startDate!,
//                 daysOfWeekStyle: DaysOfWeekStyle(
//                   weekdayStyle:
//                       Theme.of(context).textTheme.bodyMedium!.copyWith(
//                             fontSize: 14,
//                             color: AppColors.greyColor,
//                             fontWeight: FontWeight.w600,
//                           ),
//                   weekendStyle:
//                       Theme.of(context).textTheme.bodyMedium!.copyWith(
//                             fontSize: 14,
//                             color: AppColors.greyColor,
//                             fontWeight: FontWeight.w600,
//                           ),
//                 ),
//                 rangeSelectionMode: RangeSelectionMode.toggledOn,
//                 rangeStartDay: startDate,
//                 rangeEndDay: endDate,
//                 availableGestures: AvailableGestures.all,
//                 headerStyle: HeaderStyle(
//                   formatButtonVisible: false,
//                   titleCentered: true,
//                   titleTextStyle:
//                       Theme.of(context).textTheme.bodyMedium!.copyWith(
//                             fontSize: 14,
//                             color: AppColors.primaryColor,
//                             fontWeight: FontWeight.w600,
//                           ),
//                 ),
//                 calendarStyle: CalendarStyle(
//                   defaultTextStyle:
//                       Theme.of(context).textTheme.bodyMedium!.copyWith(
//                             color: AppColors.blackColor,
//                             fontSize: 14,
//                             fontWeight: FontWeight.w400,
//                           ),
//                   weekendTextStyle:
//                       Theme.of(context).textTheme.bodyMedium!.copyWith(
//                             color: AppColors.primaryColor,
//                             fontSize: 14,
//                             fontWeight: FontWeight.w400,
//                           ),
//                   rangeStartDecoration: const BoxDecoration(
//                     color: AppColors.secondaryColor,
//                     shape: BoxShape.circle,
//                   ),
//                   rangeEndDecoration: const BoxDecoration(
//                     color: AppColors.secondaryColor,
//                     shape: BoxShape.circle,
//                   ),
//                   rangeHighlightColor: AppColors.rangeHighlightColor,
//                   withinRangeTextStyle:
//                       Theme.of(context).textTheme.bodyMedium!.copyWith(
//                             color: AppColors.blackColor,
//                             fontSize: 14,
//                             fontWeight: FontWeight.w400,
//                           ),
//                   todayDecoration: const BoxDecoration(
//                     color: AppColors.backgroundMutedBrown,
//                     shape: BoxShape.circle,
//                   ),
//                   selectedDecoration: const BoxDecoration(
//                     color: AppColors.secondaryColor,
//                     shape: BoxShape.circle,
//                   ),
//                   outsideDaysVisible: false,
//                 ),
//                 onDaySelected: (selectedDay, focusedDay) {
//                   setState(() {
//                     startDate = selectedDay;
//                     endDate = null;
//                     errorMessage = null;
//                   });
//                 },
//                 onRangeSelected: (start, end, focusedDay) {
//                   setState(() {
//                     if (start != null) {
//                       startDate = start;
//                       if (end != null) {
//                         final difference = end.difference(start).inDays;
//                         if (difference > _maxRangeDays) {
//                           endDate =
//                               start.add(const Duration(days: _maxRangeDays));
//                           errorMessage =
//                               "Range cannot exceed $_maxRangeDays days. Adjusted to $_maxRangeDays days.";
//                         } else {
//                           endDate = end;
//                           errorMessage = null;
//                         }
//                       } else {
//                         endDate = null;
//                         errorMessage = null;
//                       }
//                     }
//                   });
//                 },
//                 enabledDayPredicate: (day) {
//                   final today = DateTime(
//                     DateTime.now().year,
//                     DateTime.now().month,
//                     DateTime.now().day,
//                   );

//                   if (day.isBefore(today)) {
//                     return false;
//                   }

//                   if (startDate != null &&
//                       endDate == null &&
//                       startDate != today) {
//                     final maxEndDate =
//                         startDate!.add(const Duration(days: _maxRangeDays));
//                     return !day.isBefore(startDate!) &&
//                         !day.isAfter(maxEndDate);
//                   }

//                   return true;
//                 },
//                 onPageChanged: (focusedDay) {},
//               ),
//               const SizedBox(height: 10),
//               if (errorMessage != null)
//                 Text(
//                   errorMessage!,
//                   style: const TextStyle(color: Colors.red, fontSize: 14),
//                 ),
//               if (startDate != null && endDate != null)
//                 Text(
//                   "Selected: ${formatDateForDisplay(startDate!)} → ${formatDateForDisplay(endDate!)}",
//                   style: Theme.of(context).textTheme.bodyMedium!.copyWith(
//                         color: AppColors.secondaryColor,
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                       ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: Text(
//             "Cancel",
//             style: Theme.of(context).textTheme.bodyMedium!.copyWith(
//                   color: AppColors.greyColor,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                 ),
//           ),
//         ),
//         ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: AppColors.secondaryColor,
//           ),
//           onPressed: (startDate != null && endDate != null)
//               ? () {
//                   widget.onRangeSelected(
//                     startDate!,
//                     endDate!,
//                   );
//                   Navigator.pop(context);
//                 }
//               : null,
//           child: const Text(
//             "Confirm",
//             style: TextStyle(color: Colors.white),
//           ),
//         ),
//       ],
//     );
//   }
// }
