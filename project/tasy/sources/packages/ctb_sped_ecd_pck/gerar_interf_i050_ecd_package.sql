-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ctb_sped_ecd_pck.gerar_interf_i050_ecd (regra_sped_p INOUT ctb_sped_ecd_pck.regra_sped, nm_usuario_p text) AS $body$
DECLARE

			

ds_linha_w			varchar(8000);
sep_w				varchar(1)	:= '|';
tp_registro_w			varchar(15);
ie_gerar_I051_w			varchar(01);
ie_gerar_I052_w			varchar(01);
nr_nivel_w			numeric(20);
ie_centro_custo_w		conta_contabil.ie_centro_custo%type;
cd_codigo_conta_sup_w		varchar(40);
cd_codigo_conta_ecd_w		varchar(40);

c_plano_contas CURSOR(
	cd_empresa_pc		 ctb_regra_sped.cd_empresa%type,
	ie_consolida_empresa_pc	 ctb_regra_sped.ie_consolida_empresa%type,
	cd_estabelecimento_pc	 ctb_sped_controle.cd_estabelecimento%type,
	dt_ref_inicial_pc	 ctb_sped_controle.dt_ref_inicial%type,
	dt_ref_final_pc		 ctb_sped_controle.dt_ref_final%type
	) FOR
	SELECT	a.cd_grupo_ecd,
		a.ie_tipo_ecd,
		a.cd_conta_contabil,
		a.ds_conta_contabil,
		substr(ctb_obter_classif_conta(a.cd_conta_contabil, a.cd_classificacao, dt_ref_final_pc),1,40) cd_classificacao,
		a.cd_classificacao cd_classif,
		a.cd_empresa
	from	ecd_plano_conta_v	a
	where	a.tp_registro	= 1
	and	a.cd_empresa	= cd_empresa_pc
	and	substr(obter_se_vigencia_periodo(a.dt_inicio_vigencia, a.dt_fim_vigencia,dt_ref_inicial_pc,dt_ref_final_pc,'S'),1,1) = 'S'
	and	exists (
			SELECT	1
			from	ctb_saldo x
			where	x.cd_conta_contabil = a.cd_conta_contabil
			and	((a.ie_tipo_ecd = 'S') or (x.vl_credito <> 0 or x.vl_debito <> 0 or x.vl_saldo <> 0))
			and	x.nr_seq_mes_ref in (
						select	z.nr_sequencia
						from	ctb_mes_ref z
						where	z.cd_empresa = cd_empresa_pc
						and	z.dt_referencia between pkg_date_utils.start_of(dt_ref_inicial_pc,'yyyy') and pkg_date_utils.end_of(dt_ref_inicial_pc, 'YEAR',0))
			and (ie_consolida_empresa_pc = 'S' or x.cd_estabelecimento = cd_estabelecimento_pc)
			 LIMIT 1)
	order by
		a.cd_classificacao;

type vetor_plano_contas is table of c_plano_contas%rowtype index by integer;
v_plano_contas_w    vetor_plano_contas;

c_plano_contas_ref CURSOR(
	cd_empresa_pc		 ctb_regra_sped.cd_empresa%type,
	cd_estabelecimento_pc	 ctb_sped_controle.cd_estabelecimento%type,
	ie_consolida_empresa_pc	 ctb_regra_sped.ie_consolida_empresa%type,
	dt_ref_inicial_pc	 ctb_sped_controle.dt_ref_inicial%type,
	cd_versao_pc		 ctb_regra_sped.cd_versao%type,
	cd_conta_contabil_pc	 conta_contabil.cd_conta_contabil%type,
	ie_gerar_I051_pc	 text
	) FOR
	SELECT	CASE WHEN a.ie_centro_custo='S' THEN  b.cd_centro_custo  ELSE null END  cd_centro_custo,
		a.cd_classif_ecd cd_classif_ecd,
		a.cd_classificacao
	from	ctb_saldo b,
		ecd_plano_conta_v a
	where	a.cd_conta_contabil = b.cd_conta_contabil
	and	a.tp_registro		= 2
	and	a.cd_empresa		= cd_empresa_pc
	and	a.cd_conta_contabil	= cd_conta_contabil_pc
	and	coalesce(a.cd_versao,'0.0')	= CASE WHEN cd_versao_pc='3.0' THEN '3.1' WHEN cd_versao_pc='4.0' THEN '3.1' WHEN cd_versao_pc='5.0' THEN '3.1' WHEN cd_versao_pc='6.0' THEN '3.1' WHEN cd_versao_pc='7.0' THEN '3.1' WHEN cd_versao_pc='8.0' THEN '3.1'  ELSE '0.0' END
	and	(a.cd_classif_ecd IS NOT NULL AND a.cd_classif_ecd::text <> '')
	and	ie_gerar_I051_pc = 'S'
	and	substr(obter_se_periodo_vigente(a.dt_inicio_validade, a.dt_fim_validade, dt_ref_inicial_pc),1,1) = 'S'
	and (b.vl_credito <> 0 or b.vl_debito <> 0 or b.vl_saldo <> 0)
	and	b.nr_seq_mes_ref in (	SELECT	z.nr_sequencia
					from	ctb_mes_ref z
					where	z.cd_empresa = cd_empresa_pc
					and	z.dt_referencia between pkg_date_utils.start_of(dt_ref_inicial_pc,'yyyy') and pkg_date_utils.end_of(dt_ref_inicial_pc, 'YEAR',0))
	and (ie_consolida_empresa_pc = 'S' or b.cd_estabelecimento = cd_estabelecimento_pc)
	group by
		CASE WHEN a.ie_centro_custo='S' THEN  b.cd_centro_custo  ELSE null END ,
		a.cd_classif_ecd,
		a.cd_classificacao
	order by a.cd_classificacao;

type vetor_plano_contas_ref is table of c_plano_contas_ref%rowtype index by integer;
v_plano_contas_ref_w    vetor_plano_contas_ref;

c_ind_cod_aglut_cta CURSOR(
	nr_seq_demo_dre_pc	 ctb_sped_controle.nr_seq_demo_bp%type,
	nr_seq_demo_bp_pc	 ctb_sped_controle.nr_seq_demo_bp%type,
	ie_gerar_i052_pc	 text,
	cd_conta_contabil_pc	 conta_contabil.cd_conta_contabil%type
	) FOR
	SELECT	a.cd_centro_custo,
		a.cd_conta_contabil,
		a.cd_classificacao
	from	conta_contabil a
	where	coalesce(a.ie_ecd_reg_bp,'N') = 'S'
	and	a.cd_conta_contabil	= cd_conta_contabil_pc
	and	a.ie_tipo		= 'A'
	and	nr_seq_demo_bp_pc	= 0
	and	ie_gerar_i052_pc	= 'S'
	
union

	SELECT	a.cd_centro_custo,
		a.cd_conta_contabil,
		a.cd_classificacao
	from	conta_contabil a
	where	coalesce(a.ie_ecd_reg_dre,'N')= 'S'
	and	a.cd_conta_contabil	= cd_conta_contabil_pc
	and	a.ie_tipo		= 'A'
	and	nr_seq_demo_dre_pc	= 0
	and	ie_gerar_i052_pc	= 'S'
	order by cd_classificacao;

type vetor_ind_cod_aglut_cta is table of c_ind_cod_aglut_cta%rowtype index by integer;
v_ind_cod_aglut_cta_w    vetor_ind_cod_aglut_cta;

c_ind_cod_aglut_demo CURSOR(
	nr_seq_demo_dre_pc	 ctb_sped_controle.nr_seq_demo_bp%type,
	nr_seq_demo_bp_pc	 ctb_sped_controle.nr_seq_demo_bp%type,
	ie_gerar_i052_pc	 text,
	cd_conta_contabil_pc	 conta_contabil.cd_conta_contabil%type
	) FOR
	SELECT	a.nr_seq_rubrica cd_aglutinacao,
		d.cd_centro_custo
	from	ctb_demonstrativo e,
		conta_contabil d,
		ctb_modelo_relat c,
		ctb_modelo_rubrica b,
		ctb_modelo_rubrica_conta a
	where	a.nr_seq_rubrica	= b.nr_sequencia
	and	b.nr_seq_modelo		= c.nr_sequencia
	and	a.cd_conta_contabil	= d.cd_conta_contabil
	and	c.nr_sequencia		= e.nr_seq_tipo
	and	e.nr_sequencia		in (nr_seq_demo_bp_pc, nr_seq_demo_dre_pc)
	and	((coalesce(d.ie_ecd_reg_bp,'N') = 'S') or (coalesce(d.ie_ecd_reg_dre,'N') = 'S'))
	and	d.ie_tipo		= 'A'
	and	ie_gerar_i052_pc	= 'S'
	and	coalesce(b.ie_total,'N')	= 'N'
	and	a.cd_conta_contabil	= cd_conta_contabil_pc;

type vetor_ind_cod_aglut_demo is table of c_ind_cod_aglut_demo%rowtype index by integer;
v_ind_cod_aglut_demo_w    vetor_ind_cod_aglut_demo;

c_demonstrativo CURSOR(
	nr_seq_demo_dre_pc	 ctb_sped_controle.nr_seq_demo_bp%type,
	nr_seq_demo_bp_pc	 ctb_sped_controle.nr_seq_demo_bp%type,
	ie_gerar_i052_pc	 text
	) FOR
	SELECT	b.nr_sequencia,
		b.ds_origem,
		b.ie_origem_valor,
		c.cd_registro_sped,
		c.nr_sequencia nr_seq_modelo_relat
	from	ctb_demonstrativo	e,
		ctb_modelo_relat	c,
		ctb_modelo_rubrica	b
	where	c.nr_sequencia	= b.nr_seq_modelo
	and	c.nr_sequencia	= e.nr_seq_tipo
	and	e.nr_sequencia in (nr_seq_demo_bp_pc, nr_seq_demo_dre_pc)
	and	ie_gerar_i052_pc 	= 'S'
	order by coalesce(b.nr_seq_somat,0),
		nr_seq_apres desc;

type vetor_demonstrativo is table of c_demonstrativo%rowtype index by integer;
v_demonstrativo_w    vetor_demonstrativo;

c_ind_cod_aglut_dmpl CURSOR(
	nr_seq_dmpl_pc		 ctb_sped_controle.nr_seq_dmpl%type,
	cd_conta_contabil_pc	 conta_contabil.cd_conta_contabil%type,
	ie_gerar_i052_pc	 text
	) FOR
	SELECT	cd_aglutinacao_sped
	from 	ctb_dmpl_coluna_conta a,
		ctb_dmpl_coluna b
	where 	a.nr_seq_col_dmpl 	= b.nr_sequencia
	and	ie_gerar_i052_pc	= 'S'
	and	b.nr_seq_dmpl 		= nr_seq_dmpl_pc
	and 	a.cd_conta_contabil 	= cd_conta_contabil_pc;

type vetor_ind_cod_aglut_dmpl is table of c_ind_cod_aglut_dmpl%rowtype index by integer;
v_ind_cod_aglut_dmpl_w    vetor_ind_cod_aglut_dmpl;

c_centro_custo_saldo CURSOR(
	cd_empresa_pc		 ctb_regra_sped.cd_empresa%type,
	ie_consolida_empresa_pc	 ctb_regra_sped.ie_consolida_empresa%type,
	cd_estabelecimento_pc	 ctb_sped_controle.cd_estabelecimento%type,
	dt_ref_inicial_pc	 ctb_sped_controle.dt_ref_inicial%type,
	cd_conta_contabil_pc	 conta_contabil.cd_conta_contabil%type,
	cd_aglutinacao_pc	 ctb_demo_mes.ds_coluna%type,
	ie_centro_custo_pc	 conta_contabil.ie_centro_custo%type,
	ie_gerar_I052_pc	 text
		
	) FOR
	SELECT	b.cd_centro_custo
	from	ctb_modelo_rubrica_centro_v c,
		ctb_saldo b,
		ecd_plano_conta_v a
	where	a.cd_conta_contabil	= b.cd_conta_contabil
	and	a.tp_registro		= 2
	and	a.cd_empresa		= cd_empresa_pc
	and	a.cd_conta_contabil	= cd_conta_contabil_pc
	and	c.cd_centro_custo	= b.cd_centro_custo
	and	c.cd_conta_contabil	= a.cd_conta_contabil
	and	c.nr_seq_rubrica	= cd_aglutinacao_pc
	and	ie_centro_custo_pc	= 'S'
	and	(b.cd_centro_custo IS NOT NULL AND b.cd_centro_custo::text <> '')
	and	ie_gerar_I052_pc	= 'S'
	and	substr(obter_se_periodo_vigente(a.dt_inicio_validade, a.dt_fim_validade, dt_ref_inicial_pc),1,1) = 'S'
	and (b.vl_credito <> 0 or b.vl_debito <> 0 or b.vl_saldo <> 0)
	and	b.nr_seq_mes_ref in (	SELECT	z.nr_sequencia
					from	ctb_mes_ref z
					where	z.cd_empresa = cd_empresa_pc
					and	z.dt_referencia between pkg_date_utils.start_of(dt_ref_inicial_pc,'yyyy') and pkg_date_utils.end_of(dt_ref_inicial_pc, 'YEAR',0))
	and (ie_consolida_empresa_pc = 'S' or b.cd_estabelecimento = cd_estabelecimento_pc)
	group by b.cd_centro_custo;

type v_centro_custo_saldo is table of c_centro_custo_saldo%rowtype index by integer;
v_centro_custo_saldo_w    v_centro_custo_saldo;
BEGIN

select	coalesce(max(ie_gerar),'N')
into STRICT	ie_gerar_I051_w
from	ctb_regra_sped_registro a,
	ctb_sped_controle	b
where	a.nr_seq_regra_sped	= b.nr_seq_regra_sped
and	b.nr_sequencia		= regra_sped_p.nr_seq_controle
and	a.cd_registro		= 'I051';

select	coalesce(max(ie_gerar),'N')
into STRICT	ie_gerar_I052_w
from	ctb_regra_sped_registro a,
	ctb_sped_controle	b
where	a.nr_seq_regra_sped	= b.nr_seq_regra_sped
and	b.nr_sequencia		= regra_sped_p.nr_seq_controle
and	a.cd_registro		= 'I052';

if (ie_gerar_I052_w = 'S') and
	((regra_sped_p.nr_seq_demo_bp <> 0) or (regra_sped_p.nr_seq_demo_dre <> 0)) then
	
	open c_demonstrativo(
		nr_seq_demo_dre_pc	=> regra_sped_p.nr_seq_demo_dre,
		nr_seq_demo_bp_pc	=> regra_sped_p.nr_seq_demo_bp,	
		ie_gerar_i052_pc	=> ie_gerar_i052_w	
		);
		loop fetch c_demonstrativo bulk collect into v_demonstrativo_w limit 1000;
		EXIT WHEN NOT FOUND; /* apply on c_demonstrativo */
			for i in v_demonstrativo_w.first .. v_demonstrativo_w.last loop
			CALL ctb_gerar_conta_rubrica(
						nr_seq_rubrica_p	=> v_demonstrativo_w[i].nr_sequencia,
						ds_origem_p		=> v_demonstrativo_w[i].ds_origem,
						ie_origem_valor_p	=> v_demonstrativo_w[i].ie_origem_valor,
						cd_registro_sped_p	=> v_demonstrativo_w[i].cd_registro_sped,
						ie_operacao_p		=> 'ECD',
						dt_referencia_p		=> regra_sped_p.dt_ref_final,
						nm_usuario_p		=> nm_usuario_p,
						nr_seq_model_relat_p	=> v_demonstrativo_w[i].nr_seq_modelo_relat
						);
			end loop;
		end loop;
	close c_demonstrativo;
end if;

open c_plano_contas(
	cd_empresa_pc		=> regra_sped_p.cd_empresa,
	ie_consolida_empresa_pc	=> regra_sped_p.ie_consolida_empresa,
	cd_estabelecimento_pc	=> regra_sped_p.cd_estabelecimento,
	dt_ref_inicial_pc	=> regra_sped_p.dt_ref_inicial,	
	dt_ref_final_pc		=> regra_sped_p.dt_ref_final			
	);
	loop fetch c_plano_contas bulk collect into v_plano_contas_w limit 1000;
	EXIT WHEN NOT FOUND; /* apply on c_plano_contas */
		for i in v_plano_contas_w.first .. v_plano_contas_w.last loop
		tp_registro_w		:= 'I050';
		
		select	ie_centro_custo
		into STRICT	ie_centro_custo_w
		from	conta_contabil
		where	cd_conta_contabil = v_plano_contas_w[i].cd_conta_contabil;

		

		cd_codigo_conta_ecd_w	:= ctb_sped_ecd_pck.obter_cod_conta_ecd(ie_tipo_conta_p	=> 'C',
							ie_apres_conta_ctb_p	=> regra_sped_p.ie_apres_conta_ctb, 
							cd_empresa_p		=> v_plano_contas_w[i].cd_empresa, 
							cd_conta_contabil_p	=> v_plano_contas_w[i].cd_conta_contabil, 
							cd_classificacao_p	=> v_plano_contas_w[i].cd_classificacao,
							dt_vigencia_p		=> regra_sped_p.dt_ref_final);
							
		cd_codigo_conta_sup_w	:= ctb_sped_ecd_pck.obter_cod_conta_ecd(ie_tipo_conta_p	=> 'S',
							ie_apres_conta_ctb_p	=> regra_sped_p.ie_apres_conta_ctb, 
							cd_empresa_p		=> v_plano_contas_w[i].cd_empresa, 
							cd_conta_contabil_p	=> v_plano_contas_w[i].cd_conta_contabil, 
							cd_classificacao_p	=> v_plano_contas_w[i].cd_classificacao,
							dt_vigencia_p		=> regra_sped_p.dt_ref_final);
		
		nr_nivel_w	:= ctb_obter_nivel_classif_conta(v_plano_contas_w[i].cd_classificacao);					
		
		ds_linha_w	:= substr(	sep_w || tp_registro_w							||
						sep_w || substr(to_char(regra_sped_p.dt_ref_inicial,'ddmmyyyy'),1,8)	||
						sep_w || v_plano_contas_w[i].cd_grupo_ecd				||
						sep_w || v_plano_contas_w[i].ie_tipo_ecd				||
						sep_w || nr_nivel_w							||
						sep_w || cd_codigo_conta_ecd_w						||
						sep_w || cd_codigo_conta_sup_w						||
						sep_w || v_plano_contas_w[i].ds_conta_contabil				||
						sep_w, 1, 8000);
						
		regra_sped_p.cd_registro_variavel := tp_registro_w;
		regra_sped_p => regra_sped_p := ctb_sped_ecd_pck.inserir_registros_vetor(regra_sped_p => regra_sped_p, ds_linha_p => ds_linha_w);

		tp_registro_w :=	'I051';
		open c_plano_contas_ref(
			cd_empresa_pc			=>  regra_sped_p.cd_empresa,
			cd_estabelecimento_pc		=>  regra_sped_p.cd_estabelecimento,
			ie_consolida_empresa_pc		=>  regra_sped_p.ie_consolida_empresa,
			dt_ref_inicial_pc		=>  regra_sped_p.dt_ref_inicial,
			cd_versao_pc			=>  regra_sped_p.cd_versao,
			cd_conta_contabil_pc		=>  v_plano_contas_w[i].cd_conta_contabil,
			ie_gerar_I051_pc		=>  ie_gerar_I051_w
			);
			loop fetch c_plano_contas_ref bulk collect into v_plano_contas_ref_w limit 1000;
			EXIT WHEN NOT FOUND; /* apply on c_plano_contas_ref */
				for j in v_plano_contas_ref_w.first .. v_plano_contas_ref_w.last loop
			
				if (regra_sped_p.cd_versao = '8.0') then
					ds_linha_w := substr(	sep_w || tp_registro_w					||
								sep_w || v_plano_contas_ref_w[j].cd_centro_custo	||
								sep_w || v_plano_contas_ref_w[j].cd_classif_ecd 	||
								sep_w,1,8000);
				else
					ds_linha_w := substr(	sep_w || tp_registro_w					||
								sep_w || regra_sped_p.cd_empresa_resp			||
								sep_w || v_plano_contas_ref_w[j].cd_centro_custo	||
								sep_w || v_plano_contas_ref_w[j].cd_classif_ecd		||
								sep_w,1,8000);
				end if;
				regra_sped_p.cd_registro_variavel := tp_registro_w;
				regra_sped_p => regra_sped_p := ctb_sped_ecd_pck.inserir_registros_vetor(regra_sped_p => regra_sped_p, ds_linha_p => ds_linha_w);
				if (regra_sped_p.registros.count >= 1000) then
					regra_sped_p => regra_sped_p := ctb_sped_ecd_pck.persistir_registros_em_lote(regra_sped_p => regra_sped_p, nm_usuario_p => nm_usuario_p);
				end if;	
				end loop;
				regra_sped_p => regra_sped_p := ctb_sped_ecd_pck.persistir_registros_em_lote(regra_sped_p => regra_sped_p, nm_usuario_p => nm_usuario_p);
			end loop;
		close c_plano_contas_ref;

		tp_registro_w		:= 'I052';
		
		if	((regra_sped_p.nr_seq_demo_bp = 0) or (regra_sped_p.nr_seq_demo_dre = 0)) then
			open c_ind_cod_aglut_cta(
				nr_seq_demo_dre_pc	=> regra_sped_p.nr_seq_demo_dre,
				nr_seq_demo_bp_pc	=> regra_sped_p.nr_seq_demo_bp,
				ie_gerar_i052_pc	=> ie_gerar_I052_w,
				cd_conta_contabil_pc	=> v_plano_contas_w[i].cd_conta_contabil
				);
				loop fetch c_ind_cod_aglut_cta bulk collect into v_ind_cod_aglut_cta_w limit 1000;
				EXIT WHEN NOT FOUND; /* apply on c_ind_cod_aglut_cta */
					for k in v_ind_cod_aglut_cta_w.first .. v_ind_cod_aglut_cta_w.last loop
					
					cd_codigo_conta_ecd_w	:= ctb_sped_ecd_pck.obter_cod_conta_ecd(ie_tipo_conta_p	=> 'C', 
										ie_apres_conta_ctb_p	=> regra_sped_p.ie_apres_conta_ctb, 
										cd_empresa_p		=> null, 
										cd_conta_contabil_p	=> v_ind_cod_aglut_cta_w[k].cd_conta_contabil, 
										cd_classificacao_p	=> v_ind_cod_aglut_cta_w[k].cd_classificacao,
										dt_vigencia_p		=> null);

					ds_linha_w := substr(	sep_w || tp_registro_w					||
								sep_w || v_ind_cod_aglut_cta_w[k].cd_centro_custo	||
								sep_w || cd_codigo_conta_ecd_w				||
								sep_w,1,8000);
						
					regra_sped_p.cd_registro_variavel := tp_registro_w;
					regra_sped_p => regra_sped_p := ctb_sped_ecd_pck.inserir_registros_vetor(regra_sped_p => regra_sped_p, ds_linha_p => ds_linha_w);
					end loop;
					regra_sped_p => regra_sped_p := ctb_sped_ecd_pck.persistir_registros_em_lote(regra_sped_p => regra_sped_p, nm_usuario_p => nm_usuario_p);
				end loop;
			close c_ind_cod_aglut_cta;
		end if;

		if	((regra_sped_p.nr_seq_demo_bp <> 0) or (regra_sped_p.nr_seq_demo_dre <> 0)) then
			open c_ind_cod_aglut_demo(
				nr_seq_demo_dre_pc	=> regra_sped_p.nr_seq_demo_dre,
				nr_seq_demo_bp_pc	=> regra_sped_p.nr_seq_demo_bp,		
				ie_gerar_i052_pc	=> ie_gerar_I052_w,		
				cd_conta_contabil_pc	=> v_plano_contas_w[i].cd_conta_contabil		
				);
				loop fetch c_ind_cod_aglut_demo bulk collect into v_ind_cod_aglut_demo_w limit 1000;
				EXIT WHEN NOT FOUND; /* apply on c_ind_cod_aglut_demo */
					for l in v_ind_cod_aglut_demo_w.first .. v_ind_cod_aglut_demo_w.last loop
					
					if (ie_centro_custo_w = 'N') then
						ds_linha_w :=  substr(		sep_w || tp_registro_w 					||
										sep_w || ''						||
										sep_w || v_ind_cod_aglut_demo_w[l].cd_aglutinacao	||
										sep_w,1,8000);
										
						regra_sped_p.cd_registro_variavel := tp_registro_w;
						regra_sped_p => regra_sped_p := ctb_sped_ecd_pck.inserir_registros_vetor(regra_sped_p => regra_sped_p, ds_linha_p => ds_linha_w);

						if (regra_sped_p.registros.count >= 1000) then
							regra_sped_p => regra_sped_p := ctb_sped_ecd_pck.persistir_registros_em_lote(regra_sped_p => regra_sped_p, nm_usuario_p => nm_usuario_p);
						end if;	
					else
						open c_centro_custo_saldo(
							cd_empresa_pc		=> regra_sped_p.cd_empresa,
							ie_consolida_empresa_pc	=> regra_sped_p.ie_consolida_empresa,					
							cd_estabelecimento_pc	=> regra_sped_p.cd_estabelecimento,					
							dt_ref_inicial_pc	=> regra_sped_p.dt_ref_inicial,					
							cd_conta_contabil_pc	=> v_plano_contas_w[i].cd_conta_contabil,					
							cd_aglutinacao_pc	=> v_ind_cod_aglut_demo_w[l].cd_aglutinacao,
							ie_centro_custo_pc	=> ie_centro_custo_w,
							ie_gerar_I052_pc	=> ie_gerar_I052_w							
							);
							loop fetch c_centro_custo_saldo bulk collect into v_centro_custo_saldo_w limit 1000;
							EXIT WHEN NOT FOUND; /* apply on c_centro_custo_saldo */
								for m in v_centro_custo_saldo_w.first .. v_centro_custo_saldo_w.last loop
								ds_linha_w :=  substr(		sep_w || tp_registro_w 					||
												sep_w || v_centro_custo_saldo_w[m].cd_centro_custo	||
												sep_w || v_ind_cod_aglut_demo_w[l].cd_aglutinacao	||
												sep_w,1,8000);
												
								regra_sped_p.cd_registro_variavel := tp_registro_w;
								regra_sped_p => regra_sped_p := ctb_sped_ecd_pck.inserir_registros_vetor(regra_sped_p => regra_sped_p, ds_linha_p => ds_linha_w);
								end loop;
								regra_sped_p => regra_sped_p := ctb_sped_ecd_pck.persistir_registros_em_lote(regra_sped_p => regra_sped_p, nm_usuario_p => nm_usuario_p);
							end loop;
						close c_centro_custo_saldo;
					end if;
					end loop;
				end loop;
			close c_ind_cod_aglut_demo;
		end if;

		if (coalesce(regra_sped_p.nr_seq_dmpl,0) <> 0) then
			open c_ind_cod_aglut_dmpl(
				nr_seq_dmpl_pc		=> regra_sped_p.nr_seq_dmpl,					
				cd_conta_contabil_pc	=> v_plano_contas_w[i].cd_conta_contabil,					
				ie_gerar_i052_pc	=> ie_gerar_I052_w							
				);
				loop fetch c_ind_cod_aglut_dmpl bulk collect into v_ind_cod_aglut_dmpl_w limit 1000;
				EXIT WHEN NOT FOUND; /* apply on c_ind_cod_aglut_dmpl */
					for n in v_ind_cod_aglut_dmpl_w.first .. v_ind_cod_aglut_dmpl_w.last loop		
					ds_linha_w :=  substr(		sep_w || tp_registro_w					||
									sep_w || null						||
									sep_w || v_ind_cod_aglut_dmpl_w[n].cd_aglutinacao_sped	||
									sep_w,1,8000);
					
					regra_sped_p.cd_registro_variavel := tp_registro_w;
					regra_sped_p => regra_sped_p := ctb_sped_ecd_pck.inserir_registros_vetor(regra_sped_p => regra_sped_p, ds_linha_p => ds_linha_w);
					if (regra_sped_p.registros.count >= 1000) then
						regra_sped_p => regra_sped_p := ctb_sped_ecd_pck.persistir_registros_em_lote(regra_sped_p => regra_sped_p, nm_usuario_p => nm_usuario_p);
					end if;	
					end loop;
					regra_sped_p => regra_sped_p := ctb_sped_ecd_pck.persistir_registros_em_lote(regra_sped_p => regra_sped_p, nm_usuario_p => nm_usuario_p);
				end loop;
			close c_ind_cod_aglut_dmpl;
		end if;

		if (regra_sped_p.registros.count >= 1000) then
			regra_sped_p => regra_sped_p := ctb_sped_ecd_pck.persistir_registros_em_lote(regra_sped_p => regra_sped_p, nm_usuario_p => nm_usuario_p);
		end if;	
		end loop;
		regra_sped_p => regra_sped_p := ctb_sped_ecd_pck.persistir_registros_em_lote(regra_sped_p => regra_sped_p, nm_usuario_p => nm_usuario_p);
	end loop;
close c_plano_contas;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_sped_ecd_pck.gerar_interf_i050_ecd (regra_sped_p INOUT ctb_sped_ecd_pck.regra_sped, nm_usuario_p text) FROM PUBLIC;