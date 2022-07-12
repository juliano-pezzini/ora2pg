-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_qua_classif_evento (ie_classificacao_p text, cd_empresa_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(100);


BEGIN
select	substr(obter_desc_expressao(CD_EXP_CLASSIFICACAO,DS_CLASSIFICACAO ),1,80) ds
into STRICT	ds_retorno_w
from	qua_classif_evento
where	cd_empresa = cd_empresa_p
and		ie_classificacao = ie_classificacao_p;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_qua_classif_evento (ie_classificacao_p text, cd_empresa_p bigint) FROM PUBLIC;
