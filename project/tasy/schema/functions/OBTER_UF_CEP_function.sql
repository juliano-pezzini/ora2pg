-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_uf_cep ( cd_cep_p text) RETURNS varchar AS $body$
DECLARE


ds_uf_w			valor_dominio.vl_dominio%type	:= '';


BEGIN

select	max(ds_uf)
into STRICT	ds_uf_w
from	cep_loc
where	cd_cep	= cd_cep_p;

return ds_uf_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_uf_cep ( cd_cep_p text) FROM PUBLIC;
