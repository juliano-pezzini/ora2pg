-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lab_obter_mat_integr_exame ( nr_seq_material_p bigint, nr_seq_exame_p bigint, ds_sigla_p text) RETURNS varchar AS $body$
DECLARE


cd_material_integr_w	varchar(100);


BEGIN

select	max(a.cd_material_integracao)
into STRICT	cd_material_integr_w
from	material_exame_lab_int a,
		equipamento_lab b
where	a.cd_equipamento = b.cd_equipamento
and		UPPER(b.ds_sigla) = UPPER(ds_sigla_p)
and		a.nr_seq_material = nr_seq_material_p;

if (coalesce(cd_material_integr_w::text, '') = '') then
	select	max(a.cd_material_integr)
	into STRICT	cd_material_integr_w
	from	lab_exame_equip a,
			equipamento_lab b
	where	a.cd_equipamento = b.cd_equipamento
	and		a.nr_seq_exame = nr_seq_exame_p
	and		UPPER(b.ds_sigla) = UPPER(ds_sigla_p)
	and		a.nr_seq_material = nr_seq_material_p;
end if;

return	cd_material_integr_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lab_obter_mat_integr_exame ( nr_seq_material_p bigint, nr_seq_exame_p bigint, ds_sigla_p text) FROM PUBLIC;

