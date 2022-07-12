-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_valida_data_xml_demo_pag ( dt_pagamento_p text, dt_mes_competencia_p text, dt_vencimento_p timestamp, dt_competencia_p timestamp) RETURNS varchar AS $body$
DECLARE

ds_retorno_w		varchar(1) := 'N';


BEGIN

if (coalesce(dt_pagamento_p,'0') <> '0') then
	if (trunc(dt_vencimento_p,'month') = trunc(to_date(dt_pagamento_p),'month')) then
		ds_retorno_w := 'S';
	end if;
elsif (coalesce(dt_mes_competencia_p,'0') <> '0') then
	if (to_char(trunc(dt_competencia_p,'month'),'dd/mm/yyyy') = to_char(to_date((dt_mes_competencia_p || '01'),'yyyy/mm/dd'),'dd/mm/yyyy')) then
		ds_retorno_w := 'S';
	end if;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_valida_data_xml_demo_pag ( dt_pagamento_p text, dt_mes_competencia_p text, dt_vencimento_p timestamp, dt_competencia_p timestamp) FROM PUBLIC;

