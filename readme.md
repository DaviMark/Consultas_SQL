# 📌 Repositório de Consultas SQL

🚀 Bem-vindo ao repositório de consultas SQL!  
Aqui você encontrará uma coleção de **queries otimizadas**, voltadas para **análises de dados**, **automação de relatórios** e **manipulação eficiente de bases relacionais**, aplicadas a diferentes contextos de negócio.

Se você trabalha com dados e precisa de soluções rápidas e reutilizáveis em SQL, este repositório foi feito para você.

---

## 📂 Estrutura do Repositório

O repositório está organizado por funcionalidades e casos de uso:


```
/
├── consultas/
│   ├── Info_Torre.sql       # Consultas para buscar informação dos veiculos em tempo real.
│   ├── Km_Rodado.sql          # Queries para calcular o Km rodado real por veiculo.
|   ├── proxima_manut.sql      # Consulta para buscar somente a proxima manutenção necessaria para cada veiculo.
│   ├── dist_valor.sql          # Consultas para geração de relatórios.
|   ├── controle_jornada.sql     # Consultas para gerar relatório personalizado para controle de jornada de colaboradores.
|   ├── orcamento_email.sql     # Consultas para coletar os dados e enviar o email apartir de um script em JavaScript ou Python.
|   ├── OrcadoxRealizado.sql     # Querie utiliza do DRE e Orçamento para buscar informaçoes de orçado e realizado por cada conta contabil.
|   ├── gestao_ocorrencias.sql     # Consulta para buscar as ocorrencias de cada viagem realizada.
|   ├── gestao_contratos.sql     # Consulta identificar cada contrato e suas informaçoes para analise no painel.
|   ├── control_licencas.sql     # Querie realizada no BigQuery para buscar informaçoes de cada licença SAP, das que foram contratadas e as que estão sendo utilizadas.
|   ├── contratos_ativos.sql     # Consultando tabela do BQ para buscar os contratos ativos, e relacionando a uma tabela extraida do Sharepoint para retornar dados necessarios.
|   ├── receita_analitica.sql     # Buscando dados das tabelas do BQ para atualizar nova tabela na camada datamart, e disponibilizar o consumo para visualizar no pbi.
|   ├── extracao_pontual.sql     # Extração pontual com alguns dados do receita_analitica, mas com alguns detalhes e otimizando a consulta por causa do alto consumo.
│   
└── README.md                   # Documentação do repositório
```

---

# ⚠️ Observação de Segurança

As queries aqui presentes são exemplos técnicos e **não contêm dados sensíveis ou reais**.  
Todos os nomes de projetos, datasets e tabelas foram **anônimos ou modificados** para preservar a confidencialidade e respeitar diretrizes corporativas.

---

## 🛠️ Tecnologias Utilizadas

- **BigQuery (Google Cloud)**
- **SQL Server**
- **MySQL**
- **PostgreSQL**
- **Oracle SQL**
- **SQLite**

---

## 📈 Objetivo

Este repositório tem como finalidade:

- Centralizar consultas reutilizáveis em diferentes projetos
- Documentar lógicas complexas aplicadas em ambientes reais
- Servir de inspiração ou base para automações e dashboards
- Compartilhar conhecimento técnico com a comunidade




