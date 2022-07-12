-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_trib_serv_item ( cd_cgc_p text) RETURNS varchar AS $body$
DECLARE


ie_tributacao_iss_w varchar(1);


BEGIN

select	max(ie_tributacao_iss)
into STRICT	ie_tributacao_iss_w
from	mat_lib_estrut_fornec
where	cd_cnpj_fornec = cd_cgc_p;

return	ie_tributacao_iss_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_trib_serv_item ( cd_cgc_p text) FROM PUBLIC;

