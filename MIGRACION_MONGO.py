
import pymysql
from pymongo import MongoClient, ReplaceOne, errors
from datetime import date, datetime, time
import sys


# 1. CONFIGURACION

MYSQL_DB_NAME = "soundm"
MONGO_DB_NAME = "soundM"

MYSQL_HOST = "localhost"
MYSQL_USER = "root"
MYSQL_PASSWORD = ""

MONGO_URI = "mongodb://localhost:27017/"

# 2. TABLAS DE SOUNDMETRICS


TABLES = [
    "markets",
    "chart_years",
    "songs",
    "artists",
    "song_artists",
    "charts",
    "chart_entries",
    "markets_audit",
    "chart_years_audit",
    "songs_audit",
    "artists_audit",
    "song_artists_audit",
    "charts_audit",
    "chart_entries_audit"
]


# 3. LLAVES PRIMARIAS


PRIMARY_KEYS = {
    "markets": ["market_id"],
    "chart_years": ["year_id"],
    "songs": ["song_id"],
    "artists": ["artist_id"],
    "song_artists": ["song_id", "artist_id"],
    "charts": ["chart_id"],
    "chart_entries": ["entry_id"],
    "markets_audit": ["audit_id"],
    "chart_years_audit": ["audit_id"],
    "songs_audit": ["audit_id"],
    "artists_audit": ["audit_id"],
    "song_artists_audit": ["audit_id"],
    "charts_audit": ["audit_id"],
    "chart_entries_audit": ["audit_id"]
}

# 4. CONVERTIR TIPOS DE DATOS

def convert_dates(document):

    for field, value in document.items():

        if isinstance(value, datetime):
            continue

        elif isinstance(value, date):
            document[field] = datetime.combine(
                value, time.min
            )

    return document

# 5. GENERAR IDENTIFICADOR MONGODB


def generate_mongo_id(table_name, row):

    keys = PRIMARY_KEYS[table_name]

    values = [row[key] for key in keys]

    if len(values) == 1:
        return values[0]

    return "_".join(str(value) for value in values)


# 6. CONEXION CON MYSQL


try:

    mysql_conn = pymysql.connect(
        host=MYSQL_HOST,
        user=MYSQL_USER,
        password=MYSQL_PASSWORD
    )

    print("Conexion con MySQL exitosa.")

except pymysql.MySQLError as error:

    print("Error al conectar con MySQL:", error)
    sys.exit(1)


# 7. VERIFICAR BASE DE DATOS MYSQL


try:

    with mysql_conn.cursor() as cursor:

        cursor.execute("SHOW DATABASES")

        databases = [
            row[0] for row in cursor.fetchall()
        ]

        if MYSQL_DB_NAME not in databases:

            print(
                "No existe la base de datos:",
                MYSQL_DB_NAME
            )

            mysql_conn.close()
            sys.exit(1)

    mysql_conn.select_db(MYSQL_DB_NAME)

    print("Base de datos MySQL encontrada.")

except pymysql.MySQLError as error:

    print("Error verificando MySQL:", error)
    mysql_conn.close()
    sys.exit(1)

# 8. CONEXION CON MONGODB


try:

    mongo_client = MongoClient(
        MONGO_URI,
        serverSelectionTimeoutMS=5000
    )

    mongo_client.admin.command("ping")

    mongo_db = mongo_client[MONGO_DB_NAME]

    print("Conexion con MongoDB exitosa.")

except errors.PyMongoError as error:

    print("Error al conectar con MongoDB:", error)
    mysql_conn.close()
    sys.exit(1)


# 9. VERIFICAR TABLAS

def verify_tables():

    with mysql_conn.cursor() as cursor:

        cursor.execute("SHOW TABLES")

        existing_tables = [
            row[0] for row in cursor.fetchall()
        ]

    missing_tables = [
        table for table in TABLES
        if table not in existing_tables
    ]

    if missing_tables:

        print("Faltan las siguientes tablas:")
        print(missing_tables)

        return False

    print("Las 14 tablas fueron encontradas.")

    return True


# 10. MIGRAR UNA TABLA


def migrate_table(table_name):

    try:

        with mysql_conn.cursor(
            pymysql.cursors.DictCursor
        ) as cursor:

            cursor.execute(
                f"SELECT * FROM `{table_name}`"
            )

            rows = cursor.fetchall()

        collection = mongo_db[table_name]

        # Crear la coleccion si todavia no existe
        if table_name not in mongo_db.list_collection_names():

            mongo_db.create_collection(table_name)

        if not rows:

            print(
                f"{table_name}: no contiene registros."
            )

            return 0

        operations = []

        for row in rows:

            document = dict(row)

            # Convertir fechas
            document = convert_dates(document)

            # Conservar la llave primaria
            document["_id"] = generate_mongo_id(
                table_name, row
            )

            operation = ReplaceOne(
                {"_id": document["_id"]},
                document,
                upsert=True
            )

            operations.append(operation)

        result = collection.bulk_write(
            operations,
            ordered=False
        )

        print(
            f"Migrada: {table_name} | "
            f"Registros leidos: {len(rows)} | "
            f"Nuevos: {result.upserted_count} | "
            f"Actualizados: {result.modified_count}"
        )

        return len(rows)

    except Exception as error:

        print(
            f"Error migrando {table_name}: {error}"
        )

        raise


# 11. PROCESO PRINCIPAL

try:

    print("\nVERIFICANDO TABLAS...")

    if not verify_tables():
        sys.exit(1)

    print("\nINICIANDO MIGRACION A MONGODB\n")

    total_records = 0

    for table in TABLES:

        migrated = migrate_table(table)

        total_records += migrated

    print("\n================================")
    print("MIGRACION FINALIZADA")
    print("================================")

    print("Tablas procesadas:", len(TABLES))
    print("Registros leidos:", total_records)

    print("\nREGISTROS EN MONGODB:")

    for table in TABLES:

        total = mongo_db[table].count_documents({})

        print(f"{table}: {total}")

except Exception as error:

    print("\nLa migracion no se completo:", error)

# 12. CERRAR CONEXIONES

finally:

    mysql_conn.close()
    mongo_client.close()

    print("\nConexiones cerradas.")
