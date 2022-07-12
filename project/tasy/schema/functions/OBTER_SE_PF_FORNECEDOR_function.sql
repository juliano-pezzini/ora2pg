-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_pf_fornecedor ( cd_pessoa_fisica_p text default null, cd_estabelecimento_p bigint  DEFAULT NULL) RETURNS varchar AS $body$
DECLARE


ie_fornecedor_pf_w varchar(1);
ie_fornecedor_w varchar(1);
ie_retorno_w varchar(1) := 'S';


BEGIN

begin
  select coalesce(ie_fornecedor_pf, 'N')
  into STRICT ie_fornecedor_pf_w
  from parametro_compras
  where cd_estabelecimento = cd_estabelecimento_p;
  exception
    when no_data_found then
      ie_fornecedor_pf_w := 'N';
  end;

if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') and ie_fornecedor_pf_w = 'S' then
  
  begin
  select coalesce(ie_fornecedor, 'N')
  into STRICT ie_fornecedor_w
  from pessoa_fisica
  where cd_pessoa_fisica = cd_pessoa_fisica_p;
  exception
    when no_data_found then
      ie_fornecedor_w := 'N';
  end;

  ie_retorno_w := ie_fornecedor_w;

end if;

return ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_pf_fornecedor ( cd_pessoa_fisica_p text default null, cd_estabelecimento_p bigint  DEFAULT NULL) FROM PUBLIC;

