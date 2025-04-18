-- Select para enviar os e-mails
SELECT
    O.MESANO,
    CAST(LEFT(O.MESANO, 2) AS INT) AS MES,
    RIGHT(O.MESANO, 4) AS ANO,
    O.CODCGA,
    CGA.DESCRI AS CENGASTO,
    O.CODCUS,
    CUS.DESCRI AS CENCUSTO,
    O.SINTET,
    SINTET.DESCRI AS SINTETICA,
    O.ANALIT,
    ANALIT.DESCRI AS ANALITICA,
    SUM(DISTINCT O.CMVLPR) AS VLRPRE,
    SUM(CAST(FLOOR(VW.VALOR * 100) / 100 AS DECIMAL(10, 2))) AS VALOR,
    SUM(DISTINCT O.CMVLPR) + SUM(CAST(FLOOR(VW.VALOR * 100) / 100 AS DECIMAL(10, 2))) AS SALDO
FROM 
    db_visual_rodopar.dbo.ORCLAN O
LEFT JOIN	
    db_visual_rodopar.dbo.PAGCLA ANALIT ON ANALIT.CODCLAP = O.ANALIT
LEFT JOIN
    db_visual_rodopar.dbo.PAGCLA SINTET ON SINTET.CODCLAP = O.SINTET
LEFT JOIN
    PBI_CONTROLE_ORCAMENTARIO_CEN_CUSTO CUS ON CUS.CODCUS = O.CODCUS
LEFT JOIN
    PBI_CONTROLE_ORCAMENTARIO_CEN_GASTO CGA ON CGA.CODCGA = O.CODCGA
LEFT JOIN
    db_visual_rodopar.dbo.VW_GERENCIAL_COMPETENCIA_1 VW ON VW.MES = CAST(LEFT(O.MESANO, 2) AS INT)
    AND VW.ANO = RIGHT(O.MESANO, 4)
    AND VW.CODCGA = O.CODCGA
    AND VW.CODCUS = O.CODCUS
    AND VW.SINTET = O.SINTET
    AND VW.ANALIT = O.ANALIT
    AND VW.CODEMP = 2
WHERE
    O.MESANO = FORMAT(GETDATE(), 'MM/yyyy')
GROUP BY
    O.MESANO,
    CAST(LEFT(O.MESANO, 2) AS INT),
    RIGHT(O.MESANO, 4),
    O.CODCGA,
    CGA.DESCRI,
    O.CODCUS,
    CUS.DESCRI,
    O.SINTET,
    SINTET.DESCRI,
    O.ANALIT,
    ANALIT.DESCRI

UNION ALL

-- Segunda consulta (totalização)
SELECT
    'TOTAL' AS MESANO,
    NULL AS MES,
    NULL AS ANO,
    NULL AS CODCGA,
    NULL AS CENGASTO,
    NULL AS CODCUS,
    NULL AS CENCUSTO,
    O.SINTET,
    SINTET.DESCRI AS SINTETICA,
    O.ANALIT,
    ANALIT.DESCRI AS ANALITICA,
    SUM(DISTINCT O.CMVLPR) AS VLRPRE,
    SUM(CAST(FLOOR(VW.VALOR * 100) / 100 AS DECIMAL(10, 2))) AS VALOR,
    SUM(DISTINCT O.CMVLPR) + SUM(CAST(FLOOR(VW.VALOR * 100) / 100 AS DECIMAL(10, 2))) AS SALDO
FROM 
    db_visual_rodopar.dbo.ORCLAN O
LEFT JOIN	
    db_visual_rodopar.dbo.PAGCLA ANALIT ON ANALIT.CODCLAP = O.ANALIT
LEFT JOIN
    db_visual_rodopar.dbo.PAGCLA SINTET ON SINTET.CODCLAP = O.SINTET
LEFT JOIN
    PBI_CONTROLE_ORCAMENTARIO_CEN_CUSTO CUS ON CUS.CODCUS = O.CODCUS
LEFT JOIN
    PBI_CONTROLE_ORCAMENTARIO_CEN_GASTO CGA ON CGA.CODCGA = O.CODCGA
LEFT JOIN
    db_visual_rodopar.dbo.VW_GERENCIAL_COMPETENCIA_1 VW ON VW.MES = CAST(LEFT(O.MESANO, 2) AS INT)
    AND VW.ANO = RIGHT(O.MESANO, 4)
    AND VW.CODCGA = O.CODCGA
    AND VW.CODCUS = O.CODCUS
    AND VW.SINTET = O.SINTET
    AND VW.ANALIT = O.ANALIT
    AND VW.CODEMP = 2
WHERE
    O.MESANO = FORMAT(GETDATE(), 'MM/yyyy')
GROUP BY
	O.SINTET,
    SINTET.DESCRI,
    O.ANALIT,
    ANALIT.DESCRI;
