SELECT tDataSeg.EntityX AS Entity, tDataSeg.Attr4 AS Account,tDataSeg.ud1x AS Flussi,tDataSeg.icpx AS ICP, tDataSeg.ud3x AS Custom3,
SUM(CAST (NVL(tDataSeg.ud8x,0) AS FLOAT)) AS ValoreIniziale,
SUM(CAST (NVL(tDataSeg.ud9x,0) AS FLOAT)) AS ValoreFinale,
SUM(NVL(tDataSeg.Amountx,0)) as Valore,
tPOVPartition.partname || ' (User: '||AIF_PROCESSES.LAST_UPDATED_BY||' - Date: '|| TO_CHAR(AIF_PROCESSES.LAST_UPDATE_DATE, 'DD/MM/YYYY HH24:MI:SS')||')' AS Location,
TPOVCATEGORY.CATNAME AS Scenario,
tDataSeg.PeriodKey AS Period

FROM tPOVPartition 
INNER JOIN tPOVCategory 
INNER JOIN tDataSeg 
ON tPOVCategory.CatKey = tDataSeg.CatKey ON tPOVPartition.PartitionKey = tDataSeg.PartitionKey AND tDataSeg.EntityX IS NOT NULL
INNER JOIN AIF_PROCESSES
ON TDATASEG.LOADID=AIF_PROCESSES.PROCESS_ID

WHERE (((tDataSeg.PeriodKey)=~POVPERIOD~) 
AND ((tPOVCategory.CatKey)=~POVCAT~) AND ((tDataSeg.PartitionKey)=~POVLOC~))
AND VALID_FLAG <> 'I'

group by tPOVPartition.partname || ' (User: '||AIF_PROCESSES.LAST_UPDATED_BY||' - Date: '|| TO_CHAR(AIF_PROCESSES.LAST_UPDATE_DATE, 'DD/MM/YYYY HH24:MI:SS')||')' , TPOVCATEGORY.CATNAME,tDataSeg.PeriodKey , tDataSeg.EntityX, tDataSeg.Attr4, tDataSeg.ud1x,tDataSeg.icpx,tDataSeg.ud3x
order by tDataSeg.EntityX, tDataSeg.Attr4