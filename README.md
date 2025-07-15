# Software-Construction

**End-to-End Submission and Grading Automation Suite – Python & Shell**

- Build a command line tool to submit, fetch, mark, test, report, summarise and delete files.
- Implemented a timestamp versioning to store and retrieve file submissions, enabling traceability, rollback, and reproducible grading. This automates manual file management.
- Streamlined educator workflows by allowing real-time feedback, CLI-driven grading, and automated test execution against user code. This can save markers 100’s of hours per semester.

**Custom Git Version Control System in both Python & Shell**

- Handled edge cases like forced deletions, merge-safe branching, commit message validation, and accurate file state reporting across working, index, and commit directories.
- Architected a simplified Git alternative from the ground up, implementing core commands (`init`, `add`, `commit`, `status`, `branch`, etc.) to manage code changes, history, and branching across environments.
- Designed the internal system for state tracking using layered directories (working copy, index, repository), file diffing, and commit logs to enable reproducible workflows without external libraries.
- Applied single-responsibility design for each command, standardized validation, and comprehensive edge-case handling thus ensuring the system was modular, testable, and maintainable for real-world production use.

**Implemented sed functionality in python**

- Handled semicolon-separated and newline-separated commands with support for piped stdin input and stdout output for easy shell use.
- Built a simplified version of the Unix “sed” tool in Python, allowing users to find, change, print, or remove lines of text using line numbers or patterns.
- Engineered a flexible input system that accepts multiple commands at once and works smoothly with other programs through standard input and output.
- Structured the system with modular parsing and execution layers, enabling accurate command chaining, extensibility, and maintainability aligned with Unix and Pythonic design principles.
