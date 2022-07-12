-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_excluir_etapa_conta ( dt_etapa_p timestamp, nr_tempo_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w	varchar(1) := 'S';


BEGIN

select	coalesce(max('S'),'N')
into STRICT	ie_retorno_w

where (dt_etapa_p + nr_tempo_p/60/24) <= to_date(to_char(clock_timestamp(),'dd/mm/yyyy hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss');

return	ie_retorno_w;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_excluir_etapa_conta ( dt_etapa_p timestamp, nr_tempo_p bigint) FROM PUBLIC;
