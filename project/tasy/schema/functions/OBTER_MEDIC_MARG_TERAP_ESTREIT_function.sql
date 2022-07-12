-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_medic_marg_terap_estreit ( cd_material_p bigint) RETURNS varchar AS $body$
DECLARE

ds_retorno_w 	varchar(1);



BEGIN

select coalesce(max(mft.IE_MARGEM_TERAP_ESTREITA),'N')
 into STRICT	ds_retorno_w
from	material m, medic_ficha_tecnica mft
where	m.cd_material	= cd_material_p
and mft.NR_SEQUENCIA = m.NR_SEQ_FICHA_TECNICA;


return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_medic_marg_terap_estreit ( cd_material_p bigint) FROM PUBLIC;

