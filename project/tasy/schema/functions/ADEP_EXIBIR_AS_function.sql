-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION adep_exibir_as (nr_atendimento_p bigint, ie_restr_estab_p text, cd_pessoa_fisica_p text, cd_funcao_p text, cd_funcao_chamada_p text, cd_perfil_p text, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


ie_w		varchar(1) := '';
ds_retorno_w	varchar(1) := 'N';

c01 CURSOR FOR
SELECT   'S'
from	 atendimento_alerta a
where	 nr_atendimento       = nr_atendimento
and	 a.ie_situacao        = 'A'
and	 ((coalesce(a.dt_fim_alerta::text, '') = '') or (a.dt_fim_alerta >= trunc(clock_timestamp(),'dd'))) and ((a.cd_estabelecimento = cd_estabelecimento_p AND ie_restr_estab_p = 'S') or (ie_restr_estab_p = 'N')) AND ((a.cd_estabelecimento = cd_estabelecimento_p AND ie_restr_estab_p = 'S') OR (ie_restr_estab_p = 'N') OR (coalesce(a.cd_estabelecimento::text, '') = ''))

union all

select   'S'
from	 alerta_paciente a
where	 a.cd_pessoa_fisica   = cd_pessoa_fisica_p
and	 a.ie_situacao        = 'A'
and	 ((coalesce(a.dt_fim_alerta::text, '') = '') or (a.dt_fim_alerta >= trunc(clock_timestamp(),'dd')))
and      ((cd_funcao_p = 0) or (a.cd_funcao = cd_funcao_p))
and      ((a.cd_estabelecimento = cd_estabelecimento_p AND ie_restr_estab_p = 'S') or (ie_restr_estab_p = 'N'))

union all

select   'S'
from	 alerta_paciente_geral a,
         pessoa_fisica b
where    a.ie_situacao        = 'A'
and	 ((coalesce(a.dt_fim_alerta::text, '') = '') or (a.dt_fim_alerta >= trunc(clock_timestamp(),'dd')))
and      ((coalesce(a.cd_funcao::text, '') = '') or (a.cd_funcao = cd_funcao_chamada_p))
and      ((coalesce(a.cd_perfil::text, '') = '') or (a.cd_perfil = cd_perfil_p))
and      obter_idade(b.dt_nascimento,coalesce(b.dt_obito,clock_timestamp()),'A') between
         coalesce(qt_idade_min,obter_idade(b.dt_nascimento,coalesce(b.dt_obito,clock_timestamp()),'A')) and  coalesce(qt_idade_max,obter_idade(b.dt_nascimento,coalesce(b.dt_obito,clock_timestamp()),'A'))
and      b.cd_pessoa_fisica = cd_pessoa_fisica_p;


BEGIN

open C01;
loop
fetch C01 into
	ie_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	if (coalesce(ie_w,'N') = 'S') then
		ds_retorno_w := 'S';
		exit;
	end if;

	end;
end loop;
close C01;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION adep_exibir_as (nr_atendimento_p bigint, ie_restr_estab_p text, cd_pessoa_fisica_p text, cd_funcao_p text, cd_funcao_chamada_p text, cd_perfil_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

