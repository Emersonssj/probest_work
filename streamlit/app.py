import os
import random
from joblib import dump, load
import streamlit as st
from PIL import Image
 
# loading the trained model
classifier = load('model.pkl')
 
@st.cache()
  
# defining the function which will make the prediction using the data which the user inputs 
def prediction(Gender, Married, ApplicantIncome, LoanAmount, Credit_History):   
 
    # Pre-processing user input    
    if Gender == "Male":
        Gender = 0
    else:
        Gender = 1
 
    if Married == "Unmarried":
        Married = 0
    else:
        Married = 1
 
    if Credit_History == "Unclear Debts":
        Credit_History = 0
    else:
        Credit_History = 1  
 
    LoanAmount = LoanAmount / 1000
 
    # Making predictions 
    prediction = classifier.predict( 
        [[Gender, Married, ApplicantIncome, LoanAmount, Credit_History]])
     
    if prediction == 0:
        pred = 'Rejected'
    else:
        pred = 'Approved'
    return pred
      
  
# this is the main function in which we define our webpage  
def main():       
    # front end elements of the web page 
    html_temp = """ 
    <div style ="background-color:yellow;padding:13px"> 
    <h1 style ="color:black;text-align:center;">Modelo de analise de cancer de pele</h1> 
    </div> 
    """
      
    # display the front end aspect
    st.markdown(html_temp, unsafe_allow_html = True) 
      
    # following lines create boxes in which user can enter data required to make prediction 
    result =""

    #carregar imagem aleatória
    def escolher_imagem_aleatoria():
        arquivos = os.listdir("testes")  # Lista os arquivos na pasta
        imagens = [f for f in arquivos if f.lower().endswith(('.png', '.jpg', '.jpeg', '.gif'))]  # Filtra apenas imagens
        if imagens:
            return os.path.join("testes", random.choice(imagens))  # Escolhe uma imagem aleatória
        return None  # Retorna None se não houver imagens na pasta

    # Criando um estado de sessão para armazenar a imagem atual
    if "imagem_atual" not in st.session_state:
        st.session_state.imagem_atual = escolher_imagem_aleatoria()

    # Exibir a imagem
    if st.session_state.imagem_atual:
        imagem = Image.open(st.session_state.imagem_atual)
        st.image(imagem, caption="Imagem aleatória", use_column_width=True)
    else:
        st.warning("Nenhuma imagem encontrada na pasta 'imagens'.")

    # Botão para trocar a imagem
    if st.button("Trocar Imagem 🔄"):
        st.session_state.imagem_atual = escolher_imagem_aleatoria()
        st.rerun()  # Recarrega o app para atualizar a imagem
     
    if st.button("Analisar"): 
        result = prediction() 
        st.success('Your loan is {}'.format(result))
        #print(LoanAmount)
if __name__=='__main__': 
    main()