---
layout: post
title: PDF Preview Problem on El Capitán
excerpt: 'I recently had problems with PDFs opening in Preview on OS X El Capitán.'
type: tech_note
date: 2016-07-25T07:37:48+02:00
---

I recently had problems with PDFs opening in Preview on OS X El Capitán. After weeks of thinking it was a problem with Preview, I eventually realized it was happening at a system level with PDF files generally. It’s pretty difficult to find helpful information by searching variations on ‘os x pdf preview not opening’, but I eventually found a [thread](https://discussions.apple.com/message/28953108#28953108) that led me in the right direction.

I first noticed that saving as a PDF from the print window and choosing to open in Preview did nothing. I could still save PDFs to Evernote or to Yoink so I mostly didn’t worry about it. Around the same time I noticed that the default application for PDFs on my system had become Acrobat Reader (a choice I would never have made of my own volition).

When trying to open PDFs with Preview by using a contextual menu in Finder and selecting Preview from the `Open with…` menu, I’d be presented with a file dialog when Preview launched rather than the file I had selected, and re-selecting the file to open in that dialog (or any other PDF for that matter) would fail silently. Annoying, but I just started using other PDF viewers.

Then I noticed that PDFs on my Desktop had changed to completely blank icons. Not any additional inconvenience, but increasingly troubling.

Finally, planning for an upcoming trip, I dropped a PDF of my itinerary into Notes and saw that the new note had an image attached, but my PDF did not display inline in Notes. I realized then that my problem was with PDFs, not with Preview. Turns out Quick Look for PDFs was also not working, etc. etc.

I eventually found the thread I mentioned in the intro and went from there to find this [support writeup on the Ohanaware website](http://ohanaware.com/support/index.php?article=how-not-to-break-preview.html) about an incompatibility between one of their apps and El Capitán that corrupted the launch services database and interfered with Preview’s ability to open PDFs. They have released an app called Preview Reset to fix the problem that you can find from the same page. I had never used any of Ohanaware’s software, but their Preview Reset application rats on whichever application was the culprit on your system. In my case, Notability had caused the problem.

So if you have a problem with losing PDF support in Preview or other system-level features in Finder (Quick Look), Notes (inline preview), etc.—particularly if you have been running Shine from Ohanaware or Notability, but it sounds like there are several applications that have caused this problem—try [Preview Reset](http://ohanaware.com/support/index.php?article=how-not-to-break-preview.html) from Ohanaware and see if that fixes things.
