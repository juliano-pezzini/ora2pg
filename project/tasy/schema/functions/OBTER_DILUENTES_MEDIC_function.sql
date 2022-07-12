-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_diluentes_medic (nr_prescricao_p bigint, nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_diluicao_w	varchar(2000);
ds_reconst_w	varchar(2000);
ds_rediluicao_w	varchar(2000);
ds_retorno_w	varchar(2000);


BEGIN

select	max(substr(coalesce(b.ds_reduzida, b.ds_material),1,100))
into STRICT	ds_diluicao_w
from	material b,
	prescr_material a
where	nr_prescricao		= nr_prescricao_p
and	nr_sequencia_diluicao	= nr_sequencia_p
and	a.cd_material		= b.cd_material
and	ie_agrupador		= 3;

select	max(substr(coalesce(b.ds_reduzida, b.ds_material),1,100))
into STRICT	ds_rediluicao_w
from	material b,
	prescr_material a
where	nr_prescricao		= nr_prescricao_p
and	nr_sequencia_diluicao	= nr_sequencia_p
and	a.cd_material		= b.cd_material
and	ie_agrupador		= 7;

select	max(substr(coalesce(b.ds_reduzida, b.ds_material),1,100))
into STRICT	ds_reconst_w
from	material b,
	prescr_material a
where	nr_prescricao		= nr_prescricao_p
and	nr_sequencia_diluicao	= nr_sequencia_p
and	a.cd_material		= b.cd_material
and	ie_agrupador		= 9;

if (ds_diluicao_w IS NOT NULL AND ds_diluicao_w::text <> '') then
	ds_retorno_w	:= ds_diluicao_w;
end if;

if (ds_reconst_w IS NOT NULL AND ds_reconst_w::text <> '') then
	if (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') then
		ds_retorno_w	:= ds_retorno_w || chr(13) || ds_reconst_w;
	else
		ds_retorno_w	:= ds_reconst_w;
	end if;
end if;

if (ds_rediluicao_w IS NOT NULL AND ds_rediluicao_w::text <> '') then
	if (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') then
		ds_retorno_w	:= ds_retorno_w || chr(13) || ds_rediluicao_w;
	else
		ds_retorno_w	:= ds_rediluicao_w;
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_diluentes_medic (nr_prescricao_p bigint, nr_sequencia_p bigint) FROM PUBLIC;
