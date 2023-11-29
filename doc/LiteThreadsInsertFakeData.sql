USE litethreads;

-- Insert into users
INSERT INTO users (username, password, email, birthdate, is_super_admin)
VALUES 
    ('user1', 'password123', 'user1@example.com', '1990-01-01', false),
    ('user2', 'pass456', 'user2@example.com', '1995-02-15', false),
    ('admin1', 'adminpass', 'admin1@example.com', '1985-05-20', true),
    ('john_doe', 'johns_pass', 'john.doe@example.com', '2000-10-10', false),
    ('jane_doe', 'janes_pass', 'jane.doe@example.com', '1998-08-08', false);
    
-- Insert into category
INSERT INTO categories (id, name)
VALUES 
    (1, 'Technology'),
    (2, 'Study'),
    (3, 'Food'),
    (4, 'Photography'),
    (5, 'Fitness');

-- Insert into groups
INSERT INTO `groups` (name, category_id, is_private, is_age_restricted, is_archived, creation_date, latest_update, archived_date)
VALUES 
    ('Tech Group', 1, false, false, false, '2023-01-01', '2023-01-01', NULL),
    ('Study Group', 2, true, false, false, '2023-01-02', '2023-01-02', NULL),
    ('Foodies', 3, false, true, false, '2023-01-03', '2023-01-03', NULL),
    ('Photography Club', 1, false, false, false, '2023-01-04', '2023-01-04', NULL),
    ('Fitness Enthusiasts', 4, true, false, false, '2023-01-05', '2023-01-05', NULL);

-- Insert into posts
INSERT INTO posts (user_id, group_id, title, content, is_archived, creation_date, latest_update, archived_date)
VALUES 
    (1, 1, 'Introduction to Tech', 'This is a post about technology.', false, '2023-01-01', '2023-01-01', NULL),
    (2, 2, 'Study Session Tomorrow', 'Let''s prepare for the upcoming exam together!', false, '2023-01-02', '2023-01-02', NULL),
    (3, 3, 'Favorite Food Spots', 'Share your favorite restaurants in the city.', false, '2023-01-03', '2023-01-03', NULL),
    (4, 1, 'Sunset Photography', 'Capture the beauty of the sunset and share it here.', false, '2023-01-04', '2023-01-04', NULL),
    (5, 4, 'Fitness Goals', 'Discuss your fitness goals and achievements.', false, '2023-01-05', '2023-01-05', NULL);

-- Insert into users_posts_votes
INSERT INTO users_posts_votes (user_id, post_id, reaction_like)
VALUES 
    (1, 1, true),
    (2, 1, false),
    (3, 2, true),
    (4, 3, true),
    (5, 4, false);

-- Insert into user_blocked_users
INSERT INTO user_blocked_users (user_id, blocked_user_id)
VALUES 
    (1, 2),
    (1, 3),
    (2, 1),
    (3, 1),
    (4, 5);

-- Insert into user_blocked_groups
INSERT INTO user_blocked_groups (user_id, group_id)
VALUES 
    (1, 2),
    (1, 4),
    (2, 1),
    (3, 2),
    (4, 5);

-- Insert into group_blocked_users
INSERT INTO group_blocked_users (group_id, user_id)
VALUES 
    (1, 2),
    (2, 1),
    (3, 4),
    (4, 5),
    (5, 3);

-- Insert into group_moderators
INSERT INTO group_moderators (user_id, group_id)
VALUES 
    (2, 1),
    (3, 2),
    (1, 3),
    (4, 4),
    (5, 5);

-- Insert into followed_groups
INSERT INTO followed_groups (user_id, group_id)
VALUES 
    (1, 2),
    (2, 1),
    (3, 3),
    (4, 5),
    (5, 4);

-- Insert into followed_users
INSERT INTO followed_users (user_id, followed_user_id)
VALUES 
    (1, 2),
    (2, 3),
    (3, 1),
    (4, 5),
    (5, 4);

-- Insert into users_followed_category
INSERT INTO users_followed_categories (user_id, category_id)
VALUES 
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 5);