WITH DADOS AS (
    SELECT
        (SELECT TOP 1 MAN.SITUAC 
         FROM db_visual_rodopar.dbo.RODMAN MAN 
         WHERE MAN.CODMO1 = PR.CODMO1 AND MAN.PLACA = PR.PLACA 
         ORDER BY MAN.DATEMI DESC) AS STS,
        
        CASE
            WHEN (SELECT TOP 1 MAN.SITUAC 
                  FROM db_visual_rodopar.dbo.RODMAN MAN 
                  WHERE MAN.CODMO1 = PR.CODMO1 AND MAN.PLACA = PR.PLACA 
                  ORDER BY MAN.DATEMI DESC) = 'B' 
            THEN 'Pegando a rota do Acompanhamento de Carga'
            ELSE 'Pegando a Rota do Manifesto'
        END AS STATUS,

        LIN.PEDAGI,
        PR.DATCAD,
        PR.PLACA,
        (SELECT TOP 1 VW.PRODUTO 
         FROM db_visual_rodopar.dbo.VW_ACOMP_VEICULO VW 
         WHERE VW.PLACA = PR.PLACA 
         ORDER BY DATCAD DESC) AS PRODUTO,
        
        -- Primeira atualização do caminhao
        (SELECT TOP 1 FORMAT(VRA.DATHOR, 'dd/MM/yyyy HH:mm')  
         FROM db_visual_rodopar.dbo.RODVRA VRA 
         WHERE VRA.CODVEI = PR.PLACA 
         AND CONVERT(DATE, VRA.DATHOR) = CONVERT(DATE, GETDATE())
         ORDER BY VRA.DATHOR ASC) AS PRIMEIRA_DT,
        
        -- Última atualização de Data
        (SELECT TOP 1 FORMAT(VRA.DATHOR, 'dd/MM/yyyy HH:mm')  
         FROM db_visual_rodopar.dbo.RODVRA VRA 
         WHERE VRA.CODVEI = PR.PLACA 
         ORDER BY VRA.DATHOR DESC) AS ULTIMA_DT,

        -- Tempo rodado e o que é diferente de 0 de velocidade
        CAST(FLOOR(DATEDIFF(MINUTE, 
            (SELECT TOP 1 VRA.DATHOR 
             FROM db_visual_rodopar.dbo.RODVRA VRA 
             WHERE VRA.CODVEI = PR.PLACA 
             AND VRA.VELOCI <> 0 -- Quando for 0 não contabiliza
             AND CONVERT(DATE, VRA.DATHOR) = CONVERT(DATE, GETDATE()) 
             ORDER BY VRA.DATHOR ASC), 
            (SELECT TOP 1 VRA.DATHOR 
             FROM db_visual_rodopar.dbo.RODVRA VRA 
             WHERE VRA.CODVEI = PR.PLACA 
             AND VRA.VELOCI <> 0 -- Quando for 0 não contabiliza
             ORDER BY VRA.DATHOR DESC)) / 60) AS VARCHAR) 
        + ' horas ' + 
        CAST(DATEDIFF(MINUTE, 
            (SELECT TOP 1 VRA.DATHOR 
             FROM db_visual_rodopar.dbo.RODVRA VRA 
             WHERE VRA.CODVEI = PR.PLACA 
             AND VRA.VELOCI <> 0 -- Quando for 0 não contabiliza
             AND CONVERT(DATE, VRA.DATHOR) = CONVERT(DATE, GETDATE()) 
             ORDER BY VRA.DATHOR ASC), 
            (SELECT TOP 1 VRA.DATHOR 
             FROM db_visual_rodopar.dbo.RODVRA VRA 
             WHERE VRA.CODVEI = PR.PLACA 
             AND VRA.VELOCI <> 0 -- Quando for 0 não contabiliza
             ORDER BY VRA.DATHOR DESC)) % 60 AS VARCHAR) + ' minutos' AS Tempo_rodado,

        -- Latitude atual do Caminhao
        (SELECT TOP 1 LATITU 
         FROM db_visual_rodopar.dbo.RODVRA VRA 
         WHERE VRA.CODVEI = PR.PLACA 
         ORDER BY VRA.DATHOR DESC) AS LATITUDE_CAM,

        -- Longitude atual do Caminhao
        (SELECT TOP 1 LONGIT 
         FROM db_visual_rodopar.dbo.RODVRA VRA 
         WHERE VRA.CODVEI = PR.PLACA 
         ORDER BY VRA.DATHOR DESC) AS LONGITUDE_CAM,

        -- Última cidade informada
        (SELECT TOP 1 CIDADE 
         FROM db_visual_rodopar.dbo.RODVRA VRA 
         WHERE VRA.CODVEI = PR.PLACA 
         ORDER BY VRA.DATHOR DESC) AS ULTIMA_CIDADE,

        PR.CODFIL,
        PR.CODLPR,
        PR.CODTOM,
        PAG.NOMEAB AS LOC_PAGADOR,
        PR.DISPON,
        (SELECT TOP 1 MAN.CODLIN 
         FROM db_visual_rodopar.dbo.RODMAN MAN 
         WHERE MAN.CODMO1 = PR.CODMO1 AND MAN.PLACA = PR.PLACA 
         ORDER BY MAN.DATEMI DESC) AS CODLIN,
        
        -- Ponto Inicial
        PR.CODREM,

        CASE
            WHEN (SELECT TOP 1 MAN.SITUAC 
                  FROM db_visual_rodopar.dbo.RODMAN MAN 
                  WHERE MAN.CODMO1 = PR.CODMO1 AND MAN.PLACA = PR.PLACA 
                  ORDER BY MAN.DATEMI DESC) <> 'B' 
            THEN PI.DESCRI
            ELSE REMMUN.DESCRI 
        END AS CIDADE_REM,

        -- Ponto Final
        PR.CODDES,

        CASE
            WHEN (SELECT TOP 1 MAN.SITUAC 
                  FROM db_visual_rodopar.dbo.RODMAN MAN 
                  WHERE MAN.CODMO1 = PR.CODMO1 AND MAN.PLACA = PR.PLACA 
                  ORDER BY MAN.DATEMI DESC) <> 'B' 
            THEN PF.DESCRI
            ELSE DESMUN.DESCRI 
        END AS CIDADE_DES,

        (SELECT SUM(LP.PESOKG) 
         FROM db_visual_rodopar.dbo.RODILP LP 
         WHERE PR.CODFIL = LP.FILLPR AND PR.CODLPR = LP.CODLPR) AS PESOKG,

        MOT.CODMOT,
        MOT.NOMMOT AS MOTORISTA,
        MOT.NUMTEL AS MOT_TEL,

        (SELECT TOP 1 DATHOR 
         FROM db_visual_rodopar.dbo.RODVRA VRA 
         WHERE VRA.CODVEI = PR.PLACA 
         ORDER BY VRA.DATHOR DESC) AS DATHOR

    FROM db_visual_rodopar.dbo.RODLPR PR
    INNER JOIN db_visual_rodopar.dbo.RODCLI AS PAG ON PR.CODTOM = PAG.CODCLIFOR   
    LEFT OUTER JOIN db_visual_rodopar.dbo.RODCLI AS DES ON PR.CODDES = DES.CODCLIFOR  
    LEFT OUTER JOIN db_visual_rodopar.dbo.RODMUN AS DESMUN ON DES.CODMUN = DESMUN.CODMUN  
    INNER JOIN db_visual_rodopar.dbo.RODCLI AS REM ON PR.CODREM = REM.CODCLIFOR    
    LEFT OUTER JOIN db_visual_rodopar.dbo.RODMUN AS REMMUN ON REM.CODMUN = REMMUN.CODMUN  
    INNER JOIN db_visual_rodopar.dbo.RODMOT MOT ON PR.CODMO1 = MOT.CODMOT 
    LEFT JOIN db_visual_rodopar.dbo.RODLIN LIN ON LIN.CODLIN = (SELECT TOP 1 MAN.CODLIN 
                                                               FROM db_visual_rodopar.dbo.RODMAN MAN 
                                                               WHERE MAN.CODMO1 = PR.CODMO1 AND MAN.PLACA = PR.PLACA 
                                                               ORDER BY MAN.DATEMI DESC)
    LEFT OUTER JOIN db_visual_rodopar.dbo.RODMUN PI ON LIN.PONINI = PI.CODITN  
    LEFT OUTER JOIN db_visual_rodopar.dbo.RODMUN PF ON LIN.PONFIM = PF.CODITN  
    WHERE PR.DATCAD >= CAST(GETDATE() AS DATE) AND PR.DATCAD < CAST(DATEADD(DAY, 1, GETDATE()) AS DATE)
    AND (SELECT TOP 1 VRA.CODVEI 
         FROM db_visual_rodopar.dbo.RODVRA VRA 
         WHERE VRA.CODVEI = PR.PLACA 
         ORDER BY VRA.DATHOR DESC) IS NOT NULL
)

SELECT 
    CODFIL,
    STATUS,
    PEDAGI,
    DATCAD,
    CODLIN,
    DISPON,
    PLACA,
    PRODUTO,
    PESOKG,
    CODMOT,
    MOTORISTA,
    MOT_TEL,
    LATITUDE_CAM,
    LONGITUDE_CAM,
    PRIMEIRA_DT,
    ULTIMA_DT,
    ULTIMA_CIDADE,
    LOC_PAGADOR,
    CIDADE_REM AS PARTIDA,
    CIDADE_DES AS DESTINO
FROM 
	DADOS