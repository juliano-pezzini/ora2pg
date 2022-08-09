-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lab_alterar_observacao_exame (NR_SEQ_RESULTADO_P bigint, NR_SEQUENCIA_P bigint, NM_USUARIO_P text, DS_OBSERVACAO_P text) AS $body$
BEGIN

update	exame_lab_result_item
set	ds_observacao = DS_OBSERVACAO_P,
	dt_digitacao = clock_timestamp(),
	nm_usuario_prim_dig = NM_USUARIO_P,
	ie_status = 1
where	nr_seq_resultado = nr_seq_resultado_p
and	nr_sequencia = nr_sequencia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lab_alterar_observacao_exame (NR_SEQ_RESULTADO_P bigint, NR_SEQUENCIA_P bigint, NM_USUARIO_P text, DS_OBSERVACAO_P text) FROM PUBLIC;
