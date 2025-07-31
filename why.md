### What is RDBMS?

**RDBMS** stands for **Relational Database Management System**. It's software that manages data stored in **tables** (called relations) and allows you to easily **insert, update, delete, and query** data using a language like **SQL** (Structured Query Language).

---

### Why Use Databases?

In any application like a **social media platform**, data is central: user profiles, posts, likes, messages, etc.

Reasons to use a database:

* **Organized storage** of large amounts of data.
* **Efficient access** and **searching**.
* **Data relationships** (e.g., which user wrote which post).
* **Avoid data duplication** (using normalization).
* **Security**, **backup**, and **concurrent access**.

---

### Why Multiple Tables?

Different types of data need to be **separated logically** but still **linked** using relationships. For example:

* You don’t want to store all user info, posts, and comments in one big table. It becomes slow, confusing, and redundant.
* Instead, you split the data into **tables** and link them using **keys**.

---

### Example: Simple Social Media Database

Here’s a basic structure using multiple tables:

#### 1. **Users Table**

Stores user information.

| user\_id (PK) | username | email                                 |
| ------------- | -------- | ------------------------------------- |
| 1             | alice    | [alice@xyz.com](mailto:alice@xyz.com) |
| 2             | bob      | [bob@xyz.com](mailto:bob@xyz.com)     |

---

#### 2. **Posts Table**

Each post is made by one user.

| post\_id (PK) | user\_id (FK) | content      | created\_at |
| ------------- | ------------- | ------------ | ----------- |
| 101           | 1             | Hello world! | 2025-07-01  |
| 102           | 2             | First post!  | 2025-07-02  |

(`user_id` is a **foreign key** linking to the `Users` table.)

---

#### 3. **Comments Table**

Users comment on posts.

| comment\_id (PK) | post\_id (FK) | user\_id (FK) | comment    |
| ---------------- | ------------- | ------------- | ---------- |
| 1001             | 101           | 2             | Nice post! |
| 1002             | 102           | 1             | Welcome :) |

---

#### 4. **Likes Table**

Tracks which user liked which post.

| like\_id (PK) | post\_id (FK) | user\_id (FK) |
| ------------- | ------------- | ------------- |
| 5001          | 101           | 2             |
| 5002          | 102           | 1             |

---

### Summary

* **RDBMS** uses **tables** to manage data efficiently.
* **Multiple tables** let you organize related data and **avoid repetition**.
* Tables are connected using **primary keys (PK)** and **foreign keys (FK)**.
* In a **social media app**, separating `users`, `posts`, `comments`, and `likes` makes your database **scalable**, **clean**, and **maintainable**.

Would you like to see how these tables are created using SQL?
