-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_gasto_superior_nao_canc ( nr_atendimento_p bigint, dt_referencia_p timestamp) RETURNS varchar AS $body$
DECLARE


qt_material_w			double precision;
qt_procedimento_w		double precision;
ie_pendente_w			varchar(1)	:= 'N';


BEGIN

select	sum(qt_material)
into STRICT	qt_material_w
from	material_atend_paciente
where	nr_atendimento 	= nr_atendimento_p
and	coalesce(dt_conta,dt_atendimento)	> dt_referencia_p
and	coalesce(cd_motivo_exc_conta::text, '') = ''
and	coalesce(obter_dados_conta_paciente(nr_interno_conta,'DTC'),'N') = 'N';

select	count(*)
into STRICT	qt_procedimento_w
from	procedimento_paciente
where	nr_atendimento 	= nr_atendimento_p
and	dt_procedimento	> dt_referencia_p
and	coalesce(cd_motivo_exc_conta::text, '') = ''
and	coalesce(obter_dados_conta_paciente(nr_interno_conta,'DTC'),'N') = 'N';

if (qt_material_w > 0) or (qt_procedimento_w > 0) then
	ie_pendente_w		:= 'S';
end if;

return ie_pendente_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_gasto_superior_nao_canc ( nr_atendimento_p bigint, dt_referencia_p timestamp) FROM PUBLIC;

