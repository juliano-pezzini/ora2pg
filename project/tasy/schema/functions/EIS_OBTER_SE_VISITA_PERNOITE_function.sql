-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION eis_obter_se_visita_pernoite ( nr_sequencia_p bigint ) RETURNS varchar AS $body$
DECLARE


dt_entrada_w	timestamp;
dt_saida_w	timestamp;


BEGIN

select	trunc(dt_entrada,'dd'),
	trunc(dt_saida,'dd')
into STRICT	dt_entrada_w,
	dt_saida_w
from	atendimento_visita
where	nr_sequencia	=	nr_sequencia_p;

if (dt_entrada_w = dt_saida_w) then
	return wheb_mensagem_pck.get_texto(795660);
elsif (coalesce(dt_saida_w::text, '') = '') then
	return wheb_mensagem_pck.get_texto(795671);
else
	return wheb_mensagem_pck.get_texto(795673);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION eis_obter_se_visita_pernoite ( nr_sequencia_p bigint ) FROM PUBLIC;

