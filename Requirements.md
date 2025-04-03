# Connect Four Dart Console Application

## Objective

The objective of this assignment is to gain hands-on experience in creating console-based applications in Dart [¹], leveraging Dart APIs for:

- Collections
- I/O
- Networking

## Description

You are to write a **Dart console application** [³] for playing **Connect Four (C4)** using a Connect Four **web service implemented in PHP**. Your application should:

- Provide a user-friendly **command-line interface**.
- **Not replicate** any game logic already implemented on the server.

You may use the reference implementation available at:  
🔗 https://www.cs.utep.edu/cheon/cs3360/project/c4/

---

## Requirements

### Functional & Non-Functional Requirements

- **R1.** Allow the user to specify a Connect Four web server and interact with any web service implementing the Connect Four API.
- **R2.** Enable the user to select one of the strategies supported by the server.
- **R3.** Allow the user to drop a token into any valid column of the board.
- **R4.** Display the game’s progress and current state:
    - Board configuration
    - Last token placed by the server
    - Game outcome (win/loss/draw)
- **R5.** Highlight the winning or losing sequence of four consecutive tokens when the game ends.
- **R6.** Follow the **Model-View-Controller (MVC)** design pattern [²]:
    - Ensure model classes are fully decoupled from the view and controller.
    - Introduce **at least one class** each for **Model**, **View**, and **Controller**.
- **R7.** Handle errors such as:
    - Network issues
    - Invalid user inputs
    - Show appropriate error messages.
- **R8.** Include proper documentation using **Dartdoc** comments.

---

## Implementation

- **(100 points)**: Design and implement the application using **unique Dart features** where appropriate.
- **Bonus (+10 points and up)**: Implement a **"cheat" mode** that suggests the best move:
    - Use the **Strategy design pattern** to support multiple algorithms.
    - Additional points for detecting advanced winning/losing sequences:
        - Examples: `XOO_OX`, `_OOO_`
    - Extra credit for creating a cheat mode that can outperform the server’s **Smart strategy**.

---

## Testing

- Your application must **compile and run** with Dart **2.0 or later**.
- Test thoroughly to ensure correctness.

---

## Submission

Submit a **single ZIP archive** containing your source code. The ZIP should have a root directory named:

```
YourFirstNameLastName/
```

### Include:
- `contribution-form.docx` (if working in pairs)
- `pubspec.yaml`
- `bin/main.dart`
- `lib/` (Dart source code files and directories)

### Exclude:
- Build files
- Non-source code directories and files

🕛 **Submit by 11:59 PM on the due date**.  
👥 Only **one submission per pair**, with both names and a signed contribution form.

---

## Demo

You will need to **demo your app** to the course staff.

---

## Grading Criteria

Your assignment will be graded based on:

1. **Functionality**  
   Meeting all the specified requirements.

2. **Code Quality**  
   Organization, documentation, and absence of syntax/logic errors.

3. **Design**  
   Proper use of the **MVC** pattern, separation of concerns.

4. **Error Handling**  
   Effective error management and clear user messages.

5. **Bonus**  
   Successfully implemented **cheat mode**.

6. **Documentation**  
   Completeness and accuracy of **Dartdoc** comments.

7. **Presentation**  
   Organization and naming conventions.
