USE IOModel
SELECT i1.intCategoryId, c.strDescription, i1.fltIntensity AS '1997', i2.fltIntensity AS '1998',
	i3.fltIntensity AS '1999', i4.fltIntensity AS '2000', i5.fltIntensity AS '2001', i6.fltIntensity AS '2002',
	i7.fltIntensity AS '2003', i8.fltIntensity AS '2004', i9.fltIntensity AS '2005', i10.fltIntensity AS '2006',
	i11.fltIntensity AS '2007', i12.fltIntensity AS '2008', i13.fltIntensity AS '2009', i14.fltIntensity AS '2010'
FROM Intensity i1
	INNER JOIN Category  c   ON c.intId           = i1.intCategoryId
	INNER JOIN Intensity i2  ON i2.intCategoryId  = i1.intCategoryId AND i2.intYear  = i1.intYear + 1
	INNER JOIN Intensity i3  ON i3.intCategoryId  = i1.intCategoryId AND i3.intYear  = i1.intYear + 2
	INNER JOIN Intensity i4  ON i4.intCategoryId  = i1.intCategoryId AND i4.intYear  = i1.intYear + 3
	INNER JOIN Intensity i5  ON i5.intCategoryId  = i1.intCategoryId AND i5.intYear  = i1.intYear + 4
	INNER JOIN Intensity i6  ON i6.intCategoryId  = i1.intCategoryId AND i6.intYear  = i1.intYear + 5
	INNER JOIN Intensity i7  ON i7.intCategoryId  = i1.intCategoryId AND i7.intYear  = i1.intYear + 6
	INNER JOIN Intensity i8  ON i8.intCategoryId  = i1.intCategoryId AND i8.intYear  = i1.intYear + 7
	INNER JOIN Intensity i9  ON i9.intCategoryId  = i1.intCategoryId AND i9.intYear  = i1.intYear + 8
	INNER JOIN Intensity i10 ON i10.intCategoryId = i1.intCategoryId AND i10.intYear = i1.intYear + 9
	INNER JOIN Intensity i11 ON i11.intCategoryId = i1.intCategoryId AND i11.intYear = i1.intYear + 10
	INNER JOIN Intensity i12 ON i12.intCategoryId = i1.intCategoryId AND i12.intYear = i1.intYear + 11
	INNER JOIN Intensity i13 ON i13.intCategoryId = i1.intCategoryId AND i13.intYear = i1.intYear + 12
	INNER JOIN Intensity i14 ON i14.intCategoryId = i1.intCategoryId AND i14.intYear = i1.intYear + 13