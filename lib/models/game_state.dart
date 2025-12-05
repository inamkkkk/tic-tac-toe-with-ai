import 'dart:math';
import 'package:flutter/material.dart';

class GameState extends ChangeNotifier {
  List<String?> board = List.filled(9, null);
  String currentPlayer = 'X';
  String? winner;
  bool isDraw = false;

  void makeMove(int index) {
    if (board[index] == null && winner == null && !isDraw) {
      board[index] = currentPlayer;
      _checkWinner();
      _checkDraw();

      if (winner == null && !isDraw) {
        currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
        if (currentPlayer == 'O') {
          _makeAIMove();
        }
      }
      notifyListeners();
    }
  }

  void _makeAIMove() {
    if (winner == null && !isDraw) {
      int bestMove = _getBestMove();
      if (bestMove != -1) {
        board[bestMove] = currentPlayer;
        _checkWinner();
        _checkDraw();
        if (winner == null && !isDraw) {
          currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
        }
        notifyListeners();
      }
    }
  }

  int _getBestMove() {
    List<int> availableMoves = [];
    for (int i = 0; i < board.length; i++) {
      if (board[i] == null) {
        availableMoves.add(i);
      }
    }

    if (availableMoves.isEmpty) {
      return -1;
    }

    // Basic AI: Choose a random available move
    final random = Random();
    return availableMoves[random.nextInt(availableMoves.length)];
  }

  void _checkWinner() {
    const winningCombinations = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var combination in winningCombinations) {
      final pos1 = board[combination[0]];
      final pos2 = board[combination[1]];
      final pos3 = board[combination[2]];

      if (pos1 != null && pos1 == pos2 && pos2 == pos3) {
        winner = pos1;
        return;
      }
    }
  }

  void _checkDraw() {
    if (!board.contains(null) && winner == null) {
      isDraw = true;
    }
  }

  void resetGame() {
    board = List.filled(9, null);
    currentPlayer = 'X';
    winner = null;
    isDraw = false;
    notifyListeners();
  }
}