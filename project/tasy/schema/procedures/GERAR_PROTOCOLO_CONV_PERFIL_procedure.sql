-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_protocolo_conv_perfil ( nr_seq_protocolo_p bigint, cd_perfil_p bigint, nm_usuario_p text) AS $body$
BEGIN

insert into protocolo_convenio_perfil(	nr_sequencia,
					nr_seq_protocolo,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					cd_perfil)
values (	nextval('protocolo_convenio_perfil_seq'),
	nr_seq_protocolo_p,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	cd_perfil_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_protocolo_conv_perfil ( nr_seq_protocolo_p bigint, cd_perfil_p bigint, nm_usuario_p text) FROM PUBLIC;
