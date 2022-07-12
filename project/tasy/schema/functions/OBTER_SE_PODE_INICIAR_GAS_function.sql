-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_pode_iniciar_gas ( nr_sequencia_p prescr_gasoterapia.nr_sequencia%type, nr_seq_gas_cpoe_p cpoe_gasoterapia.nr_sequencia%type default null, ie_gas_separada_p text default 'S') RETURNS varchar AS $body$
DECLARE

ie_gas_acm_sn_w		varchar(1);
ie_aprazou_hor_w	varchar(1);
						

BEGIN

ie_aprazou_hor_w	:= 'S';

if (ie_gas_separada_p = 'N' and (nr_seq_gas_cpoe_p IS NOT NULL AND nr_seq_gas_cpoe_p::text <> '')) then
	select	coalesce(max('S'), 'N')
	into STRICT	ie_gas_acm_sn_w
	from	cpoe_gasoterapia	a
	where	a.nr_sequencia	= nr_seq_gas_cpoe_p
	and (a.ie_acm = 'S' or a.ie_se_necessario = 'S');
	
	if (ie_gas_acm_sn_w = 'S') then
		select	coalesce(max('S'),'N')
		into STRICT	ie_aprazou_hor_w
		from	prescr_gasoterapia_hor	a
		where	a.nr_seq_gasoterapia in (	SELECT	x.nr_sequencia
											from	prescr_gasoterapia	x
											where	x.nr_seq_gas_cpoe	= nr_seq_gas_cpoe_p
											and		obter_se_prescr_vigente(x.nr_prescricao) = 'S')
		and		a.ie_horario_especial <> 'S';
	end if;
else
	select	coalesce(max('S'), 'N')
	into STRICT	ie_gas_acm_sn_w
	from	prescr_gasoterapia a,
			prescr_medica b
	where	a.nr_prescricao = b.nr_prescricao
	and		a.nr_sequencia = nr_sequencia_p
	and		ie_inicio in ('ACM','D')
	and		b.cd_funcao_origem = 2314;
	
	if (ie_gas_acm_sn_w = 'S') then
		select	coalesce(max('S'),'N')
		into STRICT	ie_aprazou_hor_w
		from	prescr_gasoterapia_hor
		where	nr_seq_gasoterapia = nr_sequencia_p
		and		ie_horario_especial <> 'S';
	end if;
end if;

return ie_aprazou_hor_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_pode_iniciar_gas ( nr_sequencia_p prescr_gasoterapia.nr_sequencia%type, nr_seq_gas_cpoe_p cpoe_gasoterapia.nr_sequencia%type default null, ie_gas_separada_p text default 'S') FROM PUBLIC;

