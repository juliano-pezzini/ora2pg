-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_oc_cta_tratar_val_54 ( dados_regra_p pls_tipos_ocor_pck.dados_regra, nr_id_transacao_p pls_oc_cta_selecao_ocor_v.nr_id_transacao%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


tb_valido_w			dbms_sql.varchar2_table;
tb_observacao_w			dbms_sql.varchar2_table;
tb_seq_selecao_w		dbms_sql.number_table;
ie_autorizado_w			varchar(1);
ie_gerar_glosa_w		varchar(1);
ie_carencia_w			varchar(1);
ie_carencia_ant_w		varchar(1);
ie_consistir_caren_prod_ant_w	varchar(10);
ds_observacao_w			varchar(4000);
ds_observacao_abrang_ant_w	varchar(4000);
qt_regra_carencia_w		integer;
qt_carencia_mat_w		integer;
i				integer := 0;
nr_seq_plano_w			pls_plano.nr_sequencia%type;
nr_seq_contrato_w		pls_contrato.nr_sequencia%type;
dt_inclusao_operadora_w		pls_segurado.dt_inclusao_operadora%type;
dt_contratacao_w		pls_segurado.dt_contratacao%type;
nr_seq_segurado_ant_w		pls_segurado.nr_sequencia%type;
cd_area_w			area_procedimento.cd_area_procedimento%type;
cd_especialidade_w		especialidade_proc.cd_especialidade%type;
cd_grupo_w			grupo_proc.cd_grupo_proc%type;
ie_origem_proced_w		procedimento.ie_origem_proced%type;
ie_rede_atend_w			pls_prestador_rede_atend.ie_permite%type;
dt_carencia_w			pls_segurado_alt_plano.dt_alteracao%type;
nr_seq_regra_carencia_w		pls_regra_lanc_carencia.nr_sequencia%type;
ie_tipo_guia_solic_w		pls_guia_plano.ie_tipo_guia%type;
nr_seq_tipo_acomod_w		pls_guia_plano.nr_seq_tipo_acomodacao%type;
nr_seq_plano_aux_w		pls_plano.nr_sequencia%type;
dt_alteracao_ant_w		pls_segurado_alt_plano.dt_alteracao%type;
ie_serv_lib_w			varchar(1);
qt_reg_w			integer;

-- Informacoes da validacao guia principal autorizacao
C01 CURSOR(	nr_seq_oc_cta_comb_pc	pls_oc_cta_combinada.nr_sequencia%type) FOR
	SELECT	ie_valida_proc,
		ie_valida_mat
	from	pls_oc_cta_val_carencia a
	where	a.nr_seq_oc_cta_comb	= nr_seq_oc_cta_comb_pc;
	
C02 CURSOR(	nr_id_transacao_pc	pls_oc_cta_selecao_imp.nr_id_transacao%type) FOR
	SELECT	conta.nr_seq_prestador,
		conta.cd_guia_ok,
		conta.nr_seq_segurado,
		conta.ie_carater_internacao,
		proc.cd_procedimento,
		proc.ie_origem_proced,
		proc.qt_procedimento_imp,
		conta.dt_atendimento_referencia dt_solicitacao,
		conta.nr_seq_guia,
		sel.nr_sequencia nr_seq_selecao,
		(SELECT	coalesce(sum(qt_procedimento_imp),0)
		 from	pls_conta_proc x
		 where	x.nr_seq_conta = proc.nr_seq_conta
		 and	x.cd_procedimento = proc.cd_procedimento
		 and	x.ie_origem_proced = proc.ie_origem_proced
		 and	x.nr_sequencia <> proc.nr_sequencia) qt_executado,
		(select	coalesce(sum(x.qt_autorizada),0)
		 from	pls_guia_plano_proc x,
			pls_guia_plano y
		 where	x.nr_seq_guia = y.nr_sequencia
		 and (y.cd_guia = conta.cd_guia_ok or y.cd_guia_principal = conta.cd_guia_ok)
		 and	y.ie_status = '1'
		 and	y.nr_seq_segurado = conta.nr_seq_segurado
		 and	x.cd_procedimento = proc.cd_procedimento
		 and	x.ie_origem_proced = proc.ie_origem_proced) qt_autorizada,
		 (select	coalesce(sum(x.qt_autorizada),0)
		 from	pls_guia_plano_proc x,
			pls_guia_plano y
		 where	x.nr_seq_guia = y.nr_sequencia
		 and (y.nr_sequencia = conta.nr_seq_guia)
		 and	y.ie_status = '1'
		 and	y.nr_seq_segurado = conta.nr_seq_segurado
		 and	x.cd_procedimento = proc.cd_procedimento
		 and	x.ie_origem_proced = proc.ie_origem_proced) qt_autorizada_a500,
		conta.ie_origem_conta,
		proc.nr_sequencia nr_seq_conta_proc
	from	pls_selecao_ocor_cta	sel,
		pls_conta		conta,
		pls_protocolo_conta	prot,
		pls_conta_proc		proc
	where	sel.nr_id_transacao	= nr_id_transacao_pc
	and	sel.ie_valido		= 'S'
	and	proc.nr_sequencia	= sel.nr_seq_conta_proc
	and 	prot.nr_sequencia	= conta.nr_seq_protocolo
	and 	conta.nr_sequencia	= proc.nr_seq_conta
	order by conta.nr_seq_segurado, proc.cd_procedimento;
	
C03 CURSOR(	nr_seq_segurado_pc		pls_conta_imp.nr_seq_segurado_conv%type,
		nr_seq_contrato_pc		pls_carencia.nr_seq_contrato%type,
		nr_seq_plano_pc			pls_segurado.nr_seq_plano%type,
		dt_contratacao_pc		timestamp,
		ie_consistir_caren_prod_ant_pc	text,
		nr_seq_segurado_ant_pc		pls_segurado.nr_sequencia%type,
		dt_alteracao_ant_pc		pls_segurado_alt_plano.dt_alteracao%type,
		dt_inclusao_operadora_pc	pls_segurado.dt_inclusao_operadora%type) FOR
	SELECT	x.nr_sequencia nr_seq_carencia,
		'N' ie_mes_posterior,
		wheb_mensagem_pck.get_texto(1108818) ie_localizacao,
		null nr_seq_plano_contrato,
		x.nr_seq_rede,
		x.qt_dias,
		pls_obter_dt_carencia(	ie_consistir_caren_prod_ant_pc, nr_seq_segurado_ant_pc, dt_contratacao_pc, dt_alteracao_ant_pc,
					x.qt_dias_fora_abrang_ant, x.qt_dias, x.dt_inicio_vigencia, dt_inclusao_operadora_pc) dt_carencia
	from	pls_carencia x
	where	x.nr_seq_segurado	= nr_seq_segurado_pc
	and	x.ie_cpt		= 'N'
	
union all

	SELECT	x.nr_sequencia nr_seq_carencia,
		coalesce(x.ie_mes_posterior, 'N') ie_mes_posterior,
		'Contrato' ie_localizacao,
		x.nr_seq_plano_contrato,
		x.nr_seq_rede,
		x.qt_dias,
		pls_obter_dt_carencia(	ie_consistir_caren_prod_ant_pc, nr_seq_segurado_ant_pc, dt_contratacao_pc, dt_alteracao_ant_pc,
					x.qt_dias_fora_abrang_ant, x.qt_dias, x.dt_inicio_vigencia, dt_inclusao_operadora_pc) dt_carencia
	from	pls_carencia x
	where	x.nr_seq_contrato	= nr_seq_contrato_pc
	and	x.ie_cpt		= 'N'
	and not exists (	select	1
					from	pls_carencia b
					where	b.nr_seq_segurado = nr_seq_segurado_pc
					and	b.ie_cpt = 'N')
	
union all

	select	x.nr_sequencia nr_seq_carencia,
		'N' ie_mes_posterior,
		'Produto' ie_localizacao,
		null nr_seq_plano_contrato,
		x.nr_seq_rede,
		x.qt_dias,
		pls_obter_dt_carencia(	ie_consistir_caren_prod_ant_pc, nr_seq_segurado_ant_pc, dt_contratacao_pc, dt_alteracao_ant_pc,
					x.qt_dias_fora_abrang_ant, x.qt_dias, x.dt_inicio_vigencia, dt_inclusao_operadora_pc) dt_carencia
	from	pls_carencia x
	where	nr_seq_plano		= nr_seq_plano_pc
	and	x.ie_cpt		= 'N'
	and not exists (	select	1
			from	pls_carencia b
			where	b.nr_seq_segurado = nr_seq_segurado_pc
			and	b.ie_cpt = 'N')
	and not exists (	select	1
			from	pls_carencia c
			where	c.nr_seq_contrato = nr_seq_contrato_pc
			and	c.ie_cpt = 'N')
	and	((coalesce(x.dt_inicio_vig_plano::text, '') = '') or (dt_contratacao_pc >= x.dt_inicio_vig_plano))
	and	((coalesce(x.dt_fim_vig_plano::text, '') = '') or (dt_contratacao_pc <= x.dt_fim_vig_plano));

C04 CURSOR(	nr_seq_carencia_pc	pls_carencia.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia nr_seq_carencia_proc,
		a.ie_liberado,
		a.nr_seq_tipo_carencia,
		a.cd_procedimento cd_proc,
		a.ie_origem_proced,
		a.cd_grupo_proc cd_grupo,
		a.cd_especialidade cd_espec,
		a.cd_area_procedimento cd_area,
		CASE WHEN a.ie_liberado='S' THEN  0  ELSE 1 END  ie_lib,
		b.ds_carencia,
		a.nr_seq_grupo_servico,
		a.nr_seq_tipo_acomodacao,
		a.ie_tipo_guia
	from	pls_carencia 		c,
		pls_tipo_carencia	b,
		pls_carencia_proc 	a
	where	c.nr_sequencia = nr_seq_carencia_pc
	and	c.ie_cpt = 'N'
	and 	b.nr_sequencia = c.nr_seq_tipo_carencia
	and	a.nr_seq_tipo_carencia = b.nr_sequencia
	--and  	nvl(a.nr_seq_tipo_acomodacao, (-1)) = -1 -- Nao retirar essa tratamento, e utilziado index function aqui

	--and  	nvl(a.ie_tipo_guia, '-1') = '-1' -- Nao retirar essa tratamento, e utilziado index function aqui
	
union all

	SELECT	a.nr_sequencia nr_seq_carencia_proc,
		a.ie_liberado,
		a.nr_seq_tipo_carencia,
		a.cd_procedimento cd_proc,
		a.ie_origem_proced,
		a.cd_grupo_proc cd_grupo,
		a.cd_especialidade cd_espec,
		a.cd_area_procedimento cd_area,
		CASE WHEN a.ie_liberado='S' THEN  0  ELSE 1 END  ie_lib,
		b.ds_carencia,
		a.nr_seq_grupo_servico,
		a.nr_seq_tipo_acomodacao,
		a.ie_tipo_guia
	from	pls_carencia 		d,
		pls_grupo_carencia	c,
		pls_tipo_carencia	b,
		pls_carencia_proc	a
	where	d.nr_sequencia = nr_seq_carencia_pc
	and	d.ie_cpt = 'N'
	and	d.nr_seq_grupo_carencia > 0
	and	c.nr_sequencia = d.nr_seq_grupo_carencia
	and	b.nr_seq_grupo = c.nr_sequencia
	and	a.nr_seq_tipo_carencia = b.nr_sequencia
	--and  	nvl(a.nr_seq_tipo_acomodacao, (-1)) = -1 -- Nao retirar essa tratamento, e utilziado index function aqui

	--and	nvl(a.ie_tipo_guia, '-1') = '-1' -- Nao retirar essa tratamento, e utilziado index function aqui
	order by nr_seq_grupo_servico,
		cd_area,
		cd_espec,
		cd_grupo,
		cd_proc,
		ie_lib;
	
C06 CURSOR(	nr_id_transacao_pc	pls_oc_cta_selecao_imp.nr_id_transacao%type) FOR
	SELECT	conta.nr_seq_prestador,
		conta.cd_guia_ok,
		conta.nr_seq_segurado,
		conta.ie_carater_internacao,
		conta.dt_atendimento_referencia dt_solicitacao,
		conta.nr_seq_guia,
		sel.nr_sequencia nr_seq_selecao,
		c_mat.ie_tipo_despesa,
		c_mat.nr_seq_material,
		mat.nr_seq_estrut_mat
	from	pls_selecao_ocor_cta	sel,
		pls_conta		conta,
		pls_protocolo_conta	prot,
		pls_conta_mat		c_mat,
		pls_material		mat
	where	sel.nr_id_transacao	= nr_id_transacao_pc
	and	sel.ie_valido		= 'S'
	and	mat.nr_sequencia	= sel.nr_seq_conta_mat
	and 	prot.nr_sequencia	= conta.nr_seq_protocolo
	and 	conta.nr_sequencia	= c_mat.nr_seq_conta
	and 	c_mat.nr_seq_material	= mat.nr_sequencia;
	
c07 CURSOR(	nr_seq_segurado_pc		pls_conta_imp.nr_seq_segurado_conv%type,
		nr_seq_contrato_pc		pls_carencia.nr_seq_contrato%type,
		nr_seq_plano_pc			pls_segurado.nr_seq_plano%type,
		dt_contratacao_pc		timestamp,
		ie_consistir_caren_prod_ant_pc	text,
		nr_seq_segurado_ant_pc		pls_segurado.nr_sequencia%type,
		dt_alteracao_ant_pc		pls_segurado_alt_plano.dt_alteracao%type,
		dt_inclusao_operadora_pc	pls_segurado.dt_inclusao_operadora%type) FOR
	SELECT	a.nr_sequencia nr_seq_carencia,
		coalesce(a.ie_mes_posterior,'N') ie_mes_posterior,
		a.nr_seq_tipo_carencia,
		a.nr_seq_rede,
		a.qt_dias,
		wheb_mensagem_pck.get_texto(1108818) ie_localizacao,
		pls_obter_dt_carencia(	ie_consistir_caren_prod_ant_pc, nr_seq_segurado_ant_pc, dt_contratacao_pc, dt_alteracao_ant_pc,
					a.qt_dias_fora_abrang_ant, a.qt_dias, a.dt_inicio_vigencia, dt_inclusao_operadora_pc) dt_carencia
	from	pls_carencia a
	where	a.nr_seq_segurado = nr_seq_segurado_pc
	
union all

	SELECT	a.nr_sequencia nr_seq_carencia,
		coalesce(a.ie_mes_posterior,'N'),
		a.nr_seq_tipo_carencia,
		a.nr_seq_rede,
		a.qt_dias,
		'Contrato' ie_localizacao,
		pls_obter_dt_carencia(	ie_consistir_caren_prod_ant_pc, nr_seq_segurado_ant_pc, dt_contratacao_pc, dt_alteracao_ant_pc,
					a.qt_dias_fora_abrang_ant, a.qt_dias, a.dt_inicio_vigencia, dt_inclusao_operadora_pc) dt_carencia
	from	pls_carencia a
	where	a.nr_seq_contrato = nr_seq_contrato_pc
	and	((a.nr_seq_plano_contrato = nr_seq_plano_pc) or (coalesce(a.nr_seq_plano_contrato::text, '') = ''))
	and not exists (	select	1
			from	pls_carencia b
			where	b.nr_seq_segurado = nr_seq_segurado_pc
			and	b.ie_cpt = 'N')
	
union all

	select	a.nr_sequencia nr_seq_carencia,
		coalesce(a.ie_mes_posterior,'N'),
		a.nr_seq_tipo_carencia,
		a.nr_seq_rede,
		a.qt_dias,
		'Produto' ie_localizacao,
		pls_obter_dt_carencia(	ie_consistir_caren_prod_ant_pc, nr_seq_segurado_ant_pc, dt_contratacao_pc, dt_alteracao_ant_pc,
					a.qt_dias_fora_abrang_ant, a.qt_dias, a.dt_inicio_vigencia, dt_inclusao_operadora_pc) dt_carencia
	from	pls_carencia a
	where	a.nr_seq_plano = nr_seq_plano_pc
	and not exists (	select	1
			from	pls_carencia b
			where	b.nr_seq_segurado = nr_seq_segurado_pc
			and	b.ie_cpt = 'N')
	and not exists (	select	1
			from	pls_carencia c
			where	c.nr_seq_contrato = nr_seq_contrato_pc
			and	c.ie_cpt = 'N')
	and	((coalesce(a.dt_inicio_vig_plano::text, '') = '') or (dt_contratacao_pc >= a.dt_inicio_vig_plano))
	and	((coalesce(a.dt_fim_vig_plano::text, '') = '') or (dt_contratacao_pc <= a.dt_fim_vig_plano));
	
C08 CURSOR(	nr_seq_carencia_pc	pls_carencia.nr_sequencia%type,
		nr_seq_material_pc	pls_conta_mat_imp.nr_seq_material_conv%type) FOR
	SELECT	a.nr_sequencia nr_seq_carencia_mat,
		a.ie_liberado,
		a.nr_seq_tipo_carencia,
		a.ie_tipo_despesa ie_despesa,
		a.nr_seq_estrut_mat nr_seq_estru,
		a.nr_seq_material nr_seq_mat,
		CASE WHEN a.ie_liberado='S' THEN  0  ELSE 1 END  ie_lib,
		a.nr_seq_grupo_material,
		pls_se_grupo_preco_material(a.nr_seq_grupo_material, nr_seq_material_pc) ie_grupo_preco_mat,
		pls_obter_se_mat_estrutura(nr_seq_material_pc, a.nr_seq_estrut_mat) ie_estru_mat,
		b.ds_carencia
	from	pls_carencia_mat a,
		pls_tipo_carencia b,
		pls_carencia c
	where	c.nr_sequencia = nr_seq_carencia_pc
	and	a.nr_seq_tipo_carencia = b.nr_sequencia
	and	c.nr_seq_tipo_carencia = b.nr_sequencia
	and (a.nr_seq_material = nr_seq_material_pc or coalesce(a.nr_seq_material::text, '') = '')
	and not exists (	SELECT	1
			from	pls_tipo_carencia b
			where 	b.nr_sequencia = a.nr_seq_tipo_carencia
			and	b.ie_cpt = 'S')
	
union all

	select	a.nr_sequencia nr_seq_carencia_mat,
		a.ie_liberado,
		a.nr_seq_tipo_carencia,
		a.ie_tipo_despesa ie_despesa,
		a.nr_seq_estrut_mat nr_seq_estru,
		a.nr_seq_material nr_seq_mat,
		CASE WHEN a.ie_liberado='S' THEN  0  ELSE 1 END  ie_lib,
		a.nr_seq_grupo_material,
		pls_se_grupo_preco_material(a.nr_seq_grupo_material, nr_seq_material_pc) ie_grupo_preco_mat,
		pls_obter_se_mat_estrutura(nr_seq_material_pc, a.nr_seq_estrut_mat) ie_estru_mat,
		b.ds_carencia
	from	pls_carencia_mat a,
		pls_tipo_carencia b,
		pls_carencia c
	where	c.nr_sequencia = nr_seq_carencia_pc
	and	a.nr_seq_tipo_carencia = b.nr_sequencia
	and	c.nr_seq_tipo_carencia = b.nr_sequencia
	and	coalesce(a.nr_seq_material::text, '') = ''
	and not exists (	select	1
			from	pls_tipo_carencia b
			where 	b.nr_sequencia = a.nr_seq_tipo_carencia
			and	b.ie_cpt = 'S')
	
union all

	select	a.nr_sequencia nr_seq_carencia_mat,
		a.ie_liberado,
		a.nr_seq_tipo_carencia,
		a.ie_tipo_despesa ie_despesa,
		a.nr_seq_estrut_mat nr_seq_estru,
		a.nr_seq_material nr_seq_mat,
		CASE WHEN a.ie_liberado='S' THEN  0  ELSE 1 END  ie_lib,
		a.nr_seq_grupo_material,
		pls_se_grupo_preco_material(a.nr_seq_grupo_material, nr_seq_material_pc) ie_grupo_preco_mat,
		pls_obter_se_mat_estrutura(nr_seq_material_pc, a.nr_seq_estrut_mat) ie_estru_mat,
		b.ds_carencia
	from	pls_carencia d,
		pls_grupo_carencia c,
		pls_tipo_carencia b,
		pls_carencia_mat a
	where	b.nr_sequencia = a.nr_seq_tipo_carencia
	and	d.nr_seq_grupo_carencia = c.nr_sequencia
	and	c.nr_sequencia = b.nr_seq_grupo
	and	d.nr_sequencia = nr_seq_carencia_pc
	and	(d.nr_seq_grupo_carencia IS NOT NULL AND d.nr_seq_grupo_carencia::text <> '')
	and	b.ie_cpt = 'N'
	and	a.nr_seq_material = nr_seq_material_pc
	
union all

	select	a.nr_sequencia nr_seq_carencia_mat,
		a.ie_liberado,
		a.nr_seq_tipo_carencia,
		a.ie_tipo_despesa ie_despesa,
		a.nr_seq_estrut_mat nr_seq_estru,
		a.nr_seq_material nr_seq_mat,
		CASE WHEN a.ie_liberado='S' THEN  0  ELSE 1 END  ie_lib,
		a.nr_seq_grupo_material,
		pls_se_grupo_preco_material(a.nr_seq_grupo_material, nr_seq_material_pc) ie_grupo_preco_mat,
		pls_obter_se_mat_estrutura(nr_seq_material_pc, a.nr_seq_estrut_mat) ie_estru_mat,
		b.ds_carencia
	from	pls_carencia d,
		pls_grupo_carencia c,
		pls_tipo_carencia b,
		pls_carencia_mat a
	where	b.nr_sequencia = a.nr_seq_tipo_carencia
	and	d.nr_seq_grupo_carencia = c.nr_sequencia
	and	c.nr_sequencia = b.nr_seq_grupo
	and	d.nr_sequencia = nr_seq_carencia_pc
	and	(d.nr_seq_grupo_carencia IS NOT NULL AND d.nr_seq_grupo_carencia::text <> '')
	and	b.ie_cpt = 'N'
	and	coalesce(a.nr_seq_material::text, '') = ''
	order by ie_despesa,
		nr_seq_estru,
		nr_seq_mat,
		ie_lib;
	
BEGIN
if (dados_regra_p.nr_sequencia IS NOT NULL AND dados_regra_p.nr_sequencia::text <> '') then
	-- tratamento em campo auxiliar para identificar posteriormente os registros que foram alterados
	CALL pls_tipos_ocor_pck.atualiza_campo_auxiliar('V', nr_id_transacao_p, null, dados_regra_p);
	
	select	count(1)
	into STRICT	qt_regra_carencia_w
	from	pls_regra_lanc_carencia;
	
	select	count(1)
	into STRICT	qt_carencia_mat_w
	from	pls_carencia_mat;
	
	for r_C01_w in C01(dados_regra_p.nr_sequencia) loop
		if (r_C01_w.ie_valida_proc = 'S') then
			for r_C02_w in C02(nr_id_transacao_p) loop
				ds_observacao_abrang_ant_w := null;
				ds_observacao_w := null;
				ie_autorizado_w := 'N';
				
				if (r_C02_w.cd_guia_ok IS NOT NULL AND r_C02_w.cd_guia_ok::text <> '') and
					(r_C02_w.qt_autorizada >= (r_C02_w.qt_executado + r_C02_w.qt_procedimento_imp)) then
					ie_autorizado_w := 'S';
				end if;
									
				--Caso for originada de A500, o vinculo com 
				if (r_c02_w.ie_origem_conta = 'A') and
					(r_C02_w.qt_autorizada_a500 >= (r_C02_w.qt_executado + r_C02_w.qt_procedimento_imp)) then
					ie_autorizado_w := 'S';														
				end if;
				
				if (ie_autorizado_w = 'N') then
					select	max(pls_obter_produto_benef(nr_sequencia, r_C02_w.dt_solicitacao)),
						max(nr_seq_contrato),
						max(dt_inclusao_operadora),
						max(dt_contratacao),
						max(nr_seq_segurado_ant)
					into STRICT	nr_seq_plano_w,
						nr_seq_contrato_w,
						dt_inclusao_operadora_w,
						dt_contratacao_w,
						nr_seq_segurado_ant_w
					from	pls_segurado
					where	nr_sequencia	= r_C02_w.nr_seq_segurado;
					
					select	max(dt_alteracao)
					into STRICT	dt_alteracao_ant_w
					from	pls_segurado_alt_plano a
					where	nr_seq_segurado	= r_C02_w.nr_seq_segurado
					and	a.ie_situacao = 'A'
					and	nr_seq_plano_atual = nr_seq_plano_w;
					
					SELECT * FROM pls_obter_estrut_proc(	r_C02_w.cd_procedimento, r_C02_w.ie_origem_proced, cd_area_w, cd_especialidade_w, cd_grupo_w, ie_origem_proced_w) INTO STRICT cd_area_w, cd_especialidade_w, cd_grupo_w, ie_origem_proced_w;
								
					ie_consistir_caren_prod_ant_w	:= 'S';
						
					if (nr_seq_plano_w IS NOT NULL AND nr_seq_plano_w::text <> '') then
						ie_consistir_caren_prod_ant_w := pls_obter_se_caren_plano_ant(	r_C02_w.nr_seq_segurado, nr_seq_plano_w, nr_seq_segurado_ant_w, r_C02_w.nr_seq_prestador, null, ie_consistir_caren_prod_ant_w);
					end if;
					
					select	max(ie_tipo_guia),
						max(nr_seq_tipo_acomodacao)
					into STRICT	ie_tipo_guia_solic_w,
						nr_seq_tipo_acomod_w
					from	pls_guia_plano
					where	nr_sequencia = r_C02_w.nr_seq_guia;
					
					for r_C03_w in C03(	r_C02_w.nr_seq_segurado, nr_seq_contrato_w, nr_seq_plano_w, dt_contratacao_w, ie_consistir_caren_prod_ant_w,
								nr_seq_segurado_ant_w, dt_alteracao_ant_w, dt_inclusao_operadora_w) loop
						
						
						if (coalesce(r_C02_w.dt_solicitacao,clock_timestamp()) < r_C03_w.dt_carencia) then
						
							ie_rede_atend_w := 'S';
							if (r_C03_w.nr_seq_rede IS NOT NULL AND r_C03_w.nr_seq_rede::text <> '') then
								ie_rede_atend_w := pls_obter_se_prest_rede_atend(r_C02_w.nr_seq_prestador, r_C03_w.nr_seq_rede);
							end if;
						
							if (ie_rede_atend_w = 'S') then
								if (r_C03_w.ie_mes_posterior	= 'S') then
									dt_inclusao_operadora_w	:= add_months(trunc(dt_inclusao_operadora_w,'month'),1);
								end if;
							
								ie_carencia_w := 'N';
								ie_carencia_ant_w := 'N';
							
								for r_C04_w in C04(r_C03_w.nr_seq_carencia) loop
									
									if	((coalesce(r_C04_w.cd_proc::text, '') = '') or (r_C04_w.cd_proc = r_C02_w.cd_procedimento)) and
										((coalesce(r_C04_w.ie_origem_proced::text, '') = '') or (r_C04_w.ie_origem_proced = r_C02_w.ie_origem_proced)) and
										((coalesce(r_C04_w.cd_grupo::text, '') = '') or (r_C04_w.cd_grupo = cd_grupo_w)) and
										((coalesce(r_C04_w.cd_espec::text, '') = '') or (r_C04_w.cd_espec = cd_especialidade_w)) and
										((coalesce(r_C04_w.cd_area::text, '') = '') or (r_C04_w.cd_area = cd_area_w)) and
										((coalesce(r_C04_w.ie_tipo_guia::text, '') = '') or (r_C04_w.ie_tipo_guia = ie_tipo_guia_solic_w)) and
										((coalesce(r_C04_w.nr_seq_tipo_acomodacao::text, '') = '') or (r_C04_w.nr_seq_tipo_acomodacao = nr_seq_tipo_acomod_w)) then
										
										ie_serv_lib_w := 'S';
										if (r_C04_w.nr_seq_grupo_servico IS NOT NULL AND r_C04_w.nr_seq_grupo_servico::text <> '') then
											ie_serv_lib_w	:= pls_se_grupo_preco_servico_lib(r_C04_w.nr_seq_grupo_servico,r_C02_w.cd_procedimento,r_C02_w.ie_origem_proced);
										end if;
										
										if (ie_serv_lib_w = 'S') then
											ie_carencia_w := r_C04_w.ie_liberado;
										else
											ie_carencia_w := ie_carencia_ant_w;
										end if;
									end if;							

									ie_carencia_ant_w := ie_carencia_w;
									
									if (ie_carencia_w = 'S') then
										if (coalesce(r_C04_w.cd_proc::text, '') = '') and (coalesce(r_C04_w.cd_grupo::text, '') = '') and (coalesce(r_C04_w.cd_espec::text, '') = '') and (coalesce(r_C04_w.cd_area::text, '') = '') then
											if (r_C04_w.ie_tipo_guia = ie_tipo_guia_solic_w) then
												ds_observacao_w := wheb_mensagem_pck.get_texto(1109040);
											elsif (r_C04_w.nr_seq_tipo_acomodacao = nr_seq_tipo_acomod_w) then
												ds_observacao_w := wheb_mensagem_pck.get_texto(1109041, 'DT_CARENCIA='||to_char(r_C03_w.dt_carencia,'dd/mm/yyyy'));
											end if;
										else
											ds_observacao_w := wheb_mensagem_pck.get_texto(1109039, 'NR_SEQ_TIPO_CARENCIA='||r_C04_w.nr_seq_tipo_carencia||';DS_CARENCIA='||r_C04_w.ds_carencia||';NR_SEQ_CARENCIA_MAT='||r_C04_w.nr_seq_carencia_proc||
																		';IE_LOCALIZACAO='||r_C03_w.ie_localizacao||';DT_CARENCIA='||to_char(r_C03_w.dt_carencia,'dd/mm/yyyy')||';QT_DIAS='||r_C03_w.qt_dias);
										end if;
									end if;
								end loop;
								
								if (ie_carencia_w = 'S') then
									
									if (ie_consistir_caren_prod_ant_w = 'N') then
										ds_observacao_abrang_ant_w	:= ' ' || wheb_mensagem_pck.get_texto(1108841);
									end if;									
									
									if ( qt_regra_carencia_w > 0) then
										nr_seq_regra_carencia_w := pls_obter_regra_carencia(	r_C02_w.ie_carater_internacao, nr_seq_plano_w, nm_usuario_p, cd_estabelecimento_p, nr_seq_regra_carencia_w);
										
										if (nr_seq_regra_carencia_w > 0) then
											ie_gerar_glosa_w := 'N';
										else
											ie_gerar_glosa_w := 'S';
										end if;
									else
										ie_gerar_glosa_w := 'S';
									end if;
									
									if (ie_gerar_glosa_w = 'S') then
										tb_valido_w(i) := 'S';
										tb_observacao_w(i) := ds_observacao_w || ds_observacao_abrang_ant_w;
										tb_seq_selecao_w(i) := r_C02_w.nr_seq_selecao;
										
										if (i >= pls_util_pck.qt_registro_transacao_w) then
											CALL pls_tipos_ocor_pck.gerencia_selecao_validacao(	tb_seq_selecao_w, pls_tipos_ocor_pck.clob_table_vazia,
																	'SEQ', tb_observacao_w, tb_valido_w, nm_usuario_p);
											tb_seq_selecao_w.delete;
											tb_valido_w.delete;
											tb_observacao_w.delete;
											i := 0;
										else
											i := i + 1;
										end if;
									end if;
								end if;
							end if;
						end if;
					end loop;
				end if;
			end loop;
			
			qt_reg_w := tb_seq_selecao_w.count;
			
			if (tb_seq_selecao_w.count > 0) then
				CALL pls_tipos_ocor_pck.gerencia_selecao_validacao(	tb_seq_selecao_w, pls_tipos_ocor_pck.clob_table_vazia,
										'SEQ', tb_observacao_w, tb_valido_w, nm_usuario_p);
				tb_seq_selecao_w.delete;
				tb_valido_w.delete;
				tb_observacao_w.delete;
				i := 0;
			end if;
		end if;

		if (r_C01_w.ie_valida_mat = 'S') then
			for r_C06_w in C06(nr_id_transacao_p) loop
				ds_observacao_w :=  null;
				ds_observacao_abrang_ant_w := null;
				
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
				where	nr_sequencia	= r_C06_w.nr_seq_segurado;
				
				select	max(dt_alteracao)
				into STRICT	dt_alteracao_ant_w
				from	pls_segurado_alt_plano a
				where	nr_seq_segurado	= r_C06_w.nr_seq_segurado
				and	a.ie_situacao = 'A'
				and	nr_seq_plano_atual = nr_seq_plano_w;
				
				if (qt_carencia_mat_w > 0) then
					ie_consistir_caren_prod_ant_w	:= 'S';
					
					if (r_C06_w.nr_seq_segurado IS NOT NULL AND r_C06_w.nr_seq_segurado::text <> '') then
						ie_consistir_caren_prod_ant_w := pls_obter_se_caren_plano_ant(	r_C06_w.nr_seq_segurado, nr_seq_plano_w, nr_seq_segurado_ant_w, r_C06_w.nr_seq_prestador, null, ie_consistir_caren_prod_ant_w);
					end if;
					
					for r_C07_w in C07(	r_C06_w.nr_seq_segurado, nr_seq_contrato_w, nr_seq_plano_w, dt_contratacao_w,
								ie_consistir_caren_prod_ant_w, nr_seq_segurado_ant_w, dt_alteracao_ant_w, dt_inclusao_operadora_w) loop
						if (coalesce(r_C06_w.dt_solicitacao,clock_timestamp()) < r_C07_w.dt_carencia) then
							ie_rede_atend_w := 'S';
							
							if (r_C07_w.nr_seq_rede IS NOT NULL AND r_C07_w.nr_seq_rede::text <> '') then
								ie_rede_atend_w := pls_obter_se_prest_rede_atend(r_C06_w.nr_seq_prestador, r_C07_w.nr_seq_rede);
							end if;
						
							if (ie_rede_atend_w = 'S') then
								if (r_C07_w.ie_mes_posterior = 'S') then
									dt_inclusao_operadora_w	:= add_months(trunc(dt_inclusao_operadora_w,'month'),1);
								end if;
								
								ie_carencia_w	:= 'N';
								
								for r_C08_w in C08(r_C07_w.nr_seq_carencia, r_C06_w.nr_seq_material) loop
									if	((coalesce(r_C08_w.ie_despesa::text, '') = '') or (r_C08_w.ie_despesa = r_C06_w.ie_tipo_despesa)) and
										((coalesce(r_C08_w.nr_seq_estru::text, '') = '') or (r_C08_w.ie_estru_mat = 'S')) and
										((coalesce(r_C08_w.nr_seq_grupo_material::text, '') = '') or (r_C08_w.ie_grupo_preco_mat = 'S')) then
										ie_carencia_w := r_C08_w.ie_liberado;
									end if;	

									if (ie_carencia_w = 'S') then
										ds_observacao_w := wheb_mensagem_pck.get_texto(1109039, 'NR_SEQ_TIPO_CARENCIA='||r_C08_w.nr_seq_tipo_carencia||';DS_CARENCIA='||r_C08_w.ds_carencia||';NR_SEQ_CARENCIA_MAT='||r_C08_w.nr_seq_carencia_mat||
																	';IE_LOCALIZACAO='||r_C07_w.ie_localizacao||';DT_CARENCIA='||to_char(r_C07_w.dt_carencia,'dd/mm/yyyy')||';QT_DIAS='||r_C07_w.qt_dias);
									end if;
								end loop;
								
								if (ie_carencia_w = 'S') then
									if (ie_consistir_caren_prod_ant_w = 'N') then
										ds_observacao_abrang_ant_w	:= ' ' || wheb_mensagem_pck.get_texto(1108841);
									end if;
									
									if (qt_regra_carencia_w > 0) then
										nr_seq_regra_carencia_w := pls_obter_regra_carencia(	r_C06_w.ie_carater_internacao, nr_seq_plano_aux_w, nm_usuario_p, cd_estabelecimento_p, nr_seq_regra_carencia_w);
										
										if (nr_seq_regra_carencia_w > 0) then
											ie_gerar_glosa_w := 'N';
										else
											ie_gerar_glosa_w := 'S';
										end if;
									else
										ie_gerar_glosa_w := 'S';
									end if;
									
									if (ie_gerar_glosa_w = 'S') then
										-- Quando a quantidade de itens da lista tiver chegado ao maximo definido na pls_util_pck, entao os registros sao persistidos no banco
										tb_valido_w(i)		:= 'S';	
										tb_seq_selecao_w(i)	:= r_C06_w.nr_seq_selecao;
										tb_observacao_w(i)	:= ds_observacao_w || ds_observacao_abrang_ant_w;
										
										if (i >= pls_util_pck.qt_registro_transacao_w) then
											CALL pls_tipos_ocor_pck.gerencia_selecao_validacao(	tb_seq_selecao_w, pls_tipos_ocor_pck.clob_table_vazia,
																	'SEQ', tb_observacao_w, tb_valido_w, nm_usuario_p);
											i := 0;
											tb_seq_selecao_w.delete;
											tb_valido_w.delete;
											tb_observacao_w.delete;
										else
											i := i + 1;
										end if;
									end if;
								end if;
							end if;
						end if;
					end loop;
				end if;				
			end loop;
			
			if (tb_seq_selecao_w.count > 0) then
				CALL pls_tipos_ocor_pck.gerencia_selecao_validacao(	tb_seq_selecao_w, pls_tipos_ocor_pck.clob_table_vazia,
										'SEQ', tb_observacao_w, tb_valido_w, nm_usuario_p);
				tb_seq_selecao_w.delete;
				tb_valido_w.delete;
				tb_observacao_w.delete;
				i := 0;
			end if;
			
		end if;
	-- seta os registros que serao validos ou invalidos apos o processamento 
	CALL pls_tipos_ocor_pck.atualiza_campo_valido('V', nr_id_transacao_p, null, dados_regra_p);
	end loop;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_oc_cta_tratar_val_54 ( dados_regra_p pls_tipos_ocor_pck.dados_regra, nr_id_transacao_p pls_oc_cta_selecao_ocor_v.nr_id_transacao%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
