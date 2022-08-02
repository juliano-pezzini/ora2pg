-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ppm_metrica_hpi_os ( nr_seq_metrica_p bigint, nr_seq_objetivo_metrica_p bigint, cd_pessoa_fisica_p text, nm_usuario_p text, dt_referencia_p timestamp) AS $body$
DECLARE

			
resultado_w			double precision;
qt_satisfacao_w		bigint;
qt_insatisfacao_w	bigint;
dt_ref_inicio_w		timestamp;
dt_ref_fim_w		timestamp;
dt_referencia_w		timestamp;
nr_seq_diretoria_w	ppm_objetivo.nr_seq_diretoria%type;
nr_seq_gerencia_w	ppm_objetivo.nr_seq_gerencia%type;
nr_seq_grupo_w		ppm_objetivo.nr_seq_grupo%type;
nr_seq_grupo_des_w	grupo_desenvolvimento.nr_sequencia%type;
nm_user_grupo_des_w	usuario_grupo_des.nm_usuario_grupo%type;
cd_cargo_user_w		cargo.cd_cargo%type;
qt_min_prev_w		double precision;
qt_min_real_w		double precision;
	

BEGIN

dt_ref_inicio_w := pkg_date_utils.start_of(dt_referencia_p,'MONTH');
dt_ref_fim_w 	:= pkg_date_utils.end_of(last_day(dt_referencia_p),'DAY');
dt_referencia_w	:= trunc(dt_referencia_p);

select	max(nr_seq_gerencia),
	max(nr_seq_grupo),
	max(nr_seq_diretoria)
into STRICT	nr_seq_gerencia_w,
	nr_seq_grupo_w,
	nr_seq_diretoria_w
from	ppm_objetivo_metrica a,
	ppm_objetivo_meta b,
	ppm_objetivo c
where	a.nr_sequencia		= nr_seq_objetivo_metrica_p
and	a.nr_seq_meta		= b.nr_sequencia
and	b.nr_seq_objetivo	= c.nr_sequencia;

if (nr_seq_grupo_w IS NOT NULL AND nr_seq_grupo_w::text <> '') then
	--Buscar HPI da OS por todos os usuários de determinado grupo
	
	select  sum(x.qt_min_prev),
		sum(x.qt_real)
	into STRICT	qt_min_prev_w,
		qt_min_real_w
	from	(
		/*select	sum(c.qt_min_prev) qt_min_prev,
			sum((select sum(d.qt_minuto) from man_ordem_serv_ativ d where a.nr_sequencia = d.nr_Seq_ordem_serv and c.nm_usuario_exec = d.nm_usuario_exec)) qt_real
		from	man_ordem_servico a,
			MAN_ORDEM_SERVICO_EXEC c
		where	a.nr_Sequencia = c.nr_Seq_ordem
		and	nvl(c.qt_min_prev,0) > 0
		and	a.ie_classificacao <> 'E'
		and	a.ie_status_ordem = '3'
		and	nvl(nvl(a.cd_funcao,0),0) <> -3001
		and	nvl(c.ie_considera_hpi,'S') = 'S'
		and	a.dt_fim_real between dt_ref_inicio_w and dt_ref_fim_w
		and	a.nr_seq_grupo_des = nr_seq_grupo_w
		and	obter_cargo_usuario(c.nm_usuario_exec,'C') in ('66','69','73','133','1379') --Programadores	
		--and	c.nm_usuario_exec in

		--	(select	x.nm_usuario_grupo

		--	from	usuario_grupo_des x

		--	where	x.nr_seq_grupo = nr_seq_grupo_w

		--	and	obter_cargo_usuario(x.nm_usuario_grupo,'C') in ('66','69','73','133','1379')) --Programadores

		and	exists (select 	1 
				from	man_ordem_serv_ativ e 
				where	a.nr_sequencia = e.nr_Seq_ordem_serv 
				and	c.nm_usuario_exec = e.nm_usuario_exec
				and	nvl(e.qt_minuto,0) > 0) 
		union*/
		SELECT	sum(c.qt_min_prev) qt_min_prev,
			sum((SELECT sum(d.qt_minuto) from man_ordem_serv_ativ d where a.nr_sequencia = d.nr_Seq_ordem_serv and c.nm_usuario_exec = d.nm_usuario_exec)) qt_real
		from	man_ordem_servico a,
			MAN_ORDEM_SERVICO_EXEC c
		where	a.nr_Sequencia = c.nr_Seq_ordem
		and	coalesce(c.qt_min_prev,0) > 0
		and	a.ie_classificacao <> 'E'
		and	a.ie_status_ordem = '3'
		and	coalesce(a.cd_funcao,0) <> -3001
		and	coalesce(c.ie_considera_hpi,'S') = 'S'
		and	coalesce(a.nr_seq_Proj_cron_etapa::text, '') = ''
		and	coalesce(a.nr_seq_projeto::text, '') = ''
		and	a.dt_fim_real between dt_ref_inicio_w and dt_ref_fim_w
		and	a.nr_seq_grupo_des = nr_seq_grupo_w
		and	obter_cargo_usuario(c.nm_usuario_exec,'C') in ('66','69','73','133','1379') --Executadas por programador
		and	obter_cargo_usuario(c.nm_usuario_prev,'C') in ('61','62','113','221','1354','1380','371','1393','1428','1430') --prevista por Analista
		/*and	c.nm_usuario_prev in
			(select	x.nm_usuario_grupo
			from	usuario_grupo_des x
			where	x.nr_seq_grupo = nr_seq_grupo_w
			and	obter_cargo_usuario(x.nm_usuario_grupo,'C') in ('61','62','113','221','1354','1380','371','1393','1428','1430')) --prevista por Analista	*/
		and	exists (select 	1
				from	man_ordem_serv_ativ e 
				where	a.nr_sequencia = e.nr_Seq_ordem_serv 
				and	c.nm_usuario_exec = e.nm_usuario_exec
				and	coalesce(e.qt_minuto,0) > 0)) x;


elsif (nr_seq_gerencia_w IS NOT NULL AND nr_seq_gerencia_w::text <> '') then
		--Buscar HPI da OS por todos os grupos da gerência
		
	select  sum(x.qt_min_prev),
		sum(x.qt_real)
	into STRICT	qt_min_prev_w,
		qt_min_real_w
	from	(
		/*select	sum(c.qt_min_prev) qt_min_prev,
			sum((select sum(d.qt_minuto) from man_ordem_serv_ativ d where a.nr_sequencia = d.nr_Seq_ordem_serv and c.nm_usuario_exec = d.nm_usuario_exec)) qt_real
		from	man_ordem_servico a,
			MAN_ORDEM_SERVICO_EXEC c,
			grupo_desenvolvimento d
		where	a.nr_Sequencia 		= c.nr_Seq_ordem
		and	a.nr_seq_grupo_des 	= d.nr_sequencia
		and	d.nr_seq_gerencia	= nr_seq_gerencia_w
		and	nvl(c.qt_min_prev,0) > 0
		and	a.ie_classificacao <> 'E'
		and	a.ie_status_ordem = '3'
		and	nvl(a.cd_funcao,0) <> -3001
		and	nvl(c.ie_considera_hpi,'S') = 'S'
		and	a.dt_fim_real between dt_ref_inicio_w and dt_ref_fim_w
		and	obter_cargo_usuario(c.nm_usuario_exec,'C') in ('66','69','73','133','1379') --Programadores	
		--and	c.nm_usuario_exec in

		--	(select	x.nm_usuario_grupo

		--	from	usuario_grupo_des x,

		--		grupo_desenvolvimento y

		--	where	x.nr_seq_grupo 		= y.nr_sequencia

		--	and	y.ie_situacao		= 'A'

		--	and	y.nr_seq_gerencia	= nr_seq_gerencia_w

		--	and	obter_cargo_usuario(x.nm_usuario_grupo,'C') in ('66','69','73','133','1379')) --Programadores

		and	exists (select 	1 
				from	man_ordem_serv_ativ e 
				where	a.nr_sequencia = e.nr_Seq_ordem_serv 
				and	c.nm_usuario_exec = e.nm_usuario_exec
				and	nvl(e.qt_minuto,0) > 0) 
		union*/
		SELECT	sum(c.qt_min_prev) qt_min_prev,
			sum((SELECT sum(d.qt_minuto) from man_ordem_serv_ativ d where a.nr_sequencia = d.nr_Seq_ordem_serv and c.nm_usuario_exec = d.nm_usuario_exec)) qt_real
		from	man_ordem_servico a,
			MAN_ORDEM_SERVICO_EXEC c,
			grupo_desenvolvimento d
		where	a.nr_Sequencia 		= c.nr_Seq_ordem
		and	a.nr_seq_grupo_des 	= d.nr_sequencia
		and	d.nr_seq_gerencia	= nr_seq_gerencia_w
		and	coalesce(c.qt_min_prev,0) > 0
		and	a.ie_classificacao <> 'E'
		and	a.ie_status_ordem = '3'
		and	coalesce(a.cd_funcao,0) <> -3001
		and	coalesce(c.ie_considera_hpi,'S') = 'S'
		and	coalesce(a.nr_seq_Proj_cron_etapa::text, '') = ''
		and	coalesce(a.nr_seq_projeto::text, '') = ''
		and	a.dt_fim_real between dt_ref_inicio_w and dt_ref_fim_w
		and	obter_cargo_usuario(c.nm_usuario_exec,'C') in ('66','69','73','133','1379') --Executadas por programador
		and	obter_cargo_usuario(c.nm_usuario_prev,'C') in ('61','62','113','221','1354','1380','371','1393','1428','1430') --prevista por Analista
		/*and	c.nm_usuario_prev in
			(select	x.nm_usuario_grupo
			from	usuario_grupo_des x,
				grupo_desenvolvimento y
			where	x.nr_seq_grupo 		= y.nr_sequencia
			and	y.ie_situacao		= 'A'
			and	y.nr_seq_gerencia	= nr_seq_gerencia_w
			and	obter_cargo_usuario(x.nm_usuario_grupo,'C') in ('61','62','113','221','1354','1380','371','1393','1428','1430')) --Analista*/
	
		and	exists (select 	1
				from	man_ordem_serv_ativ e 
				where	a.nr_sequencia = e.nr_Seq_ordem_serv 
				and	c.nm_usuario_exec = e.nm_usuario_exec
				and	coalesce(e.qt_minuto,0) > 0)) x;
	

elsif (nr_seq_diretoria_w IS NOT NULL AND nr_seq_diretoria_w::text <> '') then
		--Buscar HPI da OS de acordo com todos os usuários de todos os grupos que pertencem a todas as gerências de uma determinada diretoria
	select  sum(x.qt_min_prev),
		sum(x.qt_real)
	into STRICT	qt_min_prev_w,
		qt_min_real_w
	from	(
		/*select	sum(c.qt_min_prev) qt_min_prev,
			sum((select sum(d.qt_minuto) from man_ordem_serv_ativ d where a.nr_sequencia = d.nr_Seq_ordem_serv and c.nm_usuario_exec = d.nm_usuario_exec)) qt_real
		from	man_ordem_servico a,
			MAN_ORDEM_SERVICO_EXEC c,
			grupo_desenvolvimento d,
			gerencia_wheb g
		where	a.nr_Sequencia 		= c.nr_Seq_ordem
		and	a.nr_seq_grupo_des 	= d.nr_sequencia
		and	d.nr_seq_gerencia	= g.nr_sequencia
		and	g.nr_seq_diretoria	= nr_seq_diretoria_w
		and	nvl(c.qt_min_prev,0) > 0
		and	a.ie_classificacao <> 'E'
		and	a.ie_status_ordem = '3'
		and	nvl(a.cd_funcao,0) <> -3001
		and	nvl(c.ie_considera_hpi,'S') = 'S'
		and	a.dt_fim_real between dt_ref_inicio_w and dt_ref_fim_w
		and	obter_cargo_usuario(c.nm_usuario_exec,'C') in ('66','69','73','133','1379') --Programadores	
		--and	c.nm_usuario_exec in

		--	(select	x.nm_usuario_grupo

		--	from	usuario_grupo_des x,

		--		grupo_desenvolvimento y,

		--		gerencia_wheb z

		--	where	x.nr_seq_grupo 		= y.nr_sequencia

		--	and	y.ie_situacao		= 'A'

		--	and	z.ie_situacao		= 'A'

		--	and	y.nr_seq_gerencia	= z.nr_sequencia

		--	and	z.nr_seq_diretoria	= nr_seq_diretoria_w			

		--	and	obter_cargo_usuario(x.nm_usuario_grupo,'C') in ('66','69','73','133','1379')) --Programadores

		and	exists (select 	1 
				from	man_ordem_serv_ativ e 
				where	a.nr_sequencia = e.nr_Seq_ordem_serv 
				and	c.nm_usuario_exec = e.nm_usuario_exec
				and	nvl(e.qt_minuto,0) > 0) 
		union*/
		SELECT	sum(c.qt_min_prev) qt_min_prev,
			sum((SELECT sum(d.qt_minuto) from man_ordem_serv_ativ d where a.nr_sequencia = d.nr_Seq_ordem_serv and c.nm_usuario_exec = d.nm_usuario_exec)) qt_real
		from	man_ordem_servico a,
			MAN_ORDEM_SERVICO_EXEC c,
			grupo_desenvolvimento d,
			gerencia_wheb g
		where	a.nr_Sequencia 		= c.nr_Seq_ordem
		and	a.nr_seq_grupo_des 	= d.nr_sequencia
		and	d.nr_seq_gerencia	= g.nr_sequencia
		and	g.nr_seq_diretoria	= nr_seq_diretoria_w
		and	coalesce(c.qt_min_prev,0) > 0
		and	a.ie_classificacao <> 'E'
		and	a.ie_status_ordem = '3'
		and	coalesce(a.cd_funcao,0) <> -3001
		and	coalesce(c.ie_considera_hpi,'S') = 'S'
		and	coalesce(a.nr_seq_Proj_cron_etapa::text, '') = ''
		and	coalesce(a.nr_seq_projeto::text, '') = ''
		and	a.dt_fim_real between dt_ref_inicio_w and dt_ref_fim_w
		and	obter_cargo_usuario(c.nm_usuario_exec,'C') in ('66','69','73','133','1379') --Executadas por programador
		and	obter_cargo_usuario(c.nm_usuario_prev,'C') in ('61','62','113','221','1354','1380','371','1393','1428','1430') --prevista por Analista
		/*and	c.nm_usuario_prev in
			(select	x.nm_usuario_grupo
			from	usuario_grupo_des x,
				grupo_desenvolvimento y,
				gerencia_wheb z
			where	x.nr_seq_grupo 		= y.nr_sequencia
			and	y.ie_situacao		= 'A'
			and	z.ie_situacao		= 'A'
			and	y.nr_seq_gerencia	= z.nr_sequencia
			and	z.nr_seq_diretoria	= nr_seq_diretoria_w
			and	obter_cargo_usuario(x.nm_usuario_grupo,'C') in ('61','62','113','221','1354','1380','371','1393','1428','1430')) --Analista*/
	
		and	exists (select 	1
				from	man_ordem_serv_ativ e 
				where	a.nr_sequencia = e.nr_Seq_ordem_serv 
				and	c.nm_usuario_exec = e.nm_usuario_exec
				and	coalesce(e.qt_minuto,0) > 0)) x;		

elsif (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then

	begin
		select	nm_usuario,
			obter_cargo_usuario(nm_usuario,'C')
		into STRICT	nm_user_grupo_des_w,
			cd_cargo_user_w
		from	usuario
		where	cd_pessoa_fisica	= cd_pessoa_fisica_p
		and	ie_situacao		= 'A'  LIMIT 1;
	exception
	when others then
		cd_cargo_user_w := null;
	end;	
		
	--Usuários executores
	if (cd_cargo_user_w in ('66','69','73','133','1379')) then
	
		select	sum(c.qt_min_prev) qt_min_prev,
			sum((select sum(d.qt_minuto) from man_ordem_serv_ativ d where a.nr_sequencia = d.nr_Seq_ordem_serv and c.nm_usuario_exec = d.nm_usuario_exec)) qt_real
		into STRICT	qt_min_prev_w,
			qt_min_real_w
		from	man_ordem_servico a,
			MAN_ORDEM_SERVICO_EXEC c
		where	a.nr_Sequencia = c.nr_Seq_ordem
		and	coalesce(c.qt_min_prev,0) > 0
		and	a.ie_classificacao <> 'E'
		and	a.ie_status_ordem = '3'
		and	coalesce(a.cd_funcao,0) <> -3001
		and	coalesce(c.ie_considera_hpi,'S') = 'S'
		and	coalesce(a.nr_seq_Proj_cron_etapa::text, '') = ''
		and	coalesce(a.nr_seq_projeto::text, '') = ''
		and	a.dt_fim_real between dt_ref_inicio_w and dt_ref_fim_w
		and	c.nm_usuario_exec = nm_user_grupo_des_w					
		and	exists (SELECT 1
				from	man_ordem_serv_ativ e 
				where	a.nr_sequencia = e.nr_Seq_ordem_serv 
				and	c.nm_usuario_exec = e.nm_usuario_exec
				and	coalesce(e.qt_minuto,0) > 0);
				
	--Usuários previsão	
	elsif (cd_cargo_user_w in ('61','62','113','221','1354','1380','371','1393','1428','1430')) then
	
		select	sum(c.qt_min_prev) qt_min_prev,
			sum((select sum(d.qt_minuto) from man_ordem_serv_ativ d where a.nr_sequencia = d.nr_Seq_ordem_serv and c.nm_usuario_exec = d.nm_usuario_exec)) qt_real
		into STRICT	qt_min_prev_w,
			qt_min_real_w
		from	man_ordem_servico a,
			MAN_ORDEM_SERVICO_EXEC c
		where	a.nr_Sequencia = c.nr_Seq_ordem
		and	coalesce(c.qt_min_prev,0) > 0
		and	a.ie_classificacao <> 'E'
		and	a.ie_status_ordem = '3'
		and	coalesce(a.cd_funcao,0) <> -3001
		and	coalesce(c.ie_considera_hpi,'S') = 'S'
		and	coalesce(a.nr_seq_Proj_cron_etapa::text, '') = ''
		and	coalesce(a.nr_seq_projeto::text, '') = ''
		and	a.dt_fim_real between dt_ref_inicio_w and dt_ref_fim_w
		and	obter_cargo_usuario(c.nm_usuario_exec,'C') in ('66','69','73','133','1379') --Executadas por programador
		and	c.nm_usuario_prev = nm_user_grupo_des_w
		and	exists (SELECT 1
				from	man_ordem_serv_ativ e 
				where	a.nr_sequencia = e.nr_Seq_ordem_serv 
				and	c.nm_usuario_exec = e.nm_usuario_exec
				and	coalesce(e.qt_minuto,0) > 0);
	
	end if;
end if;

qt_min_prev_w	:= coalesce(qt_min_prev_w,0);
qt_min_real_w	:= coalesce(qt_min_real_w,0);

if (qt_min_real_w > 0) then
	select 	round((dividir(qt_min_prev_w,qt_min_real_w))::numeric,2)
	into STRICT	resultado_w
	;
else
	resultado_w := 1;
end if;

CALL PPM_GRAVAR_RESULTADO(nr_seq_objetivo_metrica_p, dt_referencia_p, resultado_w, resultado_w, resultado_w, nm_usuario_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ppm_metrica_hpi_os ( nr_seq_metrica_p bigint, nr_seq_objetivo_metrica_p bigint, cd_pessoa_fisica_p text, nm_usuario_p text, dt_referencia_p timestamp) FROM PUBLIC;

