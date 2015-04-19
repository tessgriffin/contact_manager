require 'rails_helper'

describe 'the company view', type: :feature do 

  let(:company) { Company.create(name: "Stark") }

  describe "phone numbers" do 
    before(:each) do 
      company.phone_numbers.create(number: "555-1234")
      company.phone_numbers.create(number: "555-5678")
      visit company_path(company)
    end

    it "shows the phone numbers" do 
      company.phone_numbers.each do |phone|
        expect(page).to have_content(phone.number)
      end
    end

    it "has a link to a new phone number" do 
      expect(page).to have_link("Add a phone number", href: new_phone_number_path(contact_id: company.id, contact_type: 'Company'))
    end

    it "adds a new phone number" do 
      page.click_link("Add a phone number")
      page.fill_in("Number", with: "555-8888")
      page.click_button("Create Phone number")
      expect(current_path).to eq(company_path(company))
      expect(page).to have_content("555-8888")
    end

    it "has a link to edit phone numbers" do 
      company.phone_numbers.each do |phone|
        expect(page).to have_link("edit", href: edit_phone_number_path(phone))
      end
    end

    it "edits a phone number" do 
      phone = company.phone_numbers.first
      old_number = phone.number

      first(:link, 'edit').click
      page.fill_in('Number', with: '555-9191')
      page.click_button('Update Phone number')
      expect(current_path).to eq(company_path(company))
      expect(page).to have_content('555-9191')
      expect(page).to_not have_content(old_number)
    end

    it "has a link to delete a phone number" do 
      company.phone_numbers.each do |phone|
        expect(page).to have_link("delete", href: phone_number_path(phone))
      end
    end

    it "destroys a phone number" do 
      phone = company.phone_numbers.first

      expect(page).to have_content(phone.number)
      first(:link, "delete").click
      expect(current_path).to eq(company_path(company))
      expect(page).to_not have_content(phone.number)
    end
  end
end