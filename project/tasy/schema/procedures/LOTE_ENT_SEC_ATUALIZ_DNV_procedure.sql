-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lote_ent_sec_atualiz_dnv (cd_pessoa_fisica_p text, cd_dnv_p text, nm_usuario_p text) AS $body$
BEGIN

/*  Essa procedure é utilizada nas trigger LOTE_ENT_SEC_FICHA_UPDATE e LOTE_ENT_SEC_FICHA_INSERT */

  UPDATE	pessoa_fisica
  SET		cd_declaracao_nasc_vivo = cd_dnv_p,
		nm_usuario = nm_usuario_p,
		dt_atualizacao =  clock_timestamp()
  WHERE 	cd_pessoa_fisica = cd_pessoa_fisica_p;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lote_ent_sec_atualiz_dnv (cd_pessoa_fisica_p text, cd_dnv_p text, nm_usuario_p text) FROM PUBLIC;

