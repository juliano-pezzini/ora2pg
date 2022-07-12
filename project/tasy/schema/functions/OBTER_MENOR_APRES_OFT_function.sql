-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_menor_apres_oft ( nr_sequencia_p bigint, cd_perfil_p bigint) RETURNS bigint AS $body$
DECLARE



nr_seq_apresentacao_w	bigint;


BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and (cd_perfil_p IS NOT NULL AND cd_perfil_p::text <> '') then

	select	coalesce(min(a.nr_seq_apresentacao),999)
	into STRICT	nr_seq_apresentacao_w
	from	perfil_item_oft_visual a,
		perfil_item_oftalmologia b
	where	a.nr_seq_item_perfil 	= b.nr_sequencia
	and 	a.nr_seq_item		= nr_sequencia_p
	and 	b.cd_perfil 		= cd_perfil_p;
end if;

return	nr_seq_apresentacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_menor_apres_oft ( nr_sequencia_p bigint, cd_perfil_p bigint) FROM PUBLIC;

