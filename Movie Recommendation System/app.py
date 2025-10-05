import streamlit as st
import pickle
import pandas as pd
import requests


def fetch_poster(movie_id):
    url = f"https://api.themoviedb.org/3/movie/{movie_id}/images".format(movie_id)
    headers = {
        "accept": "application/json",
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIzMzgwMjg5ZTZiMGQwNjQ0ZWRlN2Q4MmJkNDI0NDc4ZCIsIm5iZiI6MTc1Mjc1NDQzMy4xMjgsInN1YiI6IjY4NzhlOTAxZjQxYjM3OTIzNDA2MjViNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.N8vs5OGftwoCsnQV6s6CfRK1hi9nLu81L_SSL0mAm8w"
    }
    response = requests.get(url, headers=headers)
    image_url = ''
    response_len = response.json()['posters']
    for i in range(len(response_len)):
        if response_len[i]['iso_639_1'] is not None:
            if response_len[i]['iso_639_1'] == 'en':
                # print(response.json()['posters'][i])
                # print('https://image.tmdb.org/t/p/w500' + response.json()['posters'][i]['file_path'])
                image_url = 'https://image.tmdb.org/t/p/w500' + response.json()['posters'][i]['file_path']
                break
    # print(response)
    return image_url
    # print(response.text)
    # if dont convert str to json
    # return 'https://image.tmdb.org/t/p/w500'+response.text.split(',')[3].split(':')[1]


def recommend(movie_title):
    index = movies_df[movies_df['title'] == movie_title].index[0]
    sim_score = similarity[index]
    sim_scores_sorted = sorted(list(enumerate(sim_score)), reverse=True, key=lambda x: x[1])
    sim_scores_top_5 = sim_scores_sorted[1:6]  # top 10 similar movies (excluding itself)
    recommended_movies = []
    recommended_movie_poster = []
    for i in sim_scores_top_5:
        # movie_id = i[0]
        movie_id = movies_df.iloc[i[0]]['movie_id']
        recommended_movies.append(movies_df.iloc[i[0]]['title'])
        recommended_movie_poster.append(fetch_poster(movie_id))
    return recommended_movies, recommended_movie_poster


st.text("Movie Recommendation System")
movies = pickle.load(open('movies_dict.pkl', 'rb'))
similarity = pickle.load(open('similarity.pkl', 'rb'))
movies_df = pd.DataFrame(movies)

selected_movie = st.selectbox(
    'Please select a movie',
    movies_df['title'].values
)
if st.button('Recommend'):
    recommended_movies, recommended_movie_poster = recommend(selected_movie)
    # for i in recommended_movies:
    #     st.write(i)
    col1, col2, col3, col4, col5 = st.columns(5)
    columns = [col1, col2, col3, col4, col5]
    for i, val in enumerate(columns):
        with val:
            st.write(recommended_movies[i])
            st.image(recommended_movie_poster[i])


