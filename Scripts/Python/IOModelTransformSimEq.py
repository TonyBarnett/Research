import csv
import re

### string to int
### stoi('A') = 0
### stoi('B') = 1000
### stoi('AA') = 2600
def stoi(x):
    t = 0
    y = x[::-1]
# I assume len(x) !> 3
    if(len(y)>2):  # x > 'AAA'
        t += (ord(y[2]) - 64) * 676000  # 26 * 26 * 1000

    if(len(y)>1):  # z > 'AA'
        t += (ord(y[1]) - 64) * 26000  # 26 * 1000

    t += (ord(y[0]) - 67) * 1000
    return t


for year in range(1997, 2011, 1):
    simeqs = [(r'..\IO Model source data\SimEqFiles\SimEqUnknowns' + str(year) + '.csv','unknowns'),(r'..\IO Model source data\SimEqFiles\SimEq' + str(year) + '.csv', 'knowns')]
    for s in simeqs:
        with open(s[0]) as csvfile:
            read = csv.reader(csvfile, delimiter='=', quotechar='"')
            values, total = zip(*[(row[0].split('+'), row[1]) for row in read])

            headers = list(set(item for i in values for item in i))  # Executes the for i in values, then the for item in i so i is each list of elements and item is each element of each list of elements.
            headers.sort(key=lambda x: (len(x), x))  # This only works because we don't have anything in rows 1-9.

            output = []

            i = 0
            for v in values:
                output.append([])
                for h in headers:
                    if v.__contains__(h):
                        output[i].append(1)
                    else:
                        output[i].append(0)
                i += 1

            with open(r'..\IO Model source data\SimEqFiles\output' + s[1] + str(year) + '.csv', 'w', newline='') as f:
                writer = csv.writer(f)
                writer.writerows(output)

            with open(r'..\IO Model source data\SimEqFiles\headers' + s[1] + str(year) + '.csv', 'w', newline='') as wr:
                write = csv.writer(wr)
                write.writerows([headers])

            with open(r'..\IO Model source data\SimEqFiles\totals' + s[1] + str(year) + '.csv', 'w', newline='') as f:
                write = csv.writer(f)
                write.writerows([total])

        output = []
        i = 0
        for se in values:
            output.append([])
            output[i] = [(stoi(re.search(r'([A-Za-z]+)', r).group(0)) + int(re.search(r'[0-9]+', r).group(0)) - 7) for r in se]
            i += 1

        length = len(max(output, key=len))

        for o in output:
            while len(o) < length:
                o.append(0)

        with open(r'E:\Dropbox\IO Model source data\SimEqFiles\cRASInput' + s[1] + str(year) + '.csv', 'w', newline='') as c:
            write = csv.writer(c)
            write.writerows(output)
