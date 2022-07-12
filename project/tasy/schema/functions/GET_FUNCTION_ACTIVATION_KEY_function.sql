-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_function_activation_key ( cd_cgc_cliente_p text, cd_funcao_p bigint, qt_valid_p bigint) RETURNS varchar AS $body$
DECLARE


ds_key_w varchar(255);
ds_return_w varchar(255);


BEGIN
if (coalesce(cd_funcao_p,0) <> 0) then

 select substr(to_char(clock_timestamp()+qt_valid_p,'ddmmyyyy') || lpad(cd_funcao_p,5,' ') || lpad(cd_cgc_cliente_p,14,' '),1,255)
 into STRICT ds_key_w
;

 ds_key_w := ds_key_w||GET_CHECKSUM_ACTIVATION(ds_key_w);

 ds_return_w := wheb_seguranca.encrypt(ds_key_w);

end if;

return ds_return_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_function_activation_key ( cd_cgc_cliente_p text, cd_funcao_p bigint, qt_valid_p bigint) FROM PUBLIC;

