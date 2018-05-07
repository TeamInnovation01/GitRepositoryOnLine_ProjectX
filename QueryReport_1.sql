select  * from TEMPORARY_ANAG_MASTRO
where 
contomastro not in 
(
SELECT  A.CONTOMASTRO
FROM 
(select * from TEMPORARY_ANAG_MASTRO where form is null and riclassifica is null ) A
inner join
(select * from TEMPORARY_ANAG_MASTRO where ord is null and ifrs is null and form is not null and riclassifica is not null ) B
on A.CONTOMASTRO = B.CONTOMASTRO
)
union 
SELECT  A.CONTOMASTRO,A.ORD,B.FORM,A.IFRS,B.RICLASSIFICA
FROM 
(select * from TEMPORARY_ANAG_MASTRO where form is null and riclassifica is null ) A
inner join
(select * from TEMPORARY_ANAG_MASTRO where ord is null and ifrs is null and form is not null and riclassifica is not null ) B
on A.CONTOMASTRO = B.CONTOMASTRO
