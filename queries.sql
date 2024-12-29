SELECT lname, fname FROM actors 
     WHERE lname like 'K%' 
   ORDER BY lname 
 
 SELECT title, pyear  
      FROM movies 
    WHERE pyear between 1990 AND 2007 
    ORDER BY pyear DESC 
 
SELECT title, lname, fname  
      FROM movies, directors 
    WHERE movies.did=directors.did AND 
      pcountry ='GRC' 
    ORDER BY lname
	
SELECT title, lname, fname  
      FROM movies, directors 
    WHERE movies.did=directors.did AND 
      pcountry !='GRC' OR pcountry is NULL
    ORDER BY lname 
 
SELECT title, pyear  
     FROM movies, directors 
    WHERE movies.did=directors.did AND 
          lname='Σακελλάριος' 
 
SELECT title, pyear  
      FROM movies, movie_actor, actors 
    WHERE movies.mid=movie_actor.mid AND 
          actors.actid=movie_actor.actid AND 
          lname='Eastwood' 
 
SELECT lname, fname  
      FROM movies, movie_actor, actors 
    WHERE movies.mid=movie_actor.mid AND 
          actors.actid=movie_actor.actid AND 
          title='Amelie' 
 
SELECT COUNT (DISTINCT copies.mid) 
      FROM  copies 
    WHERE cmedium='DVD' 
 
SELECT COUNT (copies.barcode) 
      FROM copies 
    WHERE cmedium='DVD' 
 
SELECT MAX (price)  
      FROM copies 
     WHERE cmedium='DVD' 
 
SELECT SUM(price)  
       FROM copies 
     WHERE cmedium='BLU RAY' 
 
SELECT directors.did, lname, fname, COUNT(movies.mid) AS movies_number 
          FROM directors LEFT JOIN movies 
       ON directors.did=movies.did 
       GROUP BY directors.did, lname, fname
	   
SELECT directors.did, lname, fname, COUNT(movies.mid) AS movies_number 
          FROM directors, movies 
       WHERE directors.did=movies.did 
       GROUP BY directors.did, lname, fname 
 
SELECT lname, COUNT(movies.mid) 
        FROM movies, movie_actor, actors 
     WHERE movies.mid=movie_actor.mid AND 
           actors.actid=movie_actor.actid AND 
           lname='Παπαγιαννόπουλος' 
  GROUP BY lname
  
SELECT lname, COUNT(mid) 
        FROM movie_actor, actors 
     WHERE actors.actid=movie_actor.actid AND 
           lname='Παπαγιαννόπουλος' 
  GROUP BY lname 
 
SELECT lname, fname  
        FROM actors, movie_actor, movies 
      WHERE movies.mid=movie_actor.mid AND 
            actors.actid=movie_actor.actid AND 
            pcountry NOT LIKE 'GRC' 
 
SELECT title  
         FROM movies, movie_actor, actors 
      WHERE movies.mid=movie_actor.mid AND 
            actors.actid=movie_actor.actid AND 
            lname='Καρέζη' 
	INTERSECT 
SELECT title  
        FROM movies, movie_actor, actors 
     WHERE movies.mid=movie_actor.mid AND 
           actors.actid=movie_actor.actid AND 
           lname='Κούρκουλος' 
 
SELECT title  
         FROM movies, movie_actor, actors 
      WHERE movies.mid=movie_actor.mid AND 
            actors.actid=movie_actor.actid AND 
            lname='Καρέζη' 
	EXCEPT  
SELECT title  
        FROM movies, movie_actor, actors 
     WHERE movies.mid=movie_actor.mid AND 
           actors.actid=movie_actor.actid AND 
           lname='Κούρκουλος' 
 
 SELECT title  
      FROM movies, movie_cat, categories 
     WHERE movies.mid=movie_cat.mid AND 
           movie_cat.catid=categories.catid AND 
           category='Κωμωδία' 
	INTERSECT 
SELECT title  
      FROM movies, movie_cat, categories 
    WHERE movies.mid=movie_cat.mid AND 
          movie_cat.catid=categories.catid AND 
          category='Αισθηματική' 
 
 SELECT category, COUNT(movies.mid) 
       from categories, movie_cat, movies 
     WHERE movies.mid=movie_cat.mid AND 
           movie_cat.catid=categories.catid 
     GROUP BY category 
     HAVING COUNT(movies.mid) >=5 
 
 SELECT fname, lname, COUNT(movies.mid) 
        FROM directors LEFT JOIN movies 
             ON directors.did=movies.did 
     GROUP BY fname, lname 
 
 DELETE FROM categories 
      WHERE category='Βιογραφία' 
 
 UPDATE copies 
     SET price = 70.00 
    WHERE  barcode in (SELECT barcode  
                      FROM movies, copies  
      WHERE copies.mid=movies.mid AND  
                              medium='DVD' AND 
                              title= 'Amelie') 