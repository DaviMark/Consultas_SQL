WITH  
  
EMPRESA (FILCFR, SERCFR, CODCFR, TIPDOC, CODCLI, PRODUTO, VALOR_EMPRESA)  
AS  
(  
SELECT   
 DCO.CODFIL AS 'FILCFR',  
 DCO.SERSUB AS 'SERCFR',  
 DCO.CODIGO AS 'CODCFR',  
 DCO.TIPDOC AS 'TIPDOC',  
 CASE  
  WHEN DCO.TIPDOC = 'C.T.R.C.' THEN  
          (  
          SELECT  
           TOP 1 CON.CODPAG  
          FROM  
           db_visual_rodopar.dbo.RODCON CON  
          WHERE  
           CON.CODFIL = DCO.FILDOC AND  
           CON.SERCON = DCO.SERDOC AND  
           CON.CODCON = DCO.CODDOC  
          )  
  WHEN DCO.TIPDOC = 'O.S.T.' THEN  
          (  
          SELECT  
           TOP 1 ORD.CODPAG  
          FROM  
           db_visual_rodopar.dbo.RODORD ORD  
          WHERE  
           ORD.CODFIL = DCO.FILDOC AND  
           ORD.SERORD = DCO.SERDOC AND  
           ORD.CODIGO = DCO.CODDOC  
          )    
    
 END AS 'CODCLI',  
 CASE  
  WHEN DCO.TIPDOC = 'C.T.R.C.' THEN  
          (  
          SELECT  
           TOP 1 CMO.DESCRI  
          FROM  
           db_visual_rodopar.dbo.RODCON CON  
           INNER JOIN db_visual_rodopar.dbo.RODCLI CLI ON CON.CODPAG = CLI.CODCLIFOR  
           LEFT OUTER JOIN db_visual_rodopar.dbo.RODCMO CMO ON CLI.CODCMO = CMO.CODCMO  
          WHERE  
           CON.CODFIL = DCO.FILDOC AND  
           CON.SERCON = DCO.SERDOC AND  
           CON.CODCON = DCO.CODDOC  
          )  
  WHEN DCO.TIPDOC = 'O.S.T.' THEN  
          (  
          SELECT  
           TOP 1 CMO.DESCRI  
          FROM  
           db_visual_rodopar.dbo.RODORD ORD  
           INNER JOIN db_visual_rodopar.dbo.RODCLI CLI ON ORD.CODPAG = CLI.CODCLIFOR  
           LEFT OUTER JOIN db_visual_rodopar.dbo.RODCMO CMO ON CLI.CODCMO = CMO.CODCMO  
          WHERE  
           ORD.CODFIL = DCO.FILDOC AND  
           ORD.SERORD = DCO.SERDOC AND  
           ORD.CODIGO = DCO.CODDOC  
          )    
    
 END AS 'PRODUTO',  
 CASE  
  WHEN DCO.TIPDOC = 'C.T.R.C.' THEN  
          (  
          SELECT  
           TOP 1 ISNULL(CON.TOTFRE,0.00) - ISNULL(CON.ICMVLR,0.00)   
          FROM  
           db_visual_rodopar.dbo.RODCON CON  
          WHERE  
           CON.CODFIL = DCO.FILDOC AND  
           CON.SERCON = DCO.SERDOC AND  
           CON.CODCON = DCO.CODDOC  
          )  
  WHEN DCO.TIPDOC = 'O.S.T.' THEN  
          (  
          SELECT  
           TOP 1 ISNULL(ORD.TOTFRE,0.00)  - ISNULL(ORD.ICMVLR,0.00)  
          FROM  
           db_visual_rodopar.dbo.RODORD ORD  
          WHERE  
           ORD.CODFIL = DCO.FILDOC AND  
           ORD.SERORD = DCO.SERDOC AND  
           ORD.CODIGO = DCO.CODDOC  
          )    
    
 END AS 'VALOR_EMPRESA'  
FROM  
 db_visual_rodopar.dbo.RODDCO DCO (NOLOCK)  
)  
  
SELECT  
 CFR.CODFIL,  
 CFR.SERSUB,  
 CFR.CODIGO,  
 CFR.DATSAI AS 'DATA',  
 CFR.CODCLIFOR,  
 CFR.PLACA,  
 --CFR.VLRFRE AS 'VALOR_FRETE',  
 CFR.TOTSER AS 'VALOR_FRETE',  
 ISNULL(CFR.VLRAD1,0.00) + ISNULL(CFR.VLRAD2,0.00) AS 'ADIANTAMENTO',  
 CFR.OUTCRE AS 'OUTROS_CREDITOS',  
 CFR.OUTDEB AS 'OUTROS_DEBITOS',  
 CFR.VALSEG AS 'VALOR_SEGURO',  
 CFR.VLRPED AS 'VALOR_PEDAGIO',  
 CFR.VLRLIQ AS 'VALOR_LIQUIDO',  
 CFR.CODLIN,  
 REM.DESCRI+'/'+REM.ESTADO +' x '+DEST.DESCRI+'/'+DEST.ESTADO AS 'ROTA',  
 MAX(EMP.PRODUTO) AS PRODUTO,  
 MAX(EMP.CODCLI) AS CODCLI,  
  
 SUM(EMP.VALOR_EMPRESA) AS 'VALOR_EMPRESA'  
  
FROM  
 db_visual_rodopar.dbo.RODCFR CFR (NOLOCK)  
 INNER JOIN db_visual_rodopar.dbo.RODCLI CLI ON CFR.CODCLIFOR = CLI.CODCLIFOR   
 INNER JOIN db_visual_rodopar.dbo.RODLIN LIN (NOLOCK) ON CFR.CODLIN = LIN.CODLIN  
 INNER JOIN db_visual_rodopar.dbo.RODMUN REM (NOLOCK) ON LIN.PONINI = REM.CODITN  
 INNER JOIN db_visual_rodopar.dbo.RODMUN DEST (NOLOCK) ON LIN.PONFIM = DEST.CODITN  
  
 INNER JOIN EMPRESA EMP (NOLOCK) ON CFR.CODFIL = EMP.FILCFR AND  
                                    CFR.SERSUB = EMP.SERCFR AND  
            CFR.CODIGO = EMP.CODCFR  
  
WHERE  
 NOT(CFR.SITUAC IN ('C','I'))    

GROUP BY  
 CFR.CODFIL,  
 CFR.SERSUB,  
 CFR.CODIGO,  
 CFR.DATSAI,  
 CFR.CODCLIFOR,  
 CFR.PLACA,  
 CFR.VLRFRE,  
 CFR.TOTSER,  
 ISNULL(CFR.VLRAD1,0.00) + ISNULL(CFR.VLRAD2,0.00),  
 CFR.OUTCRE,  
 CFR.OUTDEB,  
 CFR.VALSEG,  
 CFR.VLRPED,  
 CFR.VLRLIQ,  
 CFR.CODLIN,  
 REM.DESCRI+'/'+REM.ESTADO +' x '+DEST.DESCRI+'/'+DEST.ESTADO