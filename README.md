I started writing SQL in 2020. I made many mistakes. A year later, I'd like to think I'm a better data engineer. This project contains my attempt to refactor some code I've written in 2020 with better practices, proper styling, and of course dbt.

## Project 1: Mobilize Sign Ups
**Overview**
Sunrise, like many other progressive organizations, uses Mobilize.us as our events tool. Staff and hub members can create events in one of our 3 committees. Backend users can add up to 2 custom questions per event. Volunteers who sign up for events can opt in to text and email reminders to complete their shift. Volunteers can also confirm or cancel their shift.

**Challenge**
I need to transform Mobilize data often in my role. Often I need to pivot the participations data based on the timeslot (day and time of shift).
