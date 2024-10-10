<h1 align="center">🎯 Contributing to Minds Dart SDKt 🎯</h1>
<br />
<p align="center">
    <img alt="hero" width="450" src="https://cdn.prod.website-files.com/62a8755be8bcc86e6307def8/634af4c6bca0d233ef86835a_Mindsdb%20white%20logo.png" />
</p>

> [!NOTE]
>
> We appreciate your interest in contributing to the **Minds Dart SDK**. By contributing, you can help improve the functionality and make the SDK better for everyone. This guide provides everything you need to know about contributing to this repository.

## 🛠️ Getting Started

### 1. Fork the repository

Fork the repository to your GitHub account by clicking the **"[Fork](https://github.com/ArnavK-09/mdb_dart/fork)"** button at the top of the page.

### 2. Clone your fork

Clone your forked repository to your local machine.

###### terminal

```bash
git clone https://github.com/YOUR_USERNAME/mdb_dart.git
```

### 3. Create a new branch

Create a new branch for your feature or bug fix.

###### terminal

```bash
git checkout -b feature/amazing-feature
```

### 4. Make your changes

Make your changes to the codebase. Be sure to **write tests** if appropriate and ensure everything works.

### 5. Run tests

Before committing, make sure **all tests pass** to avoid breaking changes.

###### terminal

```bash
dart test
```

### 6. Commit your changes

We follow **[Conventional](https://gist.github.com/Zekfad/f51cb06ac76e2457f11c80ed705c95a3) Commits** with emojis. Please follow this format when committing changes:

###### expected commit format

```
(emoji) (type): (description)
```

#### Common Commit Types and Emojis:

- 🏫 **build**: Changes affecting the build system or external dependencies.
- 🎬 **ci**: Changes to CI configuration files and scripts.
- 🌡️ **chore**: Non-source code changes (e.g., build process, tools).
- 🎲 **docs**: Documentation-only changes.
- 🌟 **feat**: A new feature.
- 🐛 **fix**: A bug fix.
- 🐰 **perf**: Performance improvements.
- 🚀 **refactor**: Code changes that don't add a feature or fix a bug.
- ⭕ **revert**: Reverting a previous commit.
- 🎀 **style**: Code formatting changes, no logic updates.
- 🧪 **test**: Adding or updating tests.

**Examples:**

- 🌟 feat: Add support for real-time streaming
- 🐛 fix(api): Correct data fetching from API
- 🎲 docs: Update README with latest usage examples
- 🌟 feat(scope)!: Breaking change or feature rework

> For breaking changes, use `feat!` or `feat(scope)!`.

### 7. Push to your branch

Push your changes to your branch.

###### terminal

```bash
git push origin feature/amazing-feature
```

### 8. Open a Pull Request

Submit a **Pull Request (PR)** from your branch to the main repository. Ensure your PR includes:

- A clear **description** of the problem and solution.
- A link to the related **issue** (if applicable).

---

## 📋 Development Guidelines

- Ensure that your code adheres to the [**Dart style guide**](https://dart.dev/guides/language/effective-dart/style).
- Always **write tests** for new features or bug fixes whenever possible.
- Keep your commits **small and focused**. Avoid combining multiple fixes or features in one commit.

---

<p align="center">
    <strong>Thank you for taking the time to contribute! Every improvement, bug fix, and feature makes this SDK better. If you have any questions, feel free to open an issue or contact!</strong>
</p>
