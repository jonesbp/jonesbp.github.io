---
layout: post
title: Alfred Workflow for Updating App Icons
excerpt: "Wrap a short shell script in an Alfred workflow to reset app icons rewritten on updates."
type: tech_note
---

I use [Sublime Text 3][sublime-text] as my primary text editor, but absolutely hate the icon. The wide availability of nice replacement icons for Sublime Text suggests I’m not the only one. Unfortunately, the automated updater for Sublime Text overwrites custom icons, and I eventually gave up on replacing it.

I’ve revisited working with Alfred workflows with the recent release of [Alfred 3][alfred] and realized that a very simple shell script attached to an Alfred keyword would make resetting my Sublime Text icon quick and easy enough that I would do it.

You’ll need to pick a replacement icon in .icns format and store it in a predictable place.[^icon] Create a new blank workflow in Alfred and create a new **Keyword** input, giving it a keyword (I use ‘st3icon’) and setting it to take no argument. Connect it to a new **Run Script** action and enter the following bash script:

{% highlight bash %}
cp /path/to/new-app-icon.icns /Applications/Sublime\ Text.app/Contents/Resources/Sublime\ Text.icns
touch /Applications/Sublime\ Text.app
touch /Applications/Sublime\ Text.app/Contents/Info.plist
{% endhighlight %}

The first line copies the .icns file you’d like to use as your new icon from wherever you’ve stored it (change `/path/to/new-app-icon.icns` accordingly) to the Sublime Text app bundle. The next two lines touch the app bundle and its plist to reset the modification timestamp on the app and trigger the system to reload the app’s icon.

Small adjustments to this script would obviously make it work with other apps, although having a bunch of single-use Alfred workflows each responsible for a different app isn’t the most elegant solution. I may work on a version that supported multiple application ‘profiles’ in a single workflow on some future rainy afternoon.

[^icon]: I’m partial to [this one][icon] by Jannik Siebert.

[sublime-text]: http://sublimetext.com
[alfred]: https://www.alfredapp.com
[icon]: https://dribbble.com/shots/1827488-Final-Sublime-Text-Replacement-Icon