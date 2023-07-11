import 'package:flutter/material.dart';
import 'package:flutter_chess_app/components/pieces.dart';
import 'package:flutter_chess_app/components/square.dart';
import 'package:flutter_chess_app/values/colors.dart';
import 'helpers/helper_methods.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  //Forming a list for board to set pieces states.
  late List<List<ChessPiece?>> board;

  //Selected piece.
  ChessPiece? selectedPiece;

  //Row and column index of selected piece.
  int selectedRow = -1;
  int selectedColumn = -1;

  //List of valid moves for selected piece.
  List<List<int>> validMoves = [];

  @override
  void initState() {
    super.initState();
    _initializeBoard();
  }

  void _initializeBoard() {
    List<List<ChessPiece?>> newBoard =
        List.generate(8, (index) => List.generate(8, (index) => null));
    //pawns
    for (var i = 0; i < 8; i++) {
      newBoard[1][i] = ChessPiece(
        type: ChessPieceType.pawn,
        isWhite: false,
        imagePath: "lib/assets/black/pawn.png",
      );
    }
    for (var i = 0; i < 8; i++) {
      newBoard[6][i] = ChessPiece(
        type: ChessPieceType.pawn,
        isWhite: true,
        imagePath: "lib/assets/white/pawn.png",
      );
    }

    //rooks
    newBoard[0][0] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: false,
      imagePath: "lib/assets/black/rook.png",
    );

    newBoard[0][7] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: false,
      imagePath: "lib/assets/black/rook.png",
    );

    newBoard[7][0] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: true,
      imagePath: "lib/assets/white/rook.png",
    );

    newBoard[7][7] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: true,
      imagePath: "lib/assets/white/rook.png",
    );

    //knights
    newBoard[0][1] = ChessPiece(
      type: ChessPieceType.knight,
      isWhite: false,
      imagePath: "lib/assets/black/knight.png",
    );

    newBoard[0][6] = ChessPiece(
      type: ChessPieceType.knight,
      isWhite: false,
      imagePath: "lib/assets/black/knight.png",
    );

    newBoard[7][1] = ChessPiece(
      type: ChessPieceType.knight,
      isWhite: true,
      imagePath: "lib/assets/white/knight.png",
    );

    newBoard[7][6] = ChessPiece(
      type: ChessPieceType.knight,
      isWhite: true,
      imagePath: "lib/assets/white/knight.png",
    );

    //bishops
    newBoard[0][2] = ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: false,
      imagePath: "lib/assets/black/bishop.png",
    );

    newBoard[0][5] = ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: false,
      imagePath: "lib/assets/black/bishop.png",
    );

    newBoard[7][2] = ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: true,
      imagePath: "lib/assets/white/bishop.png",
    );

    newBoard[7][5] = ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: true,
      imagePath: "lib/assets/white/bishop.png",
    );

    //queens
    newBoard[0][3] = ChessPiece(
      type: ChessPieceType.queen,
      isWhite: false,
      imagePath: "lib/assets/black/queen.png",
    );

    newBoard[7][3] = ChessPiece(
      type: ChessPieceType.queen,
      isWhite: true,
      imagePath: "lib/assets/white/queen.png",
    );

    //kings
    newBoard[0][4] = ChessPiece(
      type: ChessPieceType.king,
      isWhite: false,
      imagePath: "lib/assets/black/king.png",
    );

    newBoard[7][4] = ChessPiece(
      type: ChessPieceType.king,
      isWhite: true,
      imagePath: "lib/assets/white/king.png",
    );

    board = newBoard;
  }

  void pieceSelection(int selectedRow, int selectedColumn) {
    setState(() {
      if (board[selectedRow][selectedColumn] != null) {
        selectedPiece = board[selectedRow][selectedColumn];
        this.selectedColumn = selectedColumn;
        this.selectedRow = selectedRow;
      }

      //Assign selected pieces valid moves.
      validMoves =
          calculatedRowValidMoves(selectedRow, selectedColumn, selectedPiece);
    });
  }

  //Calculate row valid moves.
  List<List<int>> calculatedRowValidMoves(
      int row, int column, ChessPiece? selectedPiece) {
    List<List<int>> candidateMoves = [];

    //Directions based on color.
    int direction = selectedPiece!.isWhite ? -1 : 1;

    switch (selectedPiece.type) {
      case ChessPieceType.pawn:
        //Can move one step forvard if the square is empty.
        if (isInBoard(row + direction, column) &&
            board[row + direction][column] == null) {
          candidateMoves.add([row + direction, column]);
        }

        //Can move two step forward at initial position.
        if ((row == 1 && !selectedPiece.isWhite) ||
            (row == 6 && selectedPiece.isWhite)) {
          if (isInBoard(row + 2 * direction, column) &&
              board[row + 2 * direction][column] == null &&
              board[row + direction][column] == null) {
            candidateMoves.add([row + 2 * direction, column]);
          }
        }

        //Can kill diagonally.
        if (isInBoard(row + direction, column - 1) &&
            board[row + direction][column - 1] != null &&
            board[row + direction][column - 1]!.isWhite) {
          candidateMoves.add([row + direction, column - 1]);
        }

        if (isInBoard(row + direction, column + 1) &&
            board[row + direction][column + 1] != null &&
            board[row + direction][column + 1]!.isWhite) {
          candidateMoves.add([row + direction, column + 1]);
        }

        break;
      case ChessPieceType.rook:
        break;
      case ChessPieceType.knight:
        break;
      case ChessPieceType.bishop:
        break;
      case ChessPieceType.queen:
        break;
      case ChessPieceType.king:
        break;
      default:
    }
    return candidateMoves;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: GridView.builder(
        itemCount: 8 * 8,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
        itemBuilder: (context, index) {
          int row = index ~/ 8;
          int column = index % 8;

          bool isSelected = selectedColumn == column && selectedRow == row;

          //Check if its valid move.
          bool isValidmove = false;
          for (var position in validMoves) {
            if (position[0] == row && position[1] == column) {
              isValidmove = true;
            }
          }

          return Square(
            isWhite: isWhite(index),
            piece: board[row][column],
            isSelected: isSelected,
            isValidmove: isValidmove,
            onTap: () => pieceSelection(row, column),
          );
        },
      ),
    );
  }
}
