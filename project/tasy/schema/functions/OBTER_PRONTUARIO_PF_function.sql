-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_prontuario_pf ( cd_estabelecimento_p bigint, cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE


ie_regra_pront_w		varchar(15);
nr_prontuario_w		bigint := 0;


BEGIN
if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
   select	coalesce(max(vl_parametro),'BASE')
   into STRICT	ie_regra_pront_w
   from	funcao_parametro
   where	cd_funcao	= 0
   and	nr_sequencia	= 120;

   if (ie_regra_pront_w = 'BASE') or (ie_regra_pront_w = 'NUNCA') then

      select	coalesce(max(nr_prontuario),0)
      into STRICT	nr_prontuario_w
      from	pessoa_fisica
      where	cd_pessoa_fisica	= cd_pessoa_fisica_p;
   elsif (ie_regra_pront_w = 'ESTAB') then

      select	coalesce(max(nr_prontuario),0)
      into STRICT	nr_prontuario_w
      from	pessoa_fisica_pront_estab
      where	cd_pessoa_fisica	= cd_pessoa_fisica_p
      and	cd_estabelecimento	= coalesce(cd_estabelecimento_p, wheb_usuario_pck.get_cd_estabelecimento);
   end if;
end if;

return	nr_prontuario_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_prontuario_pf ( cd_estabelecimento_p bigint, cd_pessoa_fisica_p text) FROM PUBLIC;

