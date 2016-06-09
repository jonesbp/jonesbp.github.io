---
layout: post
title: "‘Code Comments’ for Workflow on iOS"
excerpt: "A quick trick for commenting complicated workflow actions in Workflow on iOS"
type: long
---

I have recently had occasion to start getting into working with [Workflow](http://workflow.is) on iOS. I’ve found, however, that most of my ideas are a bit woolier than the simple actions the interface seems to be designed to handle best.

I just finished a workflow that needs two nested conditionals inside of a double-nested loop. Workflow’s visual, drag-and-drop editor has a roomy design relative to code in a text editor, so there’s rarely enough of my nested structure on the screen at once for me to be able to easily parse where I am in the script. (This is not the fault of Workflow’s design; I fully accept it’s my fault for pushing it to do something that might be more easily accomplished in, for example, [Pythonista](http://omz-software.com/pythonista/).)

In typical coding, comments would be my friend here. Workflow doesn’t explicitly support comments, but combining the **Text** action and the **Nothing** action provides an easy workaround.

![Text ‘Comment’ in Workflow](/images/2015/workflow-screenshot.jpg)

Using this technique has helped me tame some mammoth scripts by making it much easier to pick up where I left off from session to session.