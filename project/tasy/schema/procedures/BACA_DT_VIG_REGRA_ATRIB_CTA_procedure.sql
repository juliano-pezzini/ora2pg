-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_dt_vig_regra_atrib_cta () AS $body$
DECLARE

 
tb_nr_sequencia_w	pls_util_cta_pck.t_number_table;
tb_dt_inicio_vig_ref_w	pls_util_cta_pck.t_date_table;
tb_dt_fim_vig_ref_w	pls_util_cta_pck.t_date_table;

C01 CURSOR FOR 
	SELECT	nr_sequencia,	 
		pls_util_pck.obter_dt_vigencia_null(dt_inicio_vigencia, 'I') dt_inicio_vigencia_ref, 
		pls_util_pck.obter_dt_vigencia_null(dt_fim_vigencia, 'F') dt_fim_vigencia_ref 
	from	pls_ocorrencia_conta_atrib;


BEGIN 
-- este baca foi criado para alimentar os campos de data referencia, isto por questões de performance 
-- para que não seja necessário utilizar um or dt is null nas rotinas que utilizam esta tabela 
-- o campo inicial ref é alimentado com o valor informado no campo inicial ou se este for nulo é alimentado 
-- com a data zero do oracle 31/12/1899, já o campo fim ref é alimentado com o campo fim ou se o mesmo for nulo 
-- é alimentado com a data 31/12/3000 desta forma podemos utilizar um between ou fazer uma comparação com estes campos 
-- sem precisar se preocupar se o campo vai estar nulo 
open C01;
loop 
	fetch C01 bulk collect into tb_nr_sequencia_w, tb_dt_inicio_vig_ref_w, tb_dt_fim_vig_ref_w 
	limit pls_util_pck.qt_registro_transacao_w;
	exit when tb_nr_sequencia_w.count = 0;
 
	forall	i in tb_nr_sequencia_w.first..tb_nr_sequencia_w.last 
		update	pls_ocorrencia_conta_atrib 
		set	dt_inicio_vigencia_ref = tb_dt_inicio_vig_ref_w(i), 
			dt_fim_vigencia_ref = tb_dt_fim_vig_ref_w(i) 
		where 	nr_sequencia = tb_nr_sequencia_w(i);
	commit;
end loop;
close C01;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_dt_vig_regra_atrib_cta () FROM PUBLIC;

