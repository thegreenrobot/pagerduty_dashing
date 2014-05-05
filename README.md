pagerduty-dashing
=================

A Dashing dashboard for PagerDuty Services

* The Incidents dashboard shows the number of triggered and acknowledged incidents using the [hotness widget][hotness]
* An On-call dashboard that shows who is on-call for a particular PagerDuty schedule


Getting Started
---------------

* Clone the repo
* Bundle install
* Create a new directory in the repo root called lib
* Create a secrets.json file in the lib directory with your PagerDuty information
* Start Dashing


Sample lib/secrets.json
-------------------

    {
        "url": "https://yourapp.pagerduty.com",
        "api_key": "insertyourpagerdutykeyhere",
        "services": {
            "yourservice1": "ABC1234",
            "yourservice2": "QAZ4567",
            "yourservice3": "XSW4321",
            "yourservice4": "ZAQ1234"
        },
        "schedules": {
            "oncall": "ZAQ1456",
            "firefighter": "NEB6ZLE"
        }
    }

[hotness]: https://github.com/gottfrois/dashing-hotness
