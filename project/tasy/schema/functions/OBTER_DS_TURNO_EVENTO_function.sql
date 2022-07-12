-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ds_turno_evento (nr_seq_turno_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*
D	Descrição
*/
ds_turno_w	regra_turno_evento.cd_turno%type;
ds_retorno_w	varchar(255);


BEGIN

if (ie_opcao_p	= 'D') then
	select	max(a.cd_turno)
	into STRICT	ds_turno_w
	from	regra_turno_evento a
	where	a.nr_sequencia	= nr_seq_turno_p;

	ds_retorno_w	:= ds_turno_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ds_turno_evento (nr_seq_turno_p bigint, ie_opcao_p text) FROM PUBLIC;

