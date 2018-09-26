---
layout: post
title: Using Object Literals in render() in React
excerpt: "A quick example using an object literal for selective content display in React"
type: tech_note
date: 2018-09-26T05:19:00+02:00
---
I’ve been reading the [Full Stack React](https://www.fullstackreact.com/) book and came across this neat trick that had never occurred to me before for whatever reason.

{% raw %}
``` javascript
{{
    SAVING: <input value='Saving…' type='submit' disabled />,
    SUCCESS: <input value='Saved!' type='submit' disabled />,
    ERROR: <input value='Save Failed - Retry?' type='submit' />,
    READY: <input value='Submit' type='submit' />
}[this.state._saveStatus]}
```
{% endraw %}

There’s a flag set in the state variable `_saveStatus` that will have one of the following values: `SAVING`, `SUCCESS`, `ERROR`, or `READY`. Define an object literal tieing each of four different pieces of content (in this case Submit buttons in different states) to one of these keys, and then select the appropriate piece of content by grabbing the value from the appropriate key in that object.

This immediately struck me as a succinct and useful technique. It had never occurred to me myself. I love it when that happens.