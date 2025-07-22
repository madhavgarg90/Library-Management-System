# 📚 Library Management System (Oracle SQL)

A complete relational database system for managing a library's operations — including book lending, author/publisher details, and borrower tracking — built in **Oracle SQL** with support for triggers, procedures, cursors, and analytical functions.

---

## 🗃️ Schema Features

- 📖 Track books, authors, and publishers  
- 🏢 Multi-branch library system  
- 👤 Borrower records with phone/address  
- 📚 Book availability per branch  
- 🔄 Loans and due-date tracking  
- ✅ Trigger to prevent duplicate borrowers  
- 🔍 Function to count books by publisher  
- 📋 Procedure to fetch borrower + book metadata  
- 🔁 Cursor to loop over borrower records  

---

## 📐 Entity-Relationship Diagram

![ER Diagram](images/er%20diagram.png)

---

## 📊 Sample Table Outputs

### 📗 `BOOK_INFO` Table  
![Book Info Table](images/book%20info%20table.png)

### 👥 `BORROWER` Table  
![Borrower Table](images/borrower%20table.png)

### 📄 `BOOK_LOANS` Table  
![Book Loans Table](images/book%20loans%20table.png)

---

## ⚙️ Logic Demonstrations

### ✅ Trigger Output: Prevent Duplicate Borrowers  
![Trigger Output](images/trigger%20output.png)

### 📋 Procedure Output: Book + Borrower Metadata  
```sql
EXEC Showdata(bookid => 'B101', bankid => 'L203');
```
![Procedure Output](images/procedure%20output.png)

### 🔁 Cursor Output: Looping Over Borrower Records  
![Cursor Output](images/cursor%20output.png)

---

## 🛠️ Technologies Used

- **Oracle SQL / PL-SQL**
- Tables, Primary & Foreign Keys  
- Triggers  
- Functions & Procedures  
- Cursors  

---

## 📦 How to Use

1. Ensure you have access to an **Oracle DB** (local or cloud).
2. Use **Oracle SQL Developer** or any Oracle-compatible SQL client.
3. Run the full script step by step from the `code.sql` file:

```sql
-- From SQL Developer or SQL*Plus
@code.sql
```

> 💡 You can capture your outputs using Lightshot or Snipping Tool and save them inside the `images/` folder for display.
