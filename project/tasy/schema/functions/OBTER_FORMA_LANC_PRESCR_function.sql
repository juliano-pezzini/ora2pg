-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_forma_lanc_prescr (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(240);


BEGIN
if (nr_sequencia_p = 95) then
	ds_retorno_w	:= wheb_mensagem_pck.get_texto(802856);
elsif (nr_sequencia_p = 96) then
	ds_retorno_w	:= wheb_mensagem_pck.get_texto(802857);
else
	begin
	select	ds_item
	into STRICT	ds_retorno_w
	from	tasy_padrao_cor
	where	nr_Sequencia	= nr_sequencia_p;
	exception
	when others then
		ds_retorno_w	:= '';
	end;
end if;

return	ds_retorno_W;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_forma_lanc_prescr (nr_sequencia_p bigint) FROM PUBLIC;

