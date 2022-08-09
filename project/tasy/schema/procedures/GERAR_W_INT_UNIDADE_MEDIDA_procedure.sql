-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_int_unidade_medida ( cd_sistema_ant_p text, cd_unidade_medida_p text, ds_unidade_medida_p text, ie_situacao_p text, nm_usuario_p text, nr_seq_unidade_medida_p INOUT text) AS $body$
DECLARE







nr_seq_unidade_medida_w	bigint;
ds_erro_w	varchar(4000);


BEGIN

delete FROM w_int_unidade_medida
where nm_usuario = nm_usuario_p;

select	nextval('w_int_unidade_medida_seq')
into STRICT	nr_seq_unidade_medida_w
;

insert into w_int_unidade_medida(
			nr_sequencia,
			cd_sistema_ant,
			cd_unidade_medida,
			ds_unidade_medida,
			ie_situacao,
			nm_usuario,
			nm_usuario_nrec,
			dt_atualizacao,
			dt_atualizacao_nrec)
values ( nr_seq_unidade_medida_w,
	cd_sistema_ant_p,
	cd_unidade_medida_p,
	ds_unidade_medida_p,
	ie_situacao_p,
	nm_usuario_p,
	nm_usuario_p,
	clock_timestamp(),
	clock_timestamp());

nr_seq_unidade_medida_p := nr_seq_unidade_medida_w;

commit;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_int_unidade_medida ( cd_sistema_ant_p text, cd_unidade_medida_p text, ds_unidade_medida_p text, ie_situacao_p text, nm_usuario_p text, nr_seq_unidade_medida_p INOUT text) FROM PUBLIC;
