-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_arquivo_convenio ( ds_arquivo_p text, nr_seq_autorizacao_p bigint, nm_usuario_p text) AS $body$
DECLARE

nr_sequencia_w		bigint;
ie_anexar_email_w	varchar(15) := 'N';

BEGIN

ie_anexar_email_w := obter_param_usuario(281, 1179, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_anexar_email_w);


insert into autorizacao_convenio_arq(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_sequencia_autor,
		ds_arquivo,
		ie_anexar_email )
 values (
		nextval('autorizacao_convenio_arq_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_autorizacao_p,
		ds_arquivo_p,
		coalesce(ie_anexar_email_w,'N'));

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_arquivo_convenio ( ds_arquivo_p text, nr_seq_autorizacao_p bigint, nm_usuario_p text) FROM PUBLIC;
