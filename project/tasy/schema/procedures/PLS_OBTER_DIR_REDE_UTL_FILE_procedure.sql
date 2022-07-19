-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_obter_dir_rede_utl_file ( cd_evento_p bigint, ie_opcao_p text,   -- Usado para customizações
 ds_retorno_p INOUT text, ds_erro_p INOUT text) AS $body$
DECLARE


arq_texto_w		utl_file.file_type;
ds_local_w		varchar(255);
ds_erro_w		varchar(2000);


BEGIN
ds_erro_w := '';

begin
select	ds_local_rede
into STRICT	ds_local_w
from	evento_tasy_utl_file
where	cd_evento	= cd_evento_p;
exception
when no_data_found then
	ds_erro_w  := wheb_mensagem_pck.get_texto(280512);
when others then
	ds_erro_w  := wheb_mensagem_pck.get_texto(280524);
end;

ds_erro_p	:= ds_erro_w;
ds_retorno_p	:= ds_local_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obter_dir_rede_utl_file ( cd_evento_p bigint, ie_opcao_p text, ds_retorno_p INOUT text, ds_erro_p INOUT text) FROM PUBLIC;

