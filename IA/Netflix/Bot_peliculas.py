import pandas as pd
import difflib
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity


# Cargue los datos de la película desde el archivo CSV
movies_data = pd.read_csv('./movies.csv')


# Complete los valores faltantes con cadenas vacías y combine las funciones seleccionadas
combined = ''
selected_features = ['genres', 'keywords', 'tagline', 'cast', 'director']

for feature in selected_features:
    movies_data[feature] = movies_data[feature].fillna('')
    combined += movies_data[feature]

# Inicializar el vectorizador TF-IDF
vectorizer = TfidfVectorizer()


# Transformar el texto combinado en vectores de características
feature_vectorizer = vectorizer.fit_transform(combined)


# Calculate cosine similarity between movies
similarity = cosine_similarity(feature_vectorizer)


# Obtener la película favorita del usuario
movie_name = input("Ingresa el nombre de tu película favorita: ")


# Encuentra coincidencias cercanas a la entrada del usuario
list_of_all_titles = movies_data['title'].to_list()
find_close_match = difflib.get_close_matches(movie_name, list_of_all_titles)

if not find_close_match:
    print("Sorry, we couldn't find a close match for your input.")
else:
    close_match = find_close_match[0]
    index_of_movie = movies_data[movies_data.title == close_match]['index'].values[0]


    # Obtener puntuaciones de similitud para la película seleccionada
    similarity_score = list(enumerate(similarity[index_of_movie]))


    # Ordenar películas por puntuación de similitud en orden descendente
    sorted_similar_movies = sorted(similarity_score, key=lambda x: x[1], reverse=True)

    print('Películas sugeridas: \n')
    i = 1
    for movie in sorted_similar_movies:
        index = movie[0]
        title_from_index = movies_data[movies_data.index == index]['title'].values[0]
        if i <= 20:
            print(i, title_from_index)
            i += 1
            