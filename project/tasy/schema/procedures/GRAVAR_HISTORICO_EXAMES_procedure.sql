-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_historico_exames (cd_estab_p bigint, nr_seq_exame_p bigint, ds_titulo_p text, ds_historico_p text, ie_tipo_p text, nr_seq_motivo_hist_p bigint, nm_usuario_p text, nr_seq_historico_p INOUT bigint) AS $body$
DECLARE


ds_historico_w				exame_historico.ds_historico%type;
ds_historico_curto_w		exame_historico.ds_historico_curto%type;
nr_sequencia_w				bigint;


BEGIN

ds_historico_w		:= substr(ds_historico_p,1,4000);
ds_historico_curto_w	:= substr(ds_historico_p,1,30);

select	nextval('exame_historico_seq')
into STRICT	nr_sequencia_w
;

insert into exame_historico(
	nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	ds_historico,
	ds_historico_curto,
	nr_seq_exame,
	ds_titulo,
	cd_estabelecimento,
	ie_tipo,
	dt_liberacao,
	nm_usuario_liberacao,
	nr_seq_motivo_hist)
values (	nr_sequencia_w,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	ds_historico_w,
	ds_historico_curto_w,
	nr_seq_exame_p,
	ds_titulo_p,
	CASE WHEN cd_estab_p=0 THEN null  ELSE cd_estab_p END ,
	ie_tipo_p,
	clock_timestamp(),
	'TASY',
	nr_seq_motivo_hist_p);
	
nr_seq_historico_p	:= nr_sequencia_w;
	
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_historico_exames (cd_estab_p bigint, nr_seq_exame_p bigint, ds_titulo_p text, ds_historico_p text, ie_tipo_p text, nr_seq_motivo_hist_p bigint, nm_usuario_p text, nr_seq_historico_p INOUT bigint) FROM PUBLIC;
