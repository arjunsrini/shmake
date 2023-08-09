# Git hooks

### What are git hooks?

Tk.

### How are we using git hooks?

Navigate to the .git/hooks directory inside your repository and create a file named post-push. Make sure it's executable:

```
chmod +x .git/hooks/post-push
```

Edit the post-push File: Add the following content to call your script:

```
#!/bin/sh

# Path to your script
./shmake/aws/upload.sh
```
