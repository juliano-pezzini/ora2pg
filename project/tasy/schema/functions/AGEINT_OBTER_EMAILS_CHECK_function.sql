-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ageint_obter_emails_check (nr_seq_ageint_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(32000);
ds_email_destino_w	varchar(255);

C01 CURSOR FOR
	SELECT	ds_email_destino
	from	ageint_check_list_pac_item_v
	where	nr_seq_ageint = nr_seq_ageint_p
	and	ordem = 1
	and	(ds_email_destino IS NOT NULL AND ds_email_destino::text <> '');


BEGIN

open C01;
loop
fetch C01 into
	ds_email_destino_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	ds_retorno_w	:= ds_email_destino_w || ';' || ds_retorno_w;

	end;
end loop;
close C01;

ds_retorno_w	:= substr(ds_retorno_w,1,length(ds_retorno_w)-1);

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ageint_obter_emails_check (nr_seq_ageint_p bigint) FROM PUBLIC;
