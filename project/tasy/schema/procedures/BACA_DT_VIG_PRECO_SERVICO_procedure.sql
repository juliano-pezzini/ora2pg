-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_dt_vig_preco_servico () AS $body$
DECLARE

 
tb_cd_estabelecimento_w	pls_util_cta_pck.t_number_table;
tb_cd_tabela_servico_w	pls_util_cta_pck.t_number_table;
tb_cd_procedimento_w	pls_util_cta_pck.t_number_table;
tb_dt_inicio_vig_w	pls_util_cta_pck.t_date_table;
tb_dt_fim_vig_ref_w	pls_util_cta_pck.t_date_table;

C01 CURSOR FOR 
	SELECT	cd_estabelecimento, 
		cd_tabela_servico, 
		cd_procedimento, 
		dt_inicio_vigencia, 
		pls_util_pck.obter_dt_vigencia_null(dt_vigencia_final, 'F') dt_fim_vigencia_ref 
	from	preco_servico;


BEGIN 
-- esta trigger foi criada para alimentar os campos de data referencia, isto por questões de performance 
-- para que não seja necessário utilizar um or is null nas rotinas que utilizam esta tabela o campo fim ref 
-- é alimentado com o campo fim ou se o mesmo for nulo é alimentado com a data 31/12/3000 desta forma podemos 
-- utilizar um between ou fazer uma comparação com estes campos sem precisar se preocupar se o campo vai estar nulo 
 
open C01;
loop 
	fetch C01 bulk collect into 	tb_cd_estabelecimento_w, tb_cd_tabela_servico_w, tb_cd_procedimento_w, 
					tb_dt_inicio_vig_w, tb_dt_fim_vig_ref_w 
	limit pls_util_pck.qt_registro_transacao_w;
	exit when tb_cd_tabela_servico_w.count = 0;
 
	forall	i in tb_cd_tabela_servico_w.first..tb_cd_tabela_servico_w.last 
		update	preco_servico 
		set	dt_fim_vigencia_ref = tb_dt_fim_vig_ref_w(i) 
		where 	cd_estabelecimento = tb_cd_estabelecimento_w(i) 
		and	cd_tabela_servico = tb_cd_tabela_servico_w(i) 
		and	cd_procedimento = tb_cd_procedimento_w(i) 
		and	dt_inicio_vigencia = tb_dt_inicio_vig_w(i);
	commit;
end loop;
close C01;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_dt_vig_preco_servico () FROM PUBLIC;

