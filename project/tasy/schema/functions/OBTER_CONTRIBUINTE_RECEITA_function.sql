-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_contribuinte_receita (cd_cgc_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w varchar(1);


BEGIN

select coalesce(max(ie_contribuinte_receita),0)
into STRICT   ds_retorno_w
FROM   pessoa_juridica_compl pjc,
       pessoa_juridica pj
WHERE  pjc.cd_cgc = pj.cd_cgc
and    pj.cd_cgc = cd_cgc_p;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_contribuinte_receita (cd_cgc_p text) FROM PUBLIC;
