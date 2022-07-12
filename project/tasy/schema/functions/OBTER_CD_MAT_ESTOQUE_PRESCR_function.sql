-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_cd_mat_estoque_prescr ( nr_sequencia_p bigint, nr_prescricao_p bigint) RETURNS bigint AS $body$
DECLARE

w_cd_material_estoque	bigint := 0;

BEGIN
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') then
	begin
	select 	b.cd_material_estoque
	into STRICT	w_cd_material_estoque
	from	material b,
		prescr_material a
	where	a.cd_material = b.cd_material
	and	a.nr_sequencia = nr_sequencia_p
	and	a.nr_prescricao = nr_prescricao_p;
	end;
end if;

return	w_cd_material_estoque;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_cd_mat_estoque_prescr ( nr_sequencia_p bigint, nr_prescricao_p bigint) FROM PUBLIC;

