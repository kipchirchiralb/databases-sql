# Skating Club Database Design

This database, named `skating_club`, is designed to manage a skating club’s operations, including member registration, daily activity tracking, resource/gear distribution, and monthly membership payments. It consists of four main tables: `members`, `activities`, `resources`, and `payments`. The schema uses primary and foreign keys to maintain relationships and ensure data integrity. Below is the detailed design.

## Table Breakdown

### 1. Members Table

The `members` table stores information about club members.

**Columns:**

- `member_id`: Unique identifier for each member (auto-incremented integer).
- `first_name`: Member’s first name (string, up to 50 characters).
- `last_name`: Member’s last name (string, up to 50 characters).
- `email`: Member’s email address (string, up to 100 characters, unique).
- `phone`: Member’s phone number in Kenyan format (e.g., +254712345678, string, up to 15 characters).
- `join_date`: Date the member joined the club (date or timestamp, default to current date/time).
- `membership_status`: Status of membership (e.g., 'active' or 'expired', string or ENUM).

**Constraints:**

- Primary key on `member_id` to ensure uniqueness.
- `email` is unique to prevent duplicate accounts.
- Required fields (`first_name`, `last_name`, `email`, `phone`) cannot be null.
- `membership_status` defaults to 'active' upon registration.

**Purpose:** Stores core member details and tracks membership status, which is updated based on payment records.

### 2. Activities Table

The `activities` table tracks daily activities or sessions attended by members.

**Columns:**

- `activity_id`: Unique identifier for each activity record (auto-incremented integer).
- `member_id`: Links to the member participating in the activity (integer, references `members`).
- `activity_date`: Date of the activity (date or timestamp, default to current date/time).
- `activity_type`: Type of activity (e.g., 'training', 'group skate', 'event', string, up to 50 characters).
- `notes`: Optional description of the activity (text).

**Constraints:**

- Primary key on `activity_id`.
- Foreign key on `member_id` referencing `members(member_id)` to ensure valid members.
- Required fields (`member_id`, `activity_date`, `activity_type`) cannot be null.

**Purpose:** Records daily participation in skating club activities, such as training sessions or events.

### 3. Resources Table

The `resources` table tracks the distribution of skates and gear to members.

**Columns:**

- `resource_id`: Unique identifier for each resource distribution record (auto-incremented integer).
- `member_id`: Links to the member receiving the resource (integer, references `members`).
- `resource_type`: Type of resource (e.g., 'skates', 'helmet', 'pads', string, up to 50 characters).
- `distribution_date`: Date the resource was distributed (date or timestamp, default to current date/time).
- `return_date`: Date the resource was returned, if applicable (date or timestamp, nullable).
- `status`: Status of the resource (e.g., 'issued', 'returned', string or ENUM).

**Constraints:**

- Primary key on `resource_id`.
- Foreign key on `member_id` referencing `members(member_id)` to ensure valid members.
- Required fields (`member_id`, `resource_type`, `distribution_date`, `status`) cannot be null.
- `status` defaults to 'issued' when a resource is distributed.

**Purpose:** Tracks the allocation and return of skating gear to ensure proper resource management.

### 4. Payments Table

The `payments` table tracks monthly membership payments and determines membership status.

**Columns:**

- `payment_id`: Unique identifier for each payment record (auto-incremented integer).
- `member_id`: Links to the member making the payment (integer, references `members`).
- `payment_date`: Date of the payment (date or timestamp, default to current date/time).
- `amount`: Payment amount in Kenyan Shillings (KES, decimal with two decimal places).
- `payment_period`: The month/year the payment covers (e.g., '2025-06', string or date).
- `status`: Payment status (e.g., 'paid', 'pending', string or ENUM).

**Constraints:**

- Primary key on `payment_id`.
- Foreign key on `member_id` referencing `members(member_id)` to ensure valid members.
- Required fields (`member_id`, `payment_date`, `amount`, `payment_period`) cannot be null.
- `status` defaults to 'paid' for successful payments.

**Purpose:** Tracks monthly membership payments and links to `membership_status` in the `members` table. A member’s status is 'active' if a payment exists for the current month; otherwise, it’s 'expired'.

## Relationships

- **Members ↔ Activities**: One member can participate in many activities (one-to-many). The `member_id` in `activities` references `members(member_id)`.
- **Members ↔ Resources**: One member can receive multiple resources (one-to-many). The `member_id` in `resources` references `members(member_id)`.
- **Members ↔ Payments**: One member can have multiple payments (one-to-many). The `member_id` in `payments` references `members(member_id)`.
- **Membership Status Logic**: The `membership_status` in `members` is derived from the `payments` table. If a payment exists for the current month (based on `payment_period`), the status is 'active'; otherwise, it’s 'expired'.

## Design Rationale

- **Simplicity**: Four tables keep the schema manageable for learners while covering all required functionality.
- **Kenyan Context**: Payment amounts are in KES, and phone numbers use the +254 format.
- **Data Integrity**: Primary keys, foreign keys, and NOT NULL constraints ensure valid data.
- **Flexibility**: The schema supports core operations (registration, activity tracking, resource management, and payment tracking) and can be extended with additional tables (e.g., for events or coaches).

## Practice Questions for Querying

Here are some questions for your learners to practice querying the `skating_club` database. These encourage them to think about retrieving and manipulating data.

1. **List Active Members**: Retrieve the first name, last name, and email of all members with an 'active' membership status.
2. **Recent Activities**: Find all activities from the past 7 days, including the member’s first name, last name, activity type, and activity date.
3. **Unreturned Resources**: List all resources that have been issued but not returned, including the member’s name, resource type, and distribution date.
4. **Payment Summary**: Calculate the total payment amount for each member, showing their first name, last name, and total paid.
5. **Expired Memberships**: Identify members whose membership is expired (no payment for the current month), showing their first name, last name, and email.
6. **Popular Activity Types**: Count how many times each activity type (e.g., 'training', 'group skate') has been recorded, sorted by frequency.
7. **Member Resource Usage**: For a specific member (by `member_id`), list all resources they’ve received, including resource type, distribution date, and status.
8. **Recent Payments**: Show all payments made in the last 30 days, including the member’s name, payment amount, and payment period.
