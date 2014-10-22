---
layout: post
title: Setting the Syntax for Files with Multiple Extensions in Sublime Text
---

For a while I’ve had the frustration of any files with a `.erb` extension opening in Sublime Text with the HTML (Rails) syntax coloring. I have some SASS stylesheets that I’d like to run through the Ruby interpreter, so they need the `.erb` extension, but I want the syntax coloring from the [Sass package](https://sublime.wbond.net/packages/Sass).

None of the `.sublime-settings` files that came with the default install of Sublime Text had file extension patterns for anything but single extensions, but it turns out that the same approach works for any arbitrary string of text following a dot, even if that string includes dots: `css.scss.erb` works just as well as `erb` would. My extension patterns for Sass and HTML (Rails) syntax coloring now look like the following.

```
// Sass.sublime-settings
{
  "extensions": [
    "scss.erb",
    "scss"
  ]
}
```

```
// HTML (Rails).sublime-settings
{
  "extensions": [
    "html.erb"
  ]
}
```