-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_if_encounter_medic ( nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE

qt_retorno_mat_w	varchar(20000);
qt_retorno_sol_w	varchar(20000);
ds_retorno_w		varchar(20000);


BEGIN

	select  coalesce(count(a.cd_material),0)
	into STRICT    qt_retorno_mat_w
	from	prescr_material a,
		  prescr_medica b
	where	a.nr_prescricao		= b.nr_prescricao
	and	    b.nr_Atendimento	= nr_atendimento_p
	and	    (coalesce(b.dt_liberacao, b.dt_liberacao_medico) IS NOT NULL AND (coalesce(b.dt_liberacao, b.dt_liberacao_medico))::text <> '')
	and	    a.ie_suspenso		= 'N'
	and	    a.ie_agrupador		= 1
	and     coalesce(a.dt_suspensao::text, '') = ''
	and	    coalesce(b.ie_hemodialise, 'N') <> 'R'
	--and   sysdate between b.dt_inicio_prescr and b.dt_validade_prescr --considerar somente os vigentes?
	and     coalesce(b.nr_seq_atend::text, '') = ''
	and     not exists (SELECT 1
			  from cpoe_material m,
			  cpoe_hemoterapia h
			  where m.nr_sequencia = a.nr_seq_mat_cpoe
			  and h.nr_sequencia = m.nr_seq_hemoterapia);

	select	coalesce(count(a.ds_solucao),0)
	into STRICT	qt_retorno_sol_w
	from	prescr_solucao a,
		  prescr_medica b
	where	a.nr_prescricao		= b.nr_prescricao
	and		b.nr_Atendimento	= nr_atendimento_p
	and		(coalesce(b.dt_liberacao, b.dt_liberacao_medico) IS NOT NULL AND (coalesce(b.dt_liberacao, b.dt_liberacao_medico))::text <> '')
	and		a.ie_suspenso		= 'N'
	and 	coalesce(a.dt_suspensao::text, '') = ''
	and		coalesce(b.ie_hemodialise, 'N') <> 'R'
	and		coalesce(a.nr_seq_dialise::text, '') = ''
	--and 	sysdate between b.dt_inicio_prescr and b.dt_validade_prescr --considerar somente os vigentes?
	and 	coalesce(b.nr_seq_atend::text, '') = '';

	if (qt_retorno_mat_w > 0 or qt_retorno_sol_w > 0) then
	ds_retorno_w	:= 'S';
	end if;

return	coalesce(ds_retorno_w, 'N');

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_if_encounter_medic ( nr_atendimento_p bigint) FROM PUBLIC;

