-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION dhd_obter_lista_medic (dt_inicial_p timestamp, dt_final_p timestamp, cd_classe_inferior_p bigint, nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_material_w	varchar(80);
ds_materiais_w	varchar(2000);

c01 CURSOR FOR
	SELECT  distinct a.cd_material|| '  ' || a.ds_material
	from 	material a,
		material_atend_paciente b
	where 	a.cd_material = b.cd_material
	and 	b.dt_atendimento between  dt_inicial_p and fim_dia(dt_final_p)
	and	b.nr_atendimento = nr_atendimento_p
	and a.cd_material in (11581,11580,35115,23728,20942,23730,20948,23736,20949,33995,34119,34120,20829,34123)
	and exists 	(SELECT 1
			 from material k,
			      material_atend_paciente y
			 where k.cd_material = y.cd_material
			 and ((k.cd_classe_material = cd_classe_inferior_p) or (cd_classe_inferior_p = 0 ))
			 and Y.dt_atendimento between  dt_inicial_p and fim_dia(dt_final_p)
			 and y.cd_material<>b.cd_material
			 and y.nr_seq_atepacu = b.nr_seq_atepacu
			 and y.nr_atendimento = b.nr_atendimento
			 and k.ie_tipo_material in (2,3)
			 and k.cd_classe_material  not in (34,319,45,74,85,173))
	order by 1;


BEGIN
open c01;
loop
fetch c01 into
	ds_material_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	if (ds_materiais_w IS NOT NULL AND ds_materiais_w::text <> '') then
		ds_materiais_w := ds_materiais_w || ',  ';
	end if;

	ds_materiais_w	:= ds_materiais_w || ds_material_w;

	end;
end loop;
close c01;

return	ds_materiais_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION dhd_obter_lista_medic (dt_inicial_p timestamp, dt_final_p timestamp, cd_classe_inferior_p bigint, nr_atendimento_p bigint) FROM PUBLIC;
