Select nvl(tab1.EntityX,tab2.entity) as EntityX, nvl(tab1.AccountX,tab2.account) as AccountX, nvl(UPPER(tab1.ICPX),UPPER(tab2.ICP)) AS ICPX, nvl(tab1.UD1X,tab2.ud1) as UD1X, nvl(tab1.UD2X,tab2.ud2) as UD2X, nvl(tab1.UD3X,tab2.ud3) as UD3X, nvl(tab1.UD4X,tab2.ud4) as UD4X, SUM(tab1.AmountX) AS Value, AVG(tab2.Amount) AS OLD
FROM 
(
select t1.*,p1.partname from 
TDATASEG t1 , TPOVPARTITION P1
where  
t1.PARTITIONKEY = P1.PARTITIONKEY
) tab1
full outer JOIN
(
select t2.*,p2.partname from 
TDATASEG t2 , TPOVPARTITION P2
where  
t2.PARTITIONKEY = P2.PARTITIONKEY
) tab2
ON tab1.EntityX = tab2.Entity AND tab1.CATKEY = tab2.CATKEY AND tab1.PERIODKEY = tab2.PERIODKEY AND tab1.accountX =tab2.Account
AND tab1.UD1X = tab2.UD1 AND tab1.UD2X = tab2.UD2 AND tab1.UD3X = tab2.UD3 AND tab1.UD4X = tab2.UD4 AND UPPER(tab1.ICPX) = UPPER(tab2.ICP) 

WHERE 
(tab1.accountx<>'IGNORE' or tab1.accountx is null)
and ((tab1.periodkey=~POVPERIOD~ and tab2.periodkey=~POVPERIOD~) or (tab1.periodkey=~POVPERIOD~ and tab2.periodkey is null) or (tab2.periodkey=~POVPERIOD~ and tab1.periodkey is null))
and ((tab1.PARTITIONKEY=~POVLOC~ and tab2.PARTITIONKEY is null) or (tab1.partname= SUBSTR(tab2.PARTNAME,1,5) and tab1.partitionkey=~POVLOC~) or (tab1.partitionkey is null and tab2.partitionkey=(select partitionkey from tpovpartition where partname=(select partname||'_Prev' from tpovpartition where partitionkey=~POVLOC~))))

group by nvl(tab1.EntityX,tab2.entity),nvl(tab1.AccountX,tab2.account),nvl(UPPER(tab1.ICPX),UPPER(tab2.ICP)),nvl(tab1.UD1X,tab2.ud1), nvl(tab1.UD2X,tab2.ud2), nvl(tab1.UD3X,tab2.ud3), nvl(tab1.UD4X,tab2.ud4)