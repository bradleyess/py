# Python Starter (VSCode)

I use this Python Starter Template whenever starting a new Python project (big or small).
It includes strong opinions as defaults for how to configure an environment and project.

## Motivation

I have always wrestled against setting up Python projects in various workplaces, as it is incredibly easy to get started with Python. That's the problem. There are so many different ways to manage dependencies and virtualenvs, and it seems like everyone is happy to do things their own way.

I'd rather not disagree about things like that and just have a productive base to work from, no matter what operating system I'm using, or if I want to develop from within my browser (as is becoming more and more popular).

## Getting Started

### Known Issues

```bash
Cannot activate the 'Black Formatter' extension because it depends on the 'Python' extension, which is not loaded. Would you like to reload the window to load the extension?
```

This is caused by a race between the Python extension being installed, and Black Formatter. This issue is fixed by simply reloading the window. You will see similar warnings for other packages that depend on the Python extension and they are fixed in the same way.