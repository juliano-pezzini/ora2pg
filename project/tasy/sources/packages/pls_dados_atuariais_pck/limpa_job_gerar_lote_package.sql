-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_dados_atuariais_pck.limpa_job_gerar_lote () AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Busca as JOB que sao respectivas a geracao de dados do lote, e se elas estiverem
	como executadas, elas serao removidas.
	
	Hoje isso e necessario pois nao se deixa uma JOB rodando direto, e sim e startada
	uma para fazer o processo mais pesado em background.

-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------

Pontos de atencao:

	
Alteracoes:
-------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


C01 CURSOR FOR
	-- falhas is not null, significa que ja foi executado pelo menos uma vez, se ja foi executado ao menos uma vez, apaga. durante a execucao ele fica null

	SELECT	job
	from	job_v
	where	comando	like 'pls_dados_atuariais_pck.gerar_dados_atuariais_lote()%'
	and	(falhas IS NOT NULL AND falhas::text <> '');
BEGIN

-- Verificar se a job ja existe, se existir remove

for r_C01_w in C01 loop
	dbms_job.remove(r_C01_w.job);
	commit;
end loop;


END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_dados_atuariais_pck.limpa_job_gerar_lote () FROM PUBLIC;