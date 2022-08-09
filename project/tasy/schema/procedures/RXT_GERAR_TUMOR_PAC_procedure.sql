-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE rxt_gerar_tumor_pac ( cd_pessoa_fisica_p text, cd_medico_p text, cd_convenio_p bigint, cd_cido_p text, nr_seq_tipo_p bigint, nm_usuario_p text, nr_seq_tumor_p INOUT bigint) AS $body$
BEGIN


select	nextval('rxt_tumor_seq')
into STRICT	nr_seq_tumor_p
;

insert into rxt_tumor(
	nr_sequencia,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	dt_atualizacao,
	nm_usuario,
	cd_pessoa_fisica,
	cd_medico,
	cd_convenio,
	cd_cido,
	nr_seq_tipo,
	ie_situacao
	)
values (
	nr_seq_tumor_p,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	cd_pessoa_fisica_p,
	cd_medico_p,
	cd_convenio_p,
	cd_cido_p,
	nr_seq_tipo_p,
	'A'
	);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE rxt_gerar_tumor_pac ( cd_pessoa_fisica_p text, cd_medico_p text, cd_convenio_p bigint, cd_cido_p text, nr_seq_tipo_p bigint, nm_usuario_p text, nr_seq_tumor_p INOUT bigint) FROM PUBLIC;
