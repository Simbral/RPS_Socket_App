import socket

def decide(p1, p2):
    if p1 == p2:
        return "DRAW", "DRAW"

    rules = {
        "ROCK": "SCISSORS",
        "PAPER": "ROCK",
        "SCISSORS": "PAPER"
    }

    if rules[p1] == p2:
        return "YOU WIN", "YOU LOSE"
    else:
        return "YOU LOSE", "YOU WIN"

server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.bind(("0.0.0.0", 9999))
server.listen(2)

print("Server started. Waiting for players...")

while True:
    print("\nWaiting for Player 1...")
    player1, addr1 = server.accept()
    player1.send("ROLE:PLAYER 1".encode())
    print("Player 1 connected:", addr1)

    print("Waiting for Player 2...")
    player2, addr2 = server.accept()
    player2.send("ROLE:PLAYER 2".encode())
    print("Player 2 connected:", addr2)

    move1 = player1.recv(1024).decode()
    move2 = player2.recv(1024).decode()

    result1, result2 = decide(move1, move2)

    player1.send(f"Opponent chose {move2}. {result1}".encode())
    player2.send(f"Opponent chose {move1}. {result2}".encode())

    player1.close()
    player2.close()
