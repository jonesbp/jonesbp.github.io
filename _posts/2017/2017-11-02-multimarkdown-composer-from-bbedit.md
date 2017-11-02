---
layout: post
title: Open a File in MultiMarkdown Composer from BBEdit
excerpt: "A very simple AppleScript for opening the frontmost BBEdit file in MultiMarkdown Composer"
type: tech_note
date: 2017-11-02T11:46:01-04:00
---

Sometimes I find myself doing more extensive writing in a Markdown file in BBEdit than I had anticipated and want to switch to a more focused environment. My preferred Markdown editing environment for longer writing sessions is MultiMarkdown Composer, so I’ve added an AppleScript to BBEdit’s scripts menu to open whatever file I’m currently working on in with that. The script follows and, as you will see, can be easily edited to work with any other text editor you prefer.

``` applescript
tell application "BBEdit"    set markdownFile to file of front windowend telltell application "MultiMarkdown Composer"    open markdownFile    activateend tell
```

That’s it.

Save the file in `~/Library/Application Support/BBEdit/Scripts`. You can get to this folder from the Finder by holding the ‘Option’ key while selecting the ‘Go’ menu in order to expose the ‘Library’ item which is usually hidden. A new item with the name of whatever you’ve named your script file will now appear in BBEdit’s script menu (identified by the AppleScript paper scroll icon).

You can add another layer of convenience by adding a keyboard shortcut for this action using the ‘Keyboard’ pane in the System Preferences application. Having opened the ‘Keyboard’ pane, go to the ‘Shortcuts’ tab and select ‘App Shortcuts’ from the sidebar. Click the ‘+’ button below the list on the right side and select ‘BBEdit’ as the Application, type your menu’s title exactly as it appears in the application, and set your keyboard shortcut. I use `Shift+Cmd+M`.
