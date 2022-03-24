
DROP DATABASE IF EXISTS MDB;
CREATE DATABASE MDB;
USE MDB

CREATE TABLE IF NOT EXISTS Artist(
    artist_id INT(2) NOT NULL UNIQUE,
    name TEXT(255) NOT NULL,
    nationality TEXT(255) NOT NULL,
    year_born INT NOT NULL,
    style_id INT NOT NULL,
    PRIMARY KEY (artist_id)
);

 CREATE TABLE IF NOT EXISTS ArtStyle(
     style_id INT(2) NOT NULL UNIQUE,
     descriptor TEXT(255) NOT NULL,
     century TEXT(255) NOT NULL,
     PRIMARY KEY (style_id)
 );

  CREATE TABLE IF NOT EXISTS ArtPiece(
     piece_id INT NOT NULL UNIQUE,
     price TEXT(255) NOT NULL,
     artist_id INT(2) NOT NULL,
     piece_name TEXT(255) NOT NULL,
     gallery_id INT(2) NOT NULL,
     PRIMARY KEY (piece_id)
 );

  CREATE TABLE IF NOT EXISTS Galleries(
     gallery_id INT(2) NOT NULL UNIQUE,
     postcode TEXT(255) NOT NULL,
     area TEXT(255) NOT NULL,
     PRIMARY KEY (gallery_id)
 );

  CREATE TABLE IF NOT EXISTS Visitor(
     visitor_id INT(2) NOT NULL UNIQUE,
     full_name TEXT(255) NOT NULL,
     gallery_id INT(2) NOT NULL,
     PRIMARY KEY (visitor_id)
 );

  CREATE TABLE IF NOT EXISTS Roles(
     role_id INT(2) NOT NULL UNIQUE,
     description TEXT(255) NOT NULL,
     gallery_id INT(2) NOT NULL,
     wage_ph INT NOT NULL,
     PRIMARY KEY (role_id)
 );
 
  CREATE TABLE IF NOT EXISTS Employee(
     employee_id INT(3) NOT NULL UNIQUE,
     role_id INT(2) NOT NULL,
     surname TEXT(255) NOT NULL,
     bank_no INT(8) NOT NULL,
     phone_no INT(10) NOT NULL,
     PRIMARY KEY (employee_id)
 );

 INSERT INTO Artist VALUES(01,'Picasso','Spanish',1881,11);
 INSERT INTO Artist VALUES(02,'DaVinci','Italian',1452,12);
 INSERT INTO Artist VALUES(03,'Michelangelo','Italian',1475,12);
 INSERT INTO Artist VALUES(04,'Van Gogh','Dutch',1853,13);
 INSERT INTO Artist VALUES(05,'Monet','French',1840,14);

 INSERT INTO ArtStyle VALUES(11,'Surrealism','20th');
 INSERT INTO ArtStyle VALUES(12,'Rennaissance','14th');
 INSERT INTO ArtStyle VALUES(13,'Modern','19th');
 INSERT INTO ArtStyle VALUES(14,'Impressionism','18th');

 INSERT INTO ArtPiece VALUES(31,'€1,000,000',05,'The Magpie',44);
 INSERT INTO ArtPiece VALUES(32,'€2,000,000',04,'Irises',45);
 INSERT INTO ArtPiece VALUES(33,'€10,000,000',02,'The Mona Lisa',43);
 INSERT INTO ArtPiece VALUES(34,'€3,000,000',01,'Infanta',41);
 INSERT INTO ArtPiece VALUES(35,'€1,500,000',03,'Doni Tondo',42);

 INSERT INTO Galleries VALUES(41,'D08 XD85','Liberties');
 INSERT INTO Galleries VALUES(42,'D04 RJ78','Ballsbridge');
 INSERT INTO Galleries VALUES(43,'D06 FK56','Rarthgar');
 INSERT INTO Galleries VALUES(44,'D01 CJ73','City Centre N');
 INSERT INTO Galleries VALUES(45,'D02 GY45','City Centre S');

 INSERT INTO Visitor VALUES(51,'Peadar Kenny',44);
 INSERT INTO Visitor VALUES(52,'Khushboo Jain',41);
 INSERT INTO Visitor VALUES(53,'Aaron Byrne',44);
 INSERT INTO Visitor VALUES(54,'Maria Cairns',42);
 INSERT INTO Visitor VALUES(55,'Alexandra Ichim',45);
 INSERT INTO Visitor VALUES(56,'Jay Cowan',43);

 INSERT INTO Roles VALUES(61,'Appraisor',42,18);
 INSERT INTO Roles VALUES(62,'Janitor',45,12);
 INSERT INTO Roles VALUES(63,'Receptionist',43,14);
 INSERT INTO Roles VALUES(64,'Security',41,15);
 INSERT INTO Roles VALUES(65,'Guide',45,12);
 INSERT INTO Roles VALUES(66,'Researcher',44,12);

 INSERT INTO Employee VALUES(111,64,'Gaffney',13577913,0869773678);
 INSERT INTO Employee VALUES(112,62,'Vaughan',24681012,0878983678);
 INSERT INTO Employee VALUES(113,61,'Khan',34710122,0856787836);
 INSERT INTO Employee VALUES(114,66,'Doherty',76543890,0897654315);
 INSERT INTO Employee VALUES(115,63,'OSullivan',12345678,0878763312);
 INSERT INTO Employee VALUES(116,65,'Donnelly',28737892,0854678936);
 INSERT INTO Employee VALUES(117,66,'Merriman',26797892,0859638935);

ALTER TABLE Artist
ADD CONSTRAINT FK_ArtistStyle
FOREIGN KEY (style_id) REFERENCES ArtStyle(style_id);

ALTER TABLE ArtPiece
ADD CONSTRAINT FK_ArtistPiece
FOREIGN KEY (artist_id) REFERENCES Artist(artist_id);

ALTER TABLE ArtPiece
ADD CONSTRAINT FK_PieceLocation
FOREIGN KEY (gallery_id) REFERENCES Galleries(gallery_id);

ALTER TABLE Visitor
ADD CONSTRAINT FK_GalleryVisited
FOREIGN KEY (gallery_id) REFERENCES Galleries(gallery_id);

ALTER TABLE Roles
ADD CONSTRAINT FK_GalleryRoles
FOREIGN KEY (gallery_id) REFERENCES Galleries(gallery_id);

ALTER TABLE Employee
ADD CONSTRAINT FK_EmployeeRole
FOREIGN KEY (employee_id) REFERENCES Employee(employee_id);

CREATE VIEW ItalianPainters AS
SELECT Artist.artist_id, Artist.name
FROM Artist
WHERE Artist.nationality = 'Italian';

CREATE VIEW Researchers AS
SELECT Employee.employee_id, Employee.surname
FROM Employee
WHERE Employee.role_id = 66;

SELECT Artist.name, Artist.nationality, Artist.year_born, ArtPiece.piece_name
FROM ArtPiece
INNER JOIN Artist ON Artist.artist_id = ArtPiece.artist_id;

DELIMITER $$

CREATE TRIGGER Invalid_Phone 
BEFORE INSERT ON Employee
    FOR EACH ROW
BEGIN
  IF new.phone_no > 10 THEN
    SIGNAL sqlstate '99999'
        SET message_text = 'Invalid domain';
  END IF;
END$$ 

DELIMITER ;

CREATE ROLE owner_of_gallery;
GRANT ALL ON MDB* TO owner_of_gallery; 