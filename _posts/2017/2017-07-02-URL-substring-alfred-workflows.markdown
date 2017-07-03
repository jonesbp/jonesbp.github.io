---
layout: post
title: "Extracting Substrings from URLs with Alfred Workflows"
excerpt: "A couple of simple example Alfred workflows for extracting strings of data from a URL."
date: 2017-07-03 11:15:00 +2:00
type: long
---

I frequently find myself needing to extract a predictable piece of data from a URL, like a product id, for pasting into a file or database as metadata that might be used to contact an API or construct cleaned-up URLs in the future. The predictable formatting of the part of the URL that I care about makes this the kind of task that perfectly lends itself to simple automation, saving me the small friction of manually editing these URLs in place.

[Alfred workflows](https://www.alfredapp.com/workflows/) are a quick way to run this category of automation. Because the data is in a URL, I’m typically copying the URL from my web browser to the clipboard and pasting it into a text editor or field. With an Alfred workflow, I can run a script on the text from the clipboard and put my desired result back on the clipboard, cleaned up and ready to paste wherever I’d like.

I have several workflows that fit this general use case, and my interaction with all of them follows the following pattern:

- **Me:** Copy my starting text to the clipboard
- **Me:** Invoke the workflow with an Alfred keyword
  + **Alfred:** Grab the contents of the clipboard
  + **Alfred:** Run a short Python script on that data
  + **Alfred:** Copy the result of the script back to the clipboard
  + _(optionally)_ **Alfred:** Paste the result of the script to the currently active window
- **Me:** Paste the text now in the clipboard where I want it if I haven’t already allowed Alfred to do it for me

To take a specific example, we can walk through building a workflow to extract the OCLC number for an edition of a book from a [Worldcat.org](http://worldcat.org) URL.

---

A typical URL for a book on Worldcat.org reached through their onsite search might look like the following:

`http://www.worldcat.org/title/history-and-gis-epistemologies-considerations-and-reflections/oclc/910980341&referer=brief_results`

The only part I care about are the numerals between `/oclc/` and the `&` (in this case, `910980341`). With that unique identifier I can construct my own tidier Worldcat.org URLs later or use their API in a script.

---

![Complete Alfred Workflow Screenshot](/images/2017/OCLC-workflow-overview.jpg)

The screenshot above shows the final layout of the workflow. Assuming we have the URL on the clipboard, the workflow performs the following actions:

1. Launch when invoked with the keyword `oclc` from Alfred
2. Grab the clipboard contents with a bash script
3. Take those contents and match them against a simple regular expression (in this case in a Python script)
4. Copy to the clipboard and paste in the front most app

### 1. Launch

![Launch Settings](/images/2017/OCLC-1-launch.jpg)

In the Alfred workflow editor, create a new ‘Input’ of the ‘Keyword’ type, select the keyword you would like to use to invoke your workflow, and give it a descriptive title.

### 2. Grab Clipboard

Link your ‘Keyword’ input to a new ’Action’ of type ’Run Script’. You can leave all of the sets for this script alone; the default language choice, `/bin/bash`, is what we want in this case. Our script will be a single bash command to grab the contents of the clipboard.

```bash
pbpaste
```

### 3. Find OCLC

Link your `/bin/bash` ‘Run Script’ action to a new ’Action’ of type ’Run Script’. This time we will want to change our settings for the Language to `/usr/bin/python`. (All we’re doing is matching a regular expression which would be possible using any of the language options. I just like Python.)

The script is simple. We take the input from our bash script that grabbed the clipboard contents and we match it against a regular expression that essentially says “Give me the run of numerals that follow the string `/oclc/` in the provided text.” Finally, we write our result to standard output which is how our next Alfred action will receive it.

```python
import re
import sys

url = "{query}"

matchObj = re.search(r'/oclc/([0-9]*)', url)

sys.stdout.write(matchObj.group(1))
```

A couple of things to note:

1. `{query}` is a placeholder Alfred looks for in our script in order to insert whatever string of data is coming from the previous action in our workflow. It is not a standard piece of Python syntax.
2. A ‘regular expression’ is a string of characters that defines a pattern of text. In the case of the above script, it is the part that reads `/oclc/([0-9]*)`, but they can be far more complex. For a good introduction to using regular expressions, you can look at the Google lesson on [Python Regular Expressions](https://developers.google.com/edu/python/regular-expressions).

### 4. Output

![Output Settings](/images/2017/OCLC-4-output.jpg)

Finally, we just want to link a new ‘Output’ of type ‘Copy to Clipboard’ and use the default content which is just to pass through the input from our Python script. Depending on the context, we could do additional formatting here by editing the text around `{query}`.

In this case, I have also checked the box to ‘Automatically paste to front most app’ because that matches my needs the vast majority of the time I’m using this particular workflow, but in some cases it may be preferable to leave the result on the clipboard without automatically pasting.

---

That’s it. This approach can be repeated for any number of small extraction tasks—to take ASIN numbers from Amazon.com product links in order to construct affiliate links, for example.

Any single instance of this task would be trivial to perform manually, but Alfred’s ability to combine interaction with the clipboard and access to a scripting language with nice regular expression support triggered through a quick-launch command kills the tedious friction of repeat manual editing and becomes second nature.
