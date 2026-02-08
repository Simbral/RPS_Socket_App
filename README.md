# Rock–Paper–Scissors Multiplayer Game (Flutter + Python Sockets)

## Project Overview

This project is a **2-Player Rock–Paper–Scissors mobile application** that demonstrates **client–server communication using TCP sockets**.
The mobile app is built using **Flutter**, and the backend game logic is implemented using a **Python Socket Server**.

Two players connect to the server over the same network, send their moves (Rock, Paper, or Scissors), and receive the game result in real time.

---

## Features

* Multiplayer gameplay (2 devices)
* Client–Server Architecture
* Real-time move exchange using TCP sockets
* Automatic Player 1 / Player 2 assignment
* Scoreboard (Wins, Losses, Draws)
* **Best of 5** match system
* Color-coded game results (Win / Lose / Draw)
* Play Again and New Match functionality

---

## Technologies Used

| Component          | Technology                 |
| ------------------ | -------------------------- |
| Mobile Application | Flutter (Dart)             |
| Backend Server     | Python                     |
| Networking         | TCP Socket Programming     |
| Platform           | Android (Phone & Emulator) |
---

## How to Run the Project

### Step 1: Start Python Server

1. Open terminal in `python_server` folder
2. Run:
python server.py
Server will display:
Server started. Waiting for players...

---

### Step 2: Connect Devices

* Connect both devices (phone/emulator) to the **same Wi-Fi network**
* Ensure firewall allows Python

---

### Step 3: Run Flutter App

Check devices:
flutter devices
Run on Device 1:
flutter run -d <device_id>
Run on Device 2:
flutter run -d <device_id>
---

### Step 4: Play the Game

1. Both players select Rock / Paper / Scissors
2. Server calculates winner
3. Result appears on both devices
4. Continue until Best-of-5 match completes

---

## Game Logic

* Rock beats Scissors
* Scissors beats Paper
* Paper beats Rock
* First player to win **3 rounds** wins the match

---

## Educational Objectives

This project demonstrates:

* Socket Programming Concepts
* Client–Server Architecture
* Real-Time Data Transmission
* Mobile Application Development using Flutter
* Network Communication between Multiple Devices
