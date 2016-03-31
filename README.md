# FactsOfToday
Takes the user's current date, and displays different information that happened on the same day.

Link to the Google Folder with all the documents
https://docs.google.com/document/d/1igLWQiPm7hl5luzI21SjwbPIfBHDC8UXhIl9UfTw4cU/edit?usp=sharing

#Required User Stories:

- [x] As a user I would like the app to open and search for today’s date by default.
  - @tragessere
- [x] As a user I would like to see preview of the three categories on the main screen: events, births, deaths.
  - @tragessere
- [x] As a user I would like to tap the preview to go to a table view that lists more items in that category for that day.
  - @darrell1994
- [x] As a user I would like to tap the links available in each cell to open a web view of the related Wikipedia page.
  - @darrell1994
- [x] As a user I would like to swipe left and right on the main page to switch to adjacent dates.
  - @browne0, @tragessere
- [x] As a user I would like to open a calendar view to pick from further dates more quickly.
  - @browne0
- [x] As a user I would like to tap the ‘today’ button to get back to the current day.
- - @browne0

#Optional User Stories:

- [x] As a user I would like to select color schemes
    - @darrell1994
- [ ] As a user I would like to use the 6s force touch to push and pop article links.
- [ ] As a user I would like to see images from Wikipedia API on the tableview before opening the links.
- [x] As a user I would like to be able to choose to receive a daily event notification.
  - @tragessere
  - Currently using local notifications, might have to switch to push notifications to work better.
- [x] As a user I would like my date selection to persist until the next day.
  - @darrell1994
- [x] As a user I would like to see the location an event took place on a map (for Wikipedia articles with the coordinates available)
  - @tragessere
- [x] As a user I would like to share information and links via Twitter.
  - @darrell1994

# Wireframe

![Wireframe](wireframe.png)


# APIs

* Today In History  (http://history.muffinlabs.com)
  * History item model: information, year, array of links
  * Link model: subject, title, link
* Wikipedia         (https://www.mediawiki.org/wiki/API:Main_page)
  * Only needed for article thumbnail

### Possible Extra APIs

* Numbers API       (http://numbersapi.com)
  * Only returns text
* Twitter API       (https://dev.twitter.com/rest/public)
  * Twitter API helper class

# Considerations

### Pitch

* We want to give the user perspective on history with a device that they use every day to provide daily information.

### Stakeholders

* Any iOS user could use this app to learn about important events and people in history. With information about each day, there are fewer events to be overwhelmed by and provide a reason to come back every day.

### Core Flows

* Key functions: Present information about what has happened each day in history.
* Screens: Main screen with one sample event, birth, and death for that day. After clicking on any of the three objects, present a TableView with more information of that type. Each item will have links to Wikipedia which can be opened in a Safari view controller to get more in-depth information.

### Final Demo

* Show the home page which shows an a few event examples for that day.
* Open one of the event lists
  * Scroll through the events provided by the API.
  * Open a Wikipedia article from the events.
  * (optional item) Show a map view where the event took place.
  * (optional item) Tweet one of the events.
* Return to the main page and start changing the current date
  * Swipe left and right to change the selected date.
  * Open the calendar to pick a different date further away.
  * Tap the 'today' button to return to the current date.
* Go to settings
  * (optional item) Change the app's color scheme.
  * Open acknowledgements page
  * (optional item) Show notification settings.
* (optional items) Go to the device settings and change the date.
  * Receive a notification and go to the app.


### Mobile Features

* Optional daily notifications of events.
* Some Wikipedia articles have coordinates available which could be shown on a map.

### Technical Concerns

* Using the Wikipedia API to get the article coordinates.
* User selected color schemes could be at least tedious to set up.
* Need to figure out how notifications work.


## Video Walkthrough - Part 1

![sprint1-demo](https://github.com/browne0/FactsOfToday/blob/master/factsoftoday-demo.gif)

GIF created with [LiceCap](http://www.cockos.com/licecap/).


## Video Walkthrough - Sprint 2

![sprint 2 demo](factsoftoday-demo-66%25.gif)

## Video Walkthrough - Sprint 3

![sprint3-demo](https://github.com/browne0/FactsOfToday/blob/master/factsOfToday-demo2.gif)

GIF created with [LiceCape](http://www.cockos.com/licecap/).
