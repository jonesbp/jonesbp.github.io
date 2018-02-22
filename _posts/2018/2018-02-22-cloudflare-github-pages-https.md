---
layout: post
title: HTTPS on Github Pages Custom Domains with Cloudflare
excerpt: "A workaround for the lack of HTTPS on Github Pages sites with custom domains"
type: tech_note
date: 2018-02-22T10:28:01-05:00
---

I’m hosting our archive site for [_The Appendix_](https://theappendix.net) on Github Pages because it’s free and it helps shield me from having to pay for the periodic bandwidth spike when an article or blog post gets popular for a few days on Reddit.

It has increasingly been bothering me that a  big problem with this solution long-term was the growing movement towards privileging web content served over HTTPS by services like Google as it conflicts with Github Pages inability to serve sites with custom domains over HTTPS. I was listening to the [Syntax podcast](https://syntax.fm/show/033/large-files-cdns-image-compression-video-hosting-and-big-zips) yesterday when Wes made an aside that even free-tire [Cloudflare](http://cloudflare.com) get served over HTTPS for free. That seemed like a solution to my problem.

I signed up for Cloudflare this morning, added the `theappendix.net` domain, changed my DNS settings to point to Cloudflare, and checked about 15 minutes later to find the site being served over HTTPS. Done.

This site is supposed to be an archive that will hopefully persist with little maintenance for a long, long time. In putting Cloudflare in front of it, I’ve added another layer of dependency. However, Cloudflare sits in front of the hosting. All I have to do to remove my dependency on it if it should disappear is to change my DNS settings again. As long as I’m maintaining the `theappendix.net` domain name I’ll be able to support at least that level of maintenance supervision.

One caveat is that Cloudflare’s free certificate is a shared SSL certificate which presents some security concerns. In the context of the problem I am trying to solve—providing a Github Pages-hosted static site over HTTPS—I don’t think those concerns are relevant; however, it will not be the correct approach to security for all situations.