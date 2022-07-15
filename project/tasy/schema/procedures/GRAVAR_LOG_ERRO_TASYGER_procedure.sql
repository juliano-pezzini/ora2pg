-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_log_erro_tasyger ( ie_tipo_log_p text, ds_erro_p text, nm_usuario_p text) AS $body$
BEGIN

insert into log_erro_emissao(
	dt_atualizacao,
	nm_usuario,
	ie_tipo_log,
	ds_erro)
values (	clock_timestamp(),
	nm_usuario_p,
	ie_tipo_log_p,
	substr(ds_erro_p,1,2000));

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_log_erro_tasyger ( ie_tipo_log_p text, ds_erro_p text, nm_usuario_p text) FROM PUBLIC;

