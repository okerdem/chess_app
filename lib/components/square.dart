import "package:flutter/material.dart";
import "package:flutter_chess_app/components/pieces.dart";
import "package:flutter_chess_app/values/colors.dart";

class Square extends StatelessWidget {
  final bool isWhite;
  final ChessPiece? piece;
  final bool isSelected;
  final bool isValidmove;
  final void Function()? onTap;

  const Square({
    super.key,
    required this.isWhite,
    required this.piece,
    required this.isSelected,
    required this.onTap,
    required this.isValidmove,
  });

  @override
  Widget build(BuildContext context) {
    Color? squareColor;

    if (isSelected) {
      squareColor = selectedSquareColor;
    } else if (isValidmove) {
      squareColor = validMoveColor;
    } else {
      squareColor = isWhite ? foregroundColor : backgroundColor;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: squareColor,
        child: piece != null
            ? Image.asset(
                piece!.isWhite ? piece!.imagePath : piece!.imagePath,
              )
            : null,
      ),
    );
  }
}
