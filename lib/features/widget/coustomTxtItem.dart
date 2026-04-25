import 'package:flutter/material.dart';

typedef OnChanged = Function(String);
typedef validator = String? Function(String?);
class CoustomTxtItem extends StatelessWidget {
 bool? filled;
 Color fillColor;
 Color borderColor;
 Widget? prefixIcon;
 Widget? SuffixIcon;
 String hintText;
 String labelText;
 TextStyle hintStyle;
 TextStyle lableStyle;
 int? maxLines;
 TextEditingController? controller;
 OnChanged? onChanged;
 validator? validation;
 bool obScureText;
 String obscuringChar;
 TextInputType keyboardType;

  CoustomTxtItem({super.key,required this.filled,
    required this.fillColor, required this.borderColor, this.prefixIcon, this.SuffixIcon ,
    required this.hintText,
    required this.labelText ,required this.hintStyle , required this.lableStyle, this.maxLines , this.controller ,
 this.onChanged  , this.validation ,this.obScureText = false ,this.obscuringChar = '*' , this.keyboardType = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines:maxLines ?? 1 ,
      decoration: InputDecoration(
        enabledBorder:builtDecorationBorder(borderSideColor:Colors.transparent ) ,
        focusedBorder: builtDecorationBorder(borderSideColor:Colors.transparent   ),
        errorBorder: builtDecorationBorder(borderSideColor:Colors.red),
        focusedErrorBorder:builtDecorationBorder(borderSideColor: Colors.red),
        errorStyle: TextStyle(color: Colors.red ,fontSize:10 ),
        filled:filled ,
        fillColor:fillColor ,
        prefixIcon:prefixIcon ,
        suffixIcon:SuffixIcon ,
        hintText:hintText ,
        hintStyle: hintStyle,
        labelStyle:lableStyle ,
        labelText:labelText ,
      ),
      controller: controller,
      onChanged:onChanged ,
      validator:validation ,
      obscureText: obScureText,
      obscuringCharacter: obscuringChar,
      keyboardType:keyboardType ,
    );
  }
  OutlineInputBorder builtDecorationBorder({required Color borderSideColor}){
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(
        color:borderSideColor,
        width: 2
      )
    );
  }
}
