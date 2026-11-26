# 🎧 SoundMetrics – Dashboard

Dashboard en Streamlit conectado a la base de datos MySQL `soundmetrics`
(proyecto final de Bases de Datos Avanzadas, UABC – Grupo 942).

## Dashboards
1. **Top canciones** por mercado y año
2. **Artistas** (ranking y evolución)
3. **México vs Global**
4. **Auditoría** (tablas llenadas por triggers)

## Cómo correrlo
1. Ejecutar `TEST.sql` completo en MySQL Workbench (crea la BD, triggers, procedures, roles y vistas).
2. Instalar librerías:
   ```
   pip install -r Sounds_Metrics/requirements.txt
   ```
3. Copiar `Sounds_Metrics/.env.example` como `Sounds_Metrics/.env` y poner tu usuario y contraseña de MySQL.
4. Ejecutar:
   ```
   streamlit run Sounds_Metrics/app.py
   ```

> Modo respaldo: agregar `DATA_SOURCE=csv` al `.env` para leer los CSV incluidos en lugar de MySQL.

## Estructura
- `app.py` – interfaz del dashboard
- `db.py` – conexión y consultas (aquí se cambiará a MongoDB en la migración)
- `.env` – credenciales (**no se sube a GitHub**)

## Equipo
Hernández De la Cruz Luis Esteban · Osuna Kevin Lamine · Soto Romano Jessica Mariel
