-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION fis_obter_regra_envio_email ( cd_material_p text, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w		varchar(10);			
 

BEGIN 
 
select max(nr_sequencia) 
into STRICT	ds_retorno_w 
from	REGRA_ENVIO_EMAIL_COMPRA 
where	ie_situacao = 'A' 
and	cd_estabelecimento = cd_estabelecimento_p 
and	ie_tipo_mensagem = 35 
and	obter_se_envia_email_regra(cd_material_p, 'CM', 35, cd_estabelecimento_p) = 'S';
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION fis_obter_regra_envio_email ( cd_material_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
