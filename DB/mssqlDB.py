__author__ = 'Tony'
import pymssql

import researchdb


class mssqlDB(researchdb, pymssql):

    _hungarian_decorators = {
        'str': '%s,',
        'flt': '%d,',
        'mon': '%d,',
        'int': '%d,',
        'lng': '%d,',
        'bol': '%d,',
        'bit': '%d,'
    }

    "This class is for connecting to an MSSQL database."
    #  __db = ''
    #  __uid = ''

    #  _uid =

    def __init__(self, server='localhost', username='sa', password='deter101!'):
        self._server = server
        self._uid = username
        self._pwd = password

    def run_stored_procedure(self, database, sp_name, params=None):
        with pymssql.connect(self._server, self._uid, self._pwd, database) as conn:
            with conn.cursor() as cursor:
                cursor.callproc(sp_name, params)
                return (row for row in cursor)

    def run_query(self, database, query, params=None):
        with pymssql.connect(self._server, self._uid, self._pwd, database) as conn:
            with conn.cursor() as cursor:
                conn.autocommit(True)
                cursor.execute(query % params if params else query)

    def read_from_database(self, database, query):
        with pymssql.connect(self._server, self._uid, self._pwd, database) as conn:
            with conn.cursor() as cursor:
                pass

    @staticmethod
    def _is_hungarian(self):
        return True if self[0:3] in self._hungarian_decorators.keys() else False

    @staticmethod
    def _get_column_from_hungarian(self):
        return self._hungarian_decorators[self[0:3]]

    @staticmethod
    def _guess_columns_types_from_dict(self):
        columns = ''
        for column, value in self.items():
            if column._is_hungrian():
                columns += column._get_column_from_hungarian()
            elif isinstance(value, bool) or isinstance(value, int) or isinstance(value,float):
                columns += '%d,'
            else:
                columns += '%s,'
        return columns[0:-1]

    @staticmethod
    def _guess_columns_types_from_tuple(self):
        columns = ''
        for column,value in self.items():
            if isinstance(value, bool) or isinstance(value, int) or isinstance(value,float):
                columns += '%d,'
            else:
                columns += '%s,'
        return columns[0:-1]

    @staticmethod
    def _guess_column_types(self):
        if isinstance(self, dict):
            return self._guess_columns_types_from_dict()

        elif isinstance(self, tuple):
            return self._guess_column_types_tuple()
        else:
            raise ValueError('must be tuple of dict')


    def write_to_database(self, database, table, params, data, ):
        with pymssql.connect(self._server, self._uid, self._pwd, database) as conn:
            with conn.cursor() as cursor:
                if isinstance(data[0],tuple):
                    cols = data[0]._guess_column_types()
                else:
                    cols = data._guess_column_types()

                cursor.executemany('INSERT INTO {0} VALUES ({1})'.format(table, cols), data)
                conn.commit()
                pass