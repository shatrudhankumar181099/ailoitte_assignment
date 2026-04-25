
import 'package:flutter/material.dart';

Future<dynamic> bottomSheetWidget(BuildContext context,Widget child){
  return showModalBottomSheet(context: context,

      backgroundColor: const Color(0xFFF1F5F9),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))
      ),
      builder: (context){
        return SafeArea(child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: EdgeInsetsGeometry.only(
                left: 15,right: 15,top: 15,bottom: MediaQuery.of(context).viewInsets.bottom + 15
            ),
            child: SingleChildScrollView(
                child: child
            ),
          ),
        ));
      });
}

Widget textFieldWidget(double hPadding,double vPadding,String hint, TextEditingController controller,TextInputType inputType,
    {String ? suffixText,int? maxLines,String? Function(String?)? validator}){
  return TextFormField(
    keyboardType: inputType,
    controller: controller,
    maxLines: maxLines,
    validator: validator,
    style: const TextStyle(color: Colors.black),
    decoration: InputDecoration(
      suffixIcon: Padding(
        padding: const EdgeInsets.only(right: 12, top: 12.0),
        child: Text(
          suffixText ?? "",
          textAlign: TextAlign.end,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black54),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black),
        borderRadius: BorderRadius.circular(12),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.redAccent),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.redAccent),
        borderRadius: BorderRadius.circular(12),
      ),

      contentPadding:  EdgeInsets.symmetric(horizontal:hPadding , vertical: vPadding),
    ),
  );
}
Widget elevatedButtonWidget(String title,VoidCallback ?onTap,double vertical,double horizontal){
  return SizedBox(width: double.infinity,
    child: ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),),
        padding: EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal),),
      child:  Text(title,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600,),),
    ),
  );
}
extension DateTimeExtension on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }
}