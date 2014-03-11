import csv
import matplotlib as mpl
import matplotlib.pyplot as pl
import pylab
#  import numpy
import os
#  from matplotlib import rc
#  from mpl_toolkits.mplot3d import Axes3D

##  I will generate the graphs for "PASvsAtuk" (or whatever you've decided chapter 2 needs naming) as pdf's with minimises bounding boxes.
#	#That is:
#		#directCompare
#		#mean1-1
#		#median1-1
#		#priceComparePMn
#		#priceComparePMn_Ratio
#		#priceCompareMpercent
#		#priceCompareMpercent_Ratio
#		#ranked
#		#SpectralClustering[0-6]
#		#SpectralClustering3D
#		#SpectralClustering3Dap
#		#SpectralClustering3Dca
#		#SpectralClustering3d
#		
#	#in the \variables folder I require (as csv's)
#		#averages.csv
#		#directCompareGraph_polyfit
#		#priceCompare4 (which at present comes from "T:\Dropbox\matlabFiles\variables\")
#		#priceCompare4_ratio (which at present comes from "T:\Dropbox\matlabFiles\variables\")
#		#priceCompare5 (which at present comes from "T:\Dropbox\matlabFiles\variables\")
#		#priceCompare6 (which at present comes from "T:\Dropbox\matlabFiles\variables\")
#		#priceCompare6_ratio (which at present comes from "T:\Dropbox\matlabFiles\variables\")
#		#ranked
#		#Spectral_Clustering2.csv
#		#Spectral_Clustering_3d.csv
##		

titleSize = 16
labelSize = 16
markerSize = 3

outputRoot = 'T:/Dropbox/'

outputs = []
output = []

#  Append here all the places that you wish the pdf's to get themselves put
outputs.append('Thesis\Images')
outputs.append('python\outputs')
outputs.append('Annual Review\Report 2013\Images')

#  This bit works out where it can go. T drive for work computer, E drive for desktop, C drive for laptop.
for i in range(0, len(outputs)):
    if not os.path.isdir(outputRoot):
        if not os.path.isdir('E:/Dropbox/'):
            outputRoot = 'c:/Dropbox/'
    else:
        outputRoot = 'E:/Dropbox/'
    output.append(outputRoot + outputs[i])

mpl.rc('font', family='serif', serif='Times')
mpl.rc('font', family='serif', serif='Computer Modern Roman')
mpl.rc('text', usetex=True)  #  uses the TeX compiler to render the font times in the graphs

#direct compare
print('directCompare')
with open('variables\\directCompareGraph.csv', newline='') as csvfile:
    c = csv.reader(csvfile)
    listT = list(c)
listx = listT[0]
listy = listT[1]
pl.scatter(listx, listy, s=markerSize)

pl.axis([0, 15, 0, 13])

with open('variables\\directCompareGraph_polyfit.csv', newline='') as csvfile:
    c = csv.reader(csvfile)
    poly = list(c)

pl.plot(poly[0], poly[1])

pl.xlabel('@UK footprint', fontsize=labelSize, family='serif')
pl.ylabel('PAS2050 footprint', fontsize=labelSize, family='serif')
#  pl.title('Comparison between @UK and PAS footprint for each product', fontsize=titleSize, family='serif')

pl.tight_layout()
pl.tight_layout()
for i in range(len(output)):
    pl.savefig(output[i] + '\\directCompare.pdf')
pl.figure()

#  ranked
print('ranked')
with open('variables\\ranked.csv', newline='') as csvfile:
    c = csv.reader(csvfile)
    listT = list(c)
listx = listT[0]
listy = listT[1]
pl.scatter(listx, listy, s=markerSize)

pl.plot([0, 400], [0, 400])

pl.xlabel('Ranked @UK footprint', fontsize=labelSize)
pl.ylabel('Ranked PAS2050 footprint', fontsize=labelSize)
#  pl.title('Comparison between ranked @UK and ranked PAS \nfootprint for each product', fontsize=titleSize)
pl.axis([0, 400, 0, 400], fontsize=18)

pl.tight_layout()
pl.tight_layout()
for i in range(len(output)):
    pl.savefig(output[i] + '\\ranked.pdf')
pl.figure()


#  price compare1
print('price compare')
#  part 1
print('	1')
with open('variables\\priceCompare4.csv', newline='') as csvfile:
    c = csv.reader(csvfile)
    listT = list(c)
listx = listT[0]
listy = listT[1]
pl.scatter(listx, listy, s=markerSize, color='black')

pl.axis([0.9, 10, 0.08, 1.01], fontsize=18)

pl.xlabel('$\lambda$', fontsize=labelSize)
pl.ylabel('$R^2$', fontsize=labelSize)
#  pl.title('The effect of varying range of @UK footprints on \nunexplained variance between footprints', fontsize=titleSize)

pl.tight_layout()
pl.tight_layout()
for i in range(len(output)):
    pl.savefig(output[i] + '\\priceComparePMn.pdf')
pl.figure()
#  part 2
print('	2')
with open('variables\\priceCompare4_ratio.csv', newline='') as csvfile:
    c = csv.reader(csvfile)
    listT = list(c)
listx = listT[0]
listy = listT[1]
pl.scatter(listx, listy, s=markerSize, color='black')

pl.axis([0.9, 10, -0.01, 100], fontsize=16)

pl.xlabel('$\lambda$', fontsize=labelSize)
pl.ylabel('Percentage of products for which $u\'_i$ = $t_i$', fontsize=labelSize)
#  pl.title('The effect of varying range of @UK footprints \nunexplained variance between footprints',fontsize=titleSize)

pl.tight_layout()
pl.tight_layout()
for i in range(len(output)):
    pl.savefig(output[i] + '\\priceComparePMn_ratio.pdf')
pl.figure()


#  price compare2
print('price compare 2')
#  part 1
print('	1')
with open('variables\\priceCompare5.csv', newline='') as csvfile:
    c = csv.reader(csvfile)

    listT = list(c)
listx = listT[0]
listy = listT[1]
pl.scatter(listx, listy, s=markerSize, color='black')

pl.axis([0, 1, 0.08, 1.01], fontsize=18)

pl.xlabel('$\lambda$', fontsize=labelSize)
pl.ylabel('$R^2$', fontsize=labelSize)
#  pl.title('The effect of varying range of @UK footprints on unexplained \nvariance between footprints', fontsize=titleSize)

pl.tight_layout()
pl.tight_layout()
for i in range(len(output)):
    pl.savefig(output[i] + '\\priceComparePMpercent.pdf')
pl.figure()
#  part 2
print('	2')
with open('variables\\priceCompare6_ratio.csv', newline='') as csvfile:
    c = csv.reader(csvfile)
    listT = list(c)
listx = listT[0]
listy = listT[1]
pl.scatter(listx, listy, s=markerSize, color='black')

pl.axis([0, 1, 0, 100], fontsize=16)

pl.xlabel('$\lambda$', fontsize=labelSize)
pl.ylabel('Percentage of products for which $u\'\'_i$ = $t_i$', fontsize=labelSize)
#  pl.title('The effect of varying range of @UK footprints on unexplained variance \nbetween footprints',fontsize=titleSize)

pl.tight_layout()
pl.tight_layout()
for i in range(len(output)):
    pl.savefig(output[i] + '\\priceComparePMpercent_ratio.pdf')
pl.figure()


#  price compare3
print('price compare 3')
#  part 1
print('	1')
with open('variables\\priceCompare6.csv', newline='') as csvfile:
    c = csv.reader(csvfile)
    listT = list(c)
listx = listT[0]
listy = listT[1]
pl.scatter(listx, listy, s=markerSize, color='black')

pl.axis([0, 1, 0.08, 1.01], fontsize=18)

pl.xlabel('$n$', fontsize=labelSize)
pl.ylabel('$R^2$', fontsize=labelSize)
#  pl.title('The effect of varying range of @UK footprints on \nunexplained variance between footprints', fontsize=titleSize)

pl.tight_layout()
pl.tight_layout()
for i in range(len(output)):
    pl.savefig(output[i] + '\\priceCompareMpercent.pdf')
pl.figure()
#  part 2
print('	2')
with open('variables\\priceCompare6_ratio.csv', newline='') as csvfile:
    c = csv.reader(csvfile)
    listT = list(c)
listx = listT[0]
listy = listT[1]
pl.scatter(listx, listy, s=markerSize, color='black')

pl.axis([0, 1, 0, 100], fontsize=16)

pl.xlabel('$n$', fontsize=labelSize)
pl.ylabel('Percentage of products for which $u\'\'_i$ = $t_i$', fontsize=labelSize)
#  pl.title('The effect of varying range of @UK footprints on \nunexplained variance between footprints',fontsize=titleSize)

pl.tight_layout()
pl.tight_layout()
for i in range(len(output)):
    pl.savefig(output[i] + '\\priceCompareMpercent_ratio.pdf')
pl.figure()

#  Averages
print('averages')
with open('variables\\averages.csv', newline='') as csvfile:
    c = csv.reader(csvfile)
    listT = list(c)
price = list(map(float, listT[0]))
intensity = list(map(float, listT[1]))
atuk = list(map(float, listT[2]))
mean = list(map(float, listT[3]))
median = list(map(float, listT[4]))

order = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
lbf = order
(m, b) = pylab.polyfit(atuk, mean, 1)
for j in range(0, len(order)):
    lbf[j] = m * order[j] + b

#  Mean
print('Mean')
pl.scatter(atuk, mean, s=markerSize, color='black')
pl.plot(lbf)
pl.axis([0, 15, 0, 12], fontsize=16)
pl.xlabel('@UK carbon footprint', fontsize=labelSize)
pl.ylabel('Mean PAS2050 carbon footprint', fontsize=labelSize)
pl.tight_layout()
pl.tight_layout()
for i in range(len(output)):
    pl.savefig(output[i] + '\\mean1-1.pdf')
pl.figure()

lbf = order
(m, b) = pylab.polyfit(atuk, median, 1)
for j in range(0, len(order)):
    lbf[j] = m * order[j] + b


#  Median
print('Median')
pl.scatter(atuk, median, s=markerSize, color='black')
pl.plot(lbf)
pl.axis([0, 15, 0, 12], fontsize=16)
pl.xlabel('@UK carbon footprint', fontsize=labelSize)
pl.ylabel('Median PAS2050 carbon footprint', fontsize=labelSize)
pl.tight_layout()
pl.tight_layout()
for i in range(len(output)):
    pl.savefig(output[i] + '\\median1-1.pdf')


#  Spectral clustering
print('Spectral clustering')

#  (2D : eigenVector-eigenVector)
print('	2D')
with open('variables\\Spectral_Clustering2.csv', newline='') as csvfile:
    c = csv.reader(csvfile)
    listT = list(c)
v1 = list(map(float, listT[0]))
v2 = list(map(float, listT[1]))

for thing in range(2, len(listT)):
    s = list(map(int, listT[thing]))

    #  Get the (x,y) coordinates for the points within each cluster,
    #  also get the (x,y) coordinates of the average point of the cluster (as the centroid)
    one = [(v1[i], v2[i]) for i in range(len(s)) if s[i] == 1]
    centroidOne = ([sum([row[0] for row in one]) / len(one), sum([row[1] for row in one]) / len(one)])
    two = [(v1[i], v2[i]) for i in range(len(s)) if s[i] == 2]
    centroidTwo = ([sum([row[0] for row in two]) / len(two), sum([row[1] for row in two]) / len(two)])

    pl.figure()
    pl.scatter([row[0] for row in one], [row[1] for row in one], s=20, marker='+', color='blue')
    pl.scatter([row[0] for row in two], [row[1] for row in two], s=20, marker='.', color='red')
    pl.scatter(centroidOne[0], centroidOne[1], s=20, marker='x', color='black')
    pl.scatter(centroidTwo[0], centroidTwo[1], s=20, marker='x', color='black')
    pl.xlabel('$v1$', fontsize=labelSize)
    pl.ylabel('$v2$', fontsize=labelSize)
    pl.tight_layout()
    pl.tight_layout()
    for i in range(len(output)):
        pl.savefig(output[i] + '\\SpectralClustering' + str(thing - 2) + '.pdf')

#  (3D : PAS,atuk,cat; initial ordering)
print('	3D : PAS,atuk,cat; initial ordering')

with open('variables\\Spectral_Clustering_3d.csv', newline='') as csvfile:
    c = csv.reader(csvfile)
    listT = list(c)
PAS = list(map(float, listT[0]))
atuk = list(map(float, listT[1]))
cat = list(map(float, listT[2]))
s = list(map(float, listT[3]))

#  in 2d
print('	2D (one graph)')
one = [(atuk[i], PAS[i]) for i in range(len(s)) if s[i] == 1]
centroidOne = ([sum([row[0] for row in one]) / len(one), sum([row[1] for row in one]) / len(one)])
two = [(atuk[i], PAS[i]) for i in range(len(s)) if s[i] == 2]
centroidTwo = ([sum([row[0] for row in two]) / len(two), sum([row[1] for row in two]) / len(two)])

pl.figure()
pl.scatter([row[0] for row in one], [row[1] for row in one], s=20, marker='+', color='blue')
pl.scatter([row[0] for row in two], [row[1] for row in two], s=20, marker='.', color='red')
pl.scatter(centroidOne[0], centroidOne[1], s=20, marker='x', color='black')
pl.scatter(centroidTwo[0], centroidTwo[1], s=20, marker='x', color='black')
pl.xlabel('@UK carbon footprint', fontsize=labelSize)
pl.ylabel('PAS050 carbon footprint', fontsize=labelSize)
pl.tight_layout()
pl.tight_layout()
for i in range(len(output)):
    pl.savefig(output[i] + '\\SpectralClustering3Dap.pdf')

one = [(cat[i], atuk[i]) for i in range(len(s)) if s[i] == 1]
centroidOne = ([sum([row[0] for row in one]) / len(one), sum([row[1] for row in one]) / len(one)])
two = [(cat[i], atuk[i]) for i in range(len(s)) if s[i] == 2]
centroidTwo = ([sum([row[0] for row in two]) / len(two), sum([row[1] for row in two]) / len(two)])
pl.figure()
pl.scatter([row[0] for row in one], [row[1] for row in one], s=20, marker='+', color='blue')
pl.scatter([row[0] for row in two], [row[1] for row in two], s=20, marker='.', color='red')
pl.scatter(centroidOne[0], centroidOne[1], s=20, marker='x', color='black')
pl.scatter(centroidTwo[0], centroidTwo[1], s=20, marker='x', color='black')
pl.xlabel('category', fontsize=labelSize)
pl.ylabel('@UK carbon footprint', fontsize=labelSize)
pl.tight_layout()
pl.tight_layout()
for i in range(len(output)):
    pl.savefig(output[i] + '\\SpectralClustering3Dca.pdf')

one = [(cat[i], PAS[i]) for i in range(len(s)) if s[i] == 1]
centroidOne = ([sum([row[0] for row in one]) / len(one), sum([row[1] for row in one]) / len(one)])
two = [(cat[i], PAS[i]) for i in range(len(s)) if s[i] == 2]
centroidTwo = ([sum([row[0] for row in two]) / len(two), sum([row[1] for row in two]) / len(two)])
pl.figure()
pl.scatter([row[0] for row in one], [row[1] for row in one], s=20, marker='+', color='blue')
pl.scatter([row[0] for row in two], [row[1] for row in two], s=20, marker='.', color='red')
pl.scatter(centroidOne[0], centroidOne[1], s=20, marker='x', color='black')
pl.scatter(centroidTwo[0], centroidTwo[1], s=20, marker='x', color='black')
pl.xlabel('category', fontsize=labelSize)
pl.ylabel('PAS050 carbon footprint', fontsize=labelSize)
pl.tight_layout()
pl.tight_layout()
for i in range(len(output)):
    pl.savefig(output[i] + '\\SpectralClustering3Dcp.pdf')


#  in 3d
print('	3D (3 graphs, will need tweaking before actual use)')
one = [(PAS[i], atuk[i], cat[i]) for i in range(len(s)) if s[i] == 1]
centroidOne = ([sum([row[0] for row in one]) / len(one), sum([row[2] for row in one]) / len(one),
    sum([row[2] for row in one]) / len(one)])

two = [(PAS[i], atuk[i], cat[i]) for i in range(len(s)) if s[i] == 2]
centroidTwo = ([sum([row[0] for row in two]) / len(two), sum([row[1] for row in two]) / len(two),
    sum([row[2] for row in two]) / len(two)])

three = [(PAS[i], atuk[i], cat[i]) for i in range(len(s)) if s[i] == 3]
centroidThree = ([sum([row[0] for row in three]) / len(three), sum([row[1] for row in three]) / len(three),
    sum([row[2] for row in three]) / len(three)])

fig = pl.figure()
ax = fig.add_subplot(111, projection='3d')
ax.scatter([row[0] for row in one], [row[1] for row in one], [row[2] for row in one], s=20, marker='.', color='red')
ax.scatter([row[0] for row in two], [row[1] for row in two], [row[2] for row in two], s=20, marker='+', color='blue')
ax.scatter([row[0] for row in three], [row[1] for row in three], [row[2] for row in three], s=20, marker='s', color='green')
ax.scatter(centroidOne[0], centroidOne[1], centroidOne[2], s=20, marker='x', color='black')
ax.scatter(centroidTwo[0], centroidTwo[1], centroidTwo[2], s=20, marker='x', color='black')
ax.scatter(centroidThree[0], centroidThree[1], centroidThree[2], s=20, marker='x', color='black')

ax.set_xlabel('@UK carbon footprint', fontsize=labelSize)
ax.set_ylabel('PAS050 carbon footprint', fontsize=labelSize)
ax.set_zlabel('category', fontsize=labelSize)
pl.tight_layout()
pl.tight_layout()
for i in range(len(output)):
    pl.savefig(output[i] + '\\SpectralClustering3D.pdf')

#  3D (PAS,atuk,cat: best ordering, worst ordering)
print('	3D (PAS,atuk,cat: best ordering, worst ordering)')
#  pl.show()
pl.figure()
