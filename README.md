I started writing SQL in 2020. I made many mistakes. A year later, I'd like to think I'm a better data engineer. This project contains my attempt to refactor some code I've written in 2020 with better practices, proper styling, and of course dbt.

## Project 1: Mobilize Sign Ups
### Challenge
Sunrise, like many other progressive organizations, uses Mobilize.us as our events tool. Staff and hub members can create events in one of our 3 committees. Backend users can add up to 2 custom questions per event. Volunteers who sign up for events can opt in to text and email reminders to complete their shift. Volunteers can also confirm or cancel their shift.

I need to transform Mobilize data often in my role. A common request from my organizers is to push RSVP data from Mobilize to a Google Sheet. In this case, I was working specifically with the Vote Tripling RSVP data for our Georgia 2021 runoff organizing. I need to pivot the data on the shift start timestamp to create a summary of the number of RSVPs per shift.

### Overview of Data

Sunrise has 3 Mobilize committees, one for each of our legal branches. Each Mobilize committee syncs to it's own schema in Redshift. This structure is necessary to maintain firewall (if you're unfamiliar with firewall, just know that some data need to be separate from other data for legal purposes).
Sunrise has 3 Mobilize committees:

    Mobilize Com.         Designation   Schema
    _____________________________________________________________
    | Sunrise           | IE           |  sun_mobilize          |
    |___________________|______________|________________________|
    | Sunrise 2020      | Coordinated  |  sunrise2020_mobilize  |
    |___________________|______________|________________________|
    | Sunrise Movement  | c4           |  sunrise_mobilize      |
    |___________________|______________|________________________|




### Original Code
The original script to produce the summary of Vote Tripling RSVPs for our Georgia 2021 runoff organizing is here.

### Solution
**Staging the data**
I needed to stage the same 5 tables in all 3 schemas in the same manner. To do that, I wrote a [5 macros](https://github.com/thebbennett/refactoring_with_dbt/tree/master/models/staging/mobilize_ie) that take the `schema_name` as a paramter. These macros were then called 3 times each to stage the following tables from the Mobilize schemas:

* events
* event_tags
* participations (renamed rsvps for readibility)
* sms_opt_ins
* timeslots

**Macros**
A common operation when working with the Mobilize schema is to convert a timestamp to the correct timezone. All timestamps in Mobilize are in `UTC`. There are two kinds of timestamps that we want to convert:

* `created_at`, `modified_at`, and `deleted_at` timestamps should be converted to the `America/New_York`timezone
* timestamps related to an event should be converted to the timezone where the event is taking place

I built a [macro](https://github.com/thebbennett/refactoring_with_dbt/blob/master/macros/standarize_timezone.sql) to simplify this operation and to anticipate a situation where we might want to convert the `created_at` etc timestamps to a different timezone. 



