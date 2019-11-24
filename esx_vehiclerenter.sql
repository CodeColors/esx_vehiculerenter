USE `essentialmode`;

INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_locanation',"Loca'nation",1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_locanation',"Loca'nation",1)
;

INSERT INTO `jobs` (name, label) VALUES
	('locanation',"Loca'novice")
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('locanation',0,'recruit','Recrue',700,'{}','{}'),
	('locanation',1,'experienced','Experimenté',900,'{}','{}'),
	('locanation',2,'co-patron','Co-Patron',1100,'{}','{}'),
	('locanation',3,'boss','Patron',1200,'{}','{}')
;

CREATE TABLE `locanation_vehicles` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`vehicle` varchar(255) NOT NULL,
	`price` int(11) NOT NULL,

	PRIMARY KEY (`id`)
);

CREATE TABLE `used_vehicle_sold` (
	`client` VARCHAR(50) NOT NULL,
	`model` VARCHAR(50) NOT NULL,
	`plate` VARCHAR(50) NOT NULL,
	`soldby` VARCHAR(50) NOT NULL,
	`date` VARCHAR(50) NOT NULL,

	PRIMARY KEY (`plate`)
);

CREATE TABLE `renting_vehicules` (
	`vehicle` varchar(60) NOT NULL,
	`plate` varchar(12) NOT NULL,
	`renter` varchar(255) NOT NULL,
	`remaining` int(11) NOT NULL,
	`owner` varchar(255) NOT NULL,

	PRIMARY KEY (`plate`)
);

CREATE TABLE `vehicle_rent_categories` (
	`name` varchar(60) NOT NULL,
	`label` varchar(60) NOT NULL,

	PRIMARY KEY (`name`)
);

INSERT INTO `vehicle_rent_categories` (name, label) VALUES
	('loisir','Loisir'),
	('travail','Travail'),
	('quotidien','Quotidien')
;

CREATE TABLE `vehicle_2brent` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`name` varchar(60) NOT NULL,
	`model` varchar(12) NOT NULL,
	`category` varchar(255) NOT NULL,
	
	PRIMARY KEY (`id`)
);

CREATE TABLE `used_vehicle` (
	`client` VARCHAR(50) NOT NULL,
	`model` VARCHAR(50) NOT NULL,
	`plate` VARCHAR(50) NOT NULL,
	`price` int(11) NOT NULL,

	PRIMARY KEY (`plate`)
);