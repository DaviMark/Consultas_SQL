-- Calculo de duração de uma macro a outra

WITH OrderedData AS (
    SELECT 
        VW.ID_MAR,
        VW.LATMAC,
        VW.LONGMAC,
        VW.DATENV,
        VW.PLACA,
        VW.MOTORISTA,
        VW.TELEFONE,
        VW.DESCRI,
        VW.CATEGORIA,
        VW.CID_PARTIDA,
        VW.CID_DESTINO,
        VW.PRODUTO,
        VW.PESO,
		LEAD(VW.ID_MAR) OVER (PARTITION BY VW.PLACA ORDER BY VW.DATATU) AS NEXT_IDMAR,
        LEAD(VW.DATENV) OVER (PARTITION BY VW.PLACA ORDER BY VW.DATATU) AS NEXT_DATATU,
		LEAD(VW.DESCRI) OVER (PARTITION BY VW.PLACA ORDER BY VW.DATATU) AS NEXT_DESCRICAO,
        LEAD(VW.CATEGORIA) OVER (PARTITION BY VW.PLACA ORDER BY VW.DATATU) AS NEXT_CATEGORIA
    FROM 
        VW_MACROs VW
    WHERE 
        FORMAT(VW.DATENV, 'yyyy-MM') >= FORMAT(DATEADD(MONTH, -2, GETDATE()), 'yyyy-MM') 
    AND FORMAT(VW.DATENV, 'yyyy-MM') <= FORMAT(GETDATE(), 'yyyy-MM')
	AND DESCRI LIKE '%CONTROLE DE JORNADA%'
)
SELECT 
    ID_MAR,
    LATMAC,
    LONGMAC,
    DATENV,
    PLACA,
    MOTORISTA,
    TELEFONE,
    DESCRI,
    CATEGORIA,
    CID_PARTIDA,
    CID_DESTINO,
    PRODUTO,
    PESO,
    NEXT_IDMAR,
    NEXT_DATATU,
    NEXT_DESCRICAO,
    NEXT_CATEGORIA,
    FLOOR(DATEDIFF(MINUTE, DATENV, NEXT_DATATU) / 60) AS HORAS,
    DATEDIFF(MINUTE, DATENV, NEXT_DATATU) % 60 AS MINUTOS,
	CASE
		WHEN CATEGORIA = 'Dirigindo' AND FLOOR(DATEDIFF(MINUTE, DATENV, NEXT_DATATU) / 60) > 5 THEN 'Mais de 5 hrs dirigindo sem parar'
		ELSE NULL
	END AS STS,
	GETDATE() AS DT_ATUAL,


	FLOOR(DATEDIFF(MINUTE, NEXT_DATATU, GETDATE() ) / 60) AS PROX_HRS,
	DATEDIFF(MINUTE, NEXT_DATATU, GETDATE() ) % 60 AS PROX_MIN

FROM 
    OrderedData
WHERE 
    NEXT_DATATU IS NOT NULL
ORDER BY 
    DATENV DESC;