-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pkg_name_utils.get_social_name_enabled (cd_estabelecimento_p bigint default null) RETURNS varchar AS $body$
DECLARE

ds_key_w	varchar(255);
cd_estab_w	bigint;

BEGIN
cd_estab_w	:= coalesce(cd_estabelecimento_p,coalesce(wheb_usuario_pck.get_cd_estabelecimento,1));
ds_key_w	:= cd_estab_w;

if (current_setting('pkg_name_utils.vetor_w')::estabParams_vt.exists(ds_key_w)) then
	return current_setting('pkg_name_utils.vetor_w')::estabParams_vt[ds_key_w].ie_social_name;
else
	current_setting('pkg_name_utils.vetor_w')::estabParams_vt[ds_key_w].cd_estabelecimento	:= ds_key_w;
	select	coalesce(max(ie_nome_social),'N')
	into STRICT	current_setting('pkg_name_utils.vetor_w')::estabParams_vt[ds_key_w].ie_social_name
	from	estabelecimento
	where	cd_estabelecimento = cd_estab_w;

	return current_setting('pkg_name_utils.vetor_w')::estabParams_vt[ds_key_w].ie_social_name;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pkg_name_utils.get_social_name_enabled (cd_estabelecimento_p bigint default null) FROM PUBLIC;
