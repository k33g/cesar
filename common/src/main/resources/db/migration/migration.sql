/**
 This file is not executed by flyway. It is only needed for a migration
 You have to install the prod backup on a local mysql, create the new shema (mixit) with flyway and use this scripts
 */

INSERT INTO mixit.Event (ID,CURRENT,YEAR) VALUES (2, FALSE ,2012), (3, FALSE ,2013), (4, FALSE ,2014), (5, TRUE ,2015);

INSERT INTO mixit.Interest (id, name)
SELECT id, name
FROM ad_32609ed48478829.interest;

INSERT INTO mixit.Member (
    DTYPE,  ID,     COMPANY,    EMAIL,  FIRSTNAME,  LASTNAME,   LOGIN,  LONGDESCRIPTION,    NBCONSULTS,
    PUBLICPROFILE,  REGISTEREDAT,   SHORTDESCRIPTION,   TICKETINGREGISTERED,    LOGOURL)
SELECT
    DTYPE,  id,     company,    email,  firstname,  lastname,   login,  longDescription,    nbConsults,
    publicProfile,  registeredAt,   shortDescription,   false,  logoUrl
FROM ad_32609ed48478829.member;

INSERT INTO mixit.Member_Interest (MEMBER_ID, INTERESTS_ID)
SELECT Member_id,	interests_id
FROM ad_32609ed48478829.member_interest;

INSERT INTO mixit.MemberEvent (MEMBER_ID, EVENT_ID)
SELECT sponsor_id, CASE events WHEN 'mixit12' THEN 2 WHEN 'mixit13' THEN 3 WHEN 'mixit14' THEN 4 WHEN 'mixit15' THEN 5 ELSE 6 END AS EVENTS_ID
FROM ad_32609ed48478829.sponsor_events;

UPDATE mixit.MemberEvent me set me.level=(SELECT m.level from ad_32609ed48478829.member m where m.id=me.member_id);

INSERT INTO mixit.Article (ID,CONTENT,HEADLINE,NBCONSULTS,POSTEDAT,TITLE,VALID,AUTHOR_ID)
SELECT id, content, headline, nbConsults, postedAt, title, valid, author_id
FROM ad_32609ed48478829.article;

INSERT INTO mixit.ArticleComment (ID, CONTENT, POSTEDAT, ARTICLE_ID, MEMBER_ID)
SELECT id, content, postedAt, article_id, author_id
FROM ad_32609ed48478829.comment
WHERE article_id is not null;


INSERT INTO mixit.Session (
    DTYPE,ID,ADDEDAT,DESCRIPTION,FEEDBACK,FORMAT,GUEST,IDEAFORNOW,LANG,LEVEL,MAXATTENDEES, MESSAGEFORSTAFF, NBCONSULTS,SESSIONACCEPTED,
    SUMMARY,TITLE,VALID,EVENT_ID)
SELECT
    DTYPE,id, addedAt, description, feedback, DTYPE, guest, ideaForNow, lang, level ,maxAttendees, null,nbConsults,valid,summary, title,
    valid, CASE event WHEN 'mixit12' THEN 2 WHEN 'mixit13' THEN 3 WHEN 'mixit14' THEN 4 WHEN 'mixit15' THEN 5 ELSE 6 END AS EVENTS_ID
FROM ad_32609ed48478829.session;

INSERT INTO mixit.SessionComment (ID, CONTENT, POSTEDAT, SESSION_ID, MEMBER_ID, PRIVATE)
SELECT id, content, postedAt, session_id, author_id, private
FROM ad_32609ed48478829.comment
WHERE session_id is not null;

INSERT INTO mixit.Session_Interest (SESSION_ID, INTERESTS_ID)
SELECT session_id,	interests_id
FROM ad_32609ed48478829.session_interest;


INSERT INTO mixit.Session_Member (SESSIONS_ID, SPEAKERS_ID)
SELECT sessions_id,	speakers_id
FROM ad_32609ed48478829.session_member;

INSERT INTO mixit.SharedLink (ID,URL,NAME,ORDERNUM,MEMBER_ID)
SELECT id,	URL, name, ordernum, member_id
FROM ad_32609ed48478829.sharedlink;


INSERT INTO mixit.Vote (ID,VALUE,MEMBER_ID,SESSION_ID)
SELECT id, value, member_id, session_id
FROM ad_32609ed48478829.vote;

DELETE FROM mixit.Session_Member where  speakers_id in (168);
INSERT INTO mixit.MemberEvent (MEMBER_ID, EVENT_ID)
SELECT DISTINCT speakers_id, 5
FROM mixit.Session_Member;

UPDATE mixit.Session SET lang='fr' WHERE lang is null or lang='';

UPDATE mixit.Member SET LOGOURL=REPLACE(LOGOURL,'/public/images/', 'sponsors/') where LOGOURL is not null;


INSERT INTO mixit.Authority (ID,NAME) VALUES (1, 'ADMIN');
INSERT INTO mixit.Authority (ID,NAME) VALUES (2, 'MEMBER');
INSERT INTO mixit.Authority (ID,NAME) VALUES (3, 'SPEAKER');
INSERT INTO mixit.Authority (ID,NAME) VALUES (4, 'SPONSOR');


/* V4__Sponsor_level.sql */
UPDATE MemberEvent SET LEVEL='GOLD' where LEVEL='SILVER';
UPDATE MemberEvent SET LEVEL='SILVER' where LEVEL='BRONZE';

/* V7__AddFirstSponsor2016.sql */
UPDATE mixit.Event SET CURRENT=FALSE WHERE ID=5;

INSERT INTO MemberEvent (MEMBER_ID, EVENT_ID, LEVEL) VALUES(10, 6, 'GOLD');

INSERT INTO `Member` (`DTYPE`, `ID`, `COMPANY`, `EMAIL`, `FIRSTNAME`, `LASTNAME`, `LOGIN`, `LONGDESCRIPTION`, `NBCONSULTS`, `PUBLICPROFILE`, `REGISTEREDAT`, `SHORTDESCRIPTION`, `LOGOURL`, `SESSIONTYPE`)
VALUES ('Sponsor', 5032, 'Free slot', 'contact@mix-it.fr', null, 'Mix-IT', 'mixit', NULL, 1, TRUE, NULL, 'Soutenez Mix-IT 2016', 'sponsors/undefined.svg', NULL),
 ('Sponsor', 5033, 'Free slot', 'contact@mix-it.fr', null, 'Mix-IT', 'mixit', NULL, 1, TRUE, NULL, 'Soutenez Mix-IT 2016', 'sponsors/undefined.svg', NULL),
 ('Sponsor', 5034, 'Free slot', 'contact@mix-it.fr', null, 'Mix-IT', 'mixit', NULL, 1, TRUE, NULL, 'Soutenez Mix-IT 2016', 'sponsors/undefined.svg', NULL),
 ('Sponsor', 5035, 'Free slot', 'contact@mix-it.fr', null, 'Mix-IT', 'mixit', NULL, 1, TRUE, NULL, 'Soutenez Mix-IT 2016', 'sponsors/undefined.svg', NULL),
 ('Sponsor', 5036, 'Free slot', 'contact@mix-it.fr', null, 'Mix-IT', 'mixit', NULL, 1, TRUE, NULL, 'Soutenez Mix-IT 2016', 'sponsors/undefined.svg', NULL),
 ('Sponsor', 5037, 'Free slot', 'contact@mix-it.fr', null, 'Mix-IT', 'mixit', NULL, 1, TRUE, NULL, 'Soutenez Mix-IT 2016', 'sponsors/undefined.svg', NULL),
 ('Sponsor', 5038, 'Free slot', 'contact@mix-it.fr', null, 'Mix-IT', 'mixit', NULL, 1, TRUE, NULL, 'Soutenez Mix-IT 2016', 'sponsors/undefined.svg', NULL),
 ('Sponsor', 5039, 'Free slot', 'contact@mix-it.fr', null, 'Mix-IT', 'mixit', NULL, 1, TRUE, NULL, 'Soutenez Mix-IT 2016', 'sponsors/undefined.svg', NULL),
 ('Sponsor', 5040, 'Free slot', 'contact@mix-it.fr', null, 'Mix-IT', 'mixit', NULL, 1, TRUE, NULL, 'Soutenez Mix-IT 2016', 'sponsors/undefined.svg', NULL),
 ('Sponsor', 5041, 'Free slot', 'contact@mix-it.fr', null, 'Mix-IT', 'mixit', NULL, 1, TRUE, NULL, 'Soutenez Mix-IT 2016', 'sponsors/undefined.svg', NULL),
 ('Sponsor', 5042, 'Free slot', 'contact@mix-it.fr', null, 'Mix-IT', 'mixit', NULL, 1, TRUE, NULL, 'Soutenez Mix-IT 2016', 'sponsors/undefined.svg', NULL),
 ('Sponsor', 5043, 'Free slot', 'contact@mix-it.fr', null, 'Mix-IT', 'mixit', NULL, 1, TRUE, NULL, 'Soutenez Mix-IT 2016', 'sponsors/undefined.svg', NULL);

INSERT INTO MemberEvent (MEMBER_ID, EVENT_ID, LEVEL) VALUES(5032, 6, 'GOLD');
INSERT INTO MemberEvent (MEMBER_ID, EVENT_ID, LEVEL) VALUES(5033, 6, 'GOLD');
INSERT INTO MemberEvent (MEMBER_ID, EVENT_ID, LEVEL) VALUES(5034, 6, 'GOLD');
INSERT INTO MemberEvent (MEMBER_ID, EVENT_ID, LEVEL) VALUES(5035, 6, 'GOLD');
INSERT INTO MemberEvent (MEMBER_ID, EVENT_ID, LEVEL) VALUES(5036, 6, 'GOLD');
INSERT INTO MemberEvent (MEMBER_ID, EVENT_ID, LEVEL) VALUES(5037, 6, 'GOLD');
INSERT INTO MemberEvent (MEMBER_ID, EVENT_ID, LEVEL) VALUES(5038, 6, 'GOLD');
INSERT INTO MemberEvent (MEMBER_ID, EVENT_ID, LEVEL) VALUES(5039, 6, 'GOLD');

INSERT INTO MemberEvent (MEMBER_ID, EVENT_ID, LEVEL) VALUES(5032, 6, 'SILVER');
INSERT INTO MemberEvent (MEMBER_ID, EVENT_ID, LEVEL) VALUES(5033, 6, 'SILVER');
INSERT INTO MemberEvent (MEMBER_ID, EVENT_ID, LEVEL) VALUES(5034, 6, 'SILVER');
INSERT INTO MemberEvent (MEMBER_ID, EVENT_ID, LEVEL) VALUES(5035, 6, 'SILVER');
INSERT INTO MemberEvent (MEMBER_ID, EVENT_ID, LEVEL) VALUES(5036, 6, 'SILVER');
INSERT INTO MemberEvent (MEMBER_ID, EVENT_ID, LEVEL) VALUES(5037, 6, 'SILVER');
INSERT INTO MemberEvent (MEMBER_ID, EVENT_ID, LEVEL) VALUES(5038, 6, 'SILVER');
INSERT INTO MemberEvent (MEMBER_ID, EVENT_ID, LEVEL) VALUES(5039, 6, 'SILVER');
INSERT INTO MemberEvent (MEMBER_ID, EVENT_ID, LEVEL) VALUES(5040, 6, 'SILVER');
INSERT INTO MemberEvent (MEMBER_ID, EVENT_ID, LEVEL) VALUES(5041, 6, 'SILVER');
INSERT INTO MemberEvent (MEMBER_ID, EVENT_ID, LEVEL) VALUES(5042, 6, 'SILVER');
INSERT INTO MemberEvent (MEMBER_ID, EVENT_ID, LEVEL) VALUES(5043, 6, 'SILVER');

INSERT INTO MemberEvent (MEMBER_ID, EVENT_ID, LEVEL) VALUES(5032, 6, 'LANYARD');

INSERT INTO MemberEvent (MEMBER_ID, EVENT_ID, LEVEL) VALUES(5032, 6, 'PARTY');
INSERT INTO MemberEvent (MEMBER_ID, EVENT_ID, LEVEL) VALUES(5033, 6, 'PARTY');

INSERT INTO MemberEvent (MEMBER_ID, EVENT_ID, LEVEL) VALUES(5032, 6, 'BREAKFAST');
INSERT INTO MemberEvent (MEMBER_ID, EVENT_ID, LEVEL) VALUES(5033, 6, 'BREAKFAST');

INSERT INTO MemberEvent (MEMBER_ID, EVENT_ID, LEVEL) VALUES(5032, 6, 'LUNCH');
INSERT INTO MemberEvent (MEMBER_ID, EVENT_ID, LEVEL) VALUES(5033, 6, 'LUNCH');