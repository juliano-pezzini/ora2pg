-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_obter_cbo_medico ( cd_pessoa_fisica_p text, cd_procedimento_p bigint, dt_procedimento_p timestamp default clock_timestamp(), ie_funcao_sus_p bigint DEFAULT NULL) RETURNS varchar AS $body$
DECLARE


c02 CURSOR FOR
	SELECT	cd_cbo
	from	sus_cbo_pessoa_fisica	a
	where	a.cd_pessoa_fisica	= cd_pessoa_fisica_p
	and	exists (SELECT 1 from sus_procedimento_cbo x where a.cd_cbo = x.cd_cbo)
	order by a.nr_seq_apres desc,a.cd_cbo;

c03 CURSOR(nr_seq_grupo_p       sus_grupo.nr_sequencia%type,
           nr_seq_subgrupo_p    sus_subgrupo.nr_sequencia%type,
           nr_seq_forma_org_p   sus_forma_organizacao.nr_sequencia%type,
           cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FOR
	SELECT	cd_cbo
	from	sus_cbo_pessoa_fisica a
	where	a.cd_pessoa_fisica					    = cd_pessoa_fisica_p
	and	coalesce(a.cd_procedimento,cd_procedimento_p)	= cd_procedimento_p
	and	coalesce(a.nr_seq_grupo,nr_seq_grupo_p)			= nr_seq_grupo_p
	and	coalesce(a.nr_seq_subgrupo,nr_seq_subgrupo_p)	= nr_seq_subgrupo_p
	and	coalesce(a.nr_seq_forma_org,nr_seq_forma_org_p)	= nr_seq_forma_org_p
	and	coalesce(a.cd_estab_exclusivo,cd_estabelecimento_p)		= cd_estabelecimento_p
	and	dt_procedimento_p between coalesce(a.dt_inicio_vigencia,dt_procedimento_p) and coalesce(a.dt_fim_vigencia,dt_procedimento_p)
	order by	coalesce(a.cd_procedimento,0),
		coalesce(a.nr_seq_forma_org,0),
		coalesce(a.nr_seq_subgrupo,0),
		coalesce(a.nr_seq_grupo,0),
		coalesce(a.nr_seq_apres,0) desc,
		a.cd_cbo;

cd_cbo_w                c03%rowtype;
c02_w                   c02%rowtype;
ds_retorno_w            varchar(6);
qt_cbo_anest_w          bigint	:= 0;
dt_procedimento_w               procedimento_paciente.dt_procedimento%type;
cd_estabelecimento_w            integer := wheb_usuario_pck.get_cd_estabelecimento;
nr_seq_grupo_w          bigint;
nr_seq_subgrupo_w               bigint;
nr_seq_forma_org_w              bigint;
qt_cbo_proc_w           bigint := 0;
qt_cbo_proc_ww          bigint := 0;

c01 CURSOR FOR
	SELECT	cd_cbo
	from	sus_cbo_pessoa_fisica a
	where	a.cd_pessoa_fisica					= cd_pessoa_fisica_p
	and	coalesce(a.cd_procedimento,cd_procedimento_p)		= cd_procedimento_p
	and	coalesce(a.nr_seq_grupo,nr_seq_grupo_w)			= nr_seq_grupo_w
	and	coalesce(a.nr_seq_subgrupo,nr_seq_subgrupo_w)		= nr_seq_subgrupo_w
	and	coalesce(a.nr_seq_forma_org,nr_seq_forma_org_w)		= nr_seq_forma_org_w
	and	coalesce(a.cd_estab_exclusivo,cd_estabelecimento_w)		= cd_estabelecimento_w
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



BEGIN

begin
dt_procedimento_w := establishment_timezone_utils.startOfMonth(dt_procedimento_p);
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

	if (establishment_timezone_utils.startOfMonth(dt_procedimento_w) < establishment_timezone_utils.startOfDay(to_date('01/07/2013','dd/mm/yyyy'))) then
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

        select 	count(1)
        into STRICT    qt_cbo_proc_w
        from	sus_procedimento_cbo x
        where 	x.cd_procedimento = cd_procedimento_p;

        for cd_cbo_w in c03(nr_seq_grupo_w,nr_seq_subgrupo_w,nr_seq_forma_org_w,cd_estabelecimento_w) loop
            begin

            if (qt_cbo_proc_w > 0) then
                begin
                select 	count(1)
                into STRICT    qt_cbo_proc_ww
                from	sus_procedimento_cbo x
                where 	x.cd_cbo = cd_cbo_w.cd_cbo
                and 	x.cd_procedimento = cd_procedimento_p;

                if  ((qt_cbo_proc_ww > 0) or (coalesce(sus_obter_cbo_proc_med_comp(cd_procedimento_p,7,cd_cbo_w.cd_cbo,dt_procedimento_p),'N') = 'S')) then
                    ds_retorno_w := cd_cbo_w.cd_cbo;
                end if;
                end;
            else
                begin
                ds_retorno_w := cd_cbo_w.cd_cbo;

                end;
            end if;

            end;
        end loop;

		end;
	end if;


	/* Esse codigo nao possui CBO compatativel mas e exigido CBO pelo SUS. portanto pode ser enviado qualquer CBO do medico. */

	if (cd_procedimento_p = 0802020011) and (coalesce(ds_retorno_w,'X') = 'X') then
		select	coalesce(max(cd_cbo),'')
		into STRICT	ds_retorno_w
		from	sus_cbo_pessoa_fisica	a
		where	a.cd_pessoa_fisica	= cd_pessoa_fisica_p;
	end if;
else
	for c02_w in c02 loop
                begin
                ds_retorno_w := c02_w.cd_cbo;
                end;
        end loop;
end if;

if (ie_funcao_sus_p	= 6) then
	select	coalesce(max(cd_cbo),'')
	into STRICT	ds_retorno_w
	from	sus_cbo_pessoa_fisica
	where	cd_pessoa_fisica	= cd_pessoa_fisica_p
	and	dt_procedimento_p between coalesce(dt_inicio_vigencia,dt_procedimento_p) and coalesce(dt_fim_vigencia,dt_procedimento_p)
	and	cd_cbo	in ('223104','225151');
end if;

/* Felipe - OS 81487 O SUS Informou que nos meses Janeiro  / Favereiro e Marco  sera advertido quanto ao CBO incorreto,
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
-- REVOKE ALL ON FUNCTION sus_obter_cbo_medico ( cd_pessoa_fisica_p text, cd_procedimento_p bigint, dt_procedimento_p timestamp default clock_timestamp(), ie_funcao_sus_p bigint DEFAULT NULL) FROM PUBLIC;

