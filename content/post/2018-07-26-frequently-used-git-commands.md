---
title: Frequently used git commands
author: ['Enayetur Raheem']
date: '2018-07-26'
lastmod: '2018-07-30'
slug: frequently-used-git-commands
categories:
  - Notes
tags: []
header:
  caption: ''
  image: ''
---

Thinking of using github? Great!

Github needs no introduction. If you are unfamiliar with git, its a version control system for tracking changes in computer (programming) codes. "GitHub Inc. is a web-based hosting service for version control using Git. It is mostly used for computer code. It offers all of the distributed version control and source code management functionality of Git as well as adding its own features."[^wikipedia]
[^wikipedia]: [Wikipedia](https://www.wikipedia.org)

{{% toc %}}

# Copying a remote repository to local

To bring a remote repository to your local host (computer where you are working), use the `git clone` command.

```{git}
git clone https://github.com/username/repository_name.git
```

# Publishing the changes

After you update your code or add or remove anything from the repository, you want to publish to the remote repository. 

Publishing the changes is called `push` in git jargon. For that you need to write the following codes.

```{git}
git add -A 
git commit -m "Message/notes of what the changes are"
```
This will update the local repository. Now you want to publish the changes using the following command

```{git}
git push
```

You may want to be more specific about which *remote* to update. The default *remote* is **origin**. The command would be 

```{git}
git push origin master
```

# Syncing a remote repository on two local hosts

Sometime I work on two or three different computers for the same remote project. I want my codes to be synced accross multiple computers. I sometime work from office using a PC. Sommetime I work from home where I use a Mac. So keeyping the repositories in sycned is essential.

For that I follow these simple steps.

```
- Pull the remote repository in your new workstation
- Make changes to your code
- Push (publish) the updates
```

The key is to pull and update the local repository assuming the remote has the latest updates.

```{git}
git pull
git add -A
git comit -m "Update message"
git push origin master
```



