-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_obter_dose_medic_atend ( nr_atendimento_p atendimento_paciente.nr_atendimento%type, cd_material_p material.cd_material%type, cd_unidade_medida_p unidade_medida.cd_unidade_medida%type) RETURNS bigint AS $body$
DECLARE


qt_dose_retorno_w		prescr_material.qt_dose%type := 0;


BEGIN
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then
	select	coalesce(sum(obter_dose_convertida(b.cd_material, c.qt_dose, c.cd_unidade_medida, cd_unidade_medida_p)),0)
	into STRICT	qt_dose_retorno_w
	from	prescr_mat_hor c,
			prescr_material b,
			prescr_medica a
	where	a.nr_prescricao		= b.nr_prescricao
	and		a.nr_atendimento	= nr_atendimento_p
	and		b.cd_material		= cd_material_p
	and		b.nr_prescricao		= c.nr_prescricao
	and		b.nr_sequencia		= c.nr_seq_material
	and		coalesce(a.dt_suspensao::text, '') = ''
	and		coalesce(b.ie_suspenso,'N')	= 'N'
	and		coalesce(c.dt_suspensao::text, '') = ''
	and		Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S';
end if;

return qt_dose_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_obter_dose_medic_atend ( nr_atendimento_p atendimento_paciente.nr_atendimento%type, cd_material_p material.cd_material%type, cd_unidade_medida_p unidade_medida.cd_unidade_medida%type) FROM PUBLIC;

