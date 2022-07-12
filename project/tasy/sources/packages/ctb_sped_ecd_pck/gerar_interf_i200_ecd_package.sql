-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ctb_sped_ecd_pck.gerar_interf_i200_ecd (regra_sped_p INOUT ctb_sped_ecd_pck.regra_sped, nm_usuario_p text) AS $body$
DECLARE

			

vl_credito_total_w		ctb_movimento.vl_movimento%type;
vl_debito_total_w		ctb_movimento.vl_movimento%type;
sep_w				varchar(1)	:= '|';
ie_tipo_lancamento_w		varchar(2);
tp_registro_w			varchar(15);
cd_codigo_conta_ecd_w		varchar(40);
ds_historico_w			varchar(255);
ds_linha_w			varchar(8000);
dt_movimento_w			timestamp;
dt_inicio_w			timestamp;
dt_fim_w			timestamp;
vl_movimento_w			double precision;
nr_agrup_sequencial_w		bigint;
nr_agrup_sequencial_ant		bigint;
dt_lancto_ext_w			ctb_movimento.dt_lancto_ext%type;

c_partidas_ag CURSOR(
	cd_estabelecimento_pc	 ctb_sped_controle.cd_estabelecimento%type,
	cd_empresa_pc 		 ctb_sped_controle.cd_empresa%type,
	dt_ref_inicial_pc	 ctb_sped_controle.dt_ref_inicial%type,
	dt_ref_final_pc		 ctb_sped_controle.dt_ref_final%type,
	dt_inicio_pc		 ctb_mes_ref.dt_referencia%type,
	dt_fim_pc		 ctb_mes_ref.dt_referencia%type,
	ie_consolida_empresa_pc  ctb_regra_sped.ie_consolida_empresa%type
	)FOR
	SELECT	x.nr_agrup_sequencial,
		x.dt_referencia,
		x.dt_movimento,
		x.cd_conta_contabil,
		x.cd_classificacao,
		x.cd_centro_custo,
		x.vl_movimento,
		x.ie_debito_credito,
		x.nr_documento,
		x.cd_historico,
		x.ds_historico,
		x.ds_compl_historico,
		x.ie_encerramento,
		x.vl_credito,
		x.vl_debito,
		x.dt_lancto_ext
	from (	SELECT	a.nr_agrup_sequencial,
			b.dt_referencia,
			a.dt_movimento,
			a.cd_conta_contabil,
			a.cd_classificacao,
			CASE WHEN a.ie_centro_custo='N' THEN null  ELSE c.cd_centro_custo END 	cd_centro_custo,
			coalesce(coalesce(c.vl_movimento,a.vl_movimento),0)	vl_movimento,
			a.ie_debito_credito,
			a.nr_seq_agrupamento	nr_documento,
			a.cd_historico,
			a.ds_historico,
			a.ds_compl_historico,
			a.ie_encerramento,
			CASE WHEN a.ie_debito_credito='C' THEN coalesce(coalesce(c.vl_movimento,a.vl_movimento),0)  ELSE 0 END 	vl_credito,
			CASE WHEN a.ie_debito_credito='D' THEN coalesce(coalesce(c.vl_movimento,a.vl_movimento),0)  ELSE 0 END 	vl_debito,
			a.dt_lancto_ext
		FROM lote_contabil d, ctb_mes_ref b, ctb_movimento_v2 a
LEFT OUTER JOIN ctb_movto_centro_custo c ON (a.nr_sequencia = c.nr_seq_movimento)
WHERE b.nr_sequencia		= a.nr_seq_mes_ref and b.nr_sequencia		= d.nr_seq_mes_ref and d.nr_lote_contabil	= a.nr_lote_contabil and b.cd_empresa		= cd_empresa_pc and a.cd_estabelecimento	= coalesce(cd_estabelecimento_pc, a.cd_estabelecimento) and b.dt_referencia between dt_inicio_pc and dt_fim_pc and trunc(a.dt_movimento) between trunc(dt_ref_inicial_pc) and fim_dia(dt_ref_final_pc) and ie_consolida_empresa_pc	= 'N' and (a.nr_agrup_sequencial IS NOT NULL AND a.nr_agrup_sequencial::text <> '')
		
union all

		select	a.nr_agrup_sequencial,
			b.dt_referencia,
			a.dt_movimento,
			a.cd_conta_contabil,
			a.cd_classificacao,
			CASE WHEN a.ie_centro_custo='N' THEN null  ELSE c.cd_centro_custo END 	cd_centro_custo,
			coalesce(coalesce(c.vl_movimento,a.vl_movimento),0) vl_movimento,
			a.ie_debito_credito,
			a.nr_seq_agrupamento	nr_documento,
			a.cd_historico,
			a.ds_historico,
			a.ds_compl_historico,
			a.ie_encerramento,
			CASE WHEN a.ie_debito_credito='C' THEN coalesce(coalesce(c.vl_movimento,a.vl_movimento),0)  ELSE 0 END 	vl_credito,
			CASE WHEN a.ie_debito_credito='D' THEN coalesce(coalesce(c.vl_movimento,a.vl_movimento),0)  ELSE 0 END 	vl_debito,
			a.dt_lancto_ext
		FROM estabelecimento e, lote_contabil d, ctb_mes_ref b, ctb_movimento_v2 a
LEFT OUTER JOIN ctb_movto_centro_custo c ON (a.nr_sequencia = c.nr_seq_movimento)
WHERE b.nr_sequencia		= a.nr_seq_mes_ref and b.nr_sequencia		= d.nr_seq_mes_ref and d.nr_lote_contabil	= a.nr_lote_contabil and b.cd_empresa		= cd_empresa_pc and a.cd_estabelecimento	= e.cd_estabelecimento and b.dt_referencia between dt_inicio_pc and dt_fim_pc and trunc(a.dt_movimento) between trunc(dt_ref_inicial_pc) and fim_dia(dt_ref_final_pc) and coalesce(e.ie_gerar_sped,'S') = 'S' and coalesce(e.ie_scp, 'N')	!= 'S' and ie_consolida_empresa_pc	= 'S' and (a.nr_agrup_sequencial IS NOT NULL AND a.nr_agrup_sequencial::text <> '') order by 1, 2)
	x;

type vetor_partidas_ag is table of c_partidas_ag%rowtype index by integer;
v_partidas_ag_w   vetor_partidas_ag;

BEGIN

dt_inicio_w	:= 	trunc(regra_sped_p.dt_ref_inicial,'mm');
dt_fim_w	:=	fim_mes(regra_sped_p.dt_ref_final);

if (regra_sped_p.ie_forma_num_lcto = 'AG') then
	nr_agrup_sequencial_ant := 0;
	ie_tipo_lancamento_w	:= null;
	open c_partidas_ag(
		cd_estabelecimento_pc	=> regra_sped_p.cd_estabelecimento,
		cd_empresa_pc		=> regra_sped_p.cd_empresa, 		
		dt_ref_inicial_pc	=> regra_sped_p.dt_ref_inicial,	
		dt_ref_final_pc		=> regra_sped_p.dt_ref_final,	
		dt_inicio_pc		=> dt_inicio_w,
		dt_fim_pc		=> dt_fim_w,		
		ie_consolida_empresa_pc => regra_sped_p.ie_consolida_empresa
		);
		loop fetch c_partidas_ag bulk collect into v_partidas_ag_w limit 1000;
		EXIT WHEN NOT FOUND; /* apply on c_partidas_ag */
			for i in v_partidas_ag_w.first .. v_partidas_ag_w.last loop
		
			if (nr_agrup_sequencial_ant <> v_partidas_ag_w[i].nr_agrup_sequencial) or (coalesce(nr_agrup_sequencial_ant, 0) = 0) then
				
				if (nr_agrup_sequencial_ant <> v_partidas_ag_w[i].nr_agrup_sequencial) and (nr_agrup_sequencial_ant <> 0) then
					vl_movimento_w	:= vl_credito_total_w;

					if (vl_movimento_w = 0) then
						vl_movimento_w := vl_debito_total_w;
					end if;
				
					tp_registro_w		:= 'I200';
					
					if (regra_sped_p.cd_versao in ('7.0', '8.0')) then
						ds_linha_w		:= substr(	sep_w || tp_registro_w					||
											sep_w || nr_agrup_sequencial_w				||
											sep_w || to_char(dt_movimento_w,'ddmmyyyy')		||
											sep_w || sped_obter_campo_valor(vl_movimento_w)		||
											sep_w || ie_tipo_lancamento_w 				||
											sep_w || to_char(dt_lancto_ext_w,'ddmmyyyy')		||
											sep_w,1,8000);
					else
						ds_linha_w		:= substr(	sep_w || tp_registro_w					||
											sep_w || nr_agrup_sequencial_w				||
											sep_w || to_char(dt_movimento_w,'ddmmyyyy')		||
											sep_w || sped_obter_campo_valor(vl_movimento_w)		||
											sep_w || ie_tipo_lancamento_w 				||										
											sep_w,1,8000);
											
					end if;

					regra_sped_p.nr_doc_origem := nr_agrup_sequencial_w;
					regra_sped_p.cd_registro_variavel := tp_registro_w;
					regra_sped_p => regra_sped_p := ctb_sped_ecd_pck.inserir_registros_vetor(regra_sped_p => regra_sped_p, ds_linha_p => ds_linha_w);
					
				end if;
				vl_credito_total_w	:= 0;
				vl_debito_total_w	:= 0;
				dt_movimento_w		:= null;
				ie_tipo_lancamento_w	:= null;
				dt_lancto_ext_w		:= null;

			end if;


			if (coalesce(dt_movimento_w::text, '') = '') then
				dt_movimento_w	:= v_partidas_ag_w[i].dt_movimento;
			end if;

			if (coalesce(ie_tipo_lancamento_w,'X') = 'X') then
				ie_tipo_lancamento_w	:= 'N';

				if (v_partidas_ag_w[i].ie_encerramento = 'S') then
					ie_tipo_lancamento_w	:= 'E';
				end if;
			end if;
		
			dt_lancto_ext_w := v_partidas_ag_w[i].dt_lancto_ext;
			
			if (dt_lancto_ext_w IS NOT NULL AND dt_lancto_ext_w::text <> '') then
				ie_tipo_lancamento_w := 'X';
			end if;		

			nr_agrup_sequencial_w	:= v_partidas_ag_w[i].nr_agrup_sequencial;

			if (coalesce(v_partidas_ag_w[i].vl_credito, 0) 	<> 0) then
				vl_credito_total_w	:= vl_credito_total_w + v_partidas_ag_w[i].vl_credito;
			end if;

			if (coalesce(v_partidas_ag_w[i].vl_debito, 0) 	<> 0) then
				vl_debito_total_w 	:= vl_debito_total_w + v_partidas_ag_w[i].vl_debito;
			end if;

			tp_registro_w		:= 'I250';
			ds_historico_w		:= substr(v_partidas_ag_w[i].ds_historico || ' ' || v_partidas_ag_w[i].ds_compl_historico,1, 255);
			ds_historico_w		:= substr(replace(replace(replace(ds_historico_w,chr(13),' '),chr(10),' '),'|',''),1,255);
			ds_historico_w		:= substr(replace(ds_historico_w,chr(9),''),1,255);

			cd_codigo_conta_ecd_w	:= ctb_sped_ecd_pck.obter_cod_conta_ecd(ie_tipo_conta_p	=> 'C',
								ie_apres_conta_ctb_p	=> regra_sped_p.ie_apres_conta_ctb, 
								cd_empresa_p		=> null, 
								cd_conta_contabil_p	=> v_partidas_ag_w[i].cd_conta_contabil, 
								cd_classificacao_p	=> v_partidas_ag_w[i].cd_classificacao,
								dt_vigencia_p		=> null);

			ds_linha_w	:= substr(	sep_w || tp_registro_w							||
							sep_w || cd_codigo_conta_ecd_w						||
							sep_w || v_partidas_ag_w[i].cd_centro_custo				||
							sep_w || sped_obter_campo_valor(v_partidas_ag_w[i].vl_movimento)	||
							sep_w || v_partidas_ag_w[i].ie_debito_credito				||
							sep_w || v_partidas_ag_w[i].nr_documento 				||
							sep_w || v_partidas_ag_w[i].cd_historico 				||
							sep_w || ds_historico_w							||
							sep_w || ''								||
							sep_w, 1,8000);
							
			regra_sped_p.cd_registro_variavel := tp_registro_w;
			regra_sped_p => regra_sped_p := ctb_sped_ecd_pck.inserir_registros_vetor(regra_sped_p => regra_sped_p, ds_linha_p => ds_linha_w);

			nr_agrup_sequencial_ant := v_partidas_ag_w[i].nr_agrup_sequencial;
			
			end loop;
			regra_sped_p => regra_sped_p := ctb_sped_ecd_pck.persistir_registros_em_lote(regra_sped_p => regra_sped_p, nm_usuario_p => nm_usuario_p);
		end loop;
	close c_partidas_ag;

	vl_movimento_w	:= vl_credito_total_w;

	if (vl_movimento_w = 0) then
		vl_movimento_w	:= vl_debito_total_w;
	end if;


	tp_registro_w		:= 'I200';
	
	if (regra_sped_p.cd_versao in ('7.0', '8.0')) then
		ds_linha_w		:= substr(	sep_w || tp_registro_w					||
							sep_w || nr_agrup_sequencial_w				||
							sep_w || to_char(dt_movimento_w,'ddmmyyyy')		||
							sep_w || sped_obter_campo_valor(vl_movimento_w)		||
							sep_w || ie_tipo_lancamento_w 				||
							sep_w || to_char(dt_lancto_ext_w,'ddmmyyyy')		||
							sep_w,1,8000);
	else
		ds_linha_w		:= substr(	sep_w || tp_registro_w					||
							sep_w || nr_agrup_sequencial_w				||
							sep_w || to_char(dt_movimento_w,'ddmmyyyy')		||
							sep_w || sped_obter_campo_valor(vl_movimento_w)		||
							sep_w || ie_tipo_lancamento_w 				||
							sep_w,1,8000);
	end if;
	
	regra_sped_p.nr_doc_origem := nr_agrup_sequencial_w;
	regra_sped_p.cd_registro_variavel := tp_registro_w;
	regra_sped_p => regra_sped_p := ctb_sped_ecd_pck.inserir_registros_vetor(regra_sped_p => regra_sped_p, ds_linha_p => ds_linha_w);

end if;

regra_sped_p => regra_sped_p := ctb_sped_ecd_pck.persistir_registros_em_lote(regra_sped_p => regra_sped_p, nm_usuario_p => nm_usuario_p);
			
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_sped_ecd_pck.gerar_interf_i200_ecd (regra_sped_p INOUT ctb_sped_ecd_pck.regra_sped, nm_usuario_p text) FROM PUBLIC;
