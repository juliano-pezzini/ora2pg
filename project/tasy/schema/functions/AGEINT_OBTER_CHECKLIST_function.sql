-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ageint_obter_checklist (nr_seq_ageint_p bigint, ds_separador_p text) RETURNS varchar AS $body$
DECLARE


ds_item_checklist_w		varchar(255);
ds_item_checklist_ww		varchar(32000);
ds_retorno_w			varchar(32000);


C01 CURSOR FOR
	SELECT	substr(ds_item_padrao,1,255)
	from 	ageint_check_list_resumo_v
	where 	nr_seq_ageint          = nr_seq_ageint_p
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	order by  coalesce(nr_seq_grupo,0), coalesce(nr_seq_item_checklist,0);


BEGIN

open C01;
loop
fetch C01 into
	ds_item_checklist_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	ds_item_checklist_ww	:= ds_item_checklist_ww || ds_separador_p || ds_item_checklist_w;
	end;
end loop;
close C01;

ds_retorno_w	:= ds_item_checklist_ww;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ageint_obter_checklist (nr_seq_ageint_p bigint, ds_separador_p text) FROM PUBLIC;
