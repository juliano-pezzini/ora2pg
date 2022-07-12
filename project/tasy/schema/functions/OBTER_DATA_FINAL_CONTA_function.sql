-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_data_final_conta (dt_periodo_inicial_p timestamp, dt_alta_p timestamp, cd_convenio_p bigint, cd_estabelecimento_p bigint) RETURNS timestamp AS $body$
DECLARE


dt_periodo_final_conta_w		timestamp;
qt_dia_fim_conta_w			bigint;
IE_CONTA_FIM_MES_w			varchar(01);
ie_conta_fim_dia_w			varchar(01);
hr_conta_fim_dia_w			timestamp;


BEGIN

select	coalesce(max(Obter_Valor_Conv_Estab(cd_convenio, cd_estabelecimento_p, 'QT_DIA_FIM_CONTA')), 0),
		coalesce(max(Obter_Valor_Conv_Estab(cd_convenio, cd_estabelecimento_p, 'IE_CONTA_FIM_MES')), 'N'),
		coalesce(max(Obter_Valor_Conv_Estab(cd_convenio, cd_estabelecimento_p, 'IE_CONTA_FIM_DIA')), 'N')
into STRICT	qt_dia_fim_conta_w,
		IE_CONTA_FIM_MES_w,
		ie_conta_fim_dia_w
from	convenio
where	cd_convenio			= cd_convenio_p;

hr_conta_fim_dia_w := Obter_hr_conta_fim_dia(cd_convenio_p, cd_estabelecimento_p);

if (qt_dia_fim_conta_w	= 0) and (IE_CONTA_FIM_MES_w 	= 'N') then
	begin

	if (dt_alta_p IS NOT NULL AND dt_alta_p::text <> '') then
		dt_periodo_final_conta_w	:= dt_alta_p;
	else
		dt_periodo_final_conta_w	:= dt_periodo_inicial_p + 366;
	end if;

	end;
elsif (IE_CONTA_FIM_MES_w 	= 'S') then
	begin

	dt_periodo_final_conta_w	:= trunc(ESTABLISHMENT_TIMEZONE_UTILS.endOfMonth(dt_periodo_inicial_p));
	
	if (ie_conta_fim_dia_w = 'S') then
		dt_periodo_final_conta_w:= fim_dia(dt_periodo_final_conta_w);
	end if;

	end;
else
	begin

	dt_periodo_final_conta_w	:= dt_periodo_inicial_p + qt_dia_fim_conta_w;
	
	if (hr_conta_fim_dia_w IS NOT NULL AND hr_conta_fim_dia_w::text <> '') then
		dt_periodo_final_conta_w := ESTABLISHMENT_TIMEZONE_UTILS.dateAtTime(dt_periodo_final_conta_w , coalesce(hr_conta_fim_dia_w,to_date('00:00:01','hh24:mi:ss')));
	end if;
		
	if (ie_conta_fim_dia_w = 'S') then
		dt_periodo_final_conta_w:= fim_dia(dt_periodo_final_conta_w);
	end if;

	end;
end if;


return	dt_periodo_final_conta_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_data_final_conta (dt_periodo_inicial_p timestamp, dt_alta_p timestamp, cd_convenio_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;

