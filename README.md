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

## 🌐 SEO Keywords

`8086 Assembly Calculator`, `x86 DOS calculator`, `MASM calculator example`, `Assembly language project`, `simple calculator in Assembly`, `DOS int 21h tutorial`, `low-level programming calculator`, `8086 arithmetic operations`
