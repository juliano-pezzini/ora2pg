-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_intervalo_grafico (nr_sequencia_p bigint, ie_opcao_p text) RETURNS timestamp AS $body$
DECLARE


/*
	I - Data inicial
	F - Data final
*/
dt_inicio_adm_w	timestamp;
dt_final_adm_w	timestamp;


BEGIN

select (dt_inicio_adm	+ 86399/86400) - 1,
	(dt_final_adm	+ 86401/86400) - 1
into STRICT	dt_inicio_adm_w,
	dt_final_adm_w
from	cirurgia_agente_anest_ocor
where	nr_sequencia 		= nr_sequencia_p
and	coalesce(ie_situacao,'A') 	= 'A';

if (ie_opcao_p = 'I') then
	return	dt_inicio_adm_w;
else
	return	dt_final_adm_w;
end	if;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_intervalo_grafico (nr_sequencia_p bigint, ie_opcao_p text) FROM PUBLIC;

