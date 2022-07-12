-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_richtext_base ( ds_conteudo_p text, ie_alinhamento_p text, ds_fonte_p text, qt_tamanho_p text) RETURNS varchar AS $body$
DECLARE


ie_alinhamento_w	varchar(1);
ds_conteudo_w		varchar(3500);
ds_retorno_w		varchar(4000);
qt_tamanho_w		smallint := qt_tamanho_p * 2;



BEGIN

if (ie_alinhamento_p = 'E') then
	ie_alinhamento_w := 'l';
elsif (ie_alinhamento_p = 'D') then
	ie_alinhamento_w := 'r';
elsif (ie_alinhamento_p = 'C') then
	ie_alinhamento_w := 'c';
else	ie_alinhamento_w := 'j';
end if;



ds_conteudo_w := replace(ds_conteudo_p,chr(10),chr(13) || chr(10) || '\par ');

ds_retorno_w := '{\rtf1\ansi\ansicpg1252\deff0{\fonttbl{\f0\fnil\fcharset0 ' || ds_fonte_p || ';}}' 	|| chr(13) || chr(10) ||
		'{\colortbl ;\red0\green0\blue;}' 							|| chr(13) || chr(10) ||
			'\viewkind4\uc1\pard\q' || ie_alinhamento_w || '\cf1\lang1046\f0\fs' || qt_tamanho_w || ' ' ||
			ds_conteudo_w || ' \par }' || chr(13) || chr(10);

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_richtext_base ( ds_conteudo_p text, ie_alinhamento_p text, ds_fonte_p text, qt_tamanho_p text) FROM PUBLIC;

