#!/usr/bin/env python

# python lambda to replace SWM pg_cron


import psycopg2
import logging
import traceback
import json
from os import environ

endpoint=environ.get('ENDPOINT')
port=environ.get('PORT')
dbuser=environ.get('DBUSER')
password=environ.get('DBPASSWORD')
database=environ.get('DATABASE')

queriesTmp=environ.get('QUERY')

logger=logging.getLogger()
logger.setLevel(logging.INFO)


def make_connection():
    conn_str="host={0} dbname={1} user={2} password={3} port={4}".format(
        endpoint,database,dbuser,password,port)
    conn = psycopg2.connect(conn_str)
    conn.autocommit=True
    return conn 


def log_err(errmsg):
    logger.error(errmsg)
    return {"body": errmsg , "headers": {}, "statusCode": 400,
        "isBase64Encoded":"false"}

logger.info("Cold start complete.") 

def handler(event,context):

    try:
        queries = json.loads(queriesTmp)
        logger.info(queries)
    except:
        return log_err("ERROR: Cannot parse queries JSON.\n{}".format(
            traceback.format_exc()))
    
    try:
        cnx = make_connection()
        cursor=cnx.cursor()
        for query in queries:
			try:
				logger.info(query['q'])
				cursor.execute(query['q'])
			except:
				return log_err ("ERROR: Cannot execute cursor.\n{}".format(
					traceback.format_exc()) )

        try:
            cursor.close()

        except:
            return log_err ("ERROR: Cannot close connection.\n{}".format(
                traceback.format_exc()))


        return {"body": "OK", "headers": {}, "statusCode": 200,
        "isBase64Encoded":"false"}
    
    except:
        return log_err("ERROR: Cannot connect to database from handler.\n{}".format(
            traceback.format_exc()))


    finally:
        try:
            cnx.close()
        except:
            pass


if __name__== "__main__":
    handler(None,None)