# frozen_string_literal: true

require 'capybara/rspec'

# Configure Capybara for feature tests
Capybara.configure do |config|
  # Use Selenium WebDriver for JavaScript-enabled tests
  config.default_driver = :selenium_chrome_headless
  config.javascript_driver = :selenium_chrome_headless

  # Set default wait time for asynchronous operations
  config.default_max_wait_time = 10

  # Ignore hidden elements by default
  config.ignore_hidden_elements = true

  # Enable automatic waiting for elements
  config.automatic_reload = true

  # Set server timeout
  config.server_timeout = 30
end

# Configure Selenium WebDriver
Capybara.register_driver :selenium_chrome_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new

  # Headless mode for CI environments
  options.add_argument('--headless')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')
  options.add_argument('--disable-gpu')
  options.add_argument('--window-size=1920,1080')
  options.add_argument('--disable-web-security')
  options.add_argument('--allow-running-insecure-content')
  options.add_argument('--disable-features=VizDisplayCompositor')

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: options
  )
end

# Custom matchers for better test readability
RSpec::Matchers.define :have_flash_message do |message_type, content|
  match do |page|
    page.has_css?(".alert-#{message_type}", text: content)
  end

  failure_message do |_page|
    "Expected to find #{message_type} flash message with '#{content}'"
  end
end

RSpec::Matchers.define :have_validation_error do |field, message|
  match do |page|
    page.has_css?(".field_with_errors input[name*='#{field}']") &&
      page.has_content?(message)
  end

  failure_message do |_page|
    "Expected to find validation error for #{field} with message '#{message}'"
  end
end

# Helper methods for common test operations
module CapybaraHelpers
  def fill_in_quiz_form(quiz_attributes = {})
    fill_in 'Quiz name', with: quiz_attributes[:name] || 'Test Quiz'
    fill_in 'Category', with: quiz_attributes[:category] || 'Test Category'
  end

  def fill_in_question_form(question_attributes = {})
    fill_in 'Question text', with: question_attributes[:text] || 'Test Question?'
  end

  def fill_in_answer_form(answer_attributes = {})
    fill_in 'Answer text', with: answer_attributes[:text] || 'Test Answer'
    if answer_attributes[:correct]
      check 'Correct'
    else
      uncheck 'Correct'
    end
  end

  def add_question_with_answers(question_text, answers)
    click_button 'Add Question'
    within all('.question-form').last do
      fill_in 'Question text', with: question_text
      answers.each_with_index do |answer, index|
        click_button 'Add Answer' if index > 0
        within all('.answer-form').last do
          fill_in 'Answer text', with: answer[:text]
          if answer[:correct]
            check 'Correct'
          else
            uncheck 'Correct'
          end
        end
      end
    end
  end

  def submit_quiz_form
    click_button 'Create Quiz'
  end

  def update_quiz_form
    click_button 'Update Quiz'
  end

  def take_quiz_with_answers(answers)
    answers.each do |answer_id|
      choose "answer_#{answer_id}"
    end
    click_button 'Submit Quiz'
  end

  def expect_success_message
    expect(page).to have_flash_message('success', /successfully/)
  end

  def expect_error_message
    expect(page).to have_css('.alert-danger')
  end

  def expect_validation_error(field, message)
    expect(page).to have_validation_error(field, message)
  end
end

# Include helpers in feature tests
RSpec.configure do |config|
  config.include CapybaraHelpers, type: :feature

  # Configure retry for flaky tests
  config.around(:each, type: :feature) do |example|
    retries = 0
    max_retries = 2

    begin
      example.run
    rescue Selenium::WebDriver::Error::UnknownError => e
      retries += 1
      raise e unless retries <= max_retries

      puts "Retrying test due to Selenium error: #{e.message}"
      retry
    end
  end
end
