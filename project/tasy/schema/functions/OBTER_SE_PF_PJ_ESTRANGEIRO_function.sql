-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_pf_pj_estrangeiro (cd_pessoa_fisica_p text, cd_cgc_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w        varchar(1) := 'N';
ie_brasileiro_w     nacionalidade.ie_brasileiro%type;
cd_internacional_w  pessoa_juridica.cd_internacional%type;

BEGIN

if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
  select  coalesce(max(y.ie_brasileiro),'S')
  into STRICT    ie_brasileiro_w
  from    nacionalidade y
  where   y.cd_nacionalidade = coalesce(obter_dados_pf(cd_pessoa_fisica_p,'NC'),0)
  and     y.ie_situacao = 'A';

  if ie_brasileiro_w = 'N' then
    ds_retorno_w := 'S';
  end if;
else
  select  coalesce(obter_dados_pf_pj(null,coalesce(cd_cgc_p,'0'),'CINT'),'N')
  into STRICT    cd_internacional_w
;

  if (cd_internacional_w <> 'N') then
    ds_retorno_w := 'S';
  end if;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_pf_pj_estrangeiro (cd_pessoa_fisica_p text, cd_cgc_p text) FROM PUBLIC;

