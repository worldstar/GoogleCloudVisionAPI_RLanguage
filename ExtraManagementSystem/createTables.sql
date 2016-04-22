use test;

CREATE TABLE `User` (
`UserID` int(6) NOT NULL AUTO_INCREMENT,
`UserName` varchar(45) NOT NULL,
`UserAccount` varchar(50) NOT NULL,
`UserPassword` varchar(60) NOT NULL,
`UserPhone` varchar(50) NOT NULL,
`CreatedBy` int(6) NOT NULL,
`CreatedDate` timestamp NULL DEFAULT NULL,
PRIMARY KEY (`UserID`)
) ENGINE=InnoDB AUTO_INCREMENT=1;

CREATE TABLE `Topic` (
`TopicID` int(10) NOT NULL AUTO_INCREMENT,
`TopicName` varchar(45) NOT NULL,
`Descriptions` varchar(100) NULL,
`UserID` int(6) NOT NULL,
`CreatedDate` timestamp NULL DEFAULT NULL,
PRIMARY KEY (`TopicID`),
KEY `userTopicID_idx` (`UserID`),
CONSTRAINT `userTopicID` FOREIGN KEY (`UserID`) REFERENCES `User` (`UserID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1;

CREATE TABLE `TopicDetails` (
`PostID` int(11) NOT NULL AUTO_INCREMENT,
`LabelName` varchar(45) NOT NULL,
`TopicID` int(10) NOT NULL,
`CreatedBy` int(6) NOT NULL,
`CreatedDate` timestamp NULL DEFAULT NULL,
PRIMARY KEY (`PostID`),
KEY `userTopicID_idx2` (`UserID`),
CONSTRAINT `userTopicID2` FOREIGN KEY (`CreatedBy`) REFERENCES `User` (`UserID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
KEY `TopicDetailsID_idx` (`TopicID`),
CONSTRAINT `TopicDetailsID` FOREIGN KEY (`TopicID`) REFERENCES `Topic` (`TopicID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1;