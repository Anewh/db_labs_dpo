INSERT INTO "user"(USERNAME, MAIL, PASSWORD)
VALUES  ('nameuser1', 'user1@example.com', 'password1'),
		('nameuser2', 'user2@example.com', 'password2'),
		('nameuser3', 'user3@example.com', 'password3'),
		('nameuser4', 'user4@example.com', 'password4'),
		('nameuser5', 'user5@example.com', 'password5'),
		('nameuser6', 'user6@example.com', 'password6'),
		('nameuser7', 'user7@example.com', 'password7'),
		('nameuser8', 'user8@example.com', 'password8'),
		('nameuser9', 'user9@example.com', 'password9');
		
INSERT INTO "post"(NAME, VIEWS_COUNT, CONTENT, USER_ID)
VALUES  ('example header for 1 post', '0', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum', '1'),
		('example header for 2 post', '3', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum', '3'),
		('example header for 3 post', '9', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum', '2'),
		('example header for 4 post', '12', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum', '3'),
		('example header for 5 post', '16', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum', '3'),
		('example header for 6 post', '6', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum', '3'),
		('example header for 7 post', '7', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum', '3');

INSERT INTO "reaction"(
	type, post_id, user_id)
	VALUES  ('like', '2', '3'),
			('dilike', '2', '3'),
			('fire', '2', '3'),
			('chocolate pudding', '2', '3'),
            ('like', '3', '2'),
			('dilike', '3', '2'),
			('fire', '3', '2'),
			('chocolate pudding', '3', '2');

INSERT INTO "comment"(
	content, date, user_id, post_id)
	VALUES ('First very informative example comment', '2023-04-15 00:03:20', '1', '2'),
		   ('Second very informative example comment', '2023-04-15 00:03:20', '3', '2'),
		   ('Third very informative example comment', '2023-04-15 00:03:20', '2', '1'),
           ('Next(4) very informative example comment', '2023-04-15 00:03:20', '1', '1'),
           ('Next(5) very informative example comment', '2023-04-15 00:03:20', '2', '2'),
           ('Next(6) very informative example comment', '2023-04-15 00:03:20', '3', '3'),
           ('Next(7) very informative example comment', '2023-04-15 00:03:20', '4', '4'),
           ('Next(8) very informative example comment', '2023-04-15 00:03:20', '5', '5'),
           ('Next(9) very informative example comment', '2023-04-15 00:03:20', '6', '6');

------------

SELECT C.id, C.content, C.date, C.user_id, C.post_id
	FROM "comment" AS C
	ORDER BY C.content ASC;

SELECT P.id, P.name, P.views_count, P.content, P.user_id
	FROM "post" AS P;

SELECT R.id, R.type, R.post_id, R.user_id
	FROM "reaction" AS R;

SELECT U.id, U.username, U.mail, U.password
	FROM "user" as U;

--------

-- все пользователи, которые оставили реакции на этот пост
SELECT username
	FROM "user" AS U
	JOIN "comment" AS C
	ON C.user_id = U.id
	WHERE C.post_id = 2;

-- сколько каждый пользователь оставил реакций
SELECT U.id, COUNT(R.id) AS count 
    FROM "reaction" AS R
    RIGHT JOIN "user" AS U
    ON R.user_id = U.id 
    GROUP BY U.id
    ORDER BY count DESC; 

-- Какие авторы оставили комменты под своими постами
SELECT DISTINCT U.username
    FROM "user" AS U
    INNER JOIN "post" AS P ON P.user_id = U.id
    INNER JOIN "comment" AS C ON C.user_id = U.id
    WHERE P.user_id = C.user_id;


UPDATE "comment"
	SET content='updatedExampleContent'
	WHERE id=4;

DELETE FROM "comment"
	WHERE id=4;

