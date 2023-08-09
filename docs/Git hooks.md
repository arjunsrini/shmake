# Git hooks

### What are git hooks?

Tk.

### How are we using git hooks?

Navigate to the .git/hooks directory inside your repository and create a file named pre-push. Make sure it's executable:

```
chmod +x .git/hooks/pre-push
```

Edit the pre-push File: Add the following content to call your script:

```
#!/bin/sh

# Path to your script
./shmake/aws/upload.sh
```
