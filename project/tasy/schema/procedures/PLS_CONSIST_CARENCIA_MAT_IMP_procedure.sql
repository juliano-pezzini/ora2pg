-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consist_carencia_mat_imp ( nr_seq_segurado_p pls_segurado.nr_sequencia%type, nr_seq_guia_mat_p pls_guia_plano_mat.nr_sequencia%type, nr_seq_guia_p bigint, nr_seq_conta_mat_p pls_conta_mat_imp.nr_sequencia%type, nr_seq_requisicao_mat_p pls_requisicao_mat.nr_sequencia%type, nr_seq_material_p pls_material.nr_sequencia%type, nr_seq_estrut_mat_p bigint, dt_solicitacao_p timestamp, nr_seq_tipo_acomod_p bigint, ie_tipo_guia_p text, ie_carencia_abrangencia_ant_p text, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


nr_seq_plano_w			bigint;
nr_seq_contrato_w		bigint;
nr_seq_segurado_w		bigint;
nr_seq_carencia_mat_w		bigint;
qt_dias_w			integer;
dt_inicio_vigencia_w		timestamp;
dt_carencia_w			timestamp;
dt_inclusao_operadora_w		timestamp;
ie_liberado_w			varchar(1);
ie_origem_w			varchar(1);
nr_seq_carencia_w		bigint;
ie_mes_posterior_w		varchar(1);
nr_seq_guia_w			bigint;
ie_tipo_cobertura_w		varchar(1);
nr_seq_prestador_w		bigint;
nr_seq_conta_w			bigint;
nr_seq_tipo_carencia_w		bigint;
ie_tipo_consistencia_w		varchar(2);
nr_requisicao_w			bigint;
ie_tipo_despesa_w		varchar(10);
ie_localizacao_w		varchar(255);
ds_carencia_w			varchar(255);
qt_carencia_mat_w		integer;
nr_seq_segurado_ant_w		bigint;
ie_consistir_caren_prod_ant_w	varchar(10);
dt_contratacao_w		timestamp;
ds_observacao_abrang_ant_w	varchar(255);
nr_seq_tipo_carencia_aux_w	bigint;
nr_seq_uni_exec_w		bigint;
qt_regra_carencia_w		integer;
ie_carater_solic_w		varchar(1);
nr_seq_regra_carencia_w		bigint;
qt_glosa_carencia_w		integer;
ie_gerar_glosa_w		varchar(1);
nr_seq_plano_aux_w		bigint;
qt_dias_fora_abrang_ant_w	pls_carencia.qt_dias_fora_abrang_ant%type;
ie_tipo_protocolo_w		varchar(1);
ie_valido_w			varchar(1);
nr_seq_rede_w			pls_carencia.nr_seq_rede%type;

c01 CURSOR FOR
	SELECT	a.nr_sequencia,
		coalesce(a.ie_mes_posterior,'N') ie_mes_posterior,
		a.nr_seq_tipo_carencia,
		a.nr_seq_rede
	from	pls_carencia a
	where	a.nr_seq_segurado = nr_seq_segurado_p
	
union all

	SELECT	a.nr_sequencia,
		coalesce(a.ie_mes_posterior,'N'),
		a.nr_seq_tipo_carencia,
		a.nr_seq_rede
	from	pls_carencia a
	where	a.nr_seq_contrato = nr_seq_contrato_w
	and	((a.nr_seq_plano_contrato = nr_seq_plano_w) or (coalesce(a.nr_seq_plano_contrato::text, '') = ''))
	and not exists (	select	1
			from	pls_carencia b
			where	b.nr_seq_segurado = nr_seq_segurado_p
			and	b.ie_cpt = 'N')
	
union all

	select	a.nr_sequencia,
		coalesce(a.ie_mes_posterior,'N'),
		a.nr_seq_tipo_carencia,
		a.nr_seq_rede
	from	pls_carencia a
	where	a.nr_seq_plano = nr_seq_plano_w
	and not exists (	select	1
			from	pls_carencia b
			where	b.nr_seq_segurado = nr_seq_segurado_p
			and	b.ie_cpt = 'N')
	and not exists (	select	1
			from	pls_carencia c
			where	c.nr_seq_contrato = nr_seq_contrato_w
			and	c.ie_cpt = 'N')
	and	((coalesce(a.dt_inicio_vig_plano::text, '') = '') or (dt_contratacao_w >= a.dt_inicio_vig_plano))
	and	((coalesce(a.dt_fim_vig_plano::text, '') = '') or (dt_contratacao_w <= a.dt_fim_vig_plano));

-- tudo que era feito OR passei a retornar no cursor e validar dentro do FOR

-- precisei colocar o nr_seq_material novamente por causa da quantidade de registros na carencia da UM
c02 CURSOR FOR
	SELECT	a.nr_sequencia nr_seq_carencia,
		a.ie_liberado,
		c.qt_dias,
		c.dt_inicio_vigencia,
		c.nr_seq_segurado,
		c.nr_seq_contrato,
		c.nr_seq_plano,
		a.nr_seq_tipo_carencia,
		a.ie_tipo_despesa ie_despesa,
		a.nr_seq_estrut_mat nr_seq_estru,
		a.nr_seq_material nr_seq_mat,
		CASE WHEN a.ie_liberado='S' THEN  0  ELSE 1 END  ie_lib,
		c.qt_dias_fora_abrang_ant,
		a.nr_seq_grupo_material,
		pls_se_grupo_preco_material(a.nr_seq_grupo_material, nr_seq_material_p) ie_grupo_preco_mat,
		pls_obter_se_mat_estrutura(nr_seq_material_p, a.nr_seq_estrut_mat) ie_estru_mat
	from	pls_carencia_mat a,
		pls_carencia c
	where	c.nr_sequencia = nr_seq_carencia_w
	and	a.nr_seq_tipo_carencia = c.nr_seq_tipo_carencia
	and (a.nr_seq_material = nr_seq_material_p or coalesce(a.nr_seq_material::text, '') = '')
	and not exists (	SELECT	1
			from	pls_tipo_carencia b
			where 	b.nr_sequencia = a.nr_seq_tipo_carencia
			and	b.ie_cpt = 'S')
	
union all

	select	a.nr_sequencia,
		a.ie_liberado,
		d.qt_dias,
		d.dt_inicio_vigencia,
		d.nr_seq_segurado,
		d.nr_seq_contrato,
		d.nr_seq_plano,
		a.nr_seq_tipo_carencia,
		a.ie_tipo_despesa ie_despesa,
		a.nr_seq_estrut_mat nr_seq_estru,
		a.nr_seq_material nr_seq_mat,
		CASE WHEN a.ie_liberado='S' THEN  0  ELSE 1 END  ie_lib,
		d.qt_dias_fora_abrang_ant,
		a.nr_seq_grupo_material,
		pls_se_grupo_preco_material(a.nr_seq_grupo_material, nr_seq_material_p) ie_grupo_preco_mat,
		pls_obter_se_mat_estrutura(nr_seq_material_p, a.nr_seq_estrut_mat) ie_estru_mat
	from	pls_carencia d,
		pls_grupo_carencia c,
		pls_tipo_carencia b,
		pls_carencia_mat a
	where	b.nr_sequencia = a.nr_seq_tipo_carencia
	and	d.nr_seq_grupo_carencia = c.nr_sequencia
	and	c.nr_sequencia = b.nr_seq_grupo
	and	d.nr_sequencia = nr_seq_carencia_w
	and	(d.nr_seq_grupo_carencia IS NOT NULL AND d.nr_seq_grupo_carencia::text <> '')
	and	a.nr_seq_material = nr_seq_material_p
	and	b.ie_cpt = 'N'
	
union all

	select	a.nr_sequencia,
		a.ie_liberado,
		d.qt_dias,
		d.dt_inicio_vigencia,
		d.nr_seq_segurado,
		d.nr_seq_contrato,
		d.nr_seq_plano,
		a.nr_seq_tipo_carencia,
		a.ie_tipo_despesa ie_despesa,
		a.nr_seq_estrut_mat nr_seq_estru,
		a.nr_seq_material nr_seq_mat,
		CASE WHEN a.ie_liberado='S' THEN  0  ELSE 1 END  ie_lib,
		d.qt_dias_fora_abrang_ant,
		a.nr_seq_grupo_material,
		pls_se_grupo_preco_material(a.nr_seq_grupo_material, nr_seq_material_p) ie_grupo_preco_mat,
		pls_obter_se_mat_estrutura(nr_seq_material_p, a.nr_seq_estrut_mat) ie_estru_mat
	from	pls_carencia d,
		pls_grupo_carencia c,
		pls_tipo_carencia b,
		pls_carencia_mat a
	where	b.nr_sequencia = a.nr_seq_tipo_carencia
	and	d.nr_seq_grupo_carencia = c.nr_sequencia
	and	c.nr_sequencia = b.nr_seq_grupo
	and	d.nr_sequencia = nr_seq_carencia_w
	and	(d.nr_seq_grupo_carencia IS NOT NULL AND d.nr_seq_grupo_carencia::text <> '')
	and	coalesce(a.nr_seq_material::text, '') = ''
	and	b.ie_cpt = 'N'
	order by ie_despesa,
		nr_seq_estru,
		nr_seq_mat,
		ie_lib;

BEGIN
if (coalesce(nr_seq_guia_mat_p,0) > 0) then
	ie_tipo_consistencia_w	:= 'G';
elsif (coalesce(nr_seq_conta_mat_p,0) > 0) then
	ie_tipo_consistencia_w	:= 'C';
elsif (coalesce(nr_seq_requisicao_mat_p,0) > 0) then
	ie_tipo_consistencia_w	:= 'R';
end if;

select	max(nr_seq_plano),
	max(nr_seq_contrato),
	max(dt_inclusao_operadora),
	max(nr_seq_segurado_ant),
	max(dt_contratacao)
into STRICT	nr_seq_plano_w,
	nr_seq_contrato_w,
	dt_inclusao_operadora_w,
	nr_seq_segurado_ant_w,
	dt_contratacao_w
from	pls_segurado
where	nr_sequencia	= nr_seq_segurado_p;

-- Obter dados do cadastro do material 
select	max(ie_tipo_despesa)
into STRICT	ie_tipo_despesa_w
from	pls_material
where	nr_sequencia = nr_seq_material_p;

--So entrar na rotina se tem carencia de material
select	count(1)
into STRICT	qt_carencia_mat_w
from	pls_carencia_mat LIMIT 1;

if (qt_carencia_mat_w > 0) then
	if (ie_tipo_consistencia_w = 'G') then
		select 	max(nr_seq_guia),
			max(ie_tipo_cobertura)
		into STRICT	nr_seq_guia_w,
			ie_tipo_cobertura_w
		from	pls_guia_plano_mat
		where	nr_sequencia = nr_seq_guia_mat_p;
		
		select	max(nr_seq_prestador),
			max(nr_seq_uni_exec),
			max(ie_carater_internacao)
		into STRICT	nr_seq_prestador_w,
			nr_seq_uni_exec_w,
			ie_carater_solic_w
		from	pls_guia_plano
		where	nr_sequencia = nr_seq_guia_w;
	elsif (ie_tipo_consistencia_w = 'C') then
		select	max(nr_seq_conta),
			max(ie_tipo_cobertura)
		into STRICT	nr_seq_conta_w,
			ie_tipo_cobertura_w
		from	pls_conta_mat_imp
		where	nr_sequencia = nr_seq_conta_mat_p;
		
		select	max(a.nr_seq_prestador_conv),
			--max(a.nr_seq_congenere),
			max(b.ie_carater_atendimento_conv),
			'C'
		into STRICT	nr_seq_prestador_w,
			--nr_seq_uni_exec_w,
			ie_carater_solic_w,
			ie_tipo_protocolo_w
		from	pls_protocolo_conta_imp a,
			pls_conta_imp b
		where	a.nr_sequencia = b.nr_seq_protocolo
		and	b.nr_sequencia = nr_seq_conta_w;
		
		if (ie_tipo_protocolo_w = 'R') then
			ie_tipo_consistencia_w := 'CR';
		end if;
	elsif (ie_tipo_consistencia_w = 'R') then
		select 	max(nr_seq_requisicao),
			max(ie_tipo_cobertura)
		into STRICT	nr_requisicao_w,
			ie_tipo_cobertura_w
		from	pls_requisicao_mat
		where	nr_sequencia = nr_seq_requisicao_mat_p;
		
		select	max(nr_seq_prestador),
			max(nr_seq_uni_exec),
			max(ie_carater_atendimento)
		into STRICT	nr_seq_prestador_w,
			nr_seq_uni_exec_w,
			ie_carater_solic_w
		from	pls_requisicao
		where	nr_sequencia = nr_requisicao_w;
	end if;
	
	ie_consistir_caren_prod_ant_w	:= 'S';
	
	if (ie_carencia_abrangencia_ant_p = 'S') and (nr_seq_segurado_p IS NOT NULL AND nr_seq_segurado_p::text <> '')then
		ie_consistir_caren_prod_ant_w := pls_obter_se_caren_plano_ant(nr_seq_segurado_p, nr_seq_plano_w, nr_seq_segurado_ant_w, nr_seq_prestador_w, nr_seq_uni_exec_w, ie_consistir_caren_prod_ant_w);
	end if;
	
	open c01;
	loop
	fetch c01 into
		nr_seq_carencia_w,
		ie_mes_posterior_w,
		nr_seq_tipo_carencia_aux_w,
		nr_seq_rede_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		select	count(1)
		into STRICT	qt_carencia_mat_w
		from	pls_carencia_mat a
		where	a.nr_seq_tipo_carencia = nr_seq_tipo_carencia_aux_w;

		if (nr_seq_rede_w IS NOT NULL AND nr_seq_rede_w::text <> '') then
			if (pls_obter_se_prest_rede_atend(nr_seq_prestador_w,nr_seq_rede_w) = 'N') then
				goto fim_cursor_C01;
			end if;
		end if;
		
		if (qt_carencia_mat_w > 0) then
			if (ie_mes_posterior_w = 'S') then
				dt_inclusao_operadora_w	:= add_months(trunc(dt_inclusao_operadora_w,'month'),1);
			end if;
			
			if (ie_tipo_consistencia_w in ('G','C','R','CR')) then
				ie_liberado_w	:= 'N';
				
				for r_c02_w in c02 loop
					ie_valido_w := 'S';
				
					-- tipo de despesa
					if (r_c02_w.ie_despesa IS NOT NULL AND r_c02_w.ie_despesa::text <> '') and (r_c02_w.ie_despesa != ie_tipo_despesa_w) then
						ie_valido_w := 'N';
					end if;
				
					-- se foi passado a estrutura de material por parametro so pode considerar as regras que tenham a mesma estrutura
					if (nr_seq_estrut_mat_p IS NOT NULL AND nr_seq_estrut_mat_p::text <> '') and (nr_seq_estrut_mat_p != r_c02_w.nr_seq_estru) then
						ie_valido_w := 'N';
					end if;

					-- se possui estrutura de material na regra entao verifica se o material pertence a estrutura
					if (r_c02_w.nr_seq_estru IS NOT NULL AND r_c02_w.nr_seq_estru::text <> '') and (r_c02_w.ie_estru_mat = 'N') then
						ie_valido_w := 'N';
					end if;
					
					-- se possui grupo de material informado entao verifica
					if (r_c02_w.nr_seq_grupo_material IS NOT NULL AND r_c02_w.nr_seq_grupo_material::text <> '') and (r_c02_w.ie_grupo_preco_mat = 'N') then
						ie_valido_w := 'N';
					end if;
					
					-- se for valido alimenta as variaveis, senao limpa elas a ultima ira definir se e ou nao valida
					if (ie_valido_w = 'S') then
						qt_dias_w := r_c02_w.qt_dias;
						ie_liberado_w := r_c02_w.ie_liberado;
						nr_seq_segurado_w := r_c02_w.nr_seq_segurado;
						nr_seq_contrato_w := r_c02_w.nr_seq_contrato;
						nr_seq_plano_aux_w := r_c02_w.nr_seq_plano;
						dt_inicio_vigencia_w := r_c02_w.dt_inicio_vigencia;
						nr_seq_carencia_mat_w := r_c02_w.nr_seq_carencia;
						nr_seq_tipo_carencia_w := r_c02_w.nr_seq_tipo_carencia;
						qt_dias_fora_abrang_ant_w := r_c02_w.qt_dias_fora_abrang_ant;
						exit;
					else
						qt_dias_w := null;
						ie_liberado_w := null;
						nr_seq_segurado_w := null;
						nr_seq_contrato_w := null;
						nr_seq_plano_aux_w := null;
						dt_inicio_vigencia_w := null;
						nr_seq_carencia_mat_w := null;
						nr_seq_tipo_carencia_w := null;
						qt_dias_fora_abrang_ant_w := null;
					end if;
				end loop;
				
				if (nr_seq_segurado_w IS NOT NULL AND nr_seq_segurado_w::text <> '') then
					ie_origem_w	:= 'B';
				elsif (nr_seq_contrato_w IS NOT NULL AND nr_seq_contrato_w::text <> '') then
					ie_origem_w	:= 'C';
				else
					ie_origem_w	:= 'P';
				end if;
				
				if (ie_liberado_w	= 'S') then
					ds_observacao_abrang_ant_w	:= '';
					/*Caso a abrangencia anterior nao tinha abrangencia no prestador atual, entao o sistema consiste a data pela migracao do produto novo*/

					if (ie_consistir_caren_prod_ant_w = 'N') then
						ds_observacao_abrang_ant_w	:= ' ' || wheb_mensagem_pck.get_texto(1108841);
						
						if (nr_seq_segurado_ant_w IS NOT NULL AND nr_seq_segurado_ant_w::text <> '') then
							dt_carencia_w := dt_contratacao_w + coalesce(qt_dias_fora_abrang_ant_w,qt_dias_w);
						else
							select	max(a.dt_alteracao)
							into STRICT	dt_carencia_w
							from	pls_segurado_alt_plano a
							where	a.nr_seq_segurado	= nr_seq_segurado_p
							and	a.nr_seq_plano_atual	= nr_seq_plano_w
							and	a.ie_situacao 		= 'A';
							
							dt_carencia_w := dt_carencia_w + coalesce(qt_dias_fora_abrang_ant_w,qt_dias_w);
						end if;
					else
						dt_carencia_w := coalesce(dt_inicio_vigencia_w,dt_inclusao_operadora_w) + qt_dias_w;
					end if;
					
					if (coalesce(dt_solicitacao_p,clock_timestamp()) < dt_carencia_w) then
						if (nr_seq_tipo_carencia_w IS NOT NULL AND nr_seq_tipo_carencia_w::text <> '') then
							select	ds_carencia
							into STRICT	ds_carencia_w
							from	pls_tipo_carencia
							where	nr_sequencia = nr_seq_tipo_carencia_w;
						end if;
						
						if (nr_seq_carencia_w IS NOT NULL AND nr_seq_carencia_w::text <> '') then
							select	CASE WHEN coalesce(nr_seq_segurado::text, '') = '' THEN (CASE WHEN coalesce(nr_seq_contrato::text, '') = '' THEN 'Produto'  ELSE 'Contrato' END )  ELSE wheb_mensagem_pck.get_texto(1108818) END
							into STRICT	ie_localizacao_w
							from	pls_carencia
							where	nr_sequencia	= nr_seq_carencia_w;
						end if;
						
						if (ie_tipo_consistencia_w = 'G') then
							select	count(1)
							into STRICT	qt_regra_carencia_w
							from	pls_regra_lanc_carencia LIMIT 1;
							
							if (qt_regra_carencia_w > 0) then
								nr_seq_regra_carencia_w := pls_obter_regra_carencia(	ie_carater_solic_w, nr_seq_plano_aux_w, nm_usuario_p, cd_estabelecimento_p, nr_seq_regra_carencia_w);
								
								if (nr_seq_regra_carencia_w > 0) then
									CALL pls_guia_gravar_historico(	nr_seq_guia_w, 2, wheb_mensagem_pck.get_texto(1108815, 'NR_SEQ_REGRA_CARENCIA='||nr_seq_regra_carencia_w),
													'', nm_usuario_p);
								else
									ie_gerar_glosa_w := 'S';
								end if;
							else
								ie_gerar_glosa_w := 'S';
							end if;
							
							if (ie_gerar_glosa_w = 'S') then
								update	pls_guia_plano_mat
								set	nr_seq_tipo_carencia = nr_seq_tipo_carencia_w
								where	nr_sequencia = nr_seq_guia_mat_p;
								
								CALL pls_gravar_motivo_glosa('1410', null, null,
											nr_seq_guia_mat_p, wheb_mensagem_pck.get_texto(1108799, 'NR_SEQ_TIPO_CARENCIA='||nr_seq_tipo_carencia_w||';DS_CARENCIA='||ds_carencia_w||';NR_SEQ_CARENCIA_MAT='||
											nr_seq_carencia_mat_w||';IE_LOCALIZACAO='||ie_localizacao_w||';DT_CARENCIA='||to_char(dt_carencia_w,'dd/mm/yyyy')||';QT_DIAS='||qt_dias_w||';DS_OBSERVACAO_ABRANG_ANT='||ds_observacao_abrang_ant_w), nm_usuario_p,
											ie_origem_w, 'CG', nr_seq_prestador_w,
											'(Regra ' || nr_seq_tipo_carencia_w || ' -> ' || nr_seq_carencia_mat_w || ')',null);
							end if;

						elsif (ie_tipo_consistencia_w = 'C') then
							select	count(1)
							into STRICT	qt_regra_carencia_w
							from	pls_regra_lanc_carencia LIMIT 1;
							
							if (qt_regra_carencia_w > 0) then
								nr_seq_regra_carencia_w := pls_obter_regra_carencia(	ie_carater_solic_w, nr_seq_plano_aux_w, nm_usuario_p, cd_estabelecimento_p, nr_seq_regra_carencia_w);
								
								if (nr_seq_regra_carencia_w > 0) then
									ie_gerar_glosa_w := 'N';
								else
									ie_gerar_glosa_w := 'S';
								end if;
							else
								ie_gerar_glosa_w := 'S';
							end if;
							
							if (ie_gerar_glosa_w = 'S') then
								CALL pls_gravar_conta_glosa('1410', null, null,
										nr_seq_conta_mat_p, 'N', wheb_mensagem_pck.get_texto(1108799, 'NR_SEQ_TIPO_CARENCIA='||nr_seq_tipo_carencia_w||';DS_CARENCIA='||ds_carencia_w||';NR_SEQ_CARENCIA_MAT='||
										nr_seq_carencia_mat_w||';IE_LOCALIZACAO='||ie_localizacao_w||';DT_CARENCIA='||to_char(dt_carencia_w,'dd/mm/yyyy')||';QT_DIAS='||qt_dias_w||';DS_OBSERVACAO_ABRANG_ANT='||ds_observacao_abrang_ant_w), nm_usuario_p,
										'A', 'CC', nr_seq_prestador_w,
										cd_estabelecimento_p, '', null);
							end if;

						elsif (ie_tipo_consistencia_w = 'R') then
							select	count(1)
							into STRICT	qt_regra_carencia_w
							from	pls_regra_lanc_carencia LIMIT 1;
							
							if (qt_regra_carencia_w > 0) then
								nr_seq_regra_carencia_w := pls_obter_regra_carencia(	ie_carater_solic_w, nr_seq_plano_aux_w, nm_usuario_p, cd_estabelecimento_p, nr_seq_regra_carencia_w);
								
								if (nr_seq_regra_carencia_w > 0) then
									CALL pls_requisicao_gravar_hist(	nr_requisicao_w, 'L', wheb_mensagem_pck.get_texto(1108815, 'NR_SEQ_REGRA_CARENCIA='||nr_seq_regra_carencia_w),
													null, nm_usuario_p);
								else
									ie_gerar_glosa_w := 'S';
								end if;
							else
								ie_gerar_glosa_w := 'S';
							end if;
							
							if (ie_gerar_glosa_w = 'S') then
								update	pls_requisicao_mat
								set	nr_seq_tipo_carencia = nr_seq_tipo_carencia_w
								where	nr_sequencia = nr_seq_requisicao_mat_p;

								CALL pls_gravar_requisicao_glosa(	'1410', null, null,
												nr_seq_requisicao_mat_p, wheb_mensagem_pck.get_texto(1108799, 'NR_SEQ_TIPO_CARENCIA='||nr_seq_tipo_carencia_w||';DS_CARENCIA='||ds_carencia_w||';NR_SEQ_CARENCIA_MAT='||
												nr_seq_carencia_mat_w||';IE_LOCALIZACAO='||ie_localizacao_w||';DT_CARENCIA='||to_char(dt_carencia_w,'dd/mm/yyyy')||';QT_DIAS='||qt_dias_w||';DS_OBSERVACAO_ABRANG_ANT='||ds_observacao_abrang_ant_w), nm_usuario_p,
												nr_seq_prestador_w, cd_estabelecimento_p, null,
												'');
							end if;
						elsif (ie_tipo_consistencia_w = 'CR') then
							CALL pls_gravar_conta_glosa('1410', null, null,
									nr_seq_conta_mat_p, 'N',wheb_mensagem_pck.get_texto(1108799, 'NR_SEQ_TIPO_CARENCIA='||nr_seq_tipo_carencia_w||';DS_CARENCIA='||ds_carencia_w||';NR_SEQ_CARENCIA_MAT='||
									nr_seq_carencia_mat_w||';IE_LOCALIZACAO='||ie_localizacao_w||';DT_CARENCIA='||to_char(dt_carencia_w,'dd/mm/yyyy')||';QT_DIAS='||qt_dias_w||';DS_OBSERVACAO_ABRANG_ANT='||ds_observacao_abrang_ant_w), nm_usuario_p,
									'A', 'CR', nr_seq_prestador_w,
									cd_estabelecimento_p, '', null);
						end if;
					end if;
				end if;
			end if;
		end if; /* So se tiver regra de carencia de material para esta carencia */
		<<fim_cursor_C01>>
		nr_seq_carencia_w	:= nr_seq_carencia_w;
	end loop;
	close c01;
end if;

select	count(1)
into STRICT	qt_regra_carencia_w
from	pls_regra_lanc_carencia LIMIT 1;

if (qt_regra_carencia_w > 0) then
	if (ie_tipo_consistencia_w in ('C','CR')) then
		select	count(1)
		into STRICT	qt_glosa_carencia_w
		from	pls_conta_glosa a,
			tiss_motivo_glosa b
		where	a.nr_seq_motivo_glosa = b.nr_sequencia
		and	b.cd_motivo_tiss = '1410'
		and	a.nr_seq_conta_mat = nr_seq_conta_mat_p  LIMIT 1;
		
		if (qt_glosa_carencia_w > 0) then
			nr_seq_regra_carencia_w := pls_obter_regra_carencia(	ie_carater_solic_w, nr_seq_plano_w, nm_usuario_p, cd_estabelecimento_p, nr_seq_regra_carencia_w);
			
			if (nr_seq_regra_carencia_w > 0) then
				update	pls_conta_glosa x
				set	x.ie_situacao 	= 'I',
					x.ds_observacao = wheb_mensagem_pck.get_texto(1108798, 'NR_SEQ_REGRA_CARENCIA='||nr_seq_regra_carencia_w)
				where	x.nr_sequencia in (	SELECT	a.nr_sequencia
								from	pls_conta_glosa		a,
									tiss_motivo_glosa	b
								where	a.nr_seq_motivo_glosa 	= b.nr_sequencia
								and	b.cd_motivo_tiss	= '1410'
								and	a.nr_seq_conta_mat	= nr_seq_conta_mat_p   LIMIT 1);
				
				update	pls_ocorrencia_benef x
				set	x.ie_situacao 	= 'I',
					x.ds_observacao = wheb_mensagem_pck.get_texto(1108797, 'NR_SEQ_REGRA_CARENCIA='||nr_seq_regra_carencia_w)
				where	x.nr_seq_glosa in (	SELECT	a.nr_sequencia
								from	pls_conta_glosa		a,
									tiss_motivo_glosa	b
								where	a.nr_seq_motivo_glosa 	= b.nr_sequencia
								and	b.cd_motivo_tiss	= '1410'
								and	a.nr_seq_conta_mat	= nr_seq_conta_mat_p   LIMIT 1);
			end if;
		end if;
	end if;
end if;

-- nao utilizar commit nesta rotina
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consist_carencia_mat_imp ( nr_seq_segurado_p pls_segurado.nr_sequencia%type, nr_seq_guia_mat_p pls_guia_plano_mat.nr_sequencia%type, nr_seq_guia_p bigint, nr_seq_conta_mat_p pls_conta_mat_imp.nr_sequencia%type, nr_seq_requisicao_mat_p pls_requisicao_mat.nr_sequencia%type, nr_seq_material_p pls_material.nr_sequencia%type, nr_seq_estrut_mat_p bigint, dt_solicitacao_p timestamp, nr_seq_tipo_acomod_p bigint, ie_tipo_guia_p text, ie_carencia_abrangencia_ant_p text, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

