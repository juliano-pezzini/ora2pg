-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_hc_classif_serv (ie_classificacao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno	varchar(255);


BEGIN

select	max(ds_valor_dominio)
into STRICT	ds_retorno
from	valor_dominio
where	cd_dominio = 1729
and	((obter_se_contido_char(vl_dominio,hc_obter_classif_servicos) = 'S') or (coalesce(hc_obter_classif_servicos::text, '') = ''))
and	vl_dominio = ie_classificacao_p;

return	ds_retorno;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_hc_classif_serv (ie_classificacao_p text) FROM PUBLIC;
