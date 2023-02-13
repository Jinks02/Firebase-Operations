// import 'package:flutter/material.dart';
//
// class RoundButton extends StatelessWidget {
//   const RoundButton(
//       {Key? key,
//       required this.btnText,
//       required this.onTap,
//       this.loading = false})
//       : super(key: key);
//   final String btnText;
//   final VoidCallback onTap;
//   final bool loading;
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         height: 50,
//         decoration: BoxDecoration(
//           color: Colors.indigo,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Center(
//           child: loading
//               ? CircularProgressIndicator(
//             backgroundColor: Colors.red,
//                   strokeWidth: 3,
//                   color: Colors.white,
//                 )
//               : Text(
//                   btnText,
//                   style: TextStyle(
//                     color: Colors.white,
//                   ),
//                 ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
//
//
// class RoundButton extends StatelessWidget {
//   final String btnText ;
//   final VoidCallback onTap ;
//   final bool loading ;
//   const RoundButton({Key? key ,
//     required this.btnText,
//     required this.onTap,
//     this.loading = false
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         height: 50,
//         decoration: BoxDecoration(
//             color: Colors.deepPurple,
//             borderRadius: BorderRadius.circular(10)
//         ),
//         child: Center(child: loading ? CircularProgressIndicator(strokeWidth: 3,color: Colors.white,) :
//         Text(btnText, style: TextStyle(color: Colors.white),),),
//       ),
//     );
//   }
// }

Widget customButton (String btnText,VoidCallback onTap,bool loading){
  return InkWell(
    onTap: onTap,
    child: Container(
      height: 50,
      decoration: BoxDecoration(
          color: Colors.indigo,
          borderRadius: BorderRadius.circular(10)
      ),
      child: Center(child: loading ? CircularProgressIndicator(strokeWidth: 3,color: Colors.white,) :
      Text(btnText, style: TextStyle(color: Colors.white),),),
    ),
  );
}
