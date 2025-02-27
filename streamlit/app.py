import os
import numpy as np
import streamlit as st
from joblib import load
from PIL import Image

# Carregar o modelo treinado
classifier = load('model.pkl')

# Função para pré-processamento da imagem
def process_image(imagem_pil, largura=600, altura=450):
    """
    Converte a imagem carregada para o formato necessário ao modelo.
    - Redimensiona a imagem para largura x altura.
    - Converte para array NumPy.
    - Normaliza os valores para [0,1].
    - Achata a matriz em um vetor 1D.
    """
    img = imagem_pil.resize((largura, altura))
    img_array = image.img_to_array(img)  # Converte para array NumPy
    img_array = img_array / 255.0  # Normaliza os pixels
    img_flatten = img_array.flatten()  # Achata a matriz para vetor 1D
    return img_flatten.reshape(1, -1)  # Retorna no formato esperado pelo modelo

# Interface do Streamlit
def main():
    st.title("Análise de Câncer de Pele")
    
    uploaded_file = st.file_uploader("Envie uma imagem de pele para análise", type=["png", "jpg", "jpeg"])
    
    if uploaded_file is not None:
        imagem_pil = Image.open(uploaded_file).convert("RGB")  # Garantir que é RGB
        # st.image(imagem_pil, caption="Imagem carregada", use_container_width=True)
        
        if st.button("Analisar"):
            try:
                processed_image = process_image(imagem_pil)
                resultado = classifier.predict(processed_image)
                
                pred = "Câncer Maligno Detectado" if resultado[0] == 1 else "Câncer Benigno Detectado"
                st.success(f'Resultado da análise: {pred} {resultado}')
            except Exception as e:
                st.error(f"Erro ao processar a imagem: {e}")

if __name__ == '__main__':
    main()
