

SELECT 
* FROM
(
SELECT * FROM `runescapegeproj.rs3ge.rs3itemnames` 
WHERE NAME LIKE 'Elysian spirit shield' OR NAME
LIKE 'Noxious longbow' OR NAME LIKE 'Third age robe top' OR NAME LIKE 'Zaros godsword'OR NAME LIKE 'Virtus robe top' OR NAME LIKE 'Blue partyhat' OR NAME LIKE 'Ek-ZekKil' OR NAME LIKE 'Elite sirenic hauberk' OR NAME LIKE 'Noxious scythe' LIMIT 1000
) as tenitems 
INNER JOIN `runescapegeproj.rs3ge.rs3itemprices` ON
tenitems.Name_ID = `runescapegeproj.rs3ge.rs3itemprices`.id
;

# we join the names with the ids and filter for the 10 items
# that we need