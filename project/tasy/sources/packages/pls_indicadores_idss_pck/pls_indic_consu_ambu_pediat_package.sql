-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_indicadores_idss_pck.pls_indic_consu_ambu_pediat ( cd_grupo_p text, cd_indicador_p text, dt_referencia_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


	current_setting('pls_indicadores_idss_pck.nr_seq_regra_w')::pls_indic_regra_item.nr_seq_regra%type			pls_indic_regra.nr_sequencia%type;
	current_setting('pls_indicadores_idss_pck.ie_tipo_valor_contabil_w')::pls_indic_regra_item.ie_tipo_valor_contabil%type	pls_indic_regra_item.ie_tipo_valor_contabil%type;
	current_setting('pls_indicadores_idss_pck.cd_conta_contabil_w')::pls_indic_regra_item.cd_conta_contabil%type		pls_indic_regra_item.cd_conta_contabil%type;
	current_setting('pls_indicadores_idss_pck.ie_tipo_regra_w')::pls_indic_regra_item.ie_tipo_regra%type			pls_indic_regra_item.ie_tipo_regra%type;
	current_setting('pls_indicadores_idss_pck.cd_procedimento_w')::pls_indic_regra_item.cd_procedimento%type		pls_indic_regra_item.cd_procedimento%type;
	current_setting('pls_indicadores_idss_pck.cd_material_w')::pls_indic_regra_item.cd_material%type			pls_indic_regra_item.cd_material%type;
	current_setting('pls_indicadores_idss_pck.nr_idade_minima_w')::pls_indic_regra_item.nr_idade_minima%type		pls_indic_regra_item.nr_idade_minima%type;
	current_setting('pls_indicadores_idss_pck.nr_idade_maxima_w')::pls_indic_regra_item.nr_idade_maxima%type		pls_indic_regra_item.nr_idade_maxima%type;
	qt_um_ano_w			bigint;
	qt_ate_quatro_anos_w		bigint;
	
	c_seq_grupo_indc CURSOR FOR
		SELECT	a.nr_sequencia
		from	pls_indic_regra a
		where	current_setting('pls_indicadores_idss_pck.dt_ref_inicio_mes_w')::timestamp between coalesce(pkg_date_utils.start_of(a.dt_inicio_vigencia,'MONTH'),current_setting('pls_indicadores_idss_pck.dt_ref_inicio_mes_w')::timestamp) and coalesce(pkg_date_utils.start_of(a.dt_fim_vigencia,'MONTH'),current_setting('pls_indicadores_idss_pck.dt_ref_inicio_mes_w')::timestamp)
		and	a.cd_grupo = cd_grupo_p
		and (a.cd_indicador = cd_indicador_p or coalesce(cd_indicador_p::text, '') = '');

	c_tipo_saldo CURSOR FOR
		SELECT	a.ie_tipo_valor_contabil,
			a.cd_conta_contabil,
			a.ie_tipo_regra,
			a.cd_procedimento,
			a.cd_material,
			a.nr_idade_minima,
			a.nr_idade_maxima
		from	pls_indic_regra_item a
		where	a.nr_seq_regra = current_setting('pls_indicadores_idss_pck.nr_seq_regra_w')::pls_indic_regra_item.nr_seq_regra%type;
						
	
BEGIN

	open c_seq_grupo_indc;
	loop
	fetch c_seq_grupo_indc into	
		current_setting('pls_indicadores_idss_pck.nr_seq_regra_w')::pls_indic_regra_item.nr_seq_regra%type;
	EXIT WHEN NOT FOUND; /* apply on c_seq_grupo_indc */
		begin
		
		open c_tipo_saldo;
		loop
		fetch c_tipo_saldo into	
			current_setting('pls_indicadores_idss_pck.ie_tipo_valor_contabil_w')::pls_indic_regra_item.ie_tipo_valor_contabil%type,
			current_setting('pls_indicadores_idss_pck.cd_conta_contabil_w')::pls_indic_regra_item.cd_conta_contabil%type,
			current_setting('pls_indicadores_idss_pck.ie_tipo_regra_w')::pls_indic_regra_item.ie_tipo_regra%type,
			current_setting('pls_indicadores_idss_pck.cd_procedimento_w')::pls_indic_regra_item.cd_procedimento%type,
			current_setting('pls_indicadores_idss_pck.cd_material_w')::pls_indic_regra_item.cd_material%type,
			current_setting('pls_indicadores_idss_pck.nr_idade_minima_w')::pls_indic_regra_item.nr_idade_minima%type,
			current_setting('pls_indicadores_idss_pck.nr_idade_maxima_w')::pls_indic_regra_item.nr_idade_maxima%type;
		EXIT WHEN NOT FOUND; /* apply on c_tipo_saldo */
			begin
			select	sum(x.qt_item)
			into STRICT	current_setting('pls_indicadores_idss_pck.vl_numerador_w')::pls_conta_proc.vl_liberado%type
			from (SELECT	c.vl_liberado vl_liberado,
					c.qt_procedimento qt_item,
					i.nr_idade_minima nr_idade_minima,
					i.nr_idade_maxima nr_idade_maxima,
					trunc(pkg_date_utils.get_DiffDate(f.dt_nascimento, current_setting('pls_indicadores_idss_pck.dt_ref_inicio_mes_w')::timestamp, 'YEAR')) qt_idade_seg
				from	pls_protocolo_conta a,
					pls_conta b,
					pls_conta_proc c,
					pls_segurado s,
					pessoa_fisica f,
					pls_indic_regra r,
					pls_indic_regra_item i
				where	a.nr_sequencia = b.nr_seq_protocolo
				and	b.nr_sequencia = c.nr_seq_conta
				and	s.nr_sequencia = b.nr_seq_segurado
				and	s.cd_pessoa_fisica = f.cd_pessoa_fisica
				and	i.nr_seq_regra = r.nr_sequencia
				and 	c.cd_procedimento = i.cd_procedimento
				and	r.nr_sequencia = current_setting('pls_indicadores_idss_pck.nr_seq_regra_w')::pls_indic_regra_item.nr_seq_regra%type
				and	i.ie_tipo_regra = 'N'
				and	c.cd_procedimento = current_setting('pls_indicadores_idss_pck.cd_procedimento_w')::pls_indic_regra_item.cd_procedimento%type
				and	pkg_date_utils.start_of(a.dt_mes_competencia,'MONTH') = current_setting('pls_indicadores_idss_pck.dt_ref_inicio_mes_w')::timestamp
				
union all

				SELECT	c.vl_liberado vl_liberado,
					c.qt_material qt_item,
					i.nr_idade_minima nr_idade_minima,
					i.nr_idade_maxima nr_idade_maxima,
					trunc(pkg_date_utils.get_DiffDate(f.dt_nascimento, current_setting('pls_indicadores_idss_pck.dt_ref_inicio_mes_w')::timestamp, 'YEAR')) qt_idade_seg
				from	pls_protocolo_conta a,
					pls_conta b,
					pls_conta_mat c,
					pls_segurado s,
					pessoa_fisica f,
					pls_indic_regra r,
					pls_indic_regra_item i
				where	a.nr_sequencia = b.nr_seq_protocolo
				and	b.nr_sequencia = c.nr_seq_conta
				and	s.nr_sequencia = b.nr_seq_segurado
				and	s.cd_pessoa_fisica = f.cd_pessoa_fisica
				and	i.nr_seq_regra = r.nr_sequencia
				and	c.cd_material = i.cd_material
				and	r.nr_sequencia = current_setting('pls_indicadores_idss_pck.nr_seq_regra_w')::pls_indic_regra_item.nr_seq_regra%type
				and	i.ie_tipo_regra = 'N'
				and	c.cd_material = current_setting('pls_indicadores_idss_pck.cd_material_w')::pls_indic_regra_item.cd_material%type
				and	pkg_date_utils.start_of(a.dt_mes_competencia,'MONTH') = current_setting('pls_indicadores_idss_pck.dt_ref_inicio_mes_w')::timestamp)x
			where	x.qt_idade_seg between coalesce(x.nr_idade_minima,x.qt_idade_seg) and coalesce(x.nr_idade_maxima,x.qt_idade_seg);
			
			end;
		end loop;
		close c_tipo_saldo;
		end;
	end loop;
	close c_seq_grupo_indc;
	
	select	count(*)
	into STRICT	qt_um_ano_w
	from	pls_segurado s,
		pls_plano p
	where	p.nr_sequencia = s.nr_seq_plano
	and	coalesce(s.dt_rescisao, dt_referencia_p) >= dt_referencia_p
	and	(s.dt_liberacao IS NOT NULL AND s.dt_liberacao::text <> '')
	and	s.dt_contratacao <= dt_referencia_p
	and	pls_obter_dados_segurado(s.nr_sequencia, 'ID') = '0'
	and	p.ie_segmentacao in (1,5,6,7,8,11,12);

	select	count(*)
	into STRICT	qt_ate_quatro_anos_w
	from	pls_segurado s,
		pls_plano p
	where	p.nr_sequencia = s.nr_seq_plano
	and	coalesce(s.dt_rescisao, dt_referencia_p) >= dt_referencia_p
	and	(s.dt_liberacao IS NOT NULL AND s.dt_liberacao::text <> '')
	and	s.dt_contratacao <= dt_referencia_p
	and	pls_obter_dados_segurado(s.nr_sequencia, 'ID') in ('1','2','3','4')
	and	p.ie_segmentacao in (1,5,6,7,8,11,12);	
	
	PERFORM set_config('pls_indicadores_idss_pck.vl_total_w', dividir(current_setting('pls_indicadores_idss_pck.vl_numerador_w')::pls_conta_proc.vl_liberado%type, (qt_um_ano_w * 8 + 2.7 * qt_ate_quatro_anos_w)), false);
	
	insert into pls_indic_dados(	nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					cd_grupo,
					cd_indicador,
					dt_competencia,
					vl_indicador)
			values (nextval('pls_indic_dados_seq'),
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					cd_grupo_p,
					cd_indicador_p,
					dt_referencia_p,
					current_setting('pls_indicadores_idss_pck.vl_total_w')::bigint);

	commit;

	PERFORM set_config('pls_indicadores_idss_pck.vl_div_w', 0, false);
	PERFORM set_config('pls_indicadores_idss_pck.vl_total_w', 0, false);

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_indicadores_idss_pck.pls_indic_consu_ambu_pediat ( cd_grupo_p text, cd_indicador_p text, dt_referencia_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;