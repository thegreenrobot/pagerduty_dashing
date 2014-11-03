PagerDuty-Dashing
=================

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy?template=https://github.com/thegreenrobot/pagerduty_dashing)

A [Dashing][dashing] dashboard for PagerDuty Services!

* Show the number of triggered and acknowledged incidents using the [hotness widget][hotness].
* Display who's on-call for a particular PagerDuty schedule.


Sample
=======
![sample](https://f36b09034ab1a72dbb54-bd0fd07e24ed988eda39807e960a82e7.ssl.cf1.rackcdn.com/TinyGrab%20Screen%20Shot%2011-2-14%2012.33.18%20AM.png.jpg)

Getting Started
===============

The easiest way to get started is to use Heroku button above to launch your dashboard. You will need to fill out the following environment variables in Heroku so your Dashing dashboard can communicate to the PagerDuty API.

| Environment Variable | Example |
| :----------------- |:-----------------|
| PAGERDUTY_URL | https://yoursubdomain.pagerduty.com |
| API_KEY | Your api key (this can be a read only key) |
| SERVICES | {"services": { "staging": "ABC1234","preprod": "QAZ4567","production": "EDC4321"}} |
| SCHEDULES | {"schedules": { "oncall": "ABC1234","firefighter": "QAZ4567"}} | 

FAQ
====
### Where can I see what the IDs are for my services/schedules?
Clicking on a Service/Schedule within your PagerDuty URL will show you the ID in the URL.

[dashing]: http://shopify.github.io/dashing/
[hotness]: https://github.com/gottfrois/dashing-hotness
