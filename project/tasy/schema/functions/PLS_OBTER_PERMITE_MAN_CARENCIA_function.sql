-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_permite_man_carencia ( nr_seq_proposta_p bigint, ds_parametro_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(10) := 'S';
ds_parametro_w		varchar(255);
ie_status_proposta_w	varchar(10);
nr_pos_virgula_w	bigint;
ds_item_atual_w		varchar(255);
ds_w			varchar(255);


BEGIN

select	max(ie_status)
into STRICT	ie_status_proposta_w
from	pls_proposta_adesao
where	nr_sequencia	= nr_seq_proposta_p;

ds_parametro_w	:= ds_parametro_p;

while(ds_parametro_w IS NOT NULL AND ds_parametro_w::text <> '') loop
	begin

	nr_pos_virgula_w	:= position(',' in ds_parametro_w);

	if (nr_pos_virgula_w	> 0) then
		ds_item_atual_w		:= SUBSTR(ds_parametro_w,1,nr_pos_virgula_w-1);

		if (ds_item_atual_w IS NOT NULL AND ds_item_atual_w::text <> '') then
			if (ds_item_atual_w = ie_status_proposta_w) then
				ds_retorno_w	:= 'S';
				ds_parametro_w	:= null;
			else
				ds_parametro_w	:= substr(ds_parametro_w,nr_pos_virgula_w+1,length(ds_parametro_w));
			end if;
		else
			ds_parametro_w	:= null;
		end if;
	else
		if (ds_parametro_w = ie_status_proposta_w) then
			ds_retorno_w	:= 'S';
		end if;
		ds_parametro_w	:= null;
	end if;
	end;
end loop;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_permite_man_carencia ( nr_seq_proposta_p bigint, ds_parametro_p text) FROM PUBLIC;
