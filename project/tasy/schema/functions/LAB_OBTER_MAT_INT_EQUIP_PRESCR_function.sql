-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lab_obter_mat_int_equip_prescr (nr_prescricao_p bigint, nr_seq_exame_p bigint, cd_mat_integ_exame_equip_p text, ds_sigla_equip_p text) RETURNS varchar AS $body$
DECLARE


cd_material_w		material_exame_lab.cd_material_exame%type;
cd_material_exame_w	prescr_procedimento.cd_material_exame%type;
nr_seq_material_w	lab_exame_equip.nr_seq_material%type;
ie_mat_encontrado_w	varchar(1);


BEGIN

select 	coalesce(max(a.nr_seq_material), 0),
	CASE WHEN count(a.cd_equipamento)=0 THEN  'N'  ELSE 'S' END
into STRICT	nr_seq_material_w,
	ie_mat_encontrado_w
from	lab_exame_equip a,
	equipamento_lab b
where	a.cd_equipamento = b.cd_equipamento
  and	a.nr_seq_exame 	= nr_seq_exame_p
  and	a.cd_material_integr = cd_mat_integ_exame_equip_p
  and	b.ds_sigla = ds_sigla_equip_p;

if (ie_mat_encontrado_w = 'S') then
	select	max(cd_material_exame)
	into STRICT	cd_material_w
	from	material_exame_lab
	where	nr_sequencia = nr_seq_material_w;

	select  MAX(a.cd_material_exame)
	into STRICT 	cd_material_exame_w
	from	prescr_procedimento a
	where 	a.nr_prescricao = nr_prescricao_p
	and	a.nr_seq_exame = nr_seq_exame_p
	and	a.cd_material_exame = coalesce(cd_material_w, a.cd_material_exame);
else
	cd_material_exame_w := cd_mat_integ_exame_equip_p;
end if;

return	cd_material_exame_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lab_obter_mat_int_equip_prescr (nr_prescricao_p bigint, nr_seq_exame_p bigint, cd_mat_integ_exame_equip_p text, ds_sigla_equip_p text) FROM PUBLIC;
