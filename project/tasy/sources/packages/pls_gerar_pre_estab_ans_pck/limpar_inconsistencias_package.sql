-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_gerar_pre_estab_ans_pck.limpar_inconsistencias (dados_inconsistencia_p INOUT dados_inconsistencia) AS $body$
BEGIN

if (dados_inconsistencia_p.nr_seq_pre_estab_val.count > 0) then

	forall i in dados_inconsistencia_p.nr_seq_pre_estab_val.first .. dados_inconsistencia_p.nr_seq_pre_estab_val.last
		delete	FROM pls_monitor_tiss_inc_pre
		where	nr_seq_pre_estab_val = dados_inconsistencia_p.nr_seq_pre_estab_val(i);
	commit;

	dados_inconsistencia_p.nr_seq_pre_estab_val.delete;
	dados_inconsistencia_p.cd_inconsistencia.delete;
end if;


END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_pre_estab_ans_pck.limpar_inconsistencias (dados_inconsistencia_p INOUT dados_inconsistencia) FROM PUBLIC;