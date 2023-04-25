# Little Esty Shop
### Name of Contributors & Github Links

[Alejandro Lopez](https://github.com/AlejandroLopez1992)<br>
[Julian Beldotti](https://github.com/JCBeldo)<br>
[Reid Miller](https://github.com/reidsmiller)<br>
[Stephen McPhee](https://github.com/SMcPhee19)<br>

### Descirption of Project
This project, entitled "Little Esty Shop", is a Turing BE-Mod2 Group Project focusing on designing an e-commerce platform. It's funcitonality would allow merchants as well as admins to manage inventory & fulfill customers orders. 

The project was completed using `Ruby on Rails` and `PostgreSQL` for the database, `Render` for app deployment to the web, and `Github Projects` for time and project management. 

New concepts learned during the course of this project included: 
- implementing `rake tasks` in order to seed data from the `CSV` files into the database; 
- working with new gems for additional functionality including `factory_bot_rails`, `faker` and `HTTParty`
- creating complex `ActiveRecord` queries to the database; 
- Consumed an external `API` to serve data to our site.

Goals achieved during this project:
- 100% coverage of Model and Feature tests using simplecov
- Worked with and extracted information from multiple objects using `ActiveRecord` queries.
- 100% completion of all the user stories
- Collaborated togeher as a group and then in pairs to successfully complete the project.
- Used GitHub projects, milestones, and issues to effectively coordinate all tasks amongst the team.

Summary of Milestones:
- Merchant Dashboard - This page shows details for a particular merchant, including the items that are ready to ship and favorite customers
- Merchant Invoices - This displays an index page for invoices that links to a show page which shows information for the customer on this invoice and a table that shows each item on the invoice including a selector which allows for the user update the status
- Merchant Items - These pages allow a visitor to enable/disable particular items and click into those items to see a description. Additionally it reflects the sales of the top five items that this merchant has sold alongside their sales amount and best date of purchases
- Admin Dashboard - Shows top 5 customers by successful transactions and all incomplete invoices
- Admin Merchants - Merchant index and show pages, with top 5 merchants by revenue, disabled and enabled merchants, and edit merchants functionality
- Admin Invoices - Shows an index page of all IDs in the system and then Shows the details of each individual invoice. Detailed customer, invoice, and item information
- Unsplash API consumption - Adds images to various show pages and a logo to all pages

Potential Refactor Opportunities
- Make two partials to display easy access links for a user and admin to navigate between dashboard, items, and invoice pages.
- Create a welcome page.
- Style the whole app with CSS.
- Within methods that calculate total revenue implement a subquery that insures only one successful transaction is taken into account per invoice.
- Add number_to_currency to the view page to nicely format the prices and total revenue.

## Little Esty Shop - Bulk Discounts
# User Stories
    1. User Story 1: Merchant Bulk Discounts Index
     As a merchant...
     When I visit my merchant dashboard
    [X] Then I see a link to view all my discounts
    [X] When I click this link
    [X] Then I am taken to my bulk discounts index page
    [X] Where I see all of my bulk discounts including their
    [X] percentage discount and quantity thresholds
    [X] And each bulk discount listed includes a link to its show page

    2. Merchant Bulk Discount Create
    As a merchant...
    When I visit my bulk discounts index
    [X]Then I see a link to create a new discount
    [X]When I click this link
    [X]Then I am taken to a new page where I see a form to add a new bulk discount
    [X]When I fill in the form with valid data
    [X]Then I am redirected back to the bulk discount index
    [X]And I see my new bulk discount listed

    3. Merchant Bulk Discount Delete
    As a merchant
    When I visit the bulk discounts index...
    [X] Then next to each bulk discount I see a link to delete it
    [X] When I click this link
    [X] Then I am redirected back to the bulk discounts index page
    [X] And I no longer see the discount listed

    4. Merchant Bulk Discount Show
    As a merchant
    When I vivit my bulk discount show page
    [X] Then I see the bulk discount's quantity threshold and percentage discount

    5. Merchant Bulk Discount Edit    
    As a merchant
    When I visit my bulk discount show page
    [X] Then I see a link to edit the bulk discount
    [X] When I click this link
    [X] Then I am taken to a new page with a form to edit the discount
    [X] And I see that the discounts current attributes are pre-poluated in the form
    [X] When I change any/all of the information and click submit
    [X] Then I am redirected to the bulk discount's show page
    [X] And I see that the discount's attributes have been updated

    6. Merchant Invoice Show Page: Total Revenue and Discounted Revenue
    As a merchant
    When I visit my merchant invoice show page
    [X] Then I see the total revenue for my merchant from this invoice (not including discounts)
    [X] And I see the total discounted revenue for my merchant from this invoice      
    [X] Which includes bulk discounts in the calculation

    7. Merchant Invoice Show Page: Total Revenue and Discounted Revenue
    As a merchant
    When I visit my merchant invoice show page
    [X] Next to each invoice item I see a link to the show page for the bulk discount that was applied (if any)

    8. Admin Invoice Show Page: Total Revenue And Discounted Revenue
    As an admin
    When I visit an admin invoice show page
    [X] Then I see the total revenue from this invoice (not including discounts)
    [X] And I see the total discounted revenue from this invoice which includes bulk discounts in the calculation

    9. Holidays API
    As a merchant
    When I visit the discounts index page
    [ ] I see a section with a header of "Upcoming Holidays"
    [ ] In this section the name and date of the next 3 upcoming US holidays are listed.

    [ ] Use the Next Public Holidays Endpoint in the [Nager.Date API](https://date.nager.at/swagger/index.html)

        