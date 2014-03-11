import pymssql
import csv

server = 'localhost'
database = 'CrapDump'
login = 'sa'
password = 'deter101'

tableExists = False

columns = [('intCategory', 'int', 'NOT NULL'), ('flt1997', 'float', 'NULL'), ('flt1998', 'float', 'NULL'),
    ('flt1999', 'float', 'NULL'), ('flt2000', 'float', 'NULL'), ('flt2001', 'float', 'NULL'),
    ('flt2002', 'float', 'NULL'), ('flt2003', 'float', 'NULL'), ('flt2004', 'float', 'NULL'),
    ('flt2005', 'float', 'NULL'), ('flt2006', 'float', 'NULL'), ('flt2007', 'float', 'NULL'),
    ('flt2008', 'float', 'NULL'), ('flt2009', 'float', 'NULL'), ('flt2010', 'float', 'NULL')]

primaryKey = ['intCategory']
tableName = 'IOModelIntensities'

csvFile = r'..\IO Model source data\SimEqFiles\Scaled\Intensities.csv'

skipRows = 1

#  construct the table definition, td is essentially a stringBuilder
def createTD(tableName, cols, pk):
    td = '''    IF EXISTS (SELECT NULL FROM sys.tables WHERE name = \'''' + tableName + '''\')
                BEGIN
                    DROP TABLE ''' + tableName + '''
                END

 CREATE TABLE ''' + tableName + ' ('
    for column in cols:
        td += column[0] + ' ' + column[1] + ' ' + column[2] + ', '

    td += 'CONSTRAINT ' + tableName + '_PK PRIMARY KEY ('
    for p in pk:
        td += p + ','
    td = td[:-1] + '))'

    return td


def createInsert(tableName, cols):
    insert = 'INSERT INTO ' + tableName + ' VALUES ( '

    for col in cols:
        if col[1] in ('float', 'int', 'money'):
            insert += '%d,'
        else:
            insert += '%s,'
    insert = insert[:-1] + ')'
    return insert


if not tableExists:
    with pymssql.connect(server, login, password, database) as conn:
        with conn.cursor() as cursor:
            cursor.execute(createTD(tableName, columns, primaryKey))
            conn.commit()

with open(csvFile) as f:
    read = csv.reader(f, delimiter=',', quotechar='"')
    data = [tuple(row) for row in read]

del (data[0: skipRows])

if not len(columns) == len(data[0]):
    raise Exception('number of columns in table != number of columns in data')

with pymssql.connect(server, login, password, database) as conn:
    with conn.cursor() as cursor:
        cursor.executemany(createInsert(tableName, columns), data)
        conn.commit()