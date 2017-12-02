---
layout: post
title: Sass Variables in CSS calc() Functions
excerpt: "A reminder to use variable interpolation with Sass variables in CSS calc() functions"
type: tech_note
date: 2017-12-02T06:33:01-05:00
---

The most common use cases for variables in Sass allow you to drop variables directly into Sass stylesheets, so it’s easy to forget (or not to know in the first place) that there are certain circumstances where the interpolation syntax is necessary. The one I always forget is to use interpolation inside of CSS functions, like `calc()`.

The concept of ‘[interpolation](https://en.wikipedia.org/wiki/String_interpolation)’ just refers to the replacement of a placeholder with its literal value, so really in the case of processing Sass to CSS almost all of your references to variables are probably setting up an interpolation. That’s what’s happening when `color: $alertColor;` in your Sass gets changed to `color: #f00;` in your CSS output.

There are instances, however, in which the Sass preprocessor will not perform this substitution unless you *explicitly* specify interpolation using the `#{}` syntax. The [Sass documentation](http://sass-lang.com/documentation/file.SASS_REFERENCE.html#Interpolation_____) explains that the interpolation syntax is necessary when using variables to construct selector and property names and may be used in property values except that it is only necessary in cases where operators next to it should be treated as plain CSS.

There is another case where the interpolation syntax is necessary, however, and it’s the one with which a recent (repeat) stumble inspired me to write up this note. Sass does not by default process the contents of CSS functions, so the line `min-height: calc($headerHeight - 2rem);` will be rendered to the CSS output with no change as `min-height: calc($headerHeight - 2rem);` (which is not valid CSS).

It is necessary to use interpolation explicitly to get the desire result in this case, so the correct line `min-height: calc(#{$headerHeight} - 2rem);` will produce CSS output such as `min-height: calc(50px - 2rem);` if the value of `$headerHeight` is `50px`.