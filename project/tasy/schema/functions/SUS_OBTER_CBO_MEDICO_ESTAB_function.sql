-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_obter_cbo_medico_estab ( cd_pessoa_fisica_p text, cd_procedimento_p bigint, dt_procedimento_p timestamp default clock_timestamp(), ie_funcao_sus_p bigint DEFAULT NULL, cd_estabelecimento_p bigint DEFAULT NULL) RETURNS varchar AS $body$
DECLARE

				
/*
Function criada devido as integracoes, que nao possuem o wheb_usuario_pck.get_cd_estabelecimento.
*/
				

ds_retorno_w			varchar(6);
qt_cbo_anest_w			bigint	:= 0;
nr_seq_grupo_w			bigint;
nr_seq_subgrupo_w		bigint;
nr_seq_forma_org_w		bigint;
--cd_estabelecimento_w		number(5) := wheb_usuario_pck.get_cd_estabelecimento;
dt_procedimento_w		procedimento_paciente.dt_procedimento%type;

c01 CURSOR FOR
	SELECT	cd_cbo
	from	sus_cbo_pessoa_fisica a
	where	a.cd_pessoa_fisica					= cd_pessoa_fisica_p
	and	coalesce(a.cd_procedimento,cd_procedimento_p)		= cd_procedimento_p
	and	coalesce(a.nr_seq_grupo,nr_seq_grupo_w)			= nr_seq_grupo_w
	and	coalesce(a.nr_seq_subgrupo,nr_seq_subgrupo_w)		= nr_seq_subgrupo_w
	and	coalesce(a.nr_seq_forma_org,nr_seq_forma_org_w)		= nr_seq_forma_org_w
	and	coalesce(a.cd_estab_exclusivo,cd_estabelecimento_p)		= cd_estabelecimento_p
	and	dt_procedimento_p between coalesce(a.dt_inicio_vigencia,dt_procedimento_p) and coalesce(a.dt_fim_vigencia,dt_procedimento_p)
	and	exists (	SELECT 	1
			from	sus_procedimento_cbo x
			where 	a.cd_cbo = x.cd_cbo
			and 	x.cd_procedimento = cd_procedimento_p)
	order by	coalesce(a.cd_procedimento,0),
		coalesce(a.nr_seq_forma_org,0),
		coalesce(a.nr_seq_subgrupo,0),
		coalesce(a.nr_seq_grupo,0),
		coalesce(a.nr_seq_apres,0) desc,
		a.cd_cbo;

c02 CURSOR FOR
	SELECT	cd_cbo
	from	sus_cbo_pessoa_fisica	a
	where	a.cd_pessoa_fisica	= cd_pessoa_fisica_p
	and	exists (SELECT 1 from sus_procedimento_cbo x where a.cd_cbo = x.cd_cbo)
	order by a.nr_seq_apres desc,a.cd_cbo;
	
c03 CURSOR FOR
	SELECT	cd_cbo
	from	sus_cbo_pessoa_fisica a
	where	a.cd_pessoa_fisica					= cd_pessoa_fisica_p
	and	coalesce(a.cd_procedimento,cd_procedimento_p)		= cd_procedimento_p
	and	coalesce(a.nr_seq_grupo,nr_seq_grupo_w)			= nr_seq_grupo_w
	and	coalesce(a.nr_seq_subgrupo,nr_seq_subgrupo_w)		= nr_seq_subgrupo_w
	and	coalesce(a.nr_seq_forma_org,nr_seq_forma_org_w)		= nr_seq_forma_org_w
	and	coalesce(a.cd_estab_exclusivo,cd_estabelecimento_p)		= cd_estabelecimento_p
	and	dt_procedimento_p between coalesce(a.dt_inicio_vigencia,dt_procedimento_p) and coalesce(a.dt_fim_vigencia,dt_procedimento_p)
	and (exists (	SELECT 	1
			from	sus_procedimento_cbo x
			where 	a.cd_cbo = x.cd_cbo
			and 	x.cd_procedimento = cd_procedimento_p) or (coalesce(sus_obter_cbo_proc_med_comp(cd_procedimento_p,7,a.cd_cbo,dt_procedimento_p),'N') = 'S'))
	order by	coalesce(a.cd_procedimento,0),
		coalesce(a.nr_seq_forma_org,0),
		coalesce(a.nr_seq_subgrupo,0),
		coalesce(a.nr_seq_grupo,0),
		coalesce(a.nr_seq_apres,0) desc,
		a.cd_cbo;	


BEGIN

begin
dt_procedimento_w := ESTABLISHMENT_TIMEZONE_UTILS.startOfMonth(dt_procedimento_p);
exception
when others then
	dt_procedimento_w := clock_timestamp();
end;

if (cd_procedimento_p IS NOT NULL AND cd_procedimento_p::text <> '') then

	begin
	select	nr_seq_grupo,
		nr_seq_subgrupo,
		nr_seq_forma_org
	into STRICT	nr_seq_grupo_w,
		nr_seq_subgrupo_w,
		nr_seq_forma_org_w
	from	sus_estrutura_procedimento_v
	where	cd_procedimento		= cd_procedimento_p
	and	ie_origem_proced		= 7;
	exception
		when others then
		nr_seq_grupo_w		:= 0;
		nr_seq_subgrupo_w	:= 0;
		nr_seq_forma_org_w	:= 0;
	end;
	
	if (ESTABLISHMENT_TIMEZONE_UTILS.startOfMonth(dt_procedimento_w) < to_date('01/07/2013','dd/mm/yyyy')) then
		begin
		
		open c01;
		loop
		fetch c01 into
			ds_retorno_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
		end loop;
		close c01;		
		
		end;
	else
		begin
		
		open c03;
		loop
		fetch c03 into
			ds_retorno_w;
		EXIT WHEN NOT FOUND; /* apply on c03 */
		end loop;
		close c03;		
		
		end;
	end if;


	/* Esse codigo nao possui CBO compativel mas e exigido CBO pelo SUS. portanto pode ser enviado qualquer CBO do medico. */

	if (cd_procedimento_p = 0802020011) and (coalesce(ds_retorno_w,'X') = 'X') then
		select	coalesce(max(cd_cbo),'')
		into STRICT	ds_retorno_w
		from	sus_cbo_pessoa_fisica	a
		where	a.cd_pessoa_fisica	= cd_pessoa_fisica_p;
	end if;
else
	open c02;
	loop
	fetch c02 into
		ds_retorno_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	end loop;
	close c02;
end if;

if (ie_funcao_sus_p	= 6) then
	select	coalesce(max(cd_cbo),'')
	into STRICT	ds_retorno_w
	from	sus_cbo_pessoa_fisica
	where	cd_pessoa_fisica	= cd_pessoa_fisica_p
	and	dt_procedimento_p between coalesce(dt_inicio_vigencia,dt_procedimento_p) and coalesce(dt_fim_vigencia,dt_procedimento_p)
	and	cd_cbo	in ('223104','225151');
end if;

/* Felipe - OS 81487 O SUS Informou que nos meses Janeiro  / Favereiro e Marco so sera advertido quanto ao CBO incorreto,
por isso estou fazendo o Tasy exportar qualquer CBO do medico caso o mesmo nao tenha CBO compativel */
if (coalesce(ds_retorno_w,'X') = 'X') and (clock_timestamp() < to_date('30/03/2008', 'dd/mm/yyyy')) then
	select	coalesce(max(cd_cbo),'')
	into STRICT	ds_retorno_w
	from	sus_cbo_pessoa_fisica	a
	where	a.cd_pessoa_fisica	= cd_pessoa_fisica_p;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_obter_cbo_medico_estab ( cd_pessoa_fisica_p text, cd_procedimento_p bigint, dt_procedimento_p timestamp default clock_timestamp(), ie_funcao_sus_p bigint DEFAULT NULL, cd_estabelecimento_p bigint DEFAULT NULL) FROM PUBLIC;
