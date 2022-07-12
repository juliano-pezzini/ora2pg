-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_sobre_nome_openehr ( cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE


 ie_person_name_feature_w varchar(1);
 nm_pessoa_fisica_w   pessoa_fisica.nm_usuario%type;


BEGIN
 ie_person_name_feature_w := person_name_enabled();

 if (ie_person_name_feature_w = 'S') then
  select nm_pessoa_fisica
  into STRICT nm_pessoa_fisica_w
  from table(search_names_dev(null,cd_pessoa_fisica_p,null,'familyName',null, null));
 else
  select OBTER_NOME_SOBRENOME_PESSOA(cd_pessoa_fisica_p,'S')
  into STRICT nm_pessoa_fisica_w
;

 end if;

 return nm_pessoa_fisica_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_sobre_nome_openehr ( cd_pessoa_fisica_p text) FROM PUBLIC;

