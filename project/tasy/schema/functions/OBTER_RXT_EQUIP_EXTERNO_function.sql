-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_rxt_equip_externo ( cd_equipamento_p bigint ) RETURNS varchar AS $body$
DECLARE


cd_equip_externo_w			varchar(30);


BEGIN

	select max(cd_equip_externo)
	into STRICT cd_equip_externo_w
	from rxt_equipamento
	where nr_Sequencia = cd_equipamento_p;

return cd_equip_externo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_rxt_equip_externo ( cd_equipamento_p bigint ) FROM PUBLIC;

