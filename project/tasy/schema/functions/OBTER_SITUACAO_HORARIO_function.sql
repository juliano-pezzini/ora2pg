-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_situacao_horario ( ie_tipo_param_p text, nr_prescricao_p bigint, nr_seq_material_p bigint ) RETURNS varchar AS $body$
DECLARE


ie_sit_horario_w	varchar(1) := 'N';
ie_param_w		timestamp;


BEGIN

if (ie_tipo_param_p IS NOT NULL AND ie_tipo_param_p::text <> '') then
	begin
	if (ie_tipo_param_p = 'S') then
		begin

		select	max(dt_suspensao)
		into STRICT	ie_param_w
		from	prescr_mat_hor
		where	nr_prescricao = nr_prescricao_p
		and	nr_seq_material = nr_seq_material_p
		and	Obter_se_horario_liberado(dt_lib_horario, dt_horario) = 'S';

		end;
	elsif (ie_tipo_param_p = 'A') then
		begin

		select	max(dt_fim_horario)
		into STRICT	ie_param_w
		from	prescr_mat_hor
		where	nr_prescricao = nr_prescricao_p
		and	nr_seq_material = nr_seq_material_p
		and	Obter_se_horario_liberado(dt_lib_horario, dt_horario) = 'S';

		end;
	else
		ie_sit_horario_w := 'N';
	end if;
	end;
end if;

if (ie_param_w <> '') then
	begin
	ie_sit_horario_w	:= 'S';
	end;
end if;

return	ie_sit_horario_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_situacao_horario ( ie_tipo_param_p text, nr_prescricao_p bigint, nr_seq_material_p bigint ) FROM PUBLIC;

