-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE grava_log_erro_quimio (cd_material_p bigint, nr_seq_lote_fornec_p bigint, nr_seq_ordem_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w 		bigint;


BEGIN

select	nextval('log_erro_manip_quimio_seq')
into STRICT	nr_sequencia_w
;

insert into log_erro_manip_quimio(
	nr_sequencia,
	cd_material,
	dt_atualizacao,
	dt_atualizacao_nrec,
	nm_usuario,
	nm_usuario_nrec,
	nr_seq_lote_fornec,
	nr_seq_ordem)
values (nr_sequencia_w,
	cd_material_p,
	clock_timestamp(),
	clock_timestamp(),
	nm_usuario_p,
	nm_usuario_p,
	nr_seq_lote_fornec_p,
	nr_seq_ordem_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE grava_log_erro_quimio (cd_material_p bigint, nr_seq_lote_fornec_p bigint, nr_seq_ordem_p bigint, nm_usuario_p text) FROM PUBLIC;
