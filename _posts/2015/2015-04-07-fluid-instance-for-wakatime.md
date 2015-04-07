---
layout: post
title: "Auto-reloading Fluid Instance for WakaTime"
excerpt: "Simple userscript for a auto-reloading Fluid instance to use with WakaTime (or any other web dashboard)"
type: tech_note
---

I’ve been playing with running [WakaTime](http://wakatime.com) in my text editors recently to get some data about how much time I spend working in my text editor. It’s been interesting to see the difference between time I mark on a time sheet and what WakaTime records—that difference representing time spent in documentation or notes or other reference materials rather than on coding or writing.

I don’t know that I’ll use WakaTime forever, but during this early experimental phase it’s been fun to have it open in the background while I work. Of course, the service is still new and the dashboard view does not live update. I’ve fixed that by giving WakaTime its own [Fluid](http://fluidapp.com) instance with a simple userscript.

![WakaTime Userscript]({{ BASE_PATH }}/assets/images/2015-04-07/Wakatime_reload.jpg)

In your Fluid instance, go to the **Window** menu and select the **Userscripts** item. You’ll be presented with the window pictured above. Create a new rule with the **+** button, name it what you’d like and enter this simple Javascript:

{% highlight javascript %}
setTimeout(function() {
    location.reload(false);
}, 300000);
{% endhighlight %}

I’m trying to be friendly to WakaTime, so that will only reload your dashboard every 5 minutes. Adjust accordingly if desired. That’s it.