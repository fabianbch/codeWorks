# Importar las bibliotecas necesarias
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Configuración global de Seaborn
sns.set(style="whitegrid")  # Estilo gráfico limpio
plt.rcParams['figure.dpi'] = 100  # Aumentar la calidad de las imágenes

# Cargar el dataset
df = pd.read_csv('netflix_titles.csv')

# Vista previa de los primeros registros
print(df.head())

# Información general del dataset
print(df.info())

# Estadísticas descriptivas del dataset
print(df.describe())

# Limpieza de datos: Manejo de valores faltantes en las columnas director y cast
df.dropna(subset=['director', 'cast'], inplace=True)

# Análisis de la distribución de tipos de contenido (Películas vs TV Shows)
plt.figure(figsize=(8, 6))
sns.countplot(data=df, x='type', hue=None, palette='Set2', legend=False)  # Corregido palette y legend
plt.title('Distribución de Películas y Programas de TV')
plt.xlabel('Tipo de Contenido')
plt.ylabel('Cantidad')
plt.show()

# Distribución del contenido por país (Top 10)
plt.figure(figsize=(10, 8))
df['country'].value_counts().head(10).plot(kind='bar', color='skyblue')
plt.title('Top 10 Países con más Contenidos en Netflix')
plt.ylabel('Número de Contenidos')
plt.xlabel('País')
plt.xticks(rotation=45)
plt.show()

# Conteo de contenido lanzado por año
plt.figure(figsize=(10, 6))
df['release_year'].value_counts().sort_index().plot(kind='line', color='red')
plt.title('Contenidos lanzados por año')
plt.ylabel('Número de Contenidos')
plt.xlabel('Año de lanzamiento')
plt.grid(True)
plt.show()

# Conversión de la columna "duration" a numérica para películas
def convert_duration(duration):
    """Convierte la duración de películas a minutos."""
    try:
        return int(duration.split(' ')[0])
    except:
        return None

df_movies = df[df['type'] == 'Movie'].copy()
df_movies['duration'] = df_movies['duration'].apply(convert_duration)

# Duración media de las películas (en minutos)
print("Duración media de las películas:", df_movies['duration'].mean())

# Duración media de los programas de TV (en temporadas)
df_shows = df[df['type'] == 'TV Show'].copy()
df_shows['duration'] = df_shows['duration'].str.extract('(\d+)').astype(float)
print("Duración media de los programas de TV (en temporadas):", df_shows['duration'].mean())

# Relación entre la duración de los programas de TV (en temporadas)
plt.figure(figsize=(10, 6))
sns.histplot(df_shows['duration'], kde=True, color='green')
plt.title('Distribución de duración de programas de TV (en temporadas)')
plt.xlabel('Duración (número de temporadas)')
plt.ylabel('Frecuencia')
plt.show()
