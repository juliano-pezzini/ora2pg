-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_prescr_antibiotico ( nr_atendimento_p bigint, dt_referencia_p timestamp, ie_prescricao_liberada_p text) RETURNS varchar AS $body$
DECLARE


Qt_reg_w		bigint;
Qt_reg_administrado_w	bigint;
ie_retorno_w		varchar(255) := '';


BEGIN

select	count(*)
into STRICT	Qt_reg_w
from	material c,
        prescr_material a,
	prescr_medica b
where	a.nr_prescricao	= b.nr_prescricao
and	a.cd_material	= c.cd_material
and	(c.CD_MEDICAMENTO IS NOT NULL AND c.CD_MEDICAMENTO::text <> '')
and	b.nr_atendimento = nr_atendimento_p
and 	b.dt_prescricao	>= dt_referencia_p
and ((b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '') or ie_prescricao_liberada_p = 'N');

if (Qt_reg_w > 0 ) then

	select	count(*)
	into STRICT	Qt_reg_administrado_w
	from	material c,
		prescr_material a,
		prescr_medica b,
		prescr_mat_hor d
	where	a.nr_prescricao	= b.nr_prescricao
	and	d.nr_prescricao	= b.nr_prescricao
	and	a.cd_material	= c.cd_material
	and	(c.CD_MEDICAMENTO IS NOT NULL AND c.CD_MEDICAMENTO::text <> '')
	and	b.nr_atendimento = nr_atendimento_p
	and 	b.dt_prescricao	>= dt_referencia_p
	and	coalesce(d.dt_suspensao::text, '') = ''
	and	(d.dt_fim_horario IS NOT NULL AND d.dt_fim_horario::text <> '')
	and ((b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '') or ie_prescricao_liberada_p = 'N');

	if (Qt_reg_administrado_w > 0) then
		ie_retorno_w := wheb_mensagem_pck.get_texto(309940); -- Adm
	else
		ie_retorno_w := wheb_mensagem_pck.get_texto(309941); -- Pend
	end if;

end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_prescr_antibiotico ( nr_atendimento_p bigint, dt_referencia_p timestamp, ie_prescricao_liberada_p text) FROM PUBLIC;
