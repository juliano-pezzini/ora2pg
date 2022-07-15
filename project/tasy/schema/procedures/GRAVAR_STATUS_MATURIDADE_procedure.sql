-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_status_maturidade (nm_usuario_p text) AS $body$
DECLARE

 
c01 CURSOR FOR 
SELECT 
	cd_funcao, 
	QT_SCORE_VALID, 
	QT_SCORE_VERIF, 
	QT_SCORE_ESTAGIO, 
	IE_PARTIC_ELEVEN, 
	PR_EXECUCAO_ELEVEN, 
	QT_SCORE_CLIENTE, 
	QT_SCORE_FUNCAO, 
	QT_SCORE_TOTAL, 
	QT_SCORE_GERENCIA		 
FROM 	table(coverage_indicator_pck.obter_dados('31/10/2017',clock_timestamp(),'N'));

BEGIN 
 
for r_c01_w in c01 loop 
	begin 
		INSERT INTO 	funcoes_html5_maturidade(nr_sequencia, 
				dt_atualizacao, 
				nm_usuario, 
				cd_funcao, 
				QT_SCORE_VALID, 
				QT_SCORE_VERIF, 
				QT_SCORE_ESTAGIO, 
				IE_PARTIC_ELEVEN, 
				PR_EXECUCAO_ELEVEN, 
				QT_SCORE_CLIENTE, 
				QT_SCORE_FUNCAO, 
				QT_SCORE_TOTAL, 
				QT_SCORE_GERENCIA) 
		values ( 
				nextval('funcoes_html5_maturidade_seq'), 
				clock_timestamp(), 
				nm_usuario_p, 
				r_c01_w.cd_funcao, 
				r_c01_w.QT_SCORE_VALID, 
				r_c01_w.QT_SCORE_VERIF, 
				r_c01_w.QT_SCORE_ESTAGIO, 
				r_c01_w.IE_PARTIC_ELEVEN, 
				r_c01_w.PR_EXECUCAO_ELEVEN, 
				r_c01_w.QT_SCORE_CLIENTE, 
				r_c01_w.QT_SCORE_FUNCAO, 
				r_c01_w.QT_SCORE_TOTAL, 
				r_c01_w.QT_SCORE_GERENCIA);
	end;
	 
end loop;
	 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_status_maturidade (nm_usuario_p text) FROM PUBLIC;

