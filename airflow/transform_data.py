import datetime
import pandas as pd
from airflow import DAG
from airflow.operators.python_operator import PythonOperator
from airflow.operators.postgres_operator import PostgresOperator
import psycopg2
import os

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

def get_data_base(**kwargs):

    ti = kwargs['ti']
    conn = psycopg2.connect(host=os.environ["HOST_DB"], port = os.environ["HOST_DB_port"], database=os.environ["DB_name"], user=os.environ["USER_DB"], password=os.environ["PASSWORD_DB"])
    cur = conn.cursor()
    cur.execute("SELECT * FROM table_base WHERE is_worked = 0 LIMIT 1")
    query_results = cur.fetchall()

    col_names = []
    for elt in cur.description:
        col_names.append(elt[0])

    conn.close()
    cur.close()
    data = pd.DataFrame(query_results, columns=col_names)

    ti.xcom_push(key='get_table_base', value=(data.iloc[0]))
                    
with DAG('ml_data_base', description='ml_data_base', schedule_interval='*/1 * * * *',  catchup=False,default_args=args) as dag: #0 * * * *   */1 * * * *

    get_data_base  = PythonOperator(task_id='get_data_base', python_callable=get_data_base)

    change_table_base = PostgresOperator(
                            task_id="change_table_base",
                            postgres_conn_id="database_PG",
                            sql=[f"""UPDATE table_base SET is_worked = 1 WHERE CTID IN (SELECT CTID FROM table_base WHERE is_worked = 0 LIMIT 1)
                            """]
                            )

    insert_in_table_transform = PostgresOperator(
                            task_id="insert_in_table_transform",
                            postgres_conn_id="database_PG",
                            sql=[f"""INSERT INTO table_transform VALUES(
                             {{{{ ti.xcom_pull(key='get_table_base', task_ids=['get_data_base'])[0][0] }}}},
                             {{{{ ti.xcom_pull(key='get_table_base', task_ids=['get_data_base'])[0][1] }}}},
                             {{{{ ti.xcom_pull(key='get_table_base', task_ids=['get_data_base'])[0][2] }}}},
                             {{{{ ti.xcom_pull(key='get_table_base', task_ids=['get_data_base'])[0][3] }}}},
                             {{{{ ti.xcom_pull(key='get_table_base', task_ids=['get_data_base'])[0][4] }}}},
                             0)    
                            """]
                            )

    get_data_base >> change_table_base >> insert_in_table_transform