require 'rails_helper'

RSpec.describe "Race management flow", type: :feature do
  let!(:student1) { Student.create!(name: "Alice") }
  let!(:student2) { Student.create!(name: "Bob") }

  it "tests the full flow of creating and updating a race" do
    visit "/races/new"

    fill_in "Name", with: "100m Dash"
    within all(".participant-row")[0] do
      select "Alice", from: "Student"
      fill_in "Lane", with: "1"
    end
    within all(".participant-row")[1] do
      select "Bob", from: "Student"
      fill_in "Lane", with: "2"
    end

    click_button "Create Race"
    expect(page).to have_content("Race was successfully created.")
    expect(page).to have_content("100m Dash")
    expect(page).to have_content("Alice")
    expect(page).to have_content("Bob")

    click_link "Edit"
    within all(".participant-row")[0] do
      fill_in "Place", with: "1"
    end
    within all(".participant-row")[1] do
      fill_in "Place", with: "2"
    end
    click_button "Update Race"

    expect(page).to have_content("Race was successfully updated.")
    expect(page).to have_content("Alice")
    expect(page).to have_content("1")
    expect(page).to have_content("Bob")
    expect(page).to have_content("2")
  end
end
