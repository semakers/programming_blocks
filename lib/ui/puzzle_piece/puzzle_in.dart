import 'package:flutter/material.dart';
import 'package:programming_blocks/models/puzzle_piece_data.dart';
import 'package:programming_blocks/ui/puzzle_piece/puzzle_polygon.dart';

class PuzzleIn extends StatelessWidget {
  const PuzzleIn({
    Key? key,
    required this.puzzlePieceData,
  }) : super(key: key);

  final PuzzlePieceData puzzlePieceData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: puzzlePieceData.topPadding,
      ),
      child: PuzzlePolygon(
        sides: puzzlePieceData.sides,
        size: puzzlePieceData.size + 2,
        color: Colors.white,
        leftPadding: puzzlePieceData.sides <= 3
            ? 0
            : puzzlePieceData.sides == 4
                ? 0.5
                : 1,
      ),
    );
  }
}
