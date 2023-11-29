<?php
namespace Models;

use Models\DB;
// All the groups which are returned, will only be returned if they aren't marked as archived.
class Posts extends DB {
    public function createUserPost($user_id, $title, $content) {
        $groupData = DB::insert(
            "INSERT INTO posts (user_id, title, content)
            VALUES (?,?,?)", 
            [$user_id, $title, $content]);
            
        return $groupData;
    }

    public function createUserGroupPost($user_id, $group_id, $title, $content) {
        $groupData = DB::insert(
            "INSERT INTO posts (user_id, group_id, title, content)
            VALUES (?,?,?,?)", 
            [$user_id, $group_id, $title, $content]);
            
        return $groupData;
    }

    public function getPost($post_id) {
        $postInfo = DB::selectFirst(
            "SELECT * FROM posts
            WHERE id = ?", [$post_id]);

        return $postInfo;
    }

    public function archivePost($post_id) {
        $postArchived = DB::update(
            "UPDATE posts
            SET is_archived = TRUE
            WHERE id = ?",[$post_id]);

        return $postArchived;
    }

    public function voteOnPost($user_id, $post_id, $reaction_like) {
        $postVote = DB::insert(
            "INSERT INTO users_posts_votes (user_id, post_id, reaction_like)
            VALUES (?,?,?)", 
            [$user_id, $post_id, $reaction_like]);
            
        return $postVote;
    }

    public function revokePostVote($user_id, $post_id) {
        $voteRevoked = DB::delete(
            "DELETE FROM users_posts_votes
            WHERE user_id = ? AND post_id = ?", 
            [$user_id, $post_id]);
            
        return $voteRevoked;
    }

    public function postAlreadyVotedOn($user_id, $post_id) {
        $postVote = DB::selectFirst(
            "SELECT * FROM users_posts_votes
            WHERE user_id = ? AND post_id = ?", 
            [$user_id, $post_id]);
            
        return $postVote;
    }  

    public function updatePostVote($user_id, $post_id, $reaction_like) {
        $postVoteUpdated = DB::update(
            "UPDATE users_posts_votes
            SET reaction_like = ?
            WHERE user_id = ? AND post_id = ?", 
            [$reaction_like, $user_id, $post_id]);
            
        return $postVoteUpdated;
    }

    public function getPostsFromFollowedUsersWall($user_id) {
        $posts = DB::selectAll(
            "WITH VoteCounts AS (
                SELECT
                    post_id,
                    COUNT(CASE WHEN reaction_like = 1 THEN 1 END) AS likes_count,
                    COUNT(CASE WHEN reaction_like = 0 THEN 1 END) AS dislikes_count
                FROM
                    users_posts_votes
                GROUP BY
                    post_id
            )
            
            SELECT
                p.id,
                u.username,
                p.title,
                p.content,
                p.creation_date,
                COALESCE(vc.likes_count, 0) AS likes,
                COALESCE(vc.dislikes_count, 0) AS dislikes,
                COALESCE(upv.reaction_like, null) AS user_vote
            FROM
                posts p
            INNER JOIN
                followed_users fu ON p.user_id = fu.followed_user_id
            INNER JOIN
                users u ON u.id = fu.followed_user_id
            LEFT JOIN
                VoteCounts vc ON p.id = vc.post_id
            LEFT JOIN
                users_posts_votes upv ON p.id = upv.post_id AND upv.user_id = ?
            WHERE
                fu.user_id = ? AND p.group_id IS NULL AND p.is_archived = false", [$user_id, $user_id]);

        return $posts;
    }

    public function getPostsFromFollowedUsers($user_id) {
        $posts = DB::selectAll(
            "WITH VoteCounts AS (
                SELECT
                    post_id,
                    COUNT(CASE WHEN reaction_like = 1 THEN 1 END) AS likes_count,
                    COUNT(CASE WHEN reaction_like = 0 THEN 1 END) AS dislikes_count
                FROM
                    users_posts_votes
                GROUP BY
                    post_id
            )
            
            SELECT
                p.id,
                u.username,
                p.title,
                p.content,
                p.creation_date,
                COALESCE(vc.likes_count, 0) AS likes,
                COALESCE(vc.dislikes_count, 0) AS dislikes,
                COALESCE(upv.reaction_like, null) AS user_vote
            FROM
                posts p
            INNER JOIN
                followed_users fu ON p.user_id = fu.followed_user_id
            INNER JOIN
                users u ON u.id = fu.followed_user_id
            LEFT JOIN
                VoteCounts vc ON p.id = vc.post_id
            LEFT JOIN
                users_posts_votes upv ON p.id = upv.post_id AND upv.user_id = ?
            WHERE
                fu.user_id = ? AND p.is_archived = false", [$user_id, $user_id]);

        return $posts; 
    }

    public function getPostsFromFollowedGroups($user_id) {
        $posts = DB::selectAll(
            "WITH VoteCounts AS (
                SELECT
                    post_id,
                    COUNT(CASE WHEN reaction_like = 1 THEN 1 END) AS likes_count,
                    COUNT(CASE WHEN reaction_like = 0 THEN 1 END) AS dislikes_count
                FROM
                    users_posts_votes
                GROUP BY
                    post_id
            )
            
            SELECT
                p.id,
                u.username,
                g.name AS group_name,
                p.title,
                p.content,
                p.creation_date,
                COALESCE(vc.likes_count, 0) AS likes,
                COALESCE(vc.dislikes_count, 0) AS dislikes,
                COALESCE(upv.reaction_like, null) AS user_vote
            FROM
                posts p
            INNER JOIN
                followed_groups fg ON p.user_id = fg.user_id
            INNER JOIN
                users u ON u.id = fg.user_id
            INNER JOIN
            	 `groups` g ON g.id = p.group_id
            LEFT JOIN
                VoteCounts vc ON p.id = vc.post_id
            LEFT JOIN
                users_posts_votes upv ON p.id = upv.post_id AND upv.user_id = ?
            WHERE
                fg.user_id = ? AND p.is_archived = false", [$user_id, $user_id]);

        return $posts; 
    }

    public function getPostsInSpecificGroup($group_id, $user_id) {
        $posts = DB::selectAll(
            "WITH VoteCounts AS (
                SELECT
                    post_id,
                    COUNT(CASE WHEN reaction_like = 1 THEN 1 END) AS likes_count,
                    COUNT(CASE WHEN reaction_like = 0 THEN 1 END) AS dislikes_count
                FROM
                    users_posts_votes
                GROUP BY
                    post_id
            )
            
            SELECT
                p.id,
                u.username,
                g.name AS group_name,
                p.title,
                p.content,
                p.creation_date,
                COALESCE(vc.likes_count, 0) AS likes,
                COALESCE(vc.dislikes_count, 0) AS dislikes,
                COALESCE(upv.reaction_like, null) AS user_vote
            FROM
                posts p
            INNER JOIN
                `groups` g ON g.id = p.group_id
            INNER JOIN
                users u ON u.id = p.user_id
            LEFT JOIN
                VoteCounts vc ON p.id = vc.post_id
            LEFT JOIN
                users_posts_votes upv ON p.id = upv.post_id AND upv.user_id = ?
            WHERE
                p.group_id = ? AND p.is_archived = false", [$user_id, $group_id]);

        return $posts; 
    }

    public function getPostsFromSpecificUserWall($user_id, $specific_user_id) {
        $posts = DB::selectAll(
            "WITH VoteCounts AS (
                SELECT
                    post_id,
                    COUNT(CASE WHEN reaction_like = 1 THEN 1 END) AS likes_count,
                    COUNT(CASE WHEN reaction_like = 0 THEN 1 END) AS dislikes_count
                FROM
                    users_posts_votes
                GROUP BY
                    post_id
            )
            
            SELECT
                p.id,
                u.username,
                p.title,
                p.content,
                p.creation_date,
                COALESCE(vc.likes_count, 0) AS likes,
                COALESCE(vc.dislikes_count, 0) AS dislikes,
                COALESCE(upv.reaction_like, null) AS user_vote
            FROM
                posts p
            INNER JOIN
                followed_users fu ON p.user_id = fu.followed_user_id
            INNER JOIN
                users u ON u.id = fu.followed_user_id
            LEFT JOIN
                VoteCounts vc ON p.id = vc.post_id
            LEFT JOIN
                users_posts_votes upv ON p.id = upv.post_id AND upv.user_id = ?
            WHERE
                p.user_id = ? AND p.group_id IS NULL AND p.is_archived = false", [$user_id, $specific_user_id]);

        return $posts;
    }

    public function getPostsFromSpecificUser($user_id, $specific_user_id) {
        $posts = DB::selectAll(
            "WITH VoteCounts AS (
                SELECT
                    post_id,
                    COUNT(CASE WHEN reaction_like = 1 THEN 1 END) AS likes_count,
                    COUNT(CASE WHEN reaction_like = 0 THEN 1 END) AS dislikes_count
                FROM
                    users_posts_votes
                GROUP BY
                    post_id
            )
            SELECT
                p.id,
                u.username,
                g.name AS group_name,
                p.title,
                p.content,
                p.creation_date,
                COALESCE(vc.likes_count, 0) AS likes,
                COALESCE(vc.dislikes_count, 0) AS dislikes,
                COALESCE(upv.reaction_like, null) AS user_vote
                FROM
                    posts p
                INNER JOIN
                    followed_users fu ON p.user_id = fu.followed_user_id
                INNER JOIN
                    users u ON u.id = fu.followed_user_id
                LEFT JOIN
                    `groups` g ON g.id = p.group_id
                LEFT JOIN
                    VoteCounts vc ON p.id = vc.post_id
                LEFT JOIN
                    users_posts_votes upv ON p.id = upv.post_id AND upv.user_id = ?
                WHERE
                    p.user_id = ? AND p.is_archived = false", [$user_id, $specific_user_id]);

        return $posts; 
    }

    public function getPostsFromGroupsWithFollowedCategory($user_id) {
        $posts = DB::selectAll(
            "WITH VoteCounts AS (
                SELECT
                    post_id,
                    COUNT(CASE WHEN reaction_like = 1 THEN 1 END) AS likes_count,
                    COUNT(CASE WHEN reaction_like = 0 THEN 1 END) AS dislikes_count
                FROM
                    users_posts_votes
                GROUP BY
                    post_id
            )
            
            SELECT
                p.id,
                u.username,
                g.name AS group_name,
                c.name AS category_name,
                p.title,
                p.content,
                p.creation_date,
                COALESCE(vc.likes_count, 0) AS likes,
                COALESCE(vc.dislikes_count, 0) AS dislikes,
                COALESCE(upv.reaction_like, null) AS user_vote
            FROM
                posts p
            INNER JOIN
                users u ON u.id = p.user_id
            INNER JOIN
                `groups` g ON g.id = p.group_id
            INNER JOIN
                categories c ON c.id = g.category_id
            LEFT JOIN
                VoteCounts vc ON p.id = vc.post_id
            LEFT JOIN
                users_posts_votes upv ON p.id = upv.post_id AND upv.user_id = ?
            WHERE
                p.is_archived = false
                AND p.group_id IS NOT NULL
                AND p.group_id IN (
                    SELECT id
                    FROM `groups` g
                    WHERE g.category_id IN (
                        SELECT category_id
                        FROM users_followed_categories ufc
                        WHERE ufc.user_id = ?
                    ))",[$user_id, $user_id]);

        return $posts; 
    }
}