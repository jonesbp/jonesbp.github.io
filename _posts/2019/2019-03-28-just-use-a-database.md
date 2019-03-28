---
layout: post
title: "Just Use a Database"
excerpt: "In which I learn one more time to just use a relational database"
type: long
---
I am in the middle of writing some scripts to migrate a bunch of data stored as JSON into a SQLite database as well as a small front-end application for visualizations and CRUD-style operations on that data.

I started with JSON because we wanted to get moving quickly, and with JSON we could be hand-generating and -correcting data records while we waited for better tools to get developed. My partner on the project is also less technical, and the idea was that a human-readable format would be more likely to make him available for data entry while we waited for me to build better tools (or if those tools never came.)

I also thought it would be a good idea to always have our data in a plain text format so that it could be easily archived and shared regardless of the technological state the project was left in. The worry was with an ambitious, but unfunded, side project we would potentially hit a wall at some point, and I did not want to be left with a bunch of work to do to then expose our data to be reusable by someone else.

That was a mistake.

Working around the constraints involved in keeping our data in this way has almost certainly added up to more work than was theoretically saved by not building the tools to work with a database. And now I’m building those tools anyways. And in the event that we do stop working on the project, the work involved in coming up with a schema for a set of JSON (or similar) files and the output scripts to generate them would not be so big a deal.

I’ve learned the lesson again: just use a relational database.