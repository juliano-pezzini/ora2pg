-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nome_estab_estr_org (CD_ESTABELECIMENTO_P bigint) RETURNS varchar AS $body$
DECLARE


ds_razao_social_w	varchar(255);
ds_retorno_w		varchar(255);
nm_fantasia_estab_w	varchar(255);


BEGIN
if (CD_ESTABELECIMENTO_P IS NOT NULL AND CD_ESTABELECIMENTO_P::text <> '') then
 begin
	select max(b.ds_razao_social),
		max(coalesce(b.nm_fantasia,a.nm_fantasia_estab))
	into STRICT
		ds_razao_social_w,
		nm_fantasia_estab_w
	from	estabelecimento a,
          pessoa_juridica b
	where	a.cd_cgc = b.cd_cgc
  and 	a.cd_estabelecimento = CD_ESTABELECIMENTO_P;


  SELECT MAX(CASE WHEN IE_EXIBIR_NOME = 'E' THEN ds_razao_social_w
       WHEN IE_EXIBIR_NOME = 'N' THEN nm_fantasia_estab_w
       WHEN IE_EXIBIR_NOME = 'D' THEN DS_CURTA
  END) into STRICT ds_retorno_w
   FROM ESTRUTURA_ORGANIZACIONAL
   WHERE CD_ESTABELECIMENTO = CD_ESTABELECIMENTO_P;
end;
end if;

RETURN ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nome_estab_estr_org (CD_ESTABELECIMENTO_P bigint) FROM PUBLIC;

