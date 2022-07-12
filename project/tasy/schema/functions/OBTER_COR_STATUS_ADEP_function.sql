-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_cor_status_adep (ie_status_p text, cd_perfil_p bigint, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


nr_seq_cor_w		bigint 		:= 0;
ds_cor_w			varchar(50)	:= 'clWhite';
ds_cor_retorno_w	varchar(50);


BEGIN

if (ie_status_p = 'N')	then
	nr_seq_cor_w := 359;
elsif	((ie_status_p = 'A') or (ie_status_p = 'T'))	then
	nr_seq_cor_w := 363;
elsif (ie_status_p = 'S')	then
	nr_seq_cor_w := 361;
elsif (ie_status_p = 'E')	then
	nr_seq_cor_w := 661;
elsif (ie_status_p = 'D')	then
	nr_seq_cor_w := 1090;
elsif (ie_status_p = 'H')	then
	nr_seq_cor_w := 1198;
elsif (ie_status_p = 'R')	then
	nr_seq_cor_w := 1212;
elsif (ie_status_p = 'P')	then
	nr_seq_cor_w := 1091;
elsif (ie_status_p = 'I')	then
	nr_seq_cor_w := 1622;
elsif (ie_status_p = 'L')	then
	nr_seq_cor_w := 1499;
elsif (ie_status_p = 'T')	then
	nr_seq_cor_w := 363;
elsif (ie_status_p = 'Y')	then
	nr_seq_cor_w := 1884;
elsif (ie_status_p = 'Z')	then
	nr_seq_cor_w := 1606;
elsif	((ie_status_p = 'INT') or (ie_status_p = 'II'))	then
	nr_seq_cor_w := 363;
end if;

if (nr_seq_cor_w > 0) then
	ds_cor_retorno_w :=  obter_tasy_obter_cor(nr_seq_cor_w, cd_perfil_p, cd_estabelecimento_p, 'F');
end if;

if (ds_cor_retorno_w IS NOT NULL AND ds_cor_retorno_w::text <> '') then
	return ds_cor_retorno_w;
end if;

return	ds_cor_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_cor_status_adep (ie_status_p text, cd_perfil_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;
