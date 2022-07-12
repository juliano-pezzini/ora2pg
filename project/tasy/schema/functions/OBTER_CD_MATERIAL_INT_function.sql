-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_cd_material_int ( nr_seq_material_p bigint, nr_seq_exame_p bigint, ds_sigla_p text) RETURNS varchar AS $body$
DECLARE


cd_material_int		material_exame_lab_int.cd_material_integracao%type;
cd_equipamento_w	lab_exame_equip.cd_equipamento%type;
qt_registros_w		smallint;



BEGIN
	select	max(a.cd_equipamento),
			count(*)
	into STRICT	cd_equipamento_w,
			qt_registros_w
	from	lab_exame_equip a,
			equipamento_lab b
	where 	coalesce(a.nr_seq_material, nr_seq_material_p) = nr_seq_material_p
		and a.nr_seq_exame = nr_seq_exame_p
		and a.cd_equipamento = b.cd_equipamento
		and b.DS_SIGLA = ds_sigla_p
		and a.ie_padrao = 'S';

	if (qt_registros_w = 1) then
		select	max(cd_material_integracao),
				count(*)
		into STRICT	cd_material_int,
				qt_registros_w
		from 	material_exame_lab_int
		where	nr_seq_material = nr_seq_material_p
			and cd_equipamento = cd_equipamento_w;

		if (qt_registros_w = 1) then
			return substr(cd_material_int, 1, 20);
		end if;
	end if;

	return null;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_cd_material_int ( nr_seq_material_p bigint, nr_seq_exame_p bigint, ds_sigla_p text) FROM PUBLIC;

