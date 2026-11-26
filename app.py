"""
SoundMetrics - Dashboard (Streamlit)
"""
import pandas as pd
import plotly.express as px
import streamlit as st

import db

st.set_page_config(page_title="SoundMetrics", page_icon="🎧", layout="wide")


# ------------------------------------------------------------ carga de datos
@st.cache_data(ttl=300)
def load_data():
    return db.get_song_details(), db.get_artist_stats()


try:
    songs, artists = load_data()
except Exception as e:
    st.error("No pude conectarme a la base de datos. Revisa tu archivo .env y que MySQL esté encendido.")
    st.exception(e)
    st.stop()

fmt = lambda n: f"{n:,.0f}"

# ------------------------------------------------------------------- sidebar
st.sidebar.title("🎧 SoundMetrics")
st.sidebar.caption("Métricas musicales · MySQL")
pagina = st.sidebar.radio(
    "Dashboards",
    ["1. Top canciones", "2. Artistas", "3. México vs Global", "4. Auditoría"],
)
st.sidebar.divider()
st.sidebar.caption(f"{len(songs):,} registros de ranking cargados")

mercados = sorted(songs["market_name"].unique())
anios = sorted(songs["year_value"].unique(), reverse=True)


# ============================================================ DASHBOARD 1
if pagina.startswith("1"):
    st.title("🎵 Top canciones por mercado y año")
    st.caption("Responde: ¿cuáles son las canciones más escuchadas y cuánto duran en el ranking?")

    c1, c2, c3 = st.columns(3)
    mercado = c1.selectbox("Mercado", mercados)
    anio = c2.selectbox("Año", anios)
    top_n = c3.slider("Canciones en la gráfica", 5, 30, 10)

    f = songs[(songs["market_name"] == mercado) & (songs["year_value"] == anio)].sort_values("annual_rank")

    if f.empty:
        st.warning("No hay datos para esa combinación.")
        st.stop()

    m1, m2, m3, m4 = st.columns(4)
    m1.metric("Canciones en el ranking", fmt(len(f)))
    m2.metric("Streams totales", fmt(f["annual_streams"].sum()))
    m3.metric("Semanas promedio en lista", f"{f['weeks_charted'].mean():.1f}")
    m4.metric("#1 del año", f.iloc[0]["song_title"])

    top = f.head(top_n)
    fig = px.bar(
        top, x="annual_streams", y="song_title", orientation="h",
        hover_data=["artists", "annual_rank", "weeks_charted"],
        labels={"annual_streams": "Streams", "song_title": "Canción"},
        title=f"Top {top_n} por streams · {mercado} {anio}",
    )
    fig.update_layout(yaxis=dict(autorange="reversed"))
    st.plotly_chart(fig, use_container_width=True)

    st.subheader("Tabla completa del ranking")
    tabla = f[["annual_rank", "song_title", "artists", "annual_streams",
               "weeks_charted", "best_weekly_rank"]].rename(columns={
        "annual_rank": "Posición", "song_title": "Canción", "artists": "Artistas",
        "annual_streams": "Streams", "weeks_charted": "Semanas en lista",
        "best_weekly_rank": "Mejor posición semanal"})
    st.dataframe(tabla, hide_index=True, use_container_width=True)


# ============================================================ DASHBOARD 2
elif pagina.startswith("2"):
    st.title("🎤 Artistas")
    st.caption("Responde: ¿qué artistas dominan cada mercado y cómo evolucionan en el tiempo?")

    c1, c2, c3 = st.columns(3)
    mercado = c1.selectbox("Mercado", mercados)
    anio = c2.selectbox("Año", anios)
    metrica = c3.radio("Ordenar por", ["Streams totales", "Canciones en ranking"], horizontal=True)

    col = "total_streams" if metrica == "Streams totales" else "total_songs"
    f = artists[(artists["market_name"] == mercado) & (artists["year_value"] == anio)]
    top = f.sort_values(col, ascending=False).head(15)

    if top.empty:
        st.warning("No hay datos para esa combinación.")
        st.stop()

    m1, m2, m3 = st.columns(3)
    m1.metric("Artistas en el ranking", fmt(len(f)))
    m2.metric("Artista #1", top.iloc[0]["artist_name"])
    m3.metric("Posición promedio del #1", f"{top.iloc[0]['average_rank']:.1f}")

    fig = px.bar(
        top, x=col, y="artist_name", orientation="h",
        hover_data=["total_songs", "average_rank"],
        labels={col: metrica, "artist_name": "Artista"},
        title=f"Top 15 artistas · {mercado} {anio}",
    )
    fig.update_layout(yaxis=dict(autorange="reversed"))
    st.plotly_chart(fig, use_container_width=True)

    st.subheader("Evolución de un artista")
    nombre = st.selectbox("Artista", sorted(artists["artist_name"].dropna().unique()))
    hist = artists[artists["artist_name"] == nombre].sort_values("year_value")
    fig2 = px.line(
        hist, x="year_value", y="total_streams", color="market_name", markers=True,
        labels={"year_value": "Año", "total_streams": "Streams", "market_name": "Mercado"},
        title=f"Streams por año · {nombre}",
    )
    fig2.update_xaxes(dtick=1)
    st.plotly_chart(fig2, use_container_width=True)
    st.dataframe(
        hist[["market_name", "year_value", "total_songs", "total_streams", "average_rank"]].rename(columns={
            "market_name": "Mercado", "year_value": "Año", "total_songs": "Canciones",
            "total_streams": "Streams", "average_rank": "Posición promedio"}),
        hide_index=True, use_container_width=True)


# ============================================================ DASHBOARD 3
elif pagina.startswith("3"):
    st.title("🌎 México vs Global")
    st.caption("Responde: ¿cómo cambia el consumo entre mercados y qué canciones aparecen en ambos?")

    por_anio = songs.groupby(["year_value", "market_name"], as_index=False).agg(
        streams=("annual_streams", "sum"),
        semanas_prom=("weeks_charted", "mean"),
        canciones=("song_title", "count"),
    )

    c1, c2 = st.columns(2)
    fig = px.line(por_anio, x="year_value", y="streams", color="market_name", markers=True,
                  labels={"year_value": "Año", "streams": "Streams", "market_name": "Mercado"},
                  title="Streams totales del ranking por año")
    fig.update_xaxes(dtick=1)
    c1.plotly_chart(fig, use_container_width=True)

    fig = px.bar(por_anio, x="year_value", y="semanas_prom", color="market_name", barmode="group",
                 labels={"year_value": "Año", "semanas_prom": "Semanas promedio", "market_name": "Mercado"},
                 title="Semanas promedio en lista")
    fig.update_xaxes(dtick=1)
    c2.plotly_chart(fig, use_container_width=True)

    st.subheader("Canciones que están en ambos mercados")
    anio = st.selectbox("Año", anios)
    f = songs[songs["year_value"] == anio]
    ancho = f.pivot_table(index=["song_title", "artists"], columns="market_name",
                          values="annual_rank", aggfunc="min").reset_index()

    if len(mercados) >= 2 and all(m in ancho.columns for m in mercados):
        comunes = ancho.dropna(subset=mercados)
        st.metric("Canciones en ambos rankings", len(comunes))
        st.dataframe(comunes.sort_values(mercados[0]), hide_index=True, use_container_width=True)
        st.caption("Los números son la posición anual en cada mercado.")
    else:
        st.info("No hay suficientes mercados para comparar.")

    st.subheader("Resumen por año y mercado")
    st.dataframe(por_anio.rename(columns={
        "year_value": "Año", "market_name": "Mercado", "streams": "Streams",
        "semanas_prom": "Semanas promedio", "canciones": "Canciones"}),
        hide_index=True, use_container_width=True)


# ============================================================ DASHBOARD 4
else:
    st.title("🛡️ Auditoría de cambios")
    st.caption("Registro automático de los triggers: quién cambió qué y cuándo.")

    tabla = st.selectbox("Tabla de auditoría", db.AUDIT_TABLES)
    try:
        df = db.get_audit(tabla)
    except Exception as e:
        st.error("No se pudo leer la tabla de auditoría.")
        st.exception(e)
        st.stop()

    if df.empty:
        st.info("Esta tabla aún no tiene movimientos. Haz un INSERT/UPDATE/DELETE en la BD y recarga.")
    else:
        m1, m2, m3 = st.columns(3)
        m1.metric("Movimientos mostrados", len(df))
        m2.metric("Usuarios distintos", df["changed_by"].nunique())
        m3.metric("Último cambio", str(df["changed_at"].max()))

        resumen = df["action_type"].value_counts().reset_index()
        resumen.columns = ["Operación", "Cantidad"]
        st.plotly_chart(px.pie(resumen, names="Operación", values="Cantidad",
                               title="Operaciones registradas"), use_container_width=True)
        st.dataframe(df, hide_index=True, use_container_width=True)
