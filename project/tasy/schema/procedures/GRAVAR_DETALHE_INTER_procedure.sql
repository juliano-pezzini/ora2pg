-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_detalhe_inter ( nr_seq_pac_inter_p bigint, nr_seq_detalhe_p bigint, nm_usuario_p text) AS $body$
DECLARE

nr_sequencia_w		bigint;

BEGIN

select	nextval('pac_atend_interc_det_seq')
into STRICT	nr_sequencia_w
;

insert 	into pac_atend_interc_det(
	nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_seq_pac_inter,
	nr_seq_detalhe)
values (nr_sequencia_w,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_pac_inter_p,
	nr_seq_detalhe_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_detalhe_inter ( nr_seq_pac_inter_p bigint, nr_seq_detalhe_p bigint, nm_usuario_p text) FROM PUBLIC;

