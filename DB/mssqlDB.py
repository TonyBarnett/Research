__author__ = 'Tony'
import pymssql

import researchdb


class mssqlDB(researchdb, pymssql):
    "This class is for connecting to an MSSQL database."
    #  __db = ''
    #  __uid = ''

    #  _uid =

    def __init__(self, server='localhost', username='sa', password='deter101!'):
        self._server = server
        self._uid = username
        self._pwd = password
        pass

    def run_stored_procedure(self, database, sp_name, params):
        with pymssql.connect(self._server, self._uid, self._pwd, database) as conn:
            with conn.cursor() as cursor:
                cursor.callproc(sp_name, params)
                return (row for row in cursor)
        pass

    def run_query(self, database, query, params=None):
        with pymssql.connect(self._server, self._uid, self._pwd, database) as conn:
            with conn.cursor() as cursor:
                conn.autocommit(True)
                cursor.execute(query % params if params else query)
        pass