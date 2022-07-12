-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_hor_pend_prescr_lab (cd_estabelecimento_p bigint, cd_setor_atendimento_p bigint, cd_perfil_p bigint, nr_atendimento_p bigint, qt_hora_incosistencia_p bigint, ie_opcao_p bigint) RETURNS bigint AS $body$
DECLARE

 
qt_hor_pendente_w	bigint := 0;


BEGIN 
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (ie_opcao_p IS NOT NULL AND ie_opcao_p::text <> '') then 
 
	/* vigentes */
 
	if (ie_opcao_p = 1) then 
		select	count(*) 
		into STRICT	qt_hor_pendente_w 
		from	adep_pend_v 
		where	dt_validade_prescr > clock_timestamp() 
		and	dt_horario < clock_timestamp() 
		and	coalesce(ie_laboratorio,'N') = 'S' 
		and	nr_atendimento = nr_atendimento_p;
 
	/* período */
 
	elsif (ie_opcao_p = 2) then 
		select	count(*) 
		into STRICT	qt_hor_pendente_w 
		from	adep_pend_v 
		where	dt_validade_prescr > clock_timestamp() - qt_hora_incosistencia_p / 24 
		and	dt_horario < clock_timestamp() 
		and	coalesce(ie_laboratorio,'N') = 'S' 
		and	nr_atendimento = nr_atendimento_p;
	end if;
 
end if;	
 
return	qt_hor_pendente_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_hor_pend_prescr_lab (cd_estabelecimento_p bigint, cd_setor_atendimento_p bigint, cd_perfil_p bigint, nr_atendimento_p bigint, qt_hora_incosistencia_p bigint, ie_opcao_p bigint) FROM PUBLIC;

