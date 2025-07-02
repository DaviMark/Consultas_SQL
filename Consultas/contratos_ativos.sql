WITH TI_EDGE AS (
SELECT 
  T00849.cod_contract,
  T00030.nam_company_group AS nam_client,
  T00849.idt_service_situation,
  T01454.nam_current_situation,
  T00003.nam_user AS nam_lawyer,
  T00003_A.nam_user AS nam_applicant,
  DATE(T00849.dat_created) AS dat_created,
  DATE(T00849.dat_closed) AS dat_closed,
  T00849.idt_company_group,
  T00030_A.nam_company_group AS nam_company,

FROM `project.dataset.T00849` T00849
LEFT JOIN `project.dataset.T01454` T01454 
  ON T01454.idt_service_situation = T00849.idt_service_situation -- Status

LEFT JOIN `project.dataset.T00030` T00030 
  ON T00030.idt_person = T00849.idt_counterpart -- Descrição sobre Cliente

LEFT JOIN `project.dataset.T00030` T00030_A 
  ON T00030_A.idt_person = T00849.idt_company_group -- Descrição sobre Empresa

LEFT JOIN `project.dataset.T00003` T00003 
  ON T00003.idt_user = T00849.idt_user_emitter -- Descrição sobre Advogado Responsavel

LEFT JOIN `project.dataset.T00003` T00003_A 
  ON T00003_A.idt_user = T00849.idt_user_requester -- Descrição sobre nome do Solicitante

WHERE EXTRACT(YEAR FROM T00849.dat_created) = EXTRACT(YEAR FROM CURRENT_DATETIME())
AND T00849.idt_service_situation NOT IN (10,99,106,107,127,128,135,150,167,149,187,190,192,234,245,248) -- Tirando os Cancelados, cancelado por Inatividade, Aprovado, Finalizado,Aprovado e Concluido entre outros
AND T00849.idt_company_group IN (21513,24247,22315,28366,3279) -- Pegando somente as Empresas EDGE
)

, RESPONSIBLE_CURRENT AS (
SELECT nam_responsible_current FROM `project.dataset.RESPONSIBLE_CURRENT`
)

SELECT *,
IF(nam_lawyer IN (SELECT nam_responsible_current FROM RESPONSIBLE_CURRENT), "Retornou a área", "") AS des_status_area
FROM TI_EDGE