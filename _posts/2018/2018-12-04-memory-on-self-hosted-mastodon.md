---
layout: post
title: Tuning Memory for a Self-Hosted Mastodon Instance
excerpt: "How to make a Mastodon instance fit on a bottom-tier DigitalOcean Droplet"
type: tech_note
date: 2018-12-04T09:19:00+02:00
---

I recently started hosting my own [Mastodon instance](https://masto.brianjon.es/@brian), but was having a difficult time getting it to run on the low-end Droplet configuration at DigitalOcean. I was happy to run this experiment at $5/mo, but $10/mo was too much for the long term.

I found [this section](https://github.com/tootsuite/documentation/blob/master/Running-Mastodon/Tuning.md#using-jemalloc) in the Mastodon administration docs that recommends running [jemalloc](http://jemalloc.net/) to reduce Mastodon’s memory footprint.

It was easy to do and has allowed me to run on the low-end Droplet from DigitalOcean without running out of memory. I still need to upgrade to the next size when I upgrade Mastodon, but then I can size back down for normal operation.