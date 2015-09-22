---
layout: post
title: "Fix Plex Stuttering on Amazon Fire TV Stick"
excerpt: "These settings worked to get rid of annoying stuttering in Plex on Amazon Fire TV Stick."
type: tech_note
---

I grabbed one of the Amazon Fire TV Sticks when Amazon.com discounted them pre-order last year knowing that we’d be moving to Berlin and that it wouldn’t be a bad thing to have an easily portable way to watch some Netflix here.

For streaming services it has worked great, but I also wanted to try to get Plex running on it to watch some of my own video content.

A month ago I gave up after a few days of fiddling would not solve a [persistent stuttering issue](https://forums.plex.tv/discussion/129220/stuttering-on-playback-on-fire-tv-stick).

Yesterday I tried again and eventually distilled a fix to two steps:

- Use a ‘Force Direct Play’ device profile
- Cap video quality at 2.0 Mbsp 720p video

I can live with the compromises I’ve made here because I certainly didn’t buy a $20 HDMI dongle expecting videophile quality. I can actually watch a movie without the video hiccuping every few seconds.

To change the **device profile**, go to **Settings** → **Device media profile** → **Media profile** → **Force Direct Play**.

To change the **video quality**,  go to **Settings** → **Video** → **Quality over local network** → **2.0 Mbps 720p**.
