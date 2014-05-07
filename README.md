pagerduty-dashing
=================

A Dashing dashboard for PagerDuty Services

* The Incidents dashboard shows the number of triggered and acknowledged incidents using the [hotness widget][hotness]
* An On-call dashboard that shows who is on-call for a particular PagerDuty schedule


Getting Started
---------------

1. Clone the repo
2. Bundle install
3. Create a new directory in the repo root called lib
4. Create a secrets.json file in the lib directory with your PagerDuty information
5. Match the data-id in the widgets in /dashboards with the names of your services and schedules from the secrets file.
6. Start dashing!


Sample lib/secrets.json
-------------------

    {
        "url": "https://yourapp.pagerduty.com",
        "api_key": "insertyourpagerdutykeyhere",
        "services": {
            "yourservice1": "ABC1234",
            "yourservice2": "QAZ4567"
        },
        "schedules": {
            "oncall": "ZAQ1456",
            "firefighter": "NEB6ZLE"
        }
    }

Sample dashboards/oncall.erb
-------------------
Note: the data-id for these widgets will look like "schedulename-name". That extra "name" is for oncall.rb to put in the on-call's name.

```
<div class="gridster">
  <ul>

    <li data-row="1" data-col="1" data-sizex="1" data-sizey="1">
      <div data-id="oncall-name" data-view="Text" data-title="On-Call Rotation" data-moreinfo="Fix all the incidents!"</div>
    </li>    

     <li data-row="1" data-col="1" data-sizex="1" data-sizey="1">
      <div data-id="firefighter-name" data-view="Text" data-title="Firefighter Rotation" data-moreinfo="Srsly. Fix the incidents."</div>
    </li>   
 
  </ul>
</div>
```

Sample dashboards/incidents.erb
-------------------
Note: the data-id for these widgets will look like "servicename-triggered" or "servicename-acknowledged"

```
<div class="gridster">

  <ul>

    <li data-row="1" data-col="1" data-sizex="1" data-sizey="1">
      <div data-id="yourservice1-triggered" data-view="Hotness" data-title="Service 1: Triggered" data-cool="0" data-warm="2"></div>
    </li>

    <li data-row="1" data-col="1" data-sizex="1" data-sizey="1">
      <div data-id="yourservice1-acknowledged" data-view="Hotness" data-title="Service 1: Acked" data-cool="0" data-warm="2"></div>
    </li>   
    
        <li data-row="1" data-col="1" data-sizex="1" data-sizey="1">
      <div data-id="yourservice2-triggered" data-view="Hotness" data-title="Service 2: Triggered" data-cool="0" data-warm="2"></div>
    </li>

    <li data-row="1" data-col="1" data-sizex="1" data-sizey="1">
      <div data-id="yourservice2-acknowledged" data-view="Hotness" data-title="Service 2: Acked" data-cool="0" data-warm="2"></div>
    </li>    


  </ul>
</div>
```



[hotness]: https://github.com/gottfrois/dashing-hotness
