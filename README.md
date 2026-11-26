# BD_PROYECTO_FINAL
En este repo, estará el proyecto final de la materia Base de datos Avanzada

# SoundMetrics 
## Spotify Charts Historical Analysis

## 1. Project Description
**SoundMetrics** is a music data analysis and management project that uses historical Spotify chart information to organize, store, and query data about songs, artists, markets, and chart rankings.

The project integrates two database management systems:
- **MySQL:** Relational data storage using a structured and normalized model.
- **MongoDB:** NoSQL data storage using collections and documents through a migration process developed in Python.

The project focuses on working with historical music chart information from the Mexico and Global markets, facilitating data organization and further analysis.

## 2. Project Objectives
### General Objective
Develop a data management solution to store, organize, and manage historical Spotify music chart information using relational and NoSQL databases.

### Specific Objectives
- Design a relational database to organize music information.
- Implement relationships between songs, artists, markets, and charts.
- Incorporate audit tables to record changes in information.
- Develop queries and processes for data management.
- Migrate information from MySQL to MongoDB using Python.
- Validate data integrity and record counts after migration.

## 3. Technologies Used

| Technology | Purpose |
|---|---|
| MySQL | Relational database |
| MongoDB | NoSQL database |
| Python 3.13 | Migration process development |
| PyMySQL | Connection between Python and MySQL |
| PyMongo | Connection between Python and MongoDB |
| MySQL Workbench | MySQL database administration |
| MongoDB Compass | MongoDB visualization and administration |
| GitHub | Version control and project repository |

## 4. MySQL Database Structure

The relational database consists of seven main entities and seven audit tables.

### Main Tables

| Table | Description |
|---|---|
| `markets` | Stores the available markets. |
| `chart_years` | Stores the years included in the analysis. |
| `songs` | Contains song information. |
| `artists` | Stores artist information. |
| `song_artists` | Establishes relationships between songs and artists. |
| `charts` | Organizes charts by market and year. |
| `chart_entries` | Stores song rankings and statistics within charts. |

### Audit Tables

| Table | Description |
|---|---|
| `markets_audit` | Records changes to markets. |
| `chart_years_audit` | Records changes to chart years. |
| `songs_audit` | Records changes to songs. |
| `artists_audit` | Records changes to artists. |
| `song_artists_audit` | Records changes to song-artist relationships. |
| `charts_audit` | Records changes to charts. |
| `chart_entries_audit` | Records changes to chart entries. |

**Total: 14 tables.**

## 5. MySQL to MongoDB Migration

A Python script named `mongo.py` was developed to transfer information from the 14 MySQL tables to MongoDB.

The migration process performs the following operations:

1. Establishes a connection to MySQL.
2. Verifies that the database exists.
3. Establishes a connection to MongoDB.
4. Checks that all 14 tables are available.
5. Retrieves records from each table.
6. Converts date fields for MongoDB compatibility.
7. Preserves primary keys through the `_id` field.
8. Inserts or updates documents in the corresponding collections.
9. Displays a summary of migrated records.
10. Closes all database connections.

### MySQL and MongoDB Correspondence

Each MySQL table is converted into a MongoDB collection with the same name.

| MySQL Table | MongoDB Collection |
|---|---|
| `markets` | `markets` |
| `chart_years` | `chart_years` |
| `songs` | `songs` |
| `artists` | `artists` |
| `song_artists` | `song_artists` |
| `charts` | `charts` |
| `chart_entries` | `chart_entries` |
| `markets_audit` | `markets_audit` |
| `chart_years_audit` | `chart_years_audit` |
| `songs_audit` | `songs_audit` |
| `artists_audit` | `artists_audit` |
| `song_artists_audit` | `song_artists_audit` |
| `charts_audit` | `charts_audit` |
| `chart_entries_audit` | `chart_entries_audit` |

## 6. Migration Results

The migration was successfully executed, processing all 14 tables.

### Transferred Records

| Collection | Records |
|---|---:|
| markets | 2 |
| chart_years | 5 |
| songs | 661 |
| artists | 390 |
| song_artists | 1,010 |
| charts | 10 |
| chart_entries | 1,000 |
| **Total** | **3,078** |

**Result:** 3,078 records read and transferred, with no migration errors.

## 7. Installation Requirements
The following software is required to run the project:
- Python 3.13 or compatible version.
- MySQL Server.
- MongoDB Server.
- MySQL Workbench.
- MongoDB Compass (optional, for document visualization).
- PyCharm or any Python-compatible code editor.

### Python Libraries

Install the required dependencies using:
```bash
python -m pip install PyMySQL pymongo
```
The `sys` and `datetime` modules are included in Python's standard library and do not require additional installation.

## 8. Configuration
Before running the script, configure the database connection parameters in `mongo.py`.

### MySQL Connection
```python
MYSQL_DB_NAME = "soundm"
MYSQL_HOST = "localhost"
MYSQL_USER = "root"
MYSQL_PASSWORD = "YOUR_PASSWORD"
```

### MongoDB Connection
```python
MONGO_DB_NAME = "soundM"
MONGO_URI = "mongodb://localhost:27017/"
```

## 9. How to Run the Project
### Step 1. Start the Database Services
Make sure MySQL Server and MongoDB Server are running.

### Step 2. Prepare the Database
Import the project's SQL file into MySQL Workbench and verify that all 14 tables exist.

### Step 3. Install Dependencies
```bash
python -m pip install PyMySQL pymongo
```

### Step 4. Configure Database Connections
Check the MySQL credentials and MongoDB connection string in `mongo.py`.

### Step 5. Run the Migration
From the terminal:

```bash
python mongo.py
```

The script can also be executed directly from PyCharm using the **Run** button.

### Step 6. Validate the Results
Open MongoDB Compass and connect using:

```text
mongodb://localhost:27017/
```


## 11. Considerations
- MySQL and MongoDB must be running before executing the migration.
- Database credentials must be configured according to the local environment.
- Audit tables are migrated even when they contain no records.
- The migration uses insert and update operations to avoid duplicating documents when executed again.
- The migration transfers table data; it does not automatically migrate MySQL triggers, stored procedures, or views.

## 12. Conclusion
SoundMetrics integrates relational and NoSQL database technologies for music information management.
MySQL provides a structured approach to organizing data through entities and relationships, while MongoDB offers an alternative document-based storage system.
The Python migration process successfully transferred 3,078 records across the 14 project tables, demonstrating connectivity and data transfer between both database management systems.

---

**Academic Project: SoundMetrics**  
*Spotify Charts Historical Analysis*
