import csv
import pymssql
import itertools

year = 1997
server = "localhost"
user = "sa"
password = "deter101"


def getratio(m, t):
    et = dict([])
    r = dict([])
    for e, o in [(x["e"], x["o"]) for x in m]:
        if e in et:
            et[e] += int(t[o])
        else:
            et[e] = int(t[o])

    for e, o in [(x["e"], x["o"]) for x in m]:
        r[o] = float(t[o]) / float(et[e])

    return r


def widena(d, m, r):
    s = []
    e = sorted(set([y["e"] for y in m]))
    for x in d:
        #  loop over each dictionary in maps and multiply temp(e) by eTotal(maps(e)->o)
        temp = dict(zip(e, x))
        a = list(zip([y["o"] for y in m], (float(temp[y["e"]]) * r[y["o"]] for y in m)))
        c = dict([])
        for i, j in itertools.groupby(a, lambda b: b[0]):
            c[i] = sum([k[1] for k in j])
        s.append([d[1] for d in c.items()])
    return s


for year in range(1997, 2011, 1):
    # writing V matrix
    with open(r'..\\IO Model source data\\RASFiles\\output\\colTotal_cRAS_{0}.csv'.format(str(year))) as f:
        read = csv.reader(f, delimiter=',', quotechar='"')
        data = [row for row in read]

    with open(r'..\\IO Model source data\\F{0}.csv'.format(str(year))) as f:
        read = csv.reader(f, delimiter=',', quotechar='"')
        tots = [row for row in read]

    if ['', 'Total final demand'] in tots:
        tots.remove(['', 'Total final demand'])

    if ['', 'Total demand for products'] in tots:
        tots.remove(['', 'Total demand for products'])

    #  Update F in the database to the values that are in the file mentioned above.
    with pymssql.connect(server, user, password, "IOModel_20140113") as conn:
        with conn.cursor(as_dict=True) as cursor:
            for tot in tots:
                cursor.execute(''' UPDATE F SET monTotal = %d WHERE intYear = %d AND strSic2007 = %s ''',
                    (tot[1], year, tot[0]))

    with pymssql.connect(server, user, password, "IOModel_20140113") as conn:
        with conn.cursor(as_dict=True) as cursor:
            cursor.execute(''' SELECT intCategoryId, SUM(monTotal) AS monTotal
                                FROM F f
                                    INNER JOIN (
                                        SELECT DISTINCT strA, intCategoryId
                                        FROM IOModel_20140113..ABMap
                                    ) m ON m.strA = f.strSic2007
                                WHERE intYear = %d
                                GROUP BY m.intCategoryId''', year)
            totals = dict((row["intCategoryId"], row["monTotal"]) for row in cursor)

    with open(r'..\\IO Model source data\\SimEqFiles\\Scaled\\Y{0}.csv'.format(str(year)), 'w', newline='') as f:
        writer = csv.writer(f)
        writer.writerows([[x] for x in totals.values()])

    with pymssql.connect(server, user, password, "CrapDump") as conn:
        with conn.cursor(as_dict=True) as cursor:
            cursor.execute('''  SELECT strValue1 AS e, a.intCategoryId AS o
                                FROM clasMap m
                                    INNER JOIN (
                                        SELECT DISTINCT strA, intCategoryId
                                        FROM IOModel_20140113..ABMap
                                    ) a ON a.strA = m.strValue2''')
            maps = [x for x in cursor]

    r = getratio(maps, totals)
    stretched = widena(data, maps, r)
    stretched = widena(list(map(list, zip(*stretched))), maps, r)
    stretched = list(map(list, zip(*stretched)))

    with open(r'..\\IO Model source data\\SimEqFiles\\Scaled\\V{0}.csv'.format(str(year)), 'w', newline='') as f:
        writer = csv.writer(f)
        writer.writerows(stretched)

    #  Writing U matrix
    with pymssql.connect(server, user, password, "IOModel_20140113") as conn:
        with conn.cursor(as_dict=True) as cursor:
            cursor.execute('''  SELECT f.intCategoryId AS f, t.intCategoryId AS t, SUM(a.monTotal) AS total
                                FROM A a
                                    INNER JOIN (
                                        SELECT DISTINCT strA, intCategoryId
                                        FROM ABMap
                                    ) f ON f.strA = a.strSic2007From
                                    INNER JOIN (
                                        SELECT DISTINCT strA, intCategoryId
                                        FROM ABMap
                                    ) t ON t.strA = a.strSic2007To
                                 WHERE intYear = %s
                                 GROUP BY f.intCategoryId, t.intCategoryId
                                 ORDER BY 1,2''', year)
            a = [x for x in cursor]
    b = {}
    for i in a:
        if i["f"] not in b.keys():
            b[i["f"]] = {}
        b[i["f"]][i["t"]] = i["total"]

    with open(r'..\\IO Model source data\\SimEqFiles\\Scaled\\U{0}.csv'.format(str(year)), 'w', newline='') as f:
        writer = csv.writer(f)
        d = [list(c.values()) for c in b.values()]  #  convert a dict of dicts to a list of lists
        writer.writerows(d)

    #  writing E vectors
    with pymssql.connect(server, user, password, "IOModel_20140113") as conn:
        with conn.cursor(as_dict=True) as cursor:
            cursor.execute('''  SELECT m.intCategoryId, SUM(b.fltCO2) AS co
                                FROM B b
                                    INNER JOIN (
                                        SELECT DISTINCT StrB, intCategoryId
                                        FROM ABMap
                                    ) m ON m.strB = b.strSic2007
                                WHERE intYear = %d
                                GROUP BY m.intCategoryId ''', year)
            E = [x for x in cursor]
    e = [list((x["intCategoryId"], x["co"])) for x in E]

    with open(r'..\\IO Model source data\\SimEqFiles\\Scaled\\E{0}.csv'.format(str(year)), 'w', newline='') as f:
        writer = csv.writer(f)
        writer.writerows(e)