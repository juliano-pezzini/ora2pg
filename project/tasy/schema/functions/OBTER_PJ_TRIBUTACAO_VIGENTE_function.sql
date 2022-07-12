-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_pj_tributacao_vigente ( cd_cgc_p pessoa_juridica.CD_CGC%TYPE, ie_tipo_tributacao_p regra_calculo_imposto.ie_fiscales%TYPE) RETURNS varchar AS $body$
DECLARE

ie_fiscales_w regra_calculo_imposto.ie_fiscales%TYPE;
retorno_w varchar(1) := 'S';

BEGIN
select  max(ie_tipo_tributacao)
into STRICT    ie_fiscales_w
from    pj_tipo_tributacao_hist a
where   a.cd_cnpj 		= cd_cgc_p
and	ie_tipo_tributacao 	= ie_tipo_tributacao_p
and 	trunc(clock_timestamp()) between trunc(a.dt_inicio_vigencia) and trunc(coalesce(a.dt_fim_vigencia,clock_timestamp()));

if coalesce(ie_fiscales_w::text, '') = '' then
	retorno_w := 'N';
end if;

return retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_pj_tributacao_vigente ( cd_cgc_p pessoa_juridica.CD_CGC%TYPE, ie_tipo_tributacao_p regra_calculo_imposto.ie_fiscales%TYPE) FROM PUBLIC;

