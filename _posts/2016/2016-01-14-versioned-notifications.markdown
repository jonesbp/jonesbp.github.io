---
layout: post
title: "Testing Hazel Rule Notifications"
excerpt: "Add a version number to messages when testing Hazel notifications."
type: tech_note
---
Today I was working on a new [Hazel](http://www.noodlesoft.com/hazel.php) rule that uses a JavaScript action. Never having used the JavaScript support in Hazel, I was using notifications to give me some debugging messages. (JavaScript fails silently in Hazel—nice for avoiding annoyance in daily use, but bad for testing.)

The problem was I thought I was seeing really inconsistent results based on the notifications I was getting and not getting. My mistake was assuming that when I wasn’t getting notifications it was because the JavaScript had failed and the notification step of my Hazel rule hadn’t executed.

What was happening instead was that Notification Center was suppressing duplicate notification messages made under a certain time threshold. Notifications that I assumed weren’t displaying because the rule was terminated before they were triggered were in fact not displaying because they duplicated a recent notification.

My solution was simply to add a `v1`, `v2`, `v3`, etc. versioning tag to my notification messages as I tested new steps to force the messages to be unique.