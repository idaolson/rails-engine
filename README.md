# README

# rails-engine 

## Table of contents
* [Description](#description)
* [Learning Goals](#learning-goals)
* [Requirements](#requirements)
* [Database Schema](#database-schema)
* [API Endpoints](#api-endpoints)
* [Setup](#setup)
* [Live App](#live-app)
* [Tools Used](#tools-used)
* [Contributors](#contributors)

## Description

"Rails Engine" is a Rails-based API which mimics an e-commerce platform (based on [Little Esty Shop Repo](https://github.com/idaolson/little-esty-shop-bulk-discounts) reporting tool as an API. Users can query and store merchants and items, and retrieve information about an item's merchant, or a list of a merchant's items. Users can also run one of several "business intelligence" endpoints to do rich reporting using ActiveRecord queries.

## Learning Goals
- Practice building API endpoints for both RESTFUL and non-RESTFUL.
- Practice using serializer.
- Utilize Postman
- Utilize advanced ActiveRecord techniques to perform complex database queries.

## Requirements
- Rails 5.2.5
- Ruby 2.7.2
- PostgreSQL
- JSONAPI::Serializer
- Postman

## Database Schema
![Schema](https://user-images.githubusercontent.com/72399033/134418403-99e1a24c-11fb-442c-a682-01e86095ba7d.png)

## API Endpoints

## Setup
* Fork this repository
* Clone your fork
* From the command line, install gems and set up your DB:
    * `bundle install`
    * `rails db:{drop,create,migrate,seed}`
    * `rails db:schema:dump`
* Run the test suite with `bundle exec rspec`.
* Run your development server with `rails s` to see the API app in action.

## Live App
[Link to Heroku deployment](https://rails-engine-denver.herokuapp.com/api/v1)

## Tools Used

| Development    |  Testing             |
| :-------------:| :-------------------:|
| Ruby 2.7.2     | SimpleCov            |
| Rails 5.2.6    | Pry                  |
| Atom           | Launchy              |
| Git            | RSpec                |
| Github         | Factorybot/Faker     |
| Github Project | Postman              |
| Postico        |                      |


## Contributors

- [Ida Olson](https://www.linkedin.com/in/idaolson/)
