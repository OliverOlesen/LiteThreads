DROP DATABASE IF EXISTS litethreads;
CREATE DATABASE litethreads;
USE litethreads;

-- Table: users
CREATE TABLE users (
    id INT AUTO_INCREMENT,
    username VARCHAR(255) UNIQUE,
    password VARCHAR(255),
    email VARCHAR(255) UNIQUE,
    birthdate DATE,
    is_super_admin BOOLEAN,
    is_archived BOOLEAN DEFAULT false,
    creation_date DATE DEFAULT (CURRENT_DATE),
    latest_update DATE,
    archived_date DATE,
    PRIMARY KEY (id)
);


-- Table: category
CREATE TABLE categories (
    id INT UNIQUE,
    name VARCHAR(255),
    PRIMARY KEY (id)
);

-- Table: `groups`
CREATE TABLE `groups` (
    id INT AUTO_INCREMENT,
    name VARCHAR(255) UNIQUE,
    category_id INT,
    is_private BOOLEAN,
    is_age_restricted BOOLEAN,
    is_archived BOOLEAN DEFAULT false,
    creation_date DATE  DEFAULT (CURRENT_DATE),
    latest_update DATE,
    archived_date DATE,
    PRIMARY KEY (id),
    FOREIGN KEY (category_id) REFERENCES category(id)
);

-- Table: posts
CREATE TABLE posts (
    id INT AUTO_INCREMENT,
    user_id INT,
    group_id INT,
    title VARCHAR(255),
    content VARCHAR(255),
    is_archived BOOLEAN DEFAULT false,
    creation_date DATETIME  DEFAULT (NOW()),
    latest_update DATETIME,
    archived_date DATETIME,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (group_id) REFERENCES `groups`(id)
);

-- Table: users_posts_votes
CREATE TABLE users_posts_votes (
    user_id INT,
    post_id INT,
    reaction_like BOOLEAN,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (post_id) REFERENCES posts(id)
);

-- Table: user_blocked_users
CREATE TABLE user_blocked_users (
    user_id INT,
    blocked_user_id INT,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (blocked_user_id) REFERENCES users(id)
);

-- Table: user_blocked_groups
CREATE TABLE user_blocked_groups (
    user_id INT,
    group_id INT,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (group_id) REFERENCES `groups`(id)
);

-- Table: group_blocked_users
CREATE TABLE group_blocked_users (
    group_id INT,
    user_id INT,
    FOREIGN KEY (group_id) REFERENCES `groups`(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Table: group_moderators
CREATE TABLE group_moderators (
    user_id INT,
    group_id INT,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (group_id) REFERENCES `groups`(id)
);

-- Table: followed_groups
CREATE TABLE followed_groups (
    user_id INT,
    group_id INT,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (group_id) REFERENCES `groups`(id)
);

-- Table: followed_users
CREATE TABLE followed_users (
    user_id INT,
    followed_user_id INT,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (followed_user_id) REFERENCES users(id)
);

-- Table: users_followed_categories
CREATE TABLE users_followed_categories (
    user_id INT,
    category_id INT,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (category_id) REFERENCES category(id)
);

-- Table: email_authentication
CREATE TABLE email_verification (
	email VARCHAR(255) NOT NULL,
	verf_code VARCHAR(255) NOT NULL,
	creation_date DATE DEFAULT (CURRENT_DATE)
);