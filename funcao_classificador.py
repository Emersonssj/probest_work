#requirements

#requests==2.22.0
#scikit-learn==0.21.3
#google-cloud-storage==1.17.0

import requests
import pickle
from google.cloud import storage

def classificador(request):
    
    if request.method == 'GET':
        return "Welcome to Classifier"
    
    if request.method == 'POST':
        
        storage_client = storage.Client()
        bucket = storage_client.get_bucket('teste_models_buckets')  # write your bucket name
        data = request.get_json()
        
        blob = bucket.blob('models/decision_tree_model/model.pkl')
        blob.download_to_filename('/tmp/model.pkl')
        model = pickle.load(open('/tmp/model.pkl', 'rb'))
        data_teste = data['data_teste']
        output = model.predict(data_teste)
        pred_class = 'Text:' + str(data_teste) + '\nPredicted class is : ' + str(output)
            
    return pred_class
