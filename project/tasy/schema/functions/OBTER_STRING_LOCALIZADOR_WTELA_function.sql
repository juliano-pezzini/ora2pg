-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_string_localizador_wtela ( nm_atributo_cd_p text, nm_atributo_ds_p text, nm_tabela_p text, nr_seq_localizador_p bigint, nr_seq_atrib_result_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(2000);
ds_str_1_w	varchar(255);
ds_str_2_w	varchar(255);
ds_str_3_w	varchar(255);
ds_str_4_w	varchar(255);
ds_str_5_w	varchar(255);
ds_str_6_w	varchar(255);
ds_str_7_w	varchar(255);
ds_str_8_w	varchar(255);
ds_str_9_w	varchar(255);
ds_str_10_w	varchar(255);
ds_str_11_w	varchar(255);


BEGIN
if (nm_atributo_cd_p IS NOT NULL AND nm_atributo_cd_p::text <> '') and (nm_atributo_ds_p IS NOT NULL AND nm_atributo_ds_p::text <> '') and (nm_tabela_p IS NOT NULL AND nm_tabela_p::text <> '')then
	ds_str_1_w	:= nm_atributo_cd_p;
	ds_str_2_w	:= nm_atributo_ds_p;
	ds_str_3_w	:= nm_tabela_p;
	if (nr_seq_localizador_p IS NOT NULL AND nr_seq_localizador_p::text <> '') then
		ds_str_5_w	:= 'LOCALIZADOR';
	end if;
	ds_str_6_w	:= nr_seq_localizador_p;
	ds_str_11_w	:= nr_seq_atrib_result_p;

	ds_retorno_w	:= ds_str_1_w||';'||ds_str_2_w||';'||ds_str_3_w||';'||ds_str_4_w||';'||ds_str_5_w||';'||ds_str_6_w||';'||ds_str_7_w||';'||ds_str_8_w||';'||ds_str_9_w||';'||ds_str_10_w||';'||ds_str_11_w||';';
end if;
return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_string_localizador_wtela ( nm_atributo_cd_p text, nm_atributo_ds_p text, nm_tabela_p text, nr_seq_localizador_p bigint, nr_seq_atrib_result_p bigint) FROM PUBLIC;
