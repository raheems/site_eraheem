---
title: Git Essentials for Data Scientists
authors: []
date: '2020-11-22'

slug: 'git-essentials-data-scientists'
subtitle: "Git is a must have tool in a data scientist's arsenal"
summary: "I describe what is git and how to use git in your data science workflow. Git is mostly used by software developers. But as data scientists are are more and more working with software developers, data engineers and IT/devOps people, they need to understand at least the essentials of git and how to use it. I've put together the bare essentials to get you started."
categories: ["Data Science"]
tags: ["git"]
lastmod: ''

featured: yes
image:
  placement: 1
  caption: "Photo by Enayet Raheem on Unsplash"
  focal_point: "Center"
  preview_only: false
projects: []
diagram: true
draft: true 
---

I describe what is git and how to use git in your data science or analytic workflow. Git is mostly used by software developers. But as data scientists are more and more working with software developers and data enginerss and other devops people, they need to understand at least the very basics of git and how to use it.  

{{% toc %}}

## What is git?

The way I see giit is the following. It may not be technically correct, but its how I understand it. 

Git is a version control system which can be used as a tool to track all the changes you make to your tex-like documents such as codes written in your favorite languages--R, Python, SAS, SQL or whatever.

You can also think of git as a central backup of you codes which you can access, download, make changes, and then backup them up again using only a handful of commands. 

## Why git?

```r
git pull
git add --all
git commit -m "updated the feature 1"
git push origin master
```


{{< youtube >}}

```mermaid
graph LR
A[Repository] -->|Text| -B(Local repository)
A[Repository] --> B(Remote repository)
B(Remote repository) --> C(git pull <br> git add --all <br> git commit -m 'commit message' <br> git push origin master )

```