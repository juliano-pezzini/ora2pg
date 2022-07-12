-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_opme_concat (nr_sequencia_p bigint) RETURNS varchar AS $body$
 /*Jefferson luiz 08/09/2011*/
DECLARE


ds_retorno_w		varchar(4000);
ds_opme_w			varchar(255);
ds_qt_opme_w 		varchar(20);

C01 CURSOR FOR
	SELECT		a.qt_material,
			substr(OBTER_DESC_MATERIAL(a.cd_material),1,254)
	from 		agenda_pac_opme a
	where 		a.nr_seq_agenda			= nr_sequencia_p;


BEGIN

ds_retorno_w		:= '';
ds_opme_w		:= '';
ds_qt_opme_w		:= '';

open C01;
loop
fetch C01 into
		ds_qt_opme_w,
		ds_opme_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	ds_retorno_w := ds_retorno_w || ds_qt_opme_w || '  '|| ds_opme_w || '  -  ';
	end;
end loop;
close C01;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_opme_concat (nr_sequencia_p bigint) FROM PUBLIC;

