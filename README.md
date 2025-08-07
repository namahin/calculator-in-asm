# Simple 8086 Assembly Calculator

This is a **simple calculator program written in x86 Assembly (8086)** using **DOS interrupts (`int 21h`)**. It allows basic arithmetic operations on single-digit inputs: **Addition, Subtraction, Multiplication, Division, and Modulus**. Built using MASM/TASM for learning and practicing low-level programming.

## 🔢 Features

* User input using DOS interrupt `int 21h`
* Supports:

  * Addition (+)
  * Subtraction (-)
  * Multiplication (\*)
  * Division (/)
  * Modulus (%)
* Handles:

  * Division by zero error
  * Invalid input
  * Result overflow for >9
  * Negative subtraction output
* Options to **clear the screen** or **exit** the program

## 🖥 Requirements

* 8086 emulator (e.g., emu8086)

## 📷 Demo

```
Choose (+ - * / %), C/c=Clear, X/x=Exit:
Enter first number (0-9):
Enter second number (0-9):
Expression: 3+4 = 7
```

## 🧠 Educational Purpose

This project is created for learning purposes to understand:

* How to work with **registers** and **memory** in Assembly
* Use of **INT 21h** for input/output operations
* Basic structure of an Assembly program

## 📁 File Structure

* `calculator.asm` – Main source code

---

## 📘 Code Explanation (Line by Line)

```asm
.MODEL SMALL
```

* Sets the memory model to SMALL (separate 64KB for code and 64KB for data).

```asm
.STACK 100H
```

* Allocates 256 bytes for the stack (100h = 256 decimal).

```asm
.DATA
```

* Begins the data segment where variables and strings are defined.

### ➤ Messages and Prompts

```asm
menu db 10,13, "Choose (+ - * / %), C/c=Clear, X/x=Exit: $"
```

* Menu prompt with newline (`10`) and carriage return (`13`).

```asm
firstNum db 10,13, "Enter first number (0-9): $"
secondNum db 10,13, "Enter second number (0-9): $"
exprMsg db 10,13, "Expression: $"
resultMsg db " = $"
resultMsg2 db " = -$"
```

* Prompts and result labels, one for positive results (`= $`), and one for negative results (`= -$`).

```asm
errorDiv0 db 10,13,10, "Error! Division by zero.$"
invalidInput db 10,13,10, "Invalid key! Please try again with right key.$"
mathError db 10,13,10, "Math Error! Try with Small Numbers!$"
newline db 10,13, "$"
```

* Error messages for different edge cases.

### ➤ Variables

```asm
choice db ?
num1 db ?
num2 db ?
result db ?
op db ?
```

* Temporary storage for user input, operator, and result.

---

## 📘 Code Segment

```asm
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
```

* Start of main procedure. Initializes DS (Data Segment) with address of data.

---

### 🪄 Main Loop

```asm
start_loop:
    lea dx, menu
    mov ah, 09h
    int 21h
```

* Displays the operation menu using DOS interrupt 21h with AH=09h.

```asm
    mov ah, 01h
    int 21h
    mov choice, al
```

* Reads a character from the user and stores it in `choice`.

### 🛑 Exit & Clear

```asm
    cmp al, 'X'
    je terminator
    cmp al, 'x'
    je terminator
    cmp al, 'C'
    je clear_screen
    cmp al, 'c'
    je clear_screen
```

* Checks if the user chose to exit or clear the screen.

---

### 🧮 Operator Validation

```asm
    cmp al, '+'
    je store_op
    ...
    cmp al, '%'
    je store_op
```

* Compares the input with allowed operators and jumps to store the operator.

```asm
    lea dx, invalidInput
    mov ah, 09h
    int 21h
    jmp start_loop
```

* If the key is invalid, display error and restart loop.

---

### 🧾 Store Operator & Get Numbers

```asm
store_op:
    mov op, al
```

* Store operator character.

```asm
    lea dx, firstNum
    ...
    sub al, 48
    mov num1, al
```

* Prompt and read first digit, convert ASCII to number by subtracting 48.

```asm
    lea dx, secondNum
    ...
    sub al, 48
    mov num2, al
```

* Prompt and read second digit, convert ASCII to number.

---

### 🔄 Operation Matching

```asm
    cmp op, '+'
    je addition
    ...
    cmp op, '%'
    je modulus
```

* Directs control to the selected arithmetic operation.

---

## 🧠 Operation Logic

### ➕ Addition

```asm
addition:
    mov al, num1
    add al, num2
    mov result, al
    jmp show_expression
```

### ➖ Subtraction (Handles Negative Result)

```asm
subtraction:
    mov al, num1
    mov bl, num2
    cmp al, bl
    jg subtract_normally

    mov al, bl
    sub al, num1
    mov result, al
    jmp show_expression2
```

* If `num2 > num1`, show negative result using separate label.

```asm
subtract_normally:
    sub al, bl
    mov result, al
    jmp show_expression
```

### ✖️ Multiplication

```asm
multiplication:
    mov al, num1
    mov bl, num2
    mul bl
    mov result, al
    jmp show_expression
```

### ➗ Division

```asm
division:
    cmp num2, 0
    je div_by_zero
    xor ax, ax
    mov al, num1
    mov bl, num2
    div bl
    mov result, al
    jmp show_expression
```

* Avoids division by zero. AX must be cleared for `DIV`.

### ➗ Modulus

```asm
modulus:
    cmp num2, 0
    je div_by_zero
    xor ax, ax
    mov al, num1
    mov bl, num2
    div bl
    mov result, ah
    jmp show_expression
```

* Remainder from `DIV` is stored in AH.

---

### 🧯 Division by Zero

```asm
div_by_zero:
    lea dx, errorDiv0
    mov ah, 09h
    int 21h
    jmp start_loop
```

---

### 🖨 Show Expression & Result

```asm
show_expression:
    cmp result, 9
    jg result_too_large
```

* Ensures result is single digit.

```asm
    lea dx, exprMsg
    mov ah, 09h
    int 21h
```

* Show “Expression:” label.

```asm
    mov dl, num1
    add dl, 48
    ...
    mov dl, op
    ...
    mov dl, num2
    add dl, 48
```

* Print formatted expression: `num1 op num2`

```asm
    lea dx, resultMsg
    ...
    mov dl, result
    add dl, 48
```

* Display positive result.

```asm
result_too_large:
    lea dx, mathError
    mov ah, 09h
    int 21h
    jmp start_loop
```

* Handles overflow (>9).

```asm
show_expression2:
    ...
    lea dx, resultMsg2
    ...
    ; Similar to above but shows negative sign
```

---

### 🔄 Clear Screen

```asm
clear_screen:
    xor dx, dx
    lea dx, newline
    mov ah, 09h
    int 21h
    jmp start_loop
```

---

### 🔚 Program Exit

```asm
terminator:
    mov ah, 4Ch
    int 21h
```

* Exits the program gracefully.

---


## 🌐 SEO Keywords

`8086 Assembly Calculator`, `x86 DOS calculator`, `MASM calculator example`, `Assembly language project`, `simple calculator in Assembly`, `DOS int 21h tutorial`, `low-level programming calculator`, `8086 arithmetic operations`
