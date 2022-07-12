-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_funcao_usuario_orig ( nm_usuario_orig_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w varchar(255);


BEGIN

select  substr(coalesce(b.ds_valor_dominio_cliente,obter_valor_dominio(72,b.vl_dominio)),1,255)
into STRICT ds_retorno_w
from valor_dominio_v b,
 usuario a
where a.nm_usuario  = nm_usuario_orig_p
and b.cd_dominio  = 72
and a.ie_tipo_evolucao = b.vl_dominio;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_funcao_usuario_orig ( nm_usuario_orig_p text) FROM PUBLIC;
