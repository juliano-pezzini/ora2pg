-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ppm_metrica_satisf_os ( nr_seq_metrica_p bigint, nr_seq_objetivo_metrica_p bigint, cd_pessoa_fisica_p text, nm_usuario_p text, dt_referencia_p timestamp) AS $body$
DECLARE

			
resultado_w			double precision;
qt_satisfacao_w		bigint;
qt_os_insatisf_w	bigint;
dt_ref_inicio_w		timestamp;
dt_ref_fim_w		timestamp;
dt_referencia_w		timestamp;
nr_seq_diretoria_w	ppm_objetivo.nr_seq_diretoria%type;
nr_seq_gerencia_w	ppm_objetivo.nr_seq_gerencia%type;
nr_seq_grupo_w		ppm_objetivo.nr_seq_grupo%type;
nr_seq_grupo_des_w	grupo_desenvolvimento.nr_sequencia%type;
nm_user_grupo_des_w	usuario_grupo_des.nm_usuario_grupo%type;
cd_cargo_user_w		cargo.cd_cargo%type;
qt_min_prev_exec_w	double precision;
qt_min_prev_ativ_w	double precision;
qt_min_prev_exec_ww	double precision;
qt_min_prev_ativ_ww	double precision;
qt_os_insatisfacao_w	bigint;
pr_satisf_w				double precision;
	

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
	--Buscar Satisfação da OS por todos os usuários de determinado grupo
	
	select Obter_informacao_os_grupo(dt_ref_inicio_w, nr_seq_grupo_w, 'ENS', null, 'DES,TEC')
	into STRICT qt_satisfacao_w	
	;
		
	select Obter_informacao_os_grupo(dt_ref_inicio_w, nr_seq_grupo_w, 'QTI', null, 'DES,TEC')
	into STRICT qt_os_insatisf_w	
	;									

elsif (nr_seq_gerencia_w IS NOT NULL AND nr_seq_gerencia_w::text <> '') then

	select Obter_informacao_os_gerencia(dt_ref_inicio_w, nr_seq_gerencia_w, 'ENS', '', 'DES,TEC')
	into STRICT qt_satisfacao_w	
	;
		
	select Obter_informacao_os_gerencia(dt_ref_inicio_w, nr_seq_gerencia_w, 'QTI', '', 'DES,TEC')
	into STRICT qt_os_insatisf_w	
	;	
		
elsif (nr_seq_diretoria_w IS NOT NULL AND nr_seq_diretoria_w::text <> '') then

	select Obter_info_os_diretoria(dt_ref_inicio_w, nr_seq_diretoria_w, 'ENS', '')
	into STRICT qt_satisfacao_w	
	;
		
	select Obter_info_os_diretoria(dt_ref_inicio_w, nr_seq_diretoria_w, 'QTI', '')
	into STRICT qt_os_insatisf_w	
	;
		
elsif (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then

		select	coalesce(max(a.qt_excelente + a.qt_regular + a.qt_ruim + a.qt_otimo + a.qt_bom),0),
			coalesce(max(a.qt_regular + a.qt_ruim),0) qt_os_insatisfacao,
			coalesce(max(a.pr_satisf),100)
		into STRICT	qt_satisfacao_w,
			qt_os_insatisf_w,
			pr_satisf_w
		from	(SELECT	x.nm_pessoa_fisica nm_usuario,
				x.nm_usuario_exec,
				sum(CASE WHEN x.ie_grau_satisfacao='R' THEN 1  ELSE 0 END ) qt_regular,
				sum(CASE WHEN x.ie_grau_satisfacao='P' THEN 1  ELSE 0 END ) qt_ruim,
				sum(CASE WHEN x.ie_grau_satisfacao='E' THEN 1  ELSE 0 END ) qt_excelente,
				sum(CASE WHEN x.ie_grau_satisfacao='O' THEN 1  ELSE 0 END ) qt_otimo,
				sum(CASE WHEN x.ie_grau_satisfacao='B' THEN 1  ELSE 0 END ) qt_bom,
				sum(1) qt_total,
				(dividir(sum(CASE WHEN x.ie_grau_satisfacao='O' THEN 1 WHEN x.ie_grau_satisfacao='B' THEN 1  ELSE 0 END ),
				sum(CASE WHEN x.ie_grau_satisfacao='O' THEN 1 WHEN x.ie_grau_satisfacao='B' THEN 1 WHEN x.ie_grau_satisfacao='R' THEN 1 WHEN x.ie_grau_satisfacao='P' THEN 1  ELSE 0 END )) * 100) pr_satisf
			from  ( select	a.nr_sequencia,
					c.nm_usuario_exec,
					a.ie_grau_satisfacao,
					e.nm_pessoa_fisica
				from   	man_ordem_servico a,
					grupo_desenvolvimento b,
					usuario_grupo_des g,
					man_ordem_servico_exec c,
					usuario d,
					pessoa_fisica e,
					man_localizacao l
				where  	a.nr_seq_grupo_des	= b.nr_sequencia
				and    	a.nr_sequencia		=  c.nr_seq_ordem
				and    	c.nm_usuario_exec	= d.nm_usuario
				and    	d.cd_pessoa_fisica	= e.cd_pessoa_fisica
				and	a.nr_seq_localizacao 	= l.nr_sequencia
				and    	trunc(a.dt_fim_real,'month') = trunc(dt_referencia_w,'month')				
				and    	b.nr_sequencia		= g.nr_seq_grupo
				and	g.nm_usuario_grupo	= d.nm_usuario
				and	e.cd_pessoa_fisica 	= cd_pessoa_fisica_p
				and	coalesce(c.dt_fim_execucao::text, '') = ''
				and	l.ie_terceiro = 'S'
				--and      nvl(a.nr_seq_gerencia_insatisf,b.nr_seq_gerencia)   = c05_w.nr_seq_gerencia
				and      c.nm_usuario_exec    =  (	select   max(k.nm_usuario_exec) nm_usuario_exec
									from     man_ordem_servico_exec k
									where    k.nr_seq_ordem	= a.nr_sequencia
									and exists (	select   1
													from     usuario_grupo_des l
													where    k.nm_usuario_exec = l.nm_usuario_grupo))
				and		(a.ie_grau_satisfacao IS NOT NULL AND a.ie_grau_satisfacao::text <> '')
				and    	exists (select   1
						from    man_estagio_processo c,
							man_ordem_serv_estagio b
						where   b.nr_seq_estagio        = c.nr_sequencia
						and     c.ie_desenv             = 'S'
						and     a.nr_sequencia          = b.nr_seq_ordem)) x
				group by x.nm_pessoa_fisica,
						x.nm_usuario_exec) a;	
		
end if;

if (qt_os_insatisf_w > 0) and (qt_satisfacao_w > 0) then
	
	resultado_w	:= 100 - (dividir(qt_os_insatisf_w, qt_satisfacao_w) * 100);
else
	resultado_w 	:= 100;
end if;	

CALL PPM_GRAVAR_RESULTADO(nr_seq_objetivo_metrica_p, dt_referencia_p, resultado_w, null, null, nm_usuario_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ppm_metrica_satisf_os ( nr_seq_metrica_p bigint, nr_seq_objetivo_metrica_p bigint, cd_pessoa_fisica_p text, nm_usuario_p text, dt_referencia_p timestamp) FROM PUBLIC;
