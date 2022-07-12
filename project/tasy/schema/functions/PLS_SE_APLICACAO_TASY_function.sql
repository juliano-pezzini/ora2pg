-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_se_aplicacao_tasy () RETURNS varchar AS $body$
DECLARE

 
ie_retorno_w 	varchar(1);

BEGIN
ie_retorno_w := 'N';
 
/*SE não houver usuário informado, não há necessidade*/
 
if (wheb_usuario_pck.get_nm_usuario IS NOT NULL AND wheb_usuario_pck.get_nm_usuario::text <> '') or (pls_util_cta_pck.ie_grava_log_w = 'N')then 
	ie_retorno_w := 'S';
end if;
 
return	ie_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_se_aplicacao_tasy () FROM PUBLIC;
