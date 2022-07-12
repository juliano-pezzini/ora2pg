-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_if_update_preceptor (cd_pessoa_estudante_p bigint, cd_pessoa_usuario_p bigint, nr_seq_item_pront_p text) RETURNS varchar AS $body$
DECLARE

													
ds_retorno_w	varchar(1) := 'N';


BEGIN

if (get_if_rule_preceptor(cd_pessoa_estudante_p) = 'S') then
	--person
	select coalesce(max('S'),'N') ie_aval
	into STRICT	ds_retorno_w
	from    pessoa_fisica_preceptor a, liberacao_item_estudante b, pessoa_fisica_estudante c
	where 	a.cd_pessoa_estudante = c.cd_pessoa_fisica
	and     b.cd_pessoa_estudante = c.cd_pessoa_fisica
	and     a.cd_pessoa_fisica = cd_pessoa_usuario_p
	and     a.cd_pessoa_estudante = cd_pessoa_estudante_p
	and     clock_timestamp() between coalesce(dt_inicio,clock_timestamp()) and coalesce(dt_fim,clock_timestamp())
	and     b.nr_seq_item = nr_seq_item_pront_p
	and     coalesce(b.cd_perfil, coalesce(obter_perfil_ativo,0)) = coalesce(obter_perfil_ativo,0)
	and		coalesce(ie_situacao,'A') = 'A';

else
	--profile
	select	coalesce(max('S'),'N')
	into STRICT 	ds_retorno_w
	from	regra_preceptor_pep a, regra_preceptor_pep_item b, regra_preceptor_pep_prof c
	where	a.nr_sequencia = b.nr_seq_regra
	and		a.nr_sequencia = c.nr_seq_regra
	and 	a.cd_perfil = coalesce(obter_perfil_ativo,0)
	and		c.cd_pessoa_fisica = cd_pessoa_usuario_p
	and		b.nr_seq_item = nr_seq_item_pront_p
	and		clock_timestamp() between coalesce(a.dt_inicio,clock_timestamp()) and coalesce(a.dt_fim,clock_timestamp())
	and		coalesce(a.ie_situacao,'A') = 'A';

end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_if_update_preceptor (cd_pessoa_estudante_p bigint, cd_pessoa_usuario_p bigint, nr_seq_item_pront_p text) FROM PUBLIC;
