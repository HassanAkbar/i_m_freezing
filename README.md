# README

This README would normally document whatever steps are necessary to get the
application up and running.

## Rails Installation and Setup
Things you may want to cover:

* Ruby version  : 2.6.2 

* Rails version : 5.2.2

* Database : mysql

* Setup your database
```bash
rails db:create 
```
* Run migrations
```bash
rails db:migrate
 ```
* Database Upload Sample Thermostats
  ```bash
  rake db:seed
 ```
* How to run the test suite
  ```bash
  rspec spec
  ```
* How to run Sidkiq
  ```bash
  bundle exec sidekiq
  ```
## Sample Curl Requests
  * Create Reading
  ```curl
    curl  -H 'household_token:81ed1639d2a7cad24be17a5e0724bc39' -d 'reading[thermostat_id]=1' -d 'reading[temperature]= 15' -d 'reading[humidity]=11' -d 'reading[battery_charge]=10' -X POST \http://localhost:3000/readings.json
    ```

  * Show Reading
  ```curl
    curl  -H 'household_token:81ed1639d2a7cad24be17a5e0724bc39' -X GET \http://localhost:3000/readings/1.json
    ```

  * Therostat Stats
  ```curl
    curl  -H 'household_token:81ed1639d2a7cad24be17a5e0724bc39' -X GET \http://localhost:3000/thermostats/1/stats.json
    ```