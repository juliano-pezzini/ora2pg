-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE gerar_resumo_oftalmo_pkg.hdh_gerar_resumo_oftalmo ( cd_pessoa_fisica_p text, nm_usuario_p text, ds_fundoscopia_p text) AS $body$
BEGIN
	CALL HDH_gerar_Resumo_Oftalmo_pkg.HDH_Gerar_Resumo_Oftalmo(	cd_pessoa_fisica_p, nm_usuario_p, ds_fundoscopia_p);
	END;

$body$
LANGUAGE PLPGSQL
;
-- REVOKE ALL ON PROCEDURE gerar_resumo_oftalmo_pkg.hdh_gerar_resumo_oftalmo ( cd_pessoa_fisica_p text, nm_usuario_p text, ds_fundoscopia_p text) FROM PUBLIC;