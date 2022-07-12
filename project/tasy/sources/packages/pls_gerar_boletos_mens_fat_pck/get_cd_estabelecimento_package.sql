-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_gerar_boletos_mens_fat_pck.get_cd_estabelecimento () RETURNS bigint AS $body$
BEGIN
		return current_setting('pls_gerar_boletos_mens_fat_pck.cd_estabelecimento_w')::estabelecimento.cd_estabelecimento%type;
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_gerar_boletos_mens_fat_pck.get_cd_estabelecimento () FROM PUBLIC;
