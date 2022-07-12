-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_material_prescr (nr_prescricao_p bigint, nr_seq_material_p bigint) RETURNS varchar AS $body$
DECLARE


ds_material_w	varchar(100);


BEGIN
if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_material_p IS NOT NULL AND nr_seq_material_p::text <> '') then

	select	substr(obter_desc_material(cd_material),1,100) ds_material
	into STRICT	ds_material_w
	from	prescr_material
	where	nr_prescricao	= nr_prescricao_p
	and	nr_sequencia	= nr_seq_material_p;

end if;

return ds_material_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_material_prescr (nr_prescricao_p bigint, nr_seq_material_p bigint) FROM PUBLIC;

