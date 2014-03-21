@Select varchar(max) = 'select field1,field2,field3'
@From varchar(max) = 'from tablename'
@DataCol varchar(max)='field2'
@ColCol varchar(max)='field3'
@ColOrderBy varchar(max)=''
@RowOrderBy varchar(max)=''
@SummaryType varchar(max)='MAX'


DECLARE @sql varchar(max)
	DECLARE @c TABLE(c varchar(max))
	SET @sql=@Select+ ' into #t '+@From+' 
SELECT ''[''+STUFF((SELECT '',[''+'+@ColCol+'+'']'' FROM
(
SELECT DISTINCT '+@ColCol+' FROM #t
)q '+@ColOrderBy+'
FOR XML PATH('''')),1,2,'''')
	'
	PRINT @sql
	INSERT INTO @c EXEC(@sql)
	SET @sql=@Select+ ' into #t '+@From+'
	SELECT * FROM #t
	PIVOT('+@SummaryType+'('+@DataCol+')FOR '+@ColCol+' IN ('+(SELECT REPLACE(c,'&amp;','&') FROM @c)+'))t '+@RowOrderBy
	
	PRINT @sql
	EXEC(@sql)
