-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_att_saldo_lanc_prog () AS $body$
DECLARE


vl_baixa_lanc_w  double precision;

C01 CURSOR FOR
	SELECT	a.nr_seq_mensalidade,
		a.nr_sequencia nr_seq_lanc_mensalidade,
		b.ie_operacao_motivo,
		a.vl_lancamento
	from 	pls_lancamento_mensalidade a,
		pls_tipo_lanc_adic b
	where 	b.nr_sequencia = a.nr_seq_motivo
	and 	coalesce(a.vl_saldo::text, '') = ''
	and 	a.vl_lancamento <> 0;

BEGIN
CALL Exec_Sql_Dinamico('Tasy',' alter trigger pls_lancamento_mensalidade_bp disable ');

for r_c01_w in c01 loop
	begin
	if (r_c01_w.nr_seq_mensalidade IS NOT NULL AND r_c01_w.nr_seq_mensalidade::text <> '') then
		update 	pls_lancamento_mensalidade
		set 	vl_saldo = 0
		where 	nr_sequencia = r_c01_w.nr_seq_lanc_mensalidade;
	else
		CALL pls_atualizar_saldo_lanc_prog(r_c01_w.nr_seq_lanc_mensalidade, 'N');
	end if;
	end;
end loop;

commit;

CALL Exec_Sql_Dinamico('Tasy',' alter trigger pls_lancamento_mensalidade_bp enable ');

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_att_saldo_lanc_prog () FROM PUBLIC;
