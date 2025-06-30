WITH ZDT_B AS (
SELECT 
    CASE
        WHEN B.cod_code = "52 - SAP PROFESSIONAL USER" THEN 52
        WHEN B.cod_code = "53 - SAP LIMITED PROFESSIONAL" THEN 53
        WHEN B.cod_code = "54 - SAP BUSINESS SUITE EMPLOYL" THEN 54
        WHEN B.cod_code = "55 - SAP BUSINESS SUITE DEVELO" THEN 55
        WHEN B.cod_code = "57 - SAP BUSINESS EXPERT USER" THEN 57
        WHEN B.cod_code = "3157 - SAP BPC, PROFESSIONAL" THEN 58
        WHEN B.cod_code = "3158 - SAP BPC, STANDARD" THEN 59
        WHEN B.cod_code = "BO - BA&T SAP BUSINESSOBJECTS" THEN 60
        WHEN B.cod_code = "SNOW" THEN 61
        WHEN B.cod_code = "GRC USUARIOS MONITORADOS" THEN 62
        WHEN B.cod_code = "RE" THEN 63
        WHEN B.cod_code = "GOAPPROVE" THEN 64
        WHEN B.cod_code = "BLACKLINE" THEN 65
        WHEN B.cod_code = "SAP ARIBA SOURCING" THEN 66
        WHEN B.cod_code = "SAC PLANNING PRO" THEN 67
        WHEN B.cod_code = "SAC PLANNING STANDARD" THEN 68
        WHEN B.cod_code = "SAP ARIBA SLP" THEN 69
        ELSE 99
    END ID,
   B.cod_code,
   B.nam_company,
   FORMAT_TIMESTAMP('%Y%m', B.dat_year_month_ref) AS ANOMES,
   
   B.num_amount_contract AS licencas_contratadas,
   B.num_amount_measure AS medido
FROM 
  uolcs-datalake-engcorp-prd.sistemas_corporativos_erp_sapabap1_datamart.LICENCE_CONTROL_ZDT_B B
),
ZDT AS(
  SELECT 
  CASE
        WHEN T.cod_code = "52 - SAP PROFESSIONAL USER" THEN 52
        WHEN T.cod_code = "53 - SAP LIMITED PROFESSIONAL" THEN 53
        WHEN T.cod_code = "54 - SAP BUSINESS SUITE EMPLOYL" THEN 54
        WHEN T.cod_code = "55 - SAP BUSINESS SUITE DEVELO" THEN 55
        WHEN T.cod_code = "57 - SAP BUSINESS EXPERT USER" THEN 57
        WHEN T.cod_code = "3157 - SAP BPC, PROFESSIONAL" THEN 58
        WHEN T.cod_code = "3158 - SAP BPC, STANDARD" THEN 59
        WHEN T.cod_code = "BO - BA&T SAP BUSINESSOBJECTS" THEN 60
        WHEN T.cod_code = "SNOW" THEN 61
        WHEN T.cod_code = "GRC USUARIOS MONITORADOS" THEN 62
        WHEN T.cod_code = "RE" THEN 63
        WHEN T.cod_code = "GOAPPROVE" THEN 64
        WHEN T.cod_code = "BLACKLINE" THEN 65
        WHEN T.cod_code = "SAP ARIBA SOURCING" THEN 66
        WHEN T.cod_code = "SAC PLANNING PRO" THEN 67
        WHEN T.cod_code = "SAC PLANNING STANDARD" THEN 68
        WHEN T.cod_code = "SAP ARIBA SLP" THEN 69
        ELSE 99
    END ID,
   T.cod_code,
   T.nam_company,
   T.dat_modify,
   T.num_amount AS licencas_ZDT
FROM 
    uolcs-datalake-engcorp-prd.sistemas_corporativos_erp_sapabap1_datamart.LICENCE_CONTROL_ZDT T
),
SHOW AS(
  SELECT 
  S.cod_lic_type AS ID,
  COUNT(DISTINCT S.cod_user) AS contagem_users,
  S.num_year_month,
  CASE 
    WHEN COALESCE(S.nam_company_hierarquia, S.nam_company_name) IN ("UOLB") THEN "UOLCS"
    WHEN COALESCE(S.nam_company_hierarquia, S.nam_company_name) IN ("UNIVERSO ONLINE S.A.","Grupo UOL") THEN "UOLCS"
    WHEN COALESCE(S.nam_company_hierarquia, S.nam_company_name) IN ("BOAC","CRED","MOIP","NETP","R2TC","TETD","TILI","YAMI","ZYGO","CONC") THEN "PAGSEGURO"
    WHEN COALESCE(S.nam_company_hierarquia, S.nam_company_name) IN ("DIVB","COSA","UDTE","COMPASSO","QULT","COMP","EDGE") THEN "COMPASS"
    WHEN COALESCE(S.nam_company_hierarquia, S.nam_company_name) IN ("CIAT","UOLC","PDIR") THEN "EDTECH"
    WHEN COALESCE(S.nam_company_hierarquia, S.nam_company_name) IN ("DT10","FM01","PB17","TF04") THEN "FOLHA SP"
    WHEN COALESCE(S.nam_company_hierarquia, S.nam_company_name) IN ("INGR") THEN "INGRESSO"
    ELSE NULL
  END AS name_company
FROM `uolcs-datalake-engcorp-prd.sistemas_corporativos_erp_sapabap1_datamart.SHOW_USERS_LICENSES` S
WHERE
  S.cod_lic_type IN ('52', '53', '54', '55', '57')
GROUP BY
  S.cod_lic_type,
  S.num_year_month,
  S.nam_company_hierarquia,
  S.nam_company_name
), logic AS (
SELECT DISTINCT
  B.ID,
  B.cod_code,
  B.nam_company,
  B.anomes,
  B.licencas_contratadas,
  B.medido,
  T.Licencas_ZDT,
  SUM(S.contagem_users) soma_users
FROM 
  ZDT_B B
LEFT JOIN (
  SELECT 
    T.ID, 
    T.licencas_ZDT,
    T.dat_modify,
    T.nam_company
  FROM 
    ZDT T
  ORDER BY 
    T.dat_modify DESC
) T
  ON T.ID = B.ID AND T.nam_company = B.nam_company

LEFT JOIN (
  SELECT 
    S.ID, 
    S.contagem_users,
    S.num_year_month,
    S.name_company
  FROM 
    SHOW S
) S
  ON CAST(S.ID AS INT) = B.ID AND CAST(S.num_year_month AS STRING) = B.ANOMES AND S.name_company = B.nam_company
GROUP BY
  B.ID,
  B.cod_code,
  B.nam_company,
  B.anomes,
  B.licencas_contratadas,
  B.medido,
  T.Licencas_ZDT
)
SELECT 
  *
FROM 
  logic L
