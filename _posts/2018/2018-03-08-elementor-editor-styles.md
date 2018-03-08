---
layout: post
title: Editor-Only CSS for the Elementor Page Builder
excerpt: "How to add CSS specific to the editor view in the Elementor page builder plugin for WordPress"
type: tech_note
date: 2018-03-08T14:55:01-05:00
---
We’ve been experimenting recently with developing some in-house templates and tools to use on client projects based around WordPress and the [Elementor](http://elementor.com) page builder plugin.

One problem that I’ve run into has been to retain the easy copy-editing benefits of using the WP administration panel and Elementor with more advanced interactive elements that might have hidden states on the initial page load. In these cases, the Elementor editor, which uses your theme’s stylesheet to give you WYSIWYG editing, will also hide those elements in the editing view.

I haven’t found this mentioned in the Elementor documentation, but it turns out that it inserts a class `elementor-editor-active` on the `<body>` tag while in the editor. You can add styles to your stylesheet to show or highlight special layout elements in ways they wouldn’t be displayed on the public site in order to help retain the ability to edit text using the visual editor.

Of course, you’re losing some of the WYSIWYG fidelity of using precisely the same styles as the public site, but some thoughtful presentation choices can minimize that downside.