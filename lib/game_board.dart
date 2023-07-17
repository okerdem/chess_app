import 'package:flutter/material.dart';
import 'package:flutter_chess_app/components/pieces.dart';
import 'package:flutter_chess_app/components/square.dart';
import 'package:flutter_chess_app/values/colors.dart';
import 'components/captured_piece.dart';
import 'helpers/helper_methods.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  //forming a list for board to set pieces states
  late List<List<ChessPiece?>> board;

  //selected piece
  ChessPiece? selectedPiece;

  //row and column index of selected piece
  int selectedRow = -1;
  int selectedColumn = -1;

  //list of valid moves for selected piece
  List<List<int>> validMoves = [];

  //list of black and white pieces that have been captured
  List<ChessPiece> whitePiecesCaptured = [];
  List<ChessPiece> blackPiecesCaptured = [];

  //who's turn
  bool isWhiteTurn = true;

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
      //no piece selected, this is first selection
      if (selectedPiece == null && board[selectedRow][selectedColumn] != null) {
        if (board[selectedRow][selectedColumn]!.isWhite == isWhiteTurn) {
          selectedPiece = board[selectedRow][selectedColumn];
          this.selectedRow = selectedRow;
          this.selectedColumn = selectedColumn;
        }
      }

      //a piece already selected but user can select another one of their pieces
      else if (board[selectedRow][selectedColumn] != null &&
          board[selectedRow][selectedColumn]!.isWhite ==
              selectedPiece!.isWhite) {
        selectedPiece = board[selectedRow][selectedColumn];
        this.selectedRow = selectedRow;
        this.selectedColumn = selectedColumn;
      }

      //if there is a piece selected and user taps on a square that is a valid move, move there
      else if (selectedPiece != null &&
          validMoves.any((element) =>
              element[0] == selectedRow && element[1] == selectedColumn)) {
        movePiece(selectedRow, selectedColumn);
      }

      //assign selected pieces valid moves
      validMoves =
          calculatedRowValidMoves(selectedRow, selectedColumn, selectedPiece);
    });
  }

  //calculate row valid moves
  List<List<int>> calculatedRowValidMoves(
      int row, int column, ChessPiece? selectedPiece) {
    List<List<int>> candidateMoves = [];

    if (selectedPiece == null) {
      return [];
    }

    //directions based on color
    int direction = selectedPiece.isWhite ? -1 : 1;

    switch (selectedPiece.type) {
      case ChessPieceType.pawn:
        //can move one step forvard if the square is empty
        if (isInBoard(row + direction, column) &&
            board[row + direction][column] == null) {
          candidateMoves.add([row + direction, column]);
        }

        //can move two step forward at initial position
        if ((row == 1 && !selectedPiece.isWhite) ||
            (row == 6 && selectedPiece.isWhite)) {
          if (isInBoard(row + 2 * direction, column) &&
              board[row + 2 * direction][column] == null &&
              board[row + direction][column] == null) {
            candidateMoves.add([row + 2 * direction, column]);
          }
        }

        //can kill diagonally
        if (isInBoard(row + direction, column - 1) &&
            board[row + direction][column - 1] != null &&
            board[row + direction][column - 1]!.isWhite !=
                selectedPiece.isWhite) {
          candidateMoves.add([row + direction, column - 1]);
        }

        if (isInBoard(row + direction, column + 1) &&
            board[row + direction][column + 1] != null &&
            board[row + direction][column + 1]!.isWhite !=
                selectedPiece.isWhite) {
          candidateMoves.add([row + direction, column + 1]);
        }

        break;
      case ChessPieceType.rook:
        //horizontal and vertical directions
        var rookMoves = {
          [-1, 0], //up
          [1, 0], //down
          [0, -1], //left
          [0, 1], //right
        };

        for (var direction in rookMoves) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newColumn = column + i * direction[1];
            if (!isInBoard(newRow, newColumn)) {
              break;
            }
            if (board[newRow][newColumn] != null) {
              if (board[newRow][newColumn]!.isWhite != selectedPiece.isWhite) {
                candidateMoves.add([newRow, newColumn]); //kill
              }
              break; //blocked
            }
            candidateMoves.add([newRow, newColumn]);
            i++;
          }
        }

        break;
      case ChessPieceType.knight:
        //L move directions
        var knightMoves = {
          [-2, 1], //up 2 right 1
          [-2, -1], //up 2 left 1
          [-1, 2], //up 1 right 2
          [-1, -2], //up 1 left 2
          [2, 1], //down 2 right 1
          [2, -1], //down 2 left 1
          [1, 2], //down 1 right 2
          [1, -2], //down 1 left 2
        };

        for (var direction in knightMoves) {
          var newRow = row + direction[0];
          var newColumn = column + direction[1];
          if (!isInBoard(newRow, newColumn)) {
            continue;
          }
          if (board[newRow][newColumn] != null) {
            if (board[newRow][newColumn]!.isWhite != selectedPiece.isWhite) {
              candidateMoves.add([newRow, newColumn]); //kill
            }
            continue; //blocked
          }
          candidateMoves.add([newRow, newColumn]);
        }
        break;
      case ChessPieceType.bishop:
        //diagonal move directions
        var bishopMoves = {
          [-1, 1], //up right
          [-1, -1], //up left
          [1, 1], //down right
          [1, -1], //down left
        };

        for (var direction in bishopMoves) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newColumn = column + i * direction[1];

            if (!isInBoard(newRow, newColumn)) {
              break;
            }
            if (board[newRow][newColumn] != null) {
              if (board[newRow][newColumn]!.isWhite != selectedPiece.isWhite) {
                candidateMoves.add([newRow, newColumn]); //kill
              }
              break; //blocked
            }
            candidateMoves.add([newRow, newColumn]);
            i++;
          }
        }
        break;
      case ChessPieceType.queen:
        //all eight directions
        var queenMoves = {
          [-1, 0], //up
          [1, 0], //down
          [0, 1], //right
          [0, -1], //left
          [-1, 1], //up right
          [-1, -1], //up left
          [1, 1], //down right
          [1, -1], //down left
        };

        for (var direction in queenMoves) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newColumn = column + i * direction[1];

            if (!isInBoard(newRow, newColumn)) {
              break;
            }
            if (board[newRow][newColumn] != null) {
              if (board[newRow][newColumn]!.isWhite != selectedPiece.isWhite) {
                candidateMoves.add([newRow, newColumn]); //kill
              }
              break; //blocked
            }
            candidateMoves.add([newRow, newColumn]);
            i++;
          }
        }
        break;
      case ChessPieceType.king:
        //all eight directions
        var kingMoves = {
          [-1, 0], //up
          [1, 0], //down
          [0, 1], //right
          [0, -1], //left
          [-1, 1], //up right
          [-1, -1], //up left
          [1, 1], //down right
          [1, -1], //down left
        };

        for (var direction in kingMoves) {
          var newRow = row + direction[0];
          var newColumn = column + direction[1];

          if (!isInBoard(newRow, newColumn)) {
            continue;
          }

          if (board[newRow][newColumn] != null) {
            if (board[newRow][newColumn]!.isWhite != selectedPiece.isWhite) {
              candidateMoves.add([newRow, newColumn]); //kill
            }
            continue; //blocked
          }

          candidateMoves.add([newRow, newColumn]);
        }
        break;
      default:
    }
    return candidateMoves;
  }

  //move piece (tapping empty square throws error and tapping it after selecting a piece copies its move directions like there is a in where you tapped.)

  void movePiece(var newRow, var newColumn) {
    //if the new spot has an enemy piece
    //add the captured piece to the appropriate captured list
    if (board[newRow][newColumn] != null) {
      var capturedPiece = board[newRow][newColumn];
      if (capturedPiece!.isWhite) {
        whitePiecesCaptured.add(capturedPiece);
      } else {
        blackPiecesCaptured.add(capturedPiece);
      }
    }

    //move the piece and clear the old spot
    board[newRow][newColumn] = selectedPiece;
    board[selectedRow][selectedColumn] = null;

    //clear selection
    setState(() {
      selectedPiece = null;
      selectedRow = -1;
      selectedColumn = -1;
      validMoves = [];
    });

    //change turns
    isWhiteTurn = !isWhiteTurn;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Column(
        children: [
          //pieces captured
          Expanded(
            child: GridView.builder(
              itemCount: whitePiecesCaptured.length,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8),
              itemBuilder: (context, index) => CapturedPiece(
                imagePath: whitePiecesCaptured[index].imagePath,
                isWhite: true,
              ),
            ),
          ),

          //chess board
          Expanded(
            flex: 3,
            child: GridView.builder(
              itemCount: 8 * 8,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8),
              itemBuilder: (context, index) {
                int row = index ~/ 8;
                int column = index % 8;

                bool isSelected =
                    selectedColumn == column && selectedRow == row;

                //check if its valid move
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
          ),

          //pieces captured
          Expanded(
            child: GridView.builder(
              itemCount: blackPiecesCaptured.length,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8),
              itemBuilder: (context, index) => CapturedPiece(
                imagePath: blackPiecesCaptured[index].imagePath,
                isWhite: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
