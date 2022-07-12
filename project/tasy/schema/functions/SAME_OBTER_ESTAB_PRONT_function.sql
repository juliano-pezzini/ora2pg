-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION same_obter_estab_pront (cd_pessoa_fisica_p text, nr_prontuario_p bigint) RETURNS bigint AS $body$
DECLARE


cd_estabelecimento_w	bigint;			
ie_regra_pront_w		varchar(15);


BEGIN

if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '' AND nr_prontuario_p IS NOT NULL AND nr_prontuario_p::text <> '') then

   select	coalesce(max(vl_parametro),'BASE')
   into STRICT	ie_regra_pront_w
   from	funcao_parametro
   where	cd_funcao	= 0
   and	nr_sequencia	= 120;

   if (ie_regra_pront_w = 'BASE') or (ie_regra_pront_w = 'NUNCA') then

      select	coalesce(max(a.cd_estabelecimento),0)
      into STRICT	cd_estabelecimento_w
      from	pessoa_fisica a
      where	a.cd_pessoa_fisica	= cd_pessoa_fisica_p
	  and a.nr_prontuario = nr_prontuario_p;
	
   elsif (ie_regra_pront_w = 'ESTAB') then

      select	coalesce(max(a.cd_estabelecimento),0)
      into STRICT	cd_estabelecimento_w
      from	pessoa_fisica_pront_estab a
      where	a.cd_pessoa_fisica	= cd_pessoa_fisica_p
      and	a.nr_prontuario = nr_prontuario_p;
	
   end if;
end if;

return	cd_estabelecimento_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION same_obter_estab_pront (cd_pessoa_fisica_p text, nr_prontuario_p bigint) FROM PUBLIC;

