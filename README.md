# README

# Tech Stack

- Ruby 3.0.0
- Rails 7.0.2
- Database Postgresql

# Database Models

- Operator
  - Operator model is connected with operators table and saving the operator data like name, email and country etc.

- Tour
  - Tour model is connected to tours table of database and saving the tour availabilities data. We can create one time and recurring tour availablities like the following.
  - Tour starts every Monday of the week
  - Tour starts every second Tuesday of the month
  - Tour starts every Tuesday and Thursday
  - Next tour starts on Jan 5, Feb 6, March 15.

# Controllers

- ToursController
  - Added create action to handle create requests for tour availabilities
