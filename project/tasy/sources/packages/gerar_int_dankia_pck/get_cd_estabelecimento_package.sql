-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION gerar_int_dankia_pck.get_cd_estabelecimento (cd_local_estoque_p bigint) RETURNS bigint AS $body$
BEGIN
		
		select	max(coalesce(wheb_usuario_pck.get_cd_estabelecimento,cd_estabelecimento))
		into STRICT	cd_estab_w
		from	local_estoque
		where 	cd_local_estoque = cd_local_estoque_p;
		
		return	cd_estab_w;
		end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION gerar_int_dankia_pck.get_cd_estabelecimento (cd_local_estoque_p bigint) FROM PUBLIC;