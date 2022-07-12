-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_extenso_idioma ( nr_valor_p bigint) RETURNS varchar AS $body$
DECLARE


ds_valor_w		varchar(2000) := '';


BEGIN

if (philips_param_pck.get_nr_seq_idioma = 2) then -- Espanhol  - México(MX)
	ds_valor_w := obter_extenso_mx(nr_valor_p);
elsif (philips_param_pck.get_nr_seq_idioma = 13) then -- Espanhol  - República Dominicana	
	ds_valor_w := obter_extenso_do(nr_valor_p);
else
	ds_valor_w := obter_extenso(nr_valor_p);
end if;

return	ds_valor_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_extenso_idioma ( nr_valor_p bigint) FROM PUBLIC;

