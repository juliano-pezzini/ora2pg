-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ultima_etapa_dt ( nr_interno_conta_p bigint, ie_opcao_p text) RETURNS timestamp AS $body$
DECLARE


dt_etapa_w		timestamp;
dt_etapa_final_w 	timestamp;
dt_retorno_w		timestamp;


BEGIN

select	max(dt_fim_etapa),
	max(dt_etapa)
into STRICT	dt_etapa_final_w,
	dt_etapa_w
from	fatur_etapa		b,
  	conta_paciente_etapa	a
where	a.nr_seq_etapa		= b.nr_sequencia
and	a.nr_interno_conta	= nr_interno_conta_p
and	coalesce(b.ie_situacao,'A')	= 'A'
and	a.dt_etapa		=	(SELECT	max(x.dt_etapa)
   					from	conta_paciente_etapa x
					where   x.nr_interno_conta = nr_interno_conta_p);
if (ie_opcao_p	= 'D') then
	dt_retorno_w	:=	dt_etapa_w;
elsif (ie_opcao_p	= 'DTF') then
	dt_retorno_w	:=	dt_etapa_final_w;
elsif (ie_opcao_p	= 'DHR') then
	dt_retorno_w	:=	dt_etapa_w;
end if;

return dt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ultima_etapa_dt ( nr_interno_conta_p bigint, ie_opcao_p text) FROM PUBLIC;
