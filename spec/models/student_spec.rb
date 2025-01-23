# Student model test and name must be valid
require 'rails_helper'

RSpec.describe Student, type: :model do
  context 'validations' do
    it 'is valid with valid attributes' do
      student = Student.new(name: 'John Doe')
      expect(student).to be_valid
    end

    it 'is not valid without a name' do
      student = Student.new(name: nil)
      expect(student).to_not be_valid
    end
  end
end
