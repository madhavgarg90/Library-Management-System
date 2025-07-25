DROP TABLE Book_Authors;
DROP TABLE Book_Copies;
DROP TABLE Book_Loans;
DROP TABLE BOOK_INFO;
DROP TABLE Borrower;
DROP TABLE Library_Branch;
DROP TABLE Publisher;

CREATE TABLE Publisher (
    PublisherName VARCHAR2(100) PRIMARY KEY
);

CREATE TABLE BOOK_INFO (
    BookID NUMBER PRIMARY KEY,
    Title VARCHAR2(255) NOT NULL,
    PublisherName VARCHAR2(100),
    FOREIGN KEY (PublisherName) REFERENCES Publisher(PublisherName)
);

CREATE TABLE Book_Authors (
    BookID NUMBER,
    AuthorName VARCHAR2(255),
    PRIMARY KEY (BookID, AuthorName),
    FOREIGN KEY (BookID) REFERENCES BOOK_INFO(BookID)
);

CREATE TABLE Library_Branch (
    BranchID NUMBER PRIMARY KEY,
    BranchName VARCHAR2(255) NOT NULL,
    Address VARCHAR2(255) NOT NULL
);

CREATE TABLE Borrower (
    CardNo NUMBER PRIMARY KEY,
    Name VARCHAR2(255) NOT NULL,
    Address VARCHAR2(255) NOT NULL,
    Phone VARCHAR2(15) NOT NULL
);

CREATE TABLE Book_Copies (
    BookID NUMBER,
    BranchID NUMBER,
    No_of_Copies NUMBER,
    PRIMARY KEY (BookID, BranchID),
    FOREIGN KEY (BookID) REFERENCES BOOK_INFO(BookID),
    FOREIGN KEY (BranchID) REFERENCES Library_Branch(BranchID)
);

CREATE TABLE Book_Loans (
    BookLoanID NUMBER PRIMARY KEY,
    BookID NUMBER,
    BranchID NUMBER,
    CardNo NUMBER,
    DateOut DATE,
    DueDate DATE,
    FOREIGN KEY (BookID) REFERENCES BOOK_INFO(BookID),
    FOREIGN KEY (BranchID) REFERENCES Library_Branch(BranchID),
    FOREIGN KEY (CardNo) REFERENCES Borrower(CardNo)
);

INSERT INTO Publisher VALUES ('Penguin Publishers');
INSERT INTO Publisher VALUES ('HarperCollins');
INSERT INTO Publisher VALUES ('Allen & Unwin');
INSERT INTO Publisher VALUES ('Secker & Warburg');
INSERT INTO Publisher VALUES ('T. Egerton');
INSERT INTO Publisher VALUES ('Charles Scribner''s Sons');
INSERT INTO Publisher VALUES ('Little, Brown and Company');
INSERT INTO Publisher VALUES ('Geoffrey Bles');
INSERT INTO Publisher VALUES ('Harper & Brothers');
INSERT INTO Publisher VALUES ('Richard Bentley');

INSERT INTO BOOK_INFO VALUES (1, 'Harry Potter and the Sorcerer''s Stone', 'Penguin Publishers');
INSERT INTO BOOK_INFO VALUES (2, 'The Hobbit', 'Allen & Unwin');
INSERT INTO BOOK_INFO VALUES (3, 'To Kill a Mockingbird', 'HarperCollins');
INSERT INTO BOOK_INFO VALUES (4, '1984', 'Secker & Warburg');
INSERT INTO BOOK_INFO VALUES (5, 'Pride and Prejudice', 'T. Egerton');
INSERT INTO BOOK_INFO VALUES (6, 'The Great Gatsby', 'Charles Scribner''s Sons');
INSERT INTO BOOK_INFO VALUES (7, 'The Catcher in the Rye', 'Little, Brown and Company');
INSERT INTO BOOK_INFO VALUES (8, 'The Lord of the Rings', 'Allen & Unwin');
INSERT INTO BOOK_INFO VALUES (9, 'The Chronicles of Narnia', 'Geoffrey Bles');
INSERT INTO BOOK_INFO VALUES (10, 'Moby-Dick', 'Richard Bentley');

INSERT INTO Book_Authors VALUES (1, 'J.K. Rowling');
INSERT INTO Book_Authors VALUES (2, 'J.R.R. Tolkien');
INSERT INTO Book_Authors VALUES (3, 'Harper Lee');
INSERT INTO Book_Authors VALUES (4, 'George Orwell');
INSERT INTO Book_Authors VALUES (5, 'Jane Austen');
INSERT INTO Book_Authors VALUES (6, 'F. Scott Fitzgerald');
INSERT INTO Book_Authors VALUES (7, 'J.D. Salinger');
INSERT INTO Book_Authors VALUES (8, 'J.R.R. Tolkien');
INSERT INTO Book_Authors VALUES (9, 'C.S. Lewis');
INSERT INTO Book_Authors VALUES (10, 'Herman Melville');

INSERT INTO Library_Branch VALUES (1, 'Central Library', '123 Library St');
INSERT INTO Library_Branch VALUES (2, 'West End Library', '456 West St');

INSERT INTO Borrower VALUES (101, 'Alice Johnson', '789 Main St', '1234567890');
INSERT INTO Borrower VALUES (102, 'Bob Smith', '321 Elm St', '0987654321');

INSERT INTO Book_Copies VALUES (1, 1, 5);
INSERT INTO Book_Copies VALUES (2, 2, 3);

INSERT INTO Book_Loans VALUES (1, 1, 1, 101, SYSDATE, SYSDATE + 14);
INSERT INTO Book_Loans VALUES (2, 2, 2, 102, SYSDATE, SYSDATE + 14);

CREATE OR REPLACE TRIGGER before_insert_borrower
BEFORE INSERT ON Borrower
FOR EACH ROW
DECLARE
    v_exists NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_exists FROM Borrower WHERE CardNo = :NEW.CardNo;
    IF v_exists > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'First submit the previous books');
    END IF;
END;
/

INSERT INTO Borrower (CardNo, Name, Address, Phone)
VALUES (1, 'Test User', 'Nowhere', '9999999999');

CREATE OR REPLACE FUNCTION MOST_AVAILABLE_PUBLISHER(PubName IN VARCHAR2)
RETURN NUMBER IS
    COUNT_OF_BOOKS NUMBER;
BEGIN
    SELECT COUNT(*) INTO COUNT_OF_BOOKS
    FROM BOOK_INFO
    WHERE PublisherName = PubName;
    RETURN COUNT_OF_BOOKS;
END;
/

CREATE OR REPLACE PROCEDURE Showdata(
    bookid_ IN BOOK_INFO.BookID%TYPE,
    bankid_ IN Book_Loans.BookLoanID%TYPE
) 
IS
    author_ Book_Authors.AuthorName%TYPE;
    title_ BOOK_INFO.Title%TYPE;
    borrower_name Borrower.Name%TYPE;
    borrower_address Borrower.Address%TYPE;
    borrower_phone Borrower.Phone%TYPE;
BEGIN
    SELECT B.Title, A.AuthorName, BR.Name, BR.Address, BR.Phone
    INTO title_, author_, borrower_name, borrower_address, borrower_phone
    FROM Book_Authors A
    JOIN BOOK_INFO B ON A.BookID = B.BookID
    JOIN Book_Loans L ON B.BookID = L.BookID
    JOIN Borrower BR ON L.CardNo = BR.CardNo
    WHERE B.BookID = bookid_ AND L.BookLoanID = bankid_;

    DBMS_OUTPUT.PUT_LINE('Title: ' || title_);
    DBMS_OUTPUT.PUT_LINE('Author: ' || author_);
    DBMS_OUTPUT.PUT_LINE('Borrower: ' || borrower_name);
    DBMS_OUTPUT.PUT_LINE('Address: ' || borrower_address);
    DBMS_OUTPUT.PUT_LINE('Phone: ' || borrower_phone);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: No data found');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unexpected error occurred');
END;
/

DECLARE
    CURSOR c_customers IS 
        SELECT Name, CardNo, Address, Phone FROM Borrower;
BEGIN
    FOR cust IN c_customers LOOP
        DBMS_OUTPUT.PUT_LINE('Name: ' || cust.Name || ', CardNo: ' || cust.CardNo);
    END LOOP;
END;
/

SELECT MOST_AVAILABLE_PUBLISHER('Penguin Publishers') FROM dual;
