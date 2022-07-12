-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_nota_enviada (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w 		varchar(1);
ie_status_envio_w 	nota_fiscal.ie_status_envio%type;
nr_nfe_imp_w 		nota_fiscal.nr_nfe_imp%type;


BEGIN

ds_retorno_w := 'S';

if (nr_sequencia_p > 0) then

	select  coalesce(max(ie_status_envio),'N'),
		coalesce(max(nr_nfe_imp),0)
	into STRICT    ie_status_envio_w,
	        nr_nfe_imp_w
	from    nota_fiscal
	where   nr_sequencia = nr_sequencia_p;

	if 	(ie_status_envio_w = 'E' AND nr_nfe_imp_w > 0) then
		ds_retorno_w := 'N';

	elsif	((ie_status_envio_w = 'C') or (ie_status_envio_w = 'T'))  then
		ds_retorno_w := 'N';
	end if;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_nota_enviada (nr_sequencia_p bigint) FROM PUBLIC;
