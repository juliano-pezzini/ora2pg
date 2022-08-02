-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE san_inseri_hemo_emp_estab ( nr_seq_producao_p bigint, nr_seq_emp_estab_p bigint, ie_status_p text, nm_usuario_p text) AS $body$
DECLARE


nr_seq_emp_estab_hem_w	bigint;

BEGIN

if (nr_seq_producao_p IS NOT NULL AND nr_seq_producao_p::text <> '') and (nr_seq_emp_estab_p IS NOT NULL AND nr_seq_emp_estab_p::text <> '') and (ie_status_p IS NOT NULL AND ie_status_p::text <> '') then
	select	nextval('san_emp_estab_hem_seq')
	into STRICT	nr_seq_emp_estab_hem_w
	;

	insert into SAN_EMP_ESTAB_HEM(
		nr_sequencia,
		NR_SEQ_PRODUCAO,
		NR_SEQ_EMP_ESTAB,
		IE_STATUS,
		dt_atualizacao,
		nm_usuario)
	values (	nr_seq_emp_estab_hem_w,
		nr_seq_producao_p,
		nr_seq_emp_estab_p,
		ie_status_p,
		clock_timestamp(),
		nm_usuario_p);

end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE san_inseri_hemo_emp_estab ( nr_seq_producao_p bigint, nr_seq_emp_estab_p bigint, ie_status_p text, nm_usuario_p text) FROM PUBLIC;

