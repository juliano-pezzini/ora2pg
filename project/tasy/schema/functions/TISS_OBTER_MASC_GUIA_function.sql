-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION tiss_obter_masc_guia (nr_doc_convenio_p text, ds_formato_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(50);
nr_doc_convenio_w	varchar(50);
nr_doc_conv_w	varchar(50);
qt_digitos_masc_w	bigint;
y			bigint;
ds_formato_w		varchar(50);
BEGIN

if (coalesce(ds_formato_p, 'X')			<> 'X') and (coalesce(nr_doc_convenio_p, 'X')	<> 'X') then

	ds_formato_w			:= '';
	FOR 	i IN REVERSE length(ds_formato_p)..1 LOOP
		ds_formato_w		:= ds_formato_w || substr(ds_formato_p, i, 1);
	end loop;

	nr_doc_convenio_w		:= '';
	FOR 	i IN REVERSE length(nr_doc_convenio_p)..1 LOOP
		nr_doc_convenio_w	:= nr_doc_convenio_w || substr(nr_doc_convenio_p, i, 1);
	end loop;

	qt_digitos_masc_w	:= length(ds_formato_p);
	y	:= 1;

	FOR	x in 1..qt_digitos_masc_w loop
		if (substr(ds_formato_w, x, 1) = '0') then
			nr_doc_conv_w	:= nr_doc_conv_w || substr(nr_doc_convenio_w, y, 1);
			y	:= y + 1;
		elsif (substr(ds_formato_w, x, 1) = 'X') then
			y	:= y + 1;
		else
			nr_doc_conv_w	:= nr_doc_conv_w || substr(ds_formato_w, x, 1);
		end if;
	end loop;

	FOR 	i IN REVERSE length(nr_doc_conv_w)..1 LOOP
		ds_retorno_w	:= ds_retorno_w || substr(nr_doc_conv_w, i, 1);
	end loop;

--	ds_retorno_w		:= nr_doc_conv_w;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION tiss_obter_masc_guia (nr_doc_convenio_p text, ds_formato_p text) FROM PUBLIC;

