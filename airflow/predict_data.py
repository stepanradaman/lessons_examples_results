import datetime
import pandas as pd
from airflow import DAG
from airflow.operators.python_operator import PythonOperator
from airflow.operators.postgres_operator import PostgresOperator
import psycopg2
import os

import sys
import sklearn
from sklearn.svm import SVC
import joblib

os.environ["HOST_DB"] = '172.18.0.6'
os.environ["HOST_DB_port"] = '5432'
os.environ["DB_name"] = 'postgres'
os.environ["USER_DB"] ='postgres'
os.environ["PASSWORD_DB"] = 'postgres'

args = {
    'owner': 'user',
    'start_date':datetime.datetime(2018, 11, 1),
    'provide_context':True
}

def get_data_transform(**kwargs):

    ti = kwargs['ti']
    conn = psycopg2.connect(host=os.environ["HOST_DB"], port = os.environ["HOST_DB_port"], database=os.environ["DB_name"], user=os.environ["USER_DB"], password=os.environ["PASSWORD_DB"])
    cur = conn.cursor()
    cur.execute("SELECT * FROM table_transform WHERE is_worked = 0 LIMIT 1")
    query_results = cur.fetchall()

    col_names = []
    for elt in cur.description:
        col_names.append(elt[0])

    conn.close()
    cur.close()
    data = pd.DataFrame(query_results, columns=col_names)
    clf = joblib.load('/usr/local/airflow/dags/clf.pkl')
    ti.xcom_push(key='get_table_transform', value=(data[data.columns[0]][0],clf.predict(data[data.columns[1:5]])[0]))

with DAG('ml_data_transform', description='ml_data_transform', schedule_interval='*/1 * * * *',  catchup=False,default_args=args) as dag: #0 * * * *   */1 * * * *

    get_data_transform  = PythonOperator(task_id='get_data_transform', python_callable=get_data_transform)

    change_table_transform = PostgresOperator(
                            task_id="change_table_transform",
                            postgres_conn_id="database_PG",
                            sql=[f"""UPDATE table_transform SET is_worked = 1 WHERE CTID IN (SELECT CTID FROM table_transform WHERE is_worked = 0 LIMIT 1)
                            """]
                            )

    insert_in_table_predict = PostgresOperator(
                            task_id="insert_in_table_transform",
                            postgres_conn_id="database_PG",
                            sql=[f"""INSERT INTO table_predict VALUES(
                             {{{{ ti.xcom_pull(key='get_table_transform', task_ids=['get_data_transform'])[0][0] }}}},
                             {{{{ ti.xcom_pull(key='get_table_transform', task_ids=['get_data_transform'])[0][1] }}}})
                            """]
                            )

    get_data_transform >> change_table_transform >> insert_in_table_predict