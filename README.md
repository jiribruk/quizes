# Quizes

A modern Ruby on Rails 7.1 application for managing and taking quizzes. Supports dynamic quiz creation via JSON seeds, Turbo/Stimulus interactivity, and a robust test suite.

## Features

- **Quiz Management:** Create, view, and take quizzes with multiple questions and answers.
- **Dynamic Seeding:** Easily add new quizzes by placing JSON files in `db/seeds/` and its subfolders.
- **Turbo & Stimulus:** Fast, interactive UI with Turbo Streams and Stimulus controllers.
- **Modern Rails Stack:** Uses Rails 7.1, MySQL, Importmap, Sprockets, and more.
- **Comprehensive Testing:** RSpec, Capybara, FactoryBot, and Shoulda Matchers.

## Getting Started

### Prerequisites

- Ruby 3.3.x
- MySQL 5.7+/8.x
- Node.js & Yarn (for JS assets, if needed)

### Setup

1. **Clone the repository:**
   ```sh
   git clone <repo-url>
   cd quizes
   ```

2. **Install dependencies:**
   ```sh
   bundle install
   ```

3. **Configure database:**
   - Edit `config/database.yml` for your MySQL credentials.

4. **Setup the database:**
   ```sh
   bin/rails db:create db:migrate
   ```

5. **Seed the database:**
   ```sh
   bin/rails db:seed
   ```
   - All quizzes in `db/seeds/**/*.json` will be loaded automatically.

6. **Run the server:**
   ```sh
   bin/rails server
   ```
   - Visit [http://localhost:3000](http://localhost:3000)

## Project Structure

- `app/models/` – Quiz, Question, Answer models (with validations and associations)
- `app/controllers/` – RESTful controllers for quizzes
- `app/services/` – Business logic (e.g., quiz evaluation)
- `app/helpers/` – View helpers for rendering quizzes
- `app/value_objects/` – Plain Ruby objects for quiz results
- `app/javascript/` – Stimulus controllers for frontend interactivity
- `db/seeds/` – JSON files for quizzes (supports subfolders, e.g., `movies/`, `companies/`)
- `spec/` – RSpec tests (models, services, views, helpers, requests)

## Seeding Quizzes

To add a new quiz, simply create a JSON file in `db/seeds/` or any subfolder. Example structure:

```json
{
  "category": "Movies",
  "name": "The Lord of the Rings Quiz",
  "questions": [
    {
      "text": "Who wrote the original book?",
      "answers_attributes": [
        { "text": "J.R.R. Tolkien", "correct": true },
        { "text": "J.K. Rowling", "correct": false }
      ]
    }
  ]
}
```

## Running Tests

- **All tests:**
  ```sh
  DATABASE=test bin/rspec
  ```
- **With coverage:**
  ```sh
  DATABASE=test bin/rspec --format documentation
  ```

## Code Style

- Follows [RuboCop Rails style guide](https://docs.rubocop.org/rubocop-rails/)
- YARD documentation for all public methods and classes

## Contributing

1. Fork the repo
2. Create your feature branch (`git checkout -b feature/my-feature`)
3. Commit your changes (`git commit -am 'feat(quizes): refs #pbi-XXX Add my feature'`)
4. Push to the branch (`git push origin feature/my-feature`)
5. Create a new Pull Request

## License

MIT
