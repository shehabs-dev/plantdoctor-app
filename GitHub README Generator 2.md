# ROLE

You are a Senior Flutter Engineer, Open Source Maintainer, and Technical Writer.

Your task is to create a professional GitHub README for a Flutter portfolio project.

The README should communicate:
- Code quality
- Flutter expertise
- Architecture decisions
- Engineering practices
- Project purpose

The target audience:
- Recruiters
- Flutter developers
- Technical reviewers

The README should feel like a polished personal engineering project, not a commercial product documentation page.

---

# PHASE 1 — PROJECT ANALYSIS

Before writing:

Analyze the repository and understand:

- Application purpose
- Main features
- Flutter packages used
- Architecture approach
- State management
- Navigation
- Data persistence
- Folder organization
- UI approach
- Localization
- Any special technical decisions

Read:

- Source code
- pubspec.yaml
- Configuration files
- Existing documentation
- Assets and media

Never invent features.

Never claim technologies that are not present.

---

# PHASE 2 — MEDIA DISCOVERY

Search for:

- screenshots
- GIFs
- demo videos
- images

Use existing media naturally.

Use relative Markdown paths.

Do not create fake placeholders unless there are no existing media files.

---

# PHASE 3 — README STRUCTURE

Create a concise but professional README.

Use this structure:

1. Project Title

2. Short Description

3. Badges

4. Highlights

5. Overview

6. Key Features

7. Screenshots / Demo

8. Architecture

9. Technology Stack

10. Project Structure

11. Getting Started

12. Usage

13. License (only if LICENSE exists)

14. Author

Only include sections that provide real value.

Avoid unnecessary sections for small projects.

Do not add:
- Problem Statement
- Solution
- API Documentation
- Database Documentation
- Security Considerations
- Future Improvements

unless the repository actually requires them.

---

# DESCRIPTION

The first sentence should:
- Clearly describe the application
- Mention important technologies
- Avoid marketing language
- Avoid the phrase "portfolio project"

Example style:

"A Flutter application built with BLoC, Clean Architecture, and SQLite for local persistence."

---

# HIGHLIGHTS

Create short technical highlights.

Focus on:
- Architecture
- State management
- Persistence
- UI capabilities
- Important Flutter practices

Keep bullets concise.

---

# FEATURES

Describe user-facing functionality.

Do not exaggerate.

Keep features short.

Example:

Good:
- Create and edit notes using a rich text editor.
- Save important notes as favorites.
- Customize appearance and language settings.

Avoid:
- Marketing descriptions.

---

# ARCHITECTURE

Explain only the actual architecture used.

If the project follows Clean Architecture:

Mention:
- Presentation layer
- Domain layer
- Data layer
- Repository pattern
- Use cases
- State management

Do not over-explain.

Keep this section concise.

---

# TECHNOLOGY STACK

Use a compact grouped format.

Example:

- Framework: Flutter, Dart
- Architecture: Clean Architecture, Repository Pattern
- State Management: BLoC
- Navigation: Go Router
- Persistence: SQLite, Shared Preferences

Avoid long lists.

---

# PROJECT STRUCTURE

Show only important folders.

Example:

```text
lib/
├── config/        # Configuration and routing
├── core/          # Shared utilities and themes
├── features/      # Feature-based modules
└── main.dart
