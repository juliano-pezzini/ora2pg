-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_lote_medic_producao ( nr_lote_producao_p bigint, cd_material_p bigint) RETURNS bigint AS $body$
DECLARE


nr_seq_lote_fornec_w	bigint := null;


BEGIN

if (obter_se_permite_lote_dif(cd_material_p) = 'N') then
	select	max(nr_seq_lote_fornec)
	into STRICT	nr_seq_lote_fornec_w
	from	lp_item_util
	where	nr_lote_producao	=	nr_lote_producao_p
	and	cd_material		=	cd_material_p;
end if;

return	nr_seq_lote_fornec_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_lote_medic_producao ( nr_lote_producao_p bigint, cd_material_p bigint) FROM PUBLIC;

