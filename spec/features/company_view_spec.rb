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

  describe "email addresses" do 
    before(:each) do 
      company.email_addresses.create(address: "ned@stark.com")
      company.email_addresses.create(address: "something@stuff.com")
      visit company_path(company)
    end

    it "has a list of email addresses" do 
      expect(page).to have_selector('li', text: 'ned@stark.com')
    end

    it "has an add email address link" do 
      expect(page).to have_link("Add an email address", href: new_email_address_path(contact_id: company.id, contact_type: 'Company'))
    end

    it "adds a new email address" do 
      page.click_link("Add an email address")
      page.fill_in("Address", with: "thing@example.com")
      page.click_button("Create Email address")
      expect(current_path).to eq(company_path(company))
      expect(page).to have_content("thing@example.com")
    end

    it "has a link to edit email addresses" do 
      company.email_addresses.each do |email|
        expect(page).to have_link("edit", href: edit_email_address_path(email))
      end
    end

    it "edits a phone number" do 
      email = company.email_addresses.first
      old_address = email.address

      first(:link, 'edit').click
      page.fill_in('Address', with: 'newemail@example.com')
      page.click_button('Update Email address')
      expect(current_path).to eq(company_path(company))
      expect(page).to have_content('newemail@example.com')
      expect(page).to_not have_content(old_address)
    end

    it "has a link to delete an email address" do 
      company.email_addresses.each do |email|
        expect(page).to have_link("delete", href: email_address_path(email))
      end
    end

    it "destroys an email address" do 
      email = company.email_addresses.first

      expect(page).to have_content(email.address)
      first(:link, "delete").click
      expect(current_path).to eq(company_path(company))
      expect(page).to_not have_content(email.address)
    end
  end
end