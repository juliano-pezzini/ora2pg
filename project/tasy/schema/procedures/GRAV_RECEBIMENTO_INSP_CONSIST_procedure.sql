-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE grav_recebimento_insp_consist ( nr_seq_inspecao_p bigint, ds_consistencia_p text, ie_forma_p text, ds_observacao_p text, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w	bigint;

BEGIN

select	nextval('recebimento_insp_consist_seq')
into STRICT	nr_sequencia_w
;

insert into recebimento_insp_consist(
	nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_seq_inspecao,
	ds_consistencia,
	ie_forma_consistencia,
	ds_observacao)
values (	nr_sequencia_w,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_inspecao_p,
	ds_consistencia_p,
	ie_forma_p,
	ds_observacao_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE grav_recebimento_insp_consist ( nr_seq_inspecao_p bigint, ds_consistencia_p text, ie_forma_p text, ds_observacao_p text, nm_usuario_p text) FROM PUBLIC;
