-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_alerta_arredond_onc (nr_seq_paciente_setor_p bigint, nr_ciclo_inicial_p bigint, nr_ciclo_final_p bigint) RETURNS varchar AS $body$
DECLARE


ds_alerta_w	varchar(4000);
ds_material_w	varchar(255);

C01 CURSOR FOR
	SELECT	obter_desc_material(a.cd_material)
	from	paciente_atend_medic a,
		paciente_atendimento b
	where	a.nr_seq_atendimento 	= b.nr_seq_atendimento
	and	b.nr_seq_paciente 	= nr_seq_paciente_setor_p
	and	b.nr_ciclo between nr_ciclo_inicial_p and nr_ciclo_final_p
	and exists (SELECT 1 from regra_arredond_onc x where x.cd_unidade_medida = a.cd_unid_med_dose and (x.cd_material = a.cd_material or coalesce(x.cd_material::text, '') = ''))
	group by a.cd_material
	order by 1;


BEGIN

open C01;
loop
fetch C01 into
	ds_material_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	ds_alerta_w := ds_alerta_w || chr(13) || chr(10) || ds_material_w;
	end;
end loop;
close C01;

if (ds_alerta_w IS NOT NULL AND ds_alerta_w::text <> '') then
	ds_alerta_w := Wheb_mensagem_pck.get_texto(308918) || ' ' /*'As doses dos seguintes medicamentos podem ser arreondados: '*/ || chr(13) || chr(10) || ds_alerta_w;
end if;

return	ds_alerta_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_alerta_arredond_onc (nr_seq_paciente_setor_p bigint, nr_ciclo_inicial_p bigint, nr_ciclo_final_p bigint) FROM PUBLIC;
