# Contributing to Atmosphere Weather

First off, thank you for considering contributing to **Atmosphere Weather**! It's people like you that make this open-source project such a wonderful and creative tool.

---

## Code of Conduct

This project and everyone participating in it is governed by the [Atmosphere Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

---

## How Can I Contribute?

### Reporting Bugs
- Ensure the bug was not already reported by searching on GitHub under [Issues](https://github.com/kaybrian/atmosphere-weather/issues).
- If you're unable to find an open issue addressing the problem, open a new one using the **Bug Report** template.
- Include a clear title and description, as much relevant information as possible, and a code sample or test case demonstrating the unexpected behavior.

### Suggesting Enhancements
- Open a **Feature Request** issue detailing your idea.
- Explain why this enhancement would be useful to most users and how it aligns with the project's creative aesthetics.

### Pull Requests
1. Fork the repository and create your branch from `main`.
2. Ensure dependencies are up to date (`flutter pub get`).
3. If you've added code that should be tested, add unit/widget tests in `test/`.
4. Ensure the test suite passes:
   ```bash
   flutter test
   ```
5. Ensure static analysis is completely clean:
   ```bash
   flutter analyze
   ```
6. Format your code:
   ```bash
   dart format lib test
   ```
7. Open a Pull Request with a descriptive title and reference any related issues.

---

## Style Guidelines

- **Architecture**: Keep presentation, domain/business logic, and data layers decoupled (MVVM).
- **Aesthetics**: UI should feel modern, creative, and responsive. Use glassmorphism, harmonious palettes, and smooth 60fps animations.
- **Flutter Standards**: Prefer Flutter 3.24+ APIs (e.g. `Color.withValues(alpha: ...)` rather than deprecated `withOpacity`).
