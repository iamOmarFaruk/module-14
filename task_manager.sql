DROP DATABASE IF EXISTS `task_manager`;
CREATE DATABASE `task_manager` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `task_manager`;

CREATE TABLE `users` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email_unique` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `tasks` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` INT UNSIGNED NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  `description` TEXT,
  `status` ENUM('pending', 'in_progress', 'completed') NOT NULL DEFAULT 'pending',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE `tasks`
  ADD CONSTRAINT `fk_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

INSERT INTO `users` (`id`, `name`, `email`) VALUES
(1, 'Shakib Al Hasan', 'shakib.hasan@example.com'),
(2, 'Mushfiqur Rahim', 'mushfiqur.rahim@example.com'),
(3, 'Tamim Iqbal', 'tamim.iqbal@example.com'),
(4, 'Mahmudullah Riyad', 'mahmudullah.riyad@example.com');

INSERT INTO `tasks` (`id`, `user_id`, `title`, `description`, `status`) VALUES
(1, 1, 'Review match footage from last series', 'Analyze batting and bowling performance against the West Indies. Focus on areas for improvement.', 'completed'),
(2, 1, 'Attend team practice session', 'Full net session focusing on spin bowling variations.', 'in_progress'),
(3, 1, 'Finalize equipment sponsorship deal', 'Meet with marketing team to discuss terms with SG Cricket.', 'pending'),
(4, 2, 'Wicket-keeping drills', 'Complete 2 hours of specialized drills with the keeping coach.', 'in_progress'),
(5, 2, 'Develop nutrition plan for the upcoming tour', 'Consult with the team nutritionist to create a high-performance diet plan.', 'pending'),
(6, 3, 'Brand endorsement photoshoot', 'Photoshoot for Nagad campaign. Location: Gulshan Studio.', 'pending'),
(7, 3, 'Charity event appearance', 'Attend the opening of the new children''s hospital wing.', 'completed'),
(8, 3, 'Work on cover drive technique', 'Spend extra time in the nets with the batting coach to refine the cover drive.', 'in_progress');

COMMIT;