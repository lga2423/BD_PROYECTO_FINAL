"""
db.py  -  Capa de acceso a datos de SoundMetrics.

Toda la conexión y las consultas viven aquí. app.py solo llama a estas funciones.
Así, cuando el equipo migre a MongoDB, solo hay que reescribir ESTE archivo
(las funciones deben seguir devolviendo los mismos DataFrames).
"""
import os

# Evita que Windows bloquee las extensiones compiladas de SQLAlchemy
# (error "Application Control policy has blocked this file").
# Debe ir ANTES de importar sqlalchemy.
os.environ.setdefault("DISABLE_SQLALCHEMY_CEXT_RUNTIME", "1")

import pandas as pd
import streamlit as st
from dotenv import load_dotenv
from sqlalchemy import create_engine, text
from sqlalchemy.engine import URL

load_dotenv()  # lee el archivo .env


@st.cache_resource
def get_engine():
    """Crea la conexión a MySQL una sola vez."""
    url = URL.create(
        "mysql+pymysql",
        username=os.getenv("DB_USER", "analyst_test"),
        password=os.getenv("DB_PASSWORD", ""),
        host=os.getenv("DB_HOST", "localhost"),
        port=int(os.getenv("DB_PORT", "3306")),
        database=os.getenv("DB_NAME", "soundmetrics"),
    )
    return create_engine(url, pool_pre_ping=True)


@st.cache_data(ttl=300)
def run_query(sql: str) -> pd.DataFrame:
    """Ejecuta un SELECT y devuelve un DataFrame (cache de 5 min)."""
    with get_engine().connect() as conn:
        return pd.read_sql(text(sql), conn)


# ---------------------------------------------------------------- consultas
def get_song_details() -> pd.DataFrame:
    """Vista song_details: una fila por canción, mercado y año."""
    df = run_query("SELECT * FROM song_details")
    for col in ["year_value", "annual_rank", "annual_streams",
                "weeks_charted", "best_weekly_rank"]:
        df[col] = pd.to_numeric(df[col])
    return df


def get_artist_stats() -> pd.DataFrame:
    """Vista artist_stats: métricas por artista, mercado y año."""
    df = run_query("SELECT * FROM artist_stats")
    for col in ["year_value", "total_songs", "total_streams", "average_rank"]:
        df[col] = pd.to_numeric(df[col])  # SUM/AVG llegan como Decimal
    return df


AUDIT_TABLES = [
    "markets_audit", "chart_years_audit", "songs_audit", "artists_audit",
    "song_artists_audit", "charts_audit", "chart_entries_audit",
]


def get_audit(table: str, limit: int = 200) -> pd.DataFrame:
    """Últimos movimientos de una tabla de auditoría (solo nombres permitidos)."""
    if table not in AUDIT_TABLES:
        raise ValueError("Tabla de auditoría no permitida")
    return run_query(f"SELECT * FROM {table} ORDER BY changed_at DESC LIMIT {int(limit)}")
