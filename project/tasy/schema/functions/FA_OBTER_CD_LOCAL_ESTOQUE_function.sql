-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION fa_obter_cd_local_estoque ( nr_seq_material_item_p bigint) RETURNS bigint AS $body$
DECLARE


cd_local_estoque_w	bigint;


BEGIN
if (nr_seq_material_item_p IS NOT NULL AND nr_seq_material_item_p::text <> '') then
	select	coalesce(max(a.cd_local_estoque),0)
	into STRICT	cd_local_estoque_w
	from	material_atend_paciente a
	where	a.nr_seq_entrega_medic_fa = nr_seq_material_item_p;

end if;

return	cd_local_estoque_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION fa_obter_cd_local_estoque ( nr_seq_material_item_p bigint) FROM PUBLIC;
