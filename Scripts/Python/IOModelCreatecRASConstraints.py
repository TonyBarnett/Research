import csv
import re

### string to int
### stoi('A') = 0
### stoi('B') = 1000
### stoi('AA') = 2600
def stoi(x):
    t = 0
    for i in range(len(x), 0, -1):
        t = t + (ord(x[i - 1]) - 68) * 1000 + (26 * (len(x) - i) * 1000)
    return t


with open(r'E:\Dropbox\IO Model source data\SimEqFiles\SimEq1997.csv') as csvfile:
    read = csv.reader(csvfile, delimiter='=', quotechar='"')
    simeqs, total = zip(*[(row[0].split('+'), row[1]) for row in read])

output = []
i = 0
for se in simeqs:
    output.append([])
    output[i] = [(stoi(re.search(r'([A-Za-z]+)', r).group(0)) + int(re.search(r'[0-9]+', r).group(0)) - 7) for r in se]
    i += 1

length = len(max(output, key=len))

for o in output:
    while len(o) < length:
        o.append(0)

with open(r'E:\Dropbox\IO Model source data\SimEqFiles\cRASInput1997.csv', 'w', newline='') as c:
    write = csv.writer(c)
    write.writerows(output)