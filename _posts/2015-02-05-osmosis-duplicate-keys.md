---
layout: post
title: "Duplicate Nodes in Osmosis Update"
type: tech_note
---

Today I had cause to set a server running OpenStreetMap’s [Nominatim](http://wiki.openstreetmap.org/wiki/Nominatim) to run periodic automatic updates. The server is set up with the complete `planet.osm` file, and I wanted to run the updates using [Osmosis](http://wiki.openstreetmap.org/wiki/Osmosis). During testing, I had no problem running continuous updates using:

```
./utils/update.php --import-osmosis-all --no-npi
```

but for production I wanted to scale back the updates to run every 20 minutes with a cron job. So the first time I ran the one-time osmosis import:

```
./utils/update.php --import-osmosis --no-npi
```

It worked fine and the ‘Last Updated’ datetime stamp on the web interface for the server updated. I came back an hour later to see that the datetime stamp hadn’t updated again. There should have been three more updates in the time I’d left things alone, but something had gone wrong. I looked for `cron` in the log files:

```
grep CRON /var/log/syslog
```

and found that my script had been executing right on time. So I tried to run the update myself again and received the following error:

```
insert_node failed: ERROR: duplicate key value violates unique constraint planet_osm_nodes_pkey
```

I tried manually grabbing the most recent `state.txt` file with `wget`, but that didn’t make a difference. I re-indexed and afterwards ran the update successfully. When I tried to run the update again, same problem.

Finally, I updated my version of `osm2pgsql` to make sure that I had a 64-bit capable version. Turns out, I did not. The updates have been firing successfully every 20 minutes ever since.
