-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_delete_copy_anatomia ( NR_CPOE_ANATOMIA_P bigint) AS $body$
BEGIN

	DELETE FROM W_CPOE_PRESCR_PROC_PECA
	WHERE nr_seq_cpoe_proc = NR_CPOE_ANATOMIA_P;

	DELETE FROM W_CPOE_PRESCR_HISTOPATOL
	WHERE nr_seq_proc_anatomia = NR_CPOE_ANATOMIA_P;

	DELETE FROM W_CPOE_PRESCR_CITOP
	WHERE nr_seq_proc_anatomia = NR_CPOE_ANATOMIA_P;

	DELETE FROM W_CPOE_PRESCR_PROC_PECA
	WHERE DT_ATUALIZACAO_NREC <= clock_timestamp() - interval '2 days';

	DELETE FROM W_CPOE_PRESCR_HISTOPATOL
	WHERE DT_ATUALIZACAO_NREC <= clock_timestamp() - interval '2 days';

	DELETE FROM W_CPOE_PRESCR_CITOP
	WHERE DT_ATUALIZACAO_NREC <= clock_timestamp() - interval '2 days';

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_delete_copy_anatomia ( NR_CPOE_ANATOMIA_P bigint) FROM PUBLIC;

