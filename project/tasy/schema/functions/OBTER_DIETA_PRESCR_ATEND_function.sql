-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dieta_prescr_atend ( nr_atendimento_p bigint, qt_hora_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE



nr_prescricao_w		bigint;
cd_dieta_W		bigint := 0;
nm_dieta_w		varchar(80) := '';
ds_observacao_w		varchar(4000);


BEGIN

select	coalesce(max(a.nr_prescricao),0)
into STRICT	nr_prescricao_w
from 	prescr_dieta b, prescr_medica a
where 	a.nr_prescricao 	= b.nr_prescricao
and 	a.nr_atendimento	= nr_atendimento_p
and 	a.dt_prescricao	> clock_timestamp() - (qt_hora_p / 24);

if (nr_prescricao_w > 0) then
	select	coalesce(max(cd_dieta),0),
		max(ds_observacao)
	into STRICT	cd_dieta_W,
		ds_observacao_w
	from	prescr_dieta
	where	nr_prescricao 	= nr_prescricao_w
	and 	ie_suspenso	= 'N';

	if (ie_opcao_p = 'D') then
		select	substr(obter_nome_dieta(cd_dieta_w),1,225)
		into STRICT	nm_dieta_w
		;
	end if;
end if;

if (ie_opcao_p = 'D') then
	return nm_dieta_w;
elsif (ie_opcao_p	= 'OBS') then
	return ds_observacao_w;
else
	return cd_dieta_W;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dieta_prescr_atend ( nr_atendimento_p bigint, qt_hora_p bigint, ie_opcao_p text) FROM PUBLIC;
