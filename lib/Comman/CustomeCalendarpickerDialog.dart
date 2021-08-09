import 'package:condo_pigeon/Comman/string.dart';
import 'package:condo_pigeon/pages/AddPartyRoomPage.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:condo_pigeon/Comman/Util.dart';

class CustomeCalendarpickerDialog extends StatefulWidget {
  // final title;
  List<DateTime> specialDates;
  String _StartEventdate = null;
  TextEditingController _EventController = new TextEditingController();
  bool IsfromServiceElevetor;

  CustomeCalendarpickerDialog(this.specialDates, this._EventController,
      this.IsfromServiceElevetor, this._StartEventdate);

  @override
  _CustomeCalendarpickerDialogState createState() =>
      _CustomeCalendarpickerDialogState();
}

class _CustomeCalendarpickerDialogState
    extends State<CustomeCalendarpickerDialog> {
  String _selectedDate = '';

  String _dateCount = '';

  String _range = '';

  String _rangeCount = '';

  BuildContext dialogContext;

  SfDateRangePicker _getCustomizedDatePicker(List<DateTime> specialDates) {
    // final bool isDark = theme != null &&
    //     theme.brightness != null &&
    //     theme.brightness == Brightness.dark;

    final Color monthCellBackground =
        false ? const Color(0xFF232731) : const Color(0xffffffff);
    final Color indicatorColor =
        false ? const Color(0xFF5CFFB7) : const Color(0xFF1AC4C7);
    final Color highlightColor =
        false ? const Color(0xFF5CFFB7) : Colors.deepPurpleAccent;
    final Color cellTextColor =
        false ? const Color(0xFFDFD4FF) : const Color(0xFF130438);

    return SfDateRangePicker(
      selectionShape: DateRangePickerSelectionShape.rectangle,
      selectionColor: highlightColor,
      onSelectionChanged: _onSelectionChanged,
      selectionTextStyle:
          TextStyle(color: false ? Colors.black : Colors.white, fontSize: 14),
      minDate: DateTime.now().add(const Duration(days: -200)),
      maxDate: DateTime.now().add(const Duration(days: 500)),
      headerStyle: DateRangePickerHeaderStyle(
          textAlign: TextAlign.center,
          textStyle: TextStyle(
            fontSize: 18,
            color: cellTextColor,
          )),
      monthCellStyle: DateRangePickerMonthCellStyle(
          cellDecoration: _MonthCellDecoration(
              borderColor: null,
              backgroundColor: monthCellBackground,
              showIndicator: false,
              indicatorColor: indicatorColor),
          todayCellDecoration: _MonthCellDecoration(
              borderColor: highlightColor,
              backgroundColor: monthCellBackground,
              showIndicator: false,
              indicatorColor: indicatorColor),
          specialDatesDecoration: _MonthCellDecoration(
              borderColor: null,
              backgroundColor: monthCellBackground,
              showIndicator: true,
              indicatorColor: indicatorColor),
          disabledDatesTextStyle: TextStyle(
            color: false ? const Color(0xFF666479) : const Color(0xffe2d7fe),
          ),
          weekendTextStyle: TextStyle(
            color: highlightColor,
          ),
          textStyle: TextStyle(color: cellTextColor, fontSize: 14),
          specialDatesTextStyle: TextStyle(color: cellTextColor, fontSize: 14),
          todayTextStyle: TextStyle(color: highlightColor, fontSize: 14)),
      yearCellStyle: DateRangePickerYearCellStyle(
        todayTextStyle: TextStyle(color: highlightColor, fontSize: 14),
        textStyle: TextStyle(color: cellTextColor, fontSize: 14),
        disabledDatesTextStyle: TextStyle(
            color: false ? const Color(0xFF666479) : const Color(0xffe2d7fe)),
        leadingDatesTextStyle:
            TextStyle(color: cellTextColor.withOpacity(0.5), fontSize: 14),
      ),
      showNavigationArrow: true,
      todayHighlightColor: highlightColor,
      monthViewSettings: DateRangePickerMonthViewSettings(
        firstDayOfWeek: 1,
        viewHeaderStyle: DateRangePickerViewHeaderStyle(
            textStyle: TextStyle(
                fontSize: 10,
                color: cellTextColor,
                fontWeight: FontWeight.w600)),
        dayFormat: 'EEE',
        showTrailingAndLeadingDates: false,
        specialDates: specialDates,
      ),
    );
  }

  Future _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _range =
            DateFormat('dd/MM/yyyy').format(args.value.startDate).toString() +
                ' - ' +
                DateFormat('dd/MM/yyyy')
                    .format(args.value.endDate ?? args.value.startDate)
                    .toString();
        print("range:-" + _range);
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
        DateTime now = DateTime.now();
        if (widget._StartEventdate != null)
        print("_StartEventdate: " + widget._StartEventdate + "Compare:= "+formatDate(args.value, [dd, '/', mm, '/', yyyy]));
        if (widget._StartEventdate != null && DateFormat('dd/MM/yyyy').parse(widget._StartEventdate).compareTo(args.value) > 0) {
          CustomeFlutterToast(strendDatevaluenotvalid);
        } else if (widget.IsfromServiceElevetor) {
          print("_selectedDate: " + _selectedDate);
          // selectedStartDate = args.value;
          widget._EventController.text =
              formatDate(args.value, [dd, '/', mm, '/', yyyy]);
          Navigator.pop(dialogContext);
        } else if (args.value.compareTo(now) > 0) {
          if (widget.specialDates != null && widget.specialDates.length > 0) {
            if (!widget.specialDates.contains(args.value)) {
              print("_selectedDate: " + _selectedDate);
              // selectedStartDate = args.value;
              widget._EventController.text =
                  formatDate(args.value, [dd, '/', mm, '/', yyyy]);
              Navigator.pop(dialogContext);
            } else {
              print("not valid _selectedDate: " + _selectedDate);
              CustomeFlutterToast(strSelectotherdate);
              // Fluttertoast.showToast(
              //     msg: "Please select other date this date is full.Thank you",
              //     toastLength: Toast.LENGTH_LONG,
              //     gravity: ToastGravity.BOTTOM,
              //     backgroundColor: Colors.black12,
              //     textColor: Colors.white,
              //     fontSize: 16.0
              // );
              //Navigator.pop(dialogContext);
            }
          } else {
            print("_selectedDate: " + _selectedDate);
            // selectedStartDate = args.value;
            widget._EventController.text =
                formatDate(args.value, [dd, '/', mm, '/', yyyy]);
            Navigator.pop(dialogContext);
            //Navigator.pop(dialogContext);
          }
        } else {
          CustomeFlutterToast(strSelectfuturedate);
          // Fluttertoast.showToast(
          //     msg: "Please select current date or future date",
          //     toastLength: Toast.LENGTH_SHORT,
          //     gravity: ToastGravity.BOTTOM,
          //     backgroundColor: Colors.black12,
          //     textColor: Colors.white,
          //     fontSize: 16.0
          // );
        }
        // Navigator.of(dialogContext).pop(_selectedDate);
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
        print("_dateCount:-" + _dateCount);
      } else {
        _rangeCount = args.value.length.toString();
        print("_rangeCount:-" + _rangeCount);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    dialogContext = context;
    return AlertDialog(
      insetPadding: EdgeInsets.fromLTRB(40, 100, 40, 100),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      //title: Text('Alert'),
      content: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Builder(builder: (context) {
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;
          return Container(
            alignment: Alignment.center,
            height: height,
            width: width,
            child: _getCustomizedDatePicker(widget.specialDates),
          );
        }),
      ),
    );
  }
}

class _MonthCellDecoration extends Decoration {
  const _MonthCellDecoration(
      {this.borderColor,
      this.backgroundColor,
      this.showIndicator,
      this.indicatorColor});

  final Color borderColor;
  final Color backgroundColor;
  final bool showIndicator;
  final Color indicatorColor;

  @override
  BoxPainter createBoxPainter([VoidCallback onChanged]) {
    return _MonthCellDecorationPainter(
        borderColor: borderColor,
        backgroundColor: backgroundColor,
        showIndicator: showIndicator,
        indicatorColor: indicatorColor);
  }
}

/// [_MonthCellDecorationPainter] used to paint month cell decoration.
class _MonthCellDecorationPainter extends BoxPainter {
  _MonthCellDecorationPainter(
      {this.borderColor,
      this.backgroundColor,
      this.showIndicator,
      this.indicatorColor});

  final Color borderColor;
  final Color backgroundColor;
  final bool showIndicator;
  final Color indicatorColor;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Rect bounds = offset & configuration.size;
    _drawDecoration(canvas, bounds);
  }

  void _drawDecoration(Canvas canvas, Rect bounds) {
    final Paint paint = Paint()..color = backgroundColor;
    canvas.drawRRect(
        RRect.fromRectAndRadius(bounds, const Radius.circular(5)), paint);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1;
    if (borderColor != null) {
      paint.color = borderColor;
      canvas.drawRRect(
          RRect.fromRectAndRadius(bounds, const Radius.circular(5)), paint);
    }

    if (showIndicator) {
      paint.color = indicatorColor;
      paint.strokeWidth = 1;
      paint.style = PaintingStyle.fill;
      canvas.drawCircle(Offset(bounds.right - 8, bounds.top + 8), 4, paint);
      //  canvas.drawRRect(
      //      RRect.fromRectAndRadius(bounds, const Radius.circular(5)), paint);
    }
  }
}
