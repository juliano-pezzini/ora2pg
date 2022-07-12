-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_gera_juro_mult ( cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE

 
ie_gerar_juro_mult_tit_w	varchar(1);
			

BEGIN 
 
select	coalesce(ie_gerar_juro_mult_tit_repasse,'N') 
into STRICT	ie_gerar_juro_mult_tit_w 
from	pls_parametros 
where	cd_estabelecimento = cd_estabelecimento_p;
 
return	ie_gerar_juro_mult_tit_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_gera_juro_mult ( cd_estabelecimento_p bigint) FROM PUBLIC;
