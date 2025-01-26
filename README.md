# Race Management System

Table of Contents

* Overview
* Requirements & Technologies
* Installation & Setup
* Running the Application
* Testing
* Development Process & Justification
* TDD Approach
* Data Model & Relationships
* Tie/No-Gaps Logic
* Usage Flow
* Future Improvements

## Overview

This application is a Ruby on Rails project that manages student race day events for a local school. Teachers can:

* Create a race (requiring at least two participants).
* Assign students to lanes (each lane must be unique within that race).
* Optionally add more participants up to 8 lanes.
* Record final places after the race (with no gaps in the final positions, correctly handling ties).
* View race details to see participants, lanes, and results.

**The system enforces all challenge requirements:**

* Minimum of 2 participants per race.
* Unique lane per participant within a race.
* Unique student per race.
* No gaps in final places (tie logic).
* TDD approach with high test coverage (models, controllers, validations).

<hr>

## Requirements & Technologies

* Ruby 3.3.0
* Rails 7.1.4
* SQLite3 (default for development)
* RSpec (for testing)
* Gem dependencies are managed in the included Gemfile.

## Installation & Setup

**Clone the Repository**

```cli
git clone https://github.com/GoWebMe2020/race_management_system.git
cd race_management_system
```

**Install Ruby Gems**

```cli
bundle install
```

**Setup the Database**

```cli
rails db:create
rails db:migrate
```

## Testing

I used RSpec to ensure correctness and coverage. To run the test suite:

```cli
bundle exec rspec
```

This runs the model, controller, and integration specs that validate:

* Minimum two participants validation.
* Unique lane/student per race.
* Tie/no-gaps logic for places.
* Controller flows for creating, updating, and deleting records.

You should see all specs passing if everything is set up correctly.

```
% rspec
.......................Capybara starting Puma...
* Version 6.5.0, codename: Sky's Version
* Min threads: 0, max threads: 4
* Listening on http://127.0.0.1:64573
.........

Finished in 2.17 seconds (files took 0.67676 seconds to load)
32 examples, 0 failures
```

## Running the Application

**Start the Rails server:**
```cli
rails server
```

**Open the application in your browser:**

`http://localhost:3000`

## Basic Usage

* Manage Students: You can create students separately (via a StudentsController) or directly in the console.
* Create a Race: From the Races index (/races), click “New Race.” Provide a race name and fill in at least two participants (student + lane).
* Edit a Race: After creation, you can edit a race to assign the final place values once the race is complete. The system validates that final place assignments have no gaps and handle ties properly.

## Development Process & Justification

This project was built using a Test-Driven Development (TDD) approach:

* Write a failing test for a specific feature or validation.
* Implement the minimal code to pass the test.
* Refactor if needed, keeping all tests green.

**Data Model & Relationships**
* Student (`has_many :race_participants`)
* Race (`has_many :race_participants, has_many :students, through: :race_participants`)
* RaceParticipant (`belongs_to :race, belongs_to :student`)
* Enforces unique lane within a race.
* Enforces unique student within a race.
* Ensures a race must have at least 2 participants.

**Tie/No-Gaps Logic**

In the Race model, a custom validation checks final place assignments:

* If any participant’s place is nil, the system allows partial data (race isn’t finished).
* Once all places are assigned, it verifies that they start at 1 and skip appropriately for ties. For example:
  * [1,1,3] is valid.
  * [1,2,4] is invalid (missing 3).

## Thank You!

This README is designed to give you a clear overview of the system’s purpose, how to run it, how it’s tested, and the reasoning behind its architecture. If you have any questions or feedback, feel free to reach out! I look forward to hearing from you.
