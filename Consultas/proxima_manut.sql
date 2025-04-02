WITH PRO_MANT AS (SELECT DISTINCT
	ACI.CODVEI,
	IRE.CODIRE,
	IRE.DESCRI,
	CASE
		WHEN PROKMT = 0 THEN 0
		ELSE CEILING((ACI.PROKMT - VEI.ULTKMT) / 333.0) 
	END AS DIAS_ATE_PROKMT,
	CAST(CASE 
		WHEN ACI.PRODAT IS NULL THEN GETDATE() + CEILING((ACI.PROKMT - VEI.ULTKMT) / 333.0)
		ELSE ACI.PRODAT
	END AS DATE) AS PRODAT,
	ACI.PROKMT,
	ACI.DATATU,
	VEI.ULTKMT
FROM	
	db_visual_rodopar.dbo.RODIRE IRE
LEFT JOIN
	db_visual_rodopar.dbo.OSEACI ACI ON ACI.CODIRE = IRE.CODIRE
LEFT JOIN
	db_visual_rodopar.dbo.RODVEI VEI ON VEI.CODVEI = ACI.CODVEI
)
SELECT
	CODVEI,
	PRODAT,
	'Manutenção programada para ' + FORMAT(PRODAT, 'dd/MM/yyyy') AS STATUS_MANUT,
	DESCRI AS PROX_MANUT
FROM 
	PRO_MANT 
WHERE 
	PRODAT > GETDATE() 