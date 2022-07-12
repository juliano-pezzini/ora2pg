-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_valor_proc_guia_rel ( cd_procedimento_p bigint, ie_origem_p bigint, vl_procedimento_p bigint, qt_multi_proc_p bigint) RETURNS bigint AS $body$
DECLARE


vl_retorno_w		double precision;


BEGIN

if (cd_procedimento_p = 99010045) then
	vl_retorno_w := vl_procedimento_p * qt_multi_proc_p;
else
	vl_retorno_w := vl_procedimento_p;
end if;

return	vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_valor_proc_guia_rel ( cd_procedimento_p bigint, ie_origem_p bigint, vl_procedimento_p bigint, qt_multi_proc_p bigint) FROM PUBLIC;
