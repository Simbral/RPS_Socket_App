import 'dart:io';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RPSPage(),
    );
  }
}

class RPSPage extends StatefulWidget {
  const RPSPage({super.key});

  @override
  State<RPSPage> createState() => _RPSPageState();
}

class _RPSPageState extends State<RPSPage> {
  // Connection / role
  String playerRole = "Connecting...";
  String result = "Choose Rock, Paper or Scissors";
  bool isLoading = false;

  // Scoreboard
  int wins = 0;
  int losses = 0;
  int draws = 0;
  int round = 1;

  // Replace with your laptop IP if it changes
  final String serverIp = "192.168.31.230";
  final int serverPort = 9999;

  Color getResultColor(String text) {
    if (text.toUpperCase().contains("WIN")) {
      return Colors.green.shade400;
    } else if (text.toUpperCase().contains("LOSE")) {
      return Colors.red.shade400;
    } else if (text.toUpperCase().contains("DRAW")) {
      return Colors.amber.shade400;
    }
    return Colors.blueGrey.shade200;
  }

  bool isMatchOver() {
    return wins == 3 || losses == 3 || round > 5;
  }

  void resetRoundUI() {
    setState(() {
      result = "Choose Rock, Paper or Scissors";
      isLoading = false;
    });
  }

  void resetMatch() {
    setState(() {
      wins = 0;
      losses = 0;
      draws = 0;
      round = 1;
      result = "New Match Started";
      isLoading = false;
    });
  }

  Future<void> sendMove(String move) async {
    setState(() {
      isLoading = true;
      result = "Waiting for opponent...";
    });

    try {
      Socket socket = await Socket.connect(serverIp, serverPort);

      // First message from server should be ROLE
      socket.listen((data) {
        String message = String.fromCharCodes(data);

        if (message.startsWith("ROLE:")) {
          setState(() {
            playerRole = message.replaceFirst("ROLE:", "");
          });
          // After receiving role, send move
          socket.write(move);
        } else {
          setState(() {
            result = message;
            isLoading = false;

            if (message.contains("YOU WIN")) {
              wins++;
            } else if (message.contains("YOU LOSE")) {
              losses++;
            } else if (message.contains("DRAW")) {
              draws++;
            }

            round++;
          });
          socket.close();
        }
      });
    } catch (e) {
      setState(() {
        result = "⚠️ Could not connect to server";
        isLoading = false;
      });
    }
  }

  Widget moveButton(String label, String emoji, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 22),
      ),
      onPressed: (isLoading || isMatchOver()) ? null : () => sendMove(label),
      child: Text(
        "$emoji  $label",
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget scoreChip(String label, int value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Column(
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 12, color: color, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(value.toString(),
              style: TextStyle(
                  fontSize: 18, color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Card(
            elevation: 10,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(playerRole,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text("Rock Paper Scissors Game",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                const Text("Score Board",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    scoreChip("Wins", wins, Colors.green),
                    scoreChip("Losses", losses, Colors.red),
                    scoreChip("Draws", draws, Colors.amber),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: getResultColor(result),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(result,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
                const SizedBox(height: 16),
                if (isMatchOver())
                  Column(
                    children: [
                      Text(
                        wins > losses ? "MATCH WON!" : "MATCH LOST!",
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: resetMatch,
                        child: const Text("NEW MATCH"),
                      )
                    ],
                  )
                else if (isLoading)
                  const CircularProgressIndicator()
                else ...[
                  moveButton("ROCK", "🪨", Colors.deepPurple),
                  const SizedBox(height: 12),
                  moveButton("PAPER", "📄", Colors.indigo),
                  const SizedBox(height: 12),
                  moveButton("SCISSORS", "✂️", Colors.pinkAccent),
                  const SizedBox(height: 12),
                  Text("Round $round of 5"),
                  TextButton(
                    onPressed: resetRoundUI,
                    child: const Text("PLAY AGAIN"),
                  )
                ]
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
