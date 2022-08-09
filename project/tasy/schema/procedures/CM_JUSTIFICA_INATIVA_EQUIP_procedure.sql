-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cm_justifica_inativa_equip ( nr_seq_equipamento_p bigint, ds_justificativa_p text, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w		bigint;


BEGIN

select	nextval('cm_equipamento_hist_seq')
into STRICT	nr_sequencia_w
;

insert into cm_equipamento_hist(
	nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	nr_seq_equipamento,
	ds_titulo,
	ie_origem,
	ds_historico,
	dt_liberacao,
	nm_usuario_lib,
	dt_atualizacao_nrec,
	nm_usuario_nrec) values (
		nr_sequencia_w,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_equipamento_p,
		Wheb_mensagem_pck.get_texto(799640),
		'S',
		ds_justificativa_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cm_justifica_inativa_equip ( nr_seq_equipamento_p bigint, ds_justificativa_p text, nm_usuario_p text) FROM PUBLIC;
