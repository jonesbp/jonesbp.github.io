---
layout: post
title: "Show PHP Errors in MAMP"
excerpt: "Quick howto on turning on PHP error reporting when hosting sites locally with MAMP"
type: tech_note
---

I’ve been using [MAMP](http://mamp.info) for local hosting on PHP-based client sites recently rather than bothering with maintaining my own configurations for small projects. The only problem was that I lost my error reporting. I’d been satisfied to live without them until recently I had a legitimate bug to track down.

MAMP uses its own PHP instead of your default system installation, so you need to find the configuration specific to the version it’s running. You’ll find the (possibly several) versions of PHP MAMP has installed inside of the MAMP application bundle, so head there and list the contents of the `config` directory. You are most likely running the version of PHP with the highest version number. In my case, right now, it’s 5.4.10:

{% highlight bash %}
$ cd /Applications/MAMP/conf
$ ls
$ cd php5.4.10
{% endhighlight %}

And open `php.ini` using your text editor of choice, and look for the section headed `Error handling and logging`. There are several settings to adjust here, but the basic one is `error_reporting`. The relevant line will be commented out by default, so you’ll remove the leading `;` to activate the setting.

From this:

```
;error_reporting  =  E_ALL
```

to this:

```
error_reporting  =  E_ALL
```

You may want to adjust the neighboring settings based on your needs, but this is sufficient to get some error feedback without losing the convenience of MAMP.