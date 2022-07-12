-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_data_concession_card ( cd_pessoa_fisica_p text, ie_opcao_p text, ie_card_type_p text) RETURNS varchar AS $body$
DECLARE

			
ds_retorno_w		varchar(4000);	
nr_sequencia_w		bigint;


			

BEGIN


	
select	max(nr_sequencia)
into STRICT	nr_sequencia_w
from	person_concession
where	cd_pessoa_fisica = 	cd_pessoa_fisica_p
and	(((ie_card_type_p = 'M') and (cd_con_card_type in (7, 13, 1, 8))) or
	((ie_card_type_p = 'S') and (cd_con_card_type in (9, 10))));

if (nr_sequencia_w IS NOT NULL AND nr_sequencia_w::text <> '') then
	if (ie_opcao_p	= 1) then
		
		select	max(get_name_concession_card(h.cd_con_card_type)||' '||h.nr_con_card)
		into STRICT	ds_retorno_w
		from	person_concession h
		where	nr_sequencia	= nr_sequencia_w;
	else

		select	max(h.nr_con_card)
		into STRICT	ds_retorno_w
		from	person_concession h
		where	nr_sequencia	= nr_sequencia_w;
	end if;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_data_concession_card ( cd_pessoa_fisica_p text, ie_opcao_p text, ie_card_type_p text) FROM PUBLIC;

