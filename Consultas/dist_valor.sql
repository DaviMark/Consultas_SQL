-- Lógica para distribuição de valor de Orçamento

-- CTE para calcular o valor total e a quantidade de contas analíticas por SINTET
WITH TotalSynthetics AS (
    SELECT 
        SINTET, 
        SUM(CMVLPR) AS TotalValor, 
        COUNT(DISTINCT ANALIT) AS QtdAnaliticas
    FROM db_visual_rodopar.dbo.ORCLAN 
    WHERE MESANO = '02/2025' 
    GROUP BY SINTET
),

-- CTE para calcular o valor distribuído de acordo com as regras
ValorDistribuido AS (
    SELECT 
        O.ID_ORC,
        O.MESANO,
        O.CODCGA,
        O.CODCUS,
        O.SINTET,
        O.ANALIT,
        O.DEBCRE,
        O.CMVLPR AS VLRPREV,
        TS.TotalValor AS TotalSyntetico,
        -- Cálculo do valor distribuído conforme a conta e a lógica definida
        CASE 
            WHEN O.ANALIT IN ('172', '135') THEN TS.TotalValor * 0.20  -- 20% para as contas analíticas 172 e 135
            WHEN O.SINTET = '132' THEN 
                (TS.TotalValor * 0.40) / NULLIF((TS.QtdAnaliticas - 1), 0)  -- 40% dividido pelas outras contas analíticas quando SINTET = 132
            ELSE TS.TotalValor / NULLIF(TS.QtdAnaliticas, 0)  -- Caso padrão, distribuindo igualmente
        END AS ValorDistribuido
    FROM db_visual_rodopar.dbo.ORCLAN O
    JOIN TotalSynthetics TS ON O.SINTET = TS.SINTET
    WHERE O.MESANO = '02/2025'
    AND O.SINTET = 132  -- Considerando apenas o SINTET específico (132)
)

-- Seleção final dos dados com o valor distribuído calculado
SELECT 
    ID_ORC,
    MESANO,
    CODCGA,
    CODCUS,
    SINTET,
    ANALIT,
    DEBCRE,
    VLRPREV,
    TotalSyntetico,
    ValorDistribuido
FROM ValorDistribuido
ORDER BY SINTET, ANALIT;
