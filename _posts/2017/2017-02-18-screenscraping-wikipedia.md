---
layout: post
title: "Screenscraping Wikipedia with Python"
excerpt: "A walk through building a quick script to scrape data from a Wikipedia page"
type: long
---
Yesterday I did a very quick screen-scraping and text-manipulation project with a Wikipedia page that I thought I would write up as an example of using scripting for small ephemeral or one-off tasks. I used Python 3 with the [Requests](http://docs.python-requests.org/en/master/) and [BeautifulSoup](https://www.crummy.com/software/BeautifulSoup/).

I recently had occasion to compile a corpus of river names for use as throwaway names for an in-house project. I’ve also been thinking a lot about lists and how they can be used and their makers over the last year and have tried (mostly unsuccessfully) to get in the habit of capturing ephemeral lists of things to this site.

While collecting my river names from Wikipedia, I came across a nice, well-encapsulated list of the longest rivers in Europe, so I thought I’d [grab it](http://tinaja.computer/2017/02/17/longest-european-rivers.html) for one of these infrequent list posts.

------

First, I import the two libraries I need. Requests will just make grabbing the Wikipedia page super-easy. BeautifulSoup will help me drill through the HTML I pull from Wikipedia to isolate just the pieces of the page that I’m interested in.

```python
from bs4 import BeautifulSoup
import requests
```

The list I wanted to isolate was on the [List of rivers of Europe](https://en.wikipedia.org/wiki/List_of_rivers_of_Europe) page on Wikipedia. It’s for rivers with a length longer than 250km, and it’s displayed in a separate 4 column table with a header row at the top. The first column of each row following the header has a name of the river with a link to its page on Wikipedia. I want to take all of those names and URLs and output them as a Markdown-formatted list of links. I’m not interested in the contents of any of the other columns.

First, I needed to do a little bit of poking around to find where in the page this table fell and what its markup looked like. I could have done this with the DOM inspector in a web browser, but instead I decided to just start from code. I knew it was in a table, so I first just grabbed the contents of the web page, asked BeautifulSoup to give me only the table elements in the page, and printed each of them out.

```python
r = requests.get('https://en.wikipedia.org/wiki/List_of_rivers_of_Europe')

soup = BeautifulSoup(r.text, 'html.parser')

for table in soup.find_all('table'):
  print(table)
```

Scrolling through my output, I verify that the table I’m interested in is the second table on the page. I don’t care about being able to reuse this code again later, so I it’s fine with me just to hardcode this value in.

Also looking at the output, I confirm that I’m not interested in the first row of the table (it’s just header information), and that the markup of the interesting rows is very straightforward:

```html
<tr>
<td><a href="/wiki/Volga_River" title="Volga River">Volga</a></td>
<td>3,692</td>
<td>2,294</td>
<td><a href="/wiki/Caspian_Sea" title="Caspian Sea">Caspian Sea</a><sup class="reference" id="cite_ref-1"><a href="#cite_note-1">[1]</a></sup></td>
</tr>
```

From this code, I can see that I’m interested in the first `td` cell of each row of the table, and I want the URL in the `href` attribute and the text contents of the link in that cell. As a run through the rows of the table, I will take these two elements and combine them as a Markdown-formatted link and append this link as a new list item to a string that will be output at the end of the script.

------

So, to build the final script, I do my imports, grab the text I’m working with, and set up the HTML parser and the variable to start my final output.

```python
from bs4 import BeautifulSoup
import requests

r = requests.get('https://en.wikipedia.org/wiki/List_of_rivers_of_Europe')

# Give the text of the Wikipedia page to BeautifulSoup and have it
# parse the HTML into a structured object
soup = BeautifulSoup(r.text, 'html.parser')

# I will append a new line for each river to this variable and 
# output all at once at the end
output = ""
```

I then grab the second table in the page, get a handle for the first row from that table, and use that handle to get a handle to the following row using `find_next_sibling()`. This will be the second row in the table—the first row of data I’m interested in.

```python
# The Longest Rivers list is the second table on the page
long_rivers_table = soup.find_all('table')[1]

first_row = long_rivers_table.find('tr')

# Skip the first row of the table…
row = first_row.find_next_sibling()
```

I will use a `while` loop to step through the remaining rows of the table. While my `row` variable is not `None`, I’ll look for the first link in the first cell of the row and grab the information I’m interested in.

After I’ve output that information in my desired format, I set my `row` variable to its next sibling. If it has one, the loop will continue. If it does not, `row` will be `None` and my loop will end.

```python
# …and step through the remaining rows
while row:
    first_cell = row.find('td')
    link = first_cell.find('a')
    
    # Wikipedia uses relative URLs so I need to put the right
    # stem on them for them to work as absolute URLs.
    href = "https://en.wikipedia.org{}".format(link.get('href'))
    label = link.get_text()
  
    # Append a new line to my output with a new list item formatted
    # as a Markdown link
    output = output + "- [{}]({})\n".format(label, href)
    
    row = row.find_next_sibling()
```

At the end of this loop, I now have a string of Markdown-formatted text of my list of rivers as a unordered list of links stored in `output`. I just print that to the screen to be copy-and-pasted where I like, and I’m done.

```python
print(output)
```

------

There was a problem with this approach, however. I wasn’t looking carefully when I first defined my problem, and there are actually a few cells in this table where the contents are not simply a single link. There are few rows that list multiple rivers together in orographic order with separate links; there are also a few rows that list a plain text alternative name for the primary name of the river contained in the link.

So this section of my code from above was a bit too naïve:

```python
  link = first_cell.find('a')
    
  # Wikipedia uses relative URLs so I need to put the right
    # stem on them for them to work as absolute URLs.
    href = "https://en.wikipedia.org{}".format(link.get('href'))
    label = link.get_text()
  
    # Append a new line to my output with a new list item formatted
    # as a Markdown link
    output = output + "- [{}]({})\n".format(label, href)
```

I still want Markdown-formatted output, so I can’t just copy over the contents of the cell directly.

BeautifulSoup gives me what I need here. I can use the `contents` property of the first cell of the table. It is a list of the nodes contained in that cell, which in this case will be 1-n elements that are either links or plain text.

So now for each step through my loop, I will have an intermediate output variable `row_output` to use in constructing the output just for that individual row. As I step through the contents of that row, I will do one of two things depending on whether I’m dealing with plain text or a link. If I have plain text, I will copy it directly over to the output variable. If I a link, I will generate a Markdown-formatted version of that link and append it to the intermediate variable. Finally I will append a new list item to my `output` variable based on the contents of this intermediate variable and check whether I have another row to look at as before.

Now each run through my loop looks like this:

```python
row_output = "" # Reset row_output
    
first_cell = row.find('td')
    
# Step through the contents of the first cell
for el in first_cell.contents:
    # Check to see whether this element of the list is a string instance
    # in order to determine whether we’re dealing with plain text or a link
    
    if isinstance(el, str): # This node of the document is just plain text
        # Append the text directly to row_output
        row_output = row_output + el
        
    else: # This node of the document is a link
        # Wikipedia uses relative URLs so I need to put the right
        # stem on them for them to work as absolute URLs.
        href = "https://en.wikipedia.org{}".format(el.get('href'))
        label = el.get_text()

        # Append a Markdown-formatted link to row_output
        row_output = row_output + "[{}]({})".format(label, href)

# Append the compiled output for this row to the final output for the script
output = output + "- {}\n".format(row_output)
```

It’s a little more complicated, but much more robust in handling the few unusual elements in the list. This list wasn’t necessarily long enough that I absolutely needed to automate handling this small handful of exceptions, but with a larger corpus it would have been helpful and at least this way I know I won’t miss any while editing manually.

The complete source for the script follows (and is available as a [gist](https://gist.github.com/jonesbp/f9ffa3ec93bb8c8ec655a7403ea96b66)).

------

```python
from bs4 import BeautifulSoup
import requests

r = requests.get('https://en.wikipedia.org/wiki/List_of_rivers_of_Europe')

# Give the text of the Wikipedia page to BeautifulSoup and have it
# parse the HTML into a structured object
soup = BeautifulSoup(r.text, 'html.parser')

# I will append a new line for each river to this variable and 
# output all at once at the end
output = ""

# The Longest Rivers list is the second table on the page
long_rivers_table = soup.find_all('table')[1]

first_row = long_rivers_table.find('tr')

# Skip the first row of the table…
row = first_row.find_next_sibling()

# …and step through the remaining rows
while row:
    row_output = "" # Reset row_output
    
    first_cell = row.find('td')
    
    # Step through the contents of the first cell
    for el in first_cell.contents:
        # Check to see whether this element of the list is a string instance
        # in order to determine whether we’re dealing with plain text or a link

        if isinstance(el, str): # This node of the document is just plain text
            # Append the text directly to row_output
            row_output = row_output + el
            
        else: # This node of the document is a link
            # Wikipedia uses relative URLs so I need to put the right
            # stem on them for them to work as absolute URLs.
            href = "https://en.wikipedia.org{}".format(el.get('href'))
            label = el.get_text()
            
            # Append a Markdown-formatted link to row_output
            row_output = row_output + "[{}]({})".format(label, href)
        
    # Append the compiled output for this row to the final output for the script
    output = output + "- {}\n".format(row_output)
    
    # Get the next row if it exists
    row = row.find_next_sibling()

print(output)
```

