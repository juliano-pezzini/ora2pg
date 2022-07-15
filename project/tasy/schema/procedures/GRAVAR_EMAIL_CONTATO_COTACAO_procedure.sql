-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_email_contato_cotacao ( nr_cot_compra_p bigint) AS $body$
DECLARE



cd_cgc_fornecedor_w		varchar(14);
cd_material_w			bigint;
ds_email_w			varchar(255);
ds_contato_w			varchar(255);
ds_lista_email_w			varchar(4000);
ds_lista_contato_w			varchar(4000);
ie_existe_na_lista_w		varchar(1);
qt_tamanho_string_w		bigint;
qt_tamanho_lista_w			bigint;
qt_tamanho_email_w		bigint;

c01 CURSOR FOR
SELECT	a.cd_cgc_fornecedor,
	b.cd_material
from	cot_compra_forn a,
	cot_compra_forn_item b
where	a.nr_sequencia = b.nr_seq_cot_forn
and	a.nr_sequencia = nr_cot_compra_p
and	(a.cd_cgc_fornecedor IS NOT NULL AND a.cd_cgc_fornecedor::text <> '');


BEGIN

qt_tamanho_string_w	:= 0;

open C01;
loop
fetch C01 into
	cd_cgc_fornecedor_w,
	cd_material_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	select	obter_dados_regra_contato_pj(cd_cgc_fornecedor_w, cd_material_w, 'E'),
		obter_dados_regra_contato_pj(cd_cgc_fornecedor_w, cd_material_w, 'C')
	into STRICT	ds_email_w,
		ds_contato_w
	;

	if (ds_email_w IS NOT NULL AND ds_email_w::text <> '') then

		if (substr(ds_email_w,length(ds_email_w),1) = '#') then
			ds_email_w := substr(ds_email_w,1,length(ds_email_w)-1);
		end if;

		select	Obter_Se_Contido_char_separ(ds_email_w, ds_lista_email_w, '#')
		into STRICT	ie_existe_na_lista_w
		;

		select	coalesce(length(ds_lista_email_w),0),
			coalesce(length(ds_email_w),0)
		into STRICT	qt_tamanho_lista_w,
			qt_tamanho_email_w
		;


		qt_tamanho_string_w	:= qt_tamanho_lista_w + qt_tamanho_email_w;

		if (ie_existe_na_lista_w = 'N') and (qt_tamanho_string_w <= 3990) then
			ds_lista_email_w := ds_lista_email_w || ds_email_w || '#';
		end if;
	end if;

	if (ds_contato_w IS NOT NULL AND ds_contato_w::text <> '') then

		if (substr(ds_contato_w,length(ds_contato_w),1) = ',') then
			ds_contato_w := substr(ds_contato_w,1,length(ds_contato_w)-1);
		end if;

		select	Obter_Se_Contido_char_separ(ds_contato_w, ds_lista_contato_w, ',')
		into STRICT	ie_existe_na_lista_w
		;

		select	coalesce(length(ds_lista_contato_w),0),
			coalesce(length(ds_contato_w),0)
		into STRICT	qt_tamanho_lista_w,
			qt_tamanho_email_w
		;


		qt_tamanho_string_w	:= qt_tamanho_lista_w + qt_tamanho_email_w;

		if (ie_existe_na_lista_w = 'N') and (qt_tamanho_string_w <= 3990) then
			ds_lista_contato_w := ds_lista_contato_w || ds_contato_w || ',';
		end if;
	end if;

	end;
end loop;
close C01;

if (substr(ds_lista_email_w,length(ds_lista_email_w),1) = '#') then
	ds_lista_email_w := substr(ds_lista_email_w,1,length(ds_lista_email_w)-1);
end if;

if (substr(ds_lista_contato_w,length(ds_lista_contato_w),1) = ',') then
	ds_lista_contato_w := substr(ds_lista_contato_w,1,length(ds_lista_contato_w)-1);
end if;

ds_lista_email_w	:= replace(ds_lista_email_w,'#',';');

update	cot_compra_forn
set	ds_email_regra_pj	= ds_lista_email_w,
	ds_contato_regra_pj	= ds_lista_contato_w
where	nr_sequencia		= nr_cot_compra_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_email_contato_cotacao ( nr_cot_compra_p bigint) FROM PUBLIC;

