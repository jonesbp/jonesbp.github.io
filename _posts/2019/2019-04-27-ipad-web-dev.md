---
layout: post
title: "Web Development on an iPad Pro"
excerpt: "Some notes on the tools I’ve pulled together to make an iPad a worthwhile web development machine"
type: long
---

To get the recommendations out of the way up front, the tools I use in the workflow I describe below are:

- [DigitalOcean][do]
- [Ngrok][ngrok]
- [Blink][blink]
- [Textastic][textastic]
- [Working Copy][workingcopy]
- [Inspect][inspect]

---

I have been experimenting with doing web development on my iPad Pro. The main pain point has been to find a set of tools that allow me to work with a development server environment and other command line tooling (e.g., a Node.js server, a Sass preprocessor, a database server, or a static site generator) instead of static HTML files. On previous occasions I have managed to work out a few pieces of the puzzle, but never in a way that was simple enough to feel like anything more than a parlor trick. With the setup outlined below, however, I’m finally doing work on a regular basis with an array of different technology stacks and limited friction with an iPad Pro.

### The Server

I have been using [DigitalOcean][do] to run a light-weight development server, but [Linode][linode] or any other cloud hosting provider would do the trick.

To connect to the server, I use the [Mosh shell][mosh] with the [Blink][blink] app. In contrast to SSH, Mosh is designed to maintain a session over intermittent and slow connections. Mosh does this by requiring a server component to be installed on your server so that the responsibility for maintaining the session’s state is not only on the client end. On iOS, this has the added consequence of allowing a Mosh session to stay alive even when Blink is not the active app (or iOS removes it from memory entirely.) With SSH, I would likely have to make a new connection every time I returned to the terminal from doing work in my text editor.

The reason for the cloud server is to be able to run build tools and a ‘local’ development server, neither of which can be done on the iPad itself. However, running a development server at `localhost` in the cloud doesn’t do me a lot of good when I want to visit it in a web browser from my iPad.

[Ngrok][ngrok] allows me to set up a tunnel with a public URL to my localhost server. So I can start, for example, an [Express][express] or [Jekyll][jekyll] server in one Mosh session and then start ngrok in another. Ngrok will show me a public URL in the style of  `https://<subdomain>.ngrok.io` which I can then visit in Safari to view my changes. This bit of glue allows me to use a cloud server the same way I would use a local development environment.

### Editing

My favorite coding text editor on iOS is [Textastic][textastic]. It has been continuously updated since the very early days of iOS, making it both robust and well-tuned to the interaction paradigms of the iOS platform.

[Working Copy][workingcopy] is a sort of central dispatch for this whole process. It is ostensibly a git client, but provides so much more functionality than that classification implies.

First, Working Copy can serve as a document provider, allowing me to edit my files in Textastic easily. Having created or cloned a repository in Working Copy, in Textastic tap “Open File or Folder…” under the “External Files and Folders” header in the sidebar to bring up the iOS document picker interface. You should see Working Copy in the list of Locations on the left side. In the top right, tap “Select,” then tap a repository, and finally tap “Open” in the top right to open that repository as a folder in Textastic. Now, when you edit these files in Textastic, Working Copy will be aware of the changes.

So now you are tracking your changes made with Textastic in Working Copy and will be able to commit and push them to your git remote. This is Working Copy’s primary purpose, but there’s another piece of functionality in Working Copy that makes it essential for working with a remote development server. With the [SSH Upload][sshupload] feature, you can link a repository to a remote server location and have Working Copy watch for changes and upload them to that destination.

To summarize, the editing workflow is: edit files in Textastic; switch to Working Copy so that the app activates, notices the changed files, and syncs them to the remote server; and open a browser to view your updated code running on the server.

The only catch with this process is that the SSH Upload feature is not immediately easy to discover. When viewing a repo in Working Copy, you have to open the iOS share sheet and find the ‘SSH Upload’ action. Tapping that will open a panel at the top of the sidebar to configure a remote connection (by password or SSH key.) This interface is not exposed until SSH Upload has been activated for a particular repo, but once it has been configured, it will not need to be reactivated for subsequent sessions.

### Previewing

With an Ngrok tunnel running on my development server, I can interact with the development version of my code with Safari or any other browser on the iPad.

When I’m doing large-grained, additive work where my main interest is in maintaining forward momentum, I usually just use Safari to make sure that the large scale changes aren’t resulting in any big surprises. However, a lot of my time involves testing or polishing work that requires the console or to be able to inspect CSS rules. In those cases, [Inspect][inspect] is the best option for in-browser developer tools I’ve found so far.

The desktop environment has strongly shaped the received interface paradigms of in-browser developer tools, and Inspect sometimes struggles in wrangling this complexity for the touch environment. There is room for improvement here—both in Inspect itself and perhaps in the creation of more focused and fine-tuned apps designed for touch—but it’s certainly possible on iOS to do the vast majority of the things I’m doing on a regular basis with developer tools on the desktop even if it’s not always as convenient.

---

The vast majority of these puzzle pieces have been available for quite a while now. My two recent discoveries that have made everything click into place are Ngrok and the SSH Upload feature of Working Copy. Together they get my code changes onto a live server and back out into a web browser with little enough friction that I feel free to rely on my iPad in situations when its convenience and portability would be useful.


[do]: https://m.do.co/c/f771f7c968c9
[linode]: https://linode.com
[blink]: https://www.blink.sh
[mosh]: https://en.m.wikipedia.org/wiki/Mosh_(software)
[ngrok]: https://ngrok.com
[inspect]: https://apps.pdyn.net/inspect/
[workingcopy]: https://workingcopyapp.com
[textastic]: https://www.textasticapp.com
[express]: https://expressjs.com
[jekyll]: https://jekyllrb.com
[sshupload]: https://workingcopyapp.com/manual/ssh-upload