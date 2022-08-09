-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tiss_gerar_conta_opm_exec ( nr_interno_conta_p bigint, nm_usuario_p text) AS $body$
DECLARE



cd_cgc_estab_w		varchar(20);
cd_opm_w		varchar(20);
qt_opm_w		double precision;
cd_tabela_w		varchar(20);
vl_unitario_w		double precision;
vl_opm_w		double precision;
cd_autorizacao_w		varchar(30);
cd_cgc_prestador_w	varchar(20);
cd_cgc_prest_solic_tiss_w	varchar(20);
ds_opm_w		varchar(255);
ds_prestador_tiss_w	varchar(255);
ie_tiss_tipo_guia_desp_w	varchar(255);
ie_valor_unitario_opm_w	varchar(255);
ie_tipo_atendimento_w	smallint;
cd_convenio_w		integer;
cd_estabelecimento_w	smallint;
ie_emite_opm_zerado_w	varchar(3);
cd_prestador_tiss_w	varchar(100);
ie_pacote_w		varchar(255);
cd_senha_w		varchar(255);
ie_senha_guia_w		varchar(255);
nr_atendimento_w		bigint;
cont_w			bigint;
cd_medico_exec_tiss_w	varchar(20);
cd_categoria_w		varchar(10);	
nr_seq_classificacao_w	bigint;
cd_setor_atendimento_w	integer;
ie_clinica_w		integer;
ie_tipo_atend_tiss_w	varchar(2);
cd_barra_material_w	varchar(255);
nr_seq_mat_paci_w	bigint;
ie_agrupar_opme_w	varchar(1);
ie_senha_guia_regra_w	varchar(255);
ie_tipo_atend_tiss_conta_w	varchar(255);
ie_conversao_qtde_mat_w		varchar(10);
ie_qtd_material_w		varchar(10);
ie_tiss_tipo_despesa_w		varchar(10);
ie_digitos_desp_w		varchar(10);
ie_procedimento_w		varchar(2);
dt_mesano_referencia_w		timestamp;
ds_versao_w			varchar(20);


c01 CURSOR FOR
SELECT	coalesce(a.cd_material_tiss,
		TISS_OBTER_COD_MAT(a.cd_material_convenio, b.cd_estabelecimento,  a.cd_material, a.dt_conta,
					tiss_obter_origem_preco_mat(	a.ie_origem_preco,
									a.cd_material,
									b.cd_estabelecimento,
									b.cd_convenio_parametro,
									b.cd_categoria_parametro, a.cd_tab_preco_material,
									a.dt_conta, a.cd_setor_atendimento, 'X',a.nr_seq_proc_pacote,a.nr_sequencia, a.cd_material_tuss), 
									b.cd_convenio_parametro)) cd_opm,
	sum(CASE WHEN coalesce(TISS_OBTER_REGRA_QTDE_MAT(a.nr_sequencia),ie_conversao_qtde_mat_w)='M' THEN (TISS_OBTER_QTD_MAT(a.nr_sequencia,ie_qtd_material_w) * CASE WHEN coalesce(h.tx_conversao_qtde,0)=0 THEN 1  ELSE h.tx_conversao_qtde END ) WHEN coalesce(TISS_OBTER_REGRA_QTDE_MAT(a.nr_sequencia),ie_conversao_qtde_mat_w)='R' THEN (round(TISS_OBTER_QTD_MAT(a.nr_sequencia,ie_qtd_material_w) * CASE WHEN coalesce(h.tx_conversao_qtde,0)=0 THEN 1  ELSE h.tx_conversao_qtde END )) WHEN coalesce(TISS_OBTER_REGRA_QTDE_MAT(a.nr_sequencia),ie_conversao_qtde_mat_w)='D' THEN (dividir_sem_round(TISS_OBTER_QTD_MAT(a.nr_sequencia,ie_qtd_material_w), CASE WHEN coalesce(h.tx_conversao_qtde,0)=0 THEN 1  ELSE h.tx_conversao_qtde END )) WHEN coalesce(TISS_OBTER_REGRA_QTDE_MAT(a.nr_sequencia),ie_conversao_qtde_mat_w)='S' THEN (ceil(TISS_OBTER_QTD_MAT(a.nr_sequencia,ie_qtd_material_w) * CASE WHEN coalesce(h.tx_conversao_qtde,0)=0 THEN 1  ELSE h.tx_conversao_qtde END )) END ) qt_opm,
	TISS_OBTER_ORIGEM_PRECO_MAT(	a.ie_origem_preco, 
					a.cd_material, 
					b.cd_estabelecimento, 
					b.cd_convenio_parametro, 
					b.cd_categoria_parametro, 
					a.cd_tab_preco_material,
					a.dt_conta,
					a.cd_setor_atendimento,
					'X',
					a.nr_seq_proc_pacote,
					a.nr_sequencia,
					a.cd_material_tuss) ct_tabela,
	sum(a.vl_material) vl_opm,
	coalesce(a.nr_doc_convenio, obter_desc_expressao(778770)) cd_autorizacao,
	coalesce(a.cd_cgc_prestador_tiss, a.cd_cgc_prestador),
	substr(coalesce(a.ds_material_tiss, obter_desc_material(a.cd_material)),1,60),
	ie_tiss_tipo_guia_desp,
	a.cd_prestador_tiss,
	a.cd_cgc_prest_solic_tiss,
	dividir(sum(a.vl_material), sum(a.qt_material)) vl_unitario,
	a.ds_prestador_tiss,
	tiss_obter_regra_senha(b.cd_estabelecimento, b.cd_convenio_parametro, b.ie_tipo_atend_tiss, ie_tiss_tipo_guia_desp,
		ie_senha_guia_w, a.cd_senha) cd_senha,
	a.cd_medico_exec_tiss,
	CASE WHEN ie_agrupar_opme_w='N' THEN a.cd_setor_atendimento  ELSE null END  cd_setor_atendimento,
	substr(obter_barras_material(a.cd_material,null),1,255) cd_barra_material,
	CASE WHEN ie_agrupar_opme_w='N' THEN a.nr_sequencia  ELSE null END  nr_sequencia,
	b.ie_tipo_atend_tiss,
	a.ie_tiss_tipo_despesa,
	'N' ie_procedimento
FROM subgrupo_material g, classe_material f, material e, conta_paciente b, material_atend_paciente a
LEFT OUTER JOIN mat_atend_pac_convenio h ON (a.nr_sequencia = h.nr_seq_material)
WHERE b.nr_interno_conta			= a.nr_interno_conta and coalesce(a.cd_motivo_exc_conta::text, '') = '' and a.cd_material				= e.cd_material and f.cd_subgrupo_material			= g.cd_subgrupo_material and e.cd_classe_material			= f.cd_classe_material  --and	((f.ie_tipo_classe			in ('O','P','M')) or Edgar 16/01/2009, OS 123077, troquei o tratamento de tipo de classe por ie_tiss_tipo_despesa
  and ((a.ie_tiss_tipo_despesa		in ('7','8','9')) or (TISS_OBTER_REGRA_MAT_OPM(b.cd_convenio_parametro, b.cd_estabelecimento, e.cd_material, f.cd_classe_material, 
					  f.cd_subgrupo_material, g.cd_grupo_material, obter_tipo_atendimento(b.nr_atendimento),a.vl_unitario) = 'S')) and b.nr_interno_conta				= nr_interno_conta_p and ((coalesce(a.nr_seq_proc_pacote::text, '') = '') or
 	 (ie_pacote_w = 'I' AND a.nr_seq_proc_pacote IS NOT NULL AND a.nr_seq_proc_pacote::text <> '') or (ie_pacote_w = 'A'))
group 	by coalesce(a.cd_material_tiss,
		TISS_OBTER_COD_MAT(a.cd_material_convenio, b.cd_estabelecimento,  a.cd_material, a.dt_conta,
					tiss_obter_origem_preco_mat(	a.ie_origem_preco,
									a.cd_material,
									b.cd_estabelecimento,
									b.cd_convenio_parametro,
									b.cd_categoria_parametro, a.cd_tab_preco_material, 
									a.dt_conta, a.cd_setor_atendimento, 'X',a.nr_seq_proc_pacote,a.nr_sequencia, a.cd_material_tuss), 
									b.cd_convenio_parametro)),
	TISS_OBTER_ORIGEM_PRECO_MAT(	a.ie_origem_preco, 
					a.cd_material, 
					b.cd_estabelecimento, 
					b.cd_convenio_parametro, 
					b.cd_categoria_parametro, 
					a.cd_tab_preco_material,
					a.dt_conta, 
					a.cd_setor_atendimento,
					'X',
					a.nr_seq_proc_pacote,
					a.nr_sequencia,
					a.cd_material_tuss),
	coalesce(a.nr_doc_convenio, obter_desc_expressao(778770)),
	coalesce(a.cd_cgc_prestador_tiss, a.cd_cgc_prestador),
	substr(coalesce(a.ds_material_tiss, obter_desc_material(a.cd_material)),1,60),
	ie_tiss_tipo_guia_desp,
	a.cd_prestador_tiss,	
	a.cd_cgc_prest_solic_tiss,
	a.ds_prestador_tiss,
	tiss_obter_regra_senha(b.cd_estabelecimento, b.cd_convenio_parametro, b.ie_tipo_atend_tiss, ie_tiss_tipo_guia_desp,
		ie_senha_guia_w, a.cd_senha),
	a.cd_medico_exec_tiss,
	CASE WHEN ie_agrupar_opme_w='N' THEN a.cd_setor_atendimento  ELSE null END ,
	substr(obter_barras_material(a.cd_material,null),1,255),
	CASE WHEN ie_agrupar_opme_w='N' THEN a.nr_sequencia  ELSE null END ,
	b.ie_tipo_atend_tiss,
	a.ie_tiss_tipo_despesa
 
union

SELECT	coalesce(a.cd_procedimento_convenio,
		to_char(cd_procedimento)) cd_opm,
	sum(a.qt_procedimento) qt_opm,
	coalesce(substr(tiss_obter_tabela(a.cd_edicao_amb,
					b.cd_estabelecimento,
					b.cd_convenio_parametro,
					b.cd_categoria_parametro,
					a.dt_conta,
					'X',
					null,
					a.cd_procedimento,
					a.ie_origem_proced,
					a.nr_sequencia,
					a.nr_seq_proc_pacote,
					b.nr_atendimento,
					a.nr_seq_proc_interno,
					a.nr_seq_exame,
					a.cd_procedimento_tuss),1,20),'00') ct_tabela,
	sum(a.vl_procedimento) vl_opm,
	coalesce(a.nr_doc_convenio, obter_desc_expressao(778770)) cd_autorizacao,
	coalesce(a.cd_cgc_prestador_tiss, a.cd_cgc_prestador),
	substr(coalesce(a.ds_proc_tiss, obter_descricao_procedimento(a.cd_procedimento, a.ie_origem_proced)),1,60),
	a.ie_tiss_tipo_guia_desp,
	a.cd_prestador_tiss,
	a.cd_cgc_prest_solic_tiss,
	dividir(sum(a.vl_procedimento),sum(a.qt_procedimento)) vl_unitario,
	a.ds_prestador_tiss,
	tiss_obter_regra_senha(b.cd_estabelecimento, b.cd_convenio_parametro, b.ie_tipo_atend_tiss, ie_tiss_tipo_guia_desp,
		ie_senha_guia_w, a.cd_senha) cd_senha,
	a.cd_medico_exec_tiss,
	CASE WHEN ie_agrupar_opme_w='N' THEN a.cd_setor_atendimento  ELSE null END  cd_setor_atendimento,
	null cd_barra_material,
	CASE WHEN ie_agrupar_opme_w='N' THEN a.nr_sequencia  ELSE null END  nr_sequencia,
	b.ie_tipo_atend_tiss,
	a.ie_tiss_tipo_despesa,
	'S' ie_procedimento
from	procedimento_paciente a,
	conta_paciente b
where	b.nr_interno_conta			= a.nr_interno_conta
and	coalesce(a.cd_motivo_exc_conta::text, '') = ''
and	a.ie_tiss_tipo_despesa			in ('7','8','9')
and	b.nr_interno_conta				= nr_interno_conta_p
and	((coalesce(a.nr_seq_proc_pacote::text, '') = '') or
 	 (ie_pacote_w = 'I' AND a.nr_seq_proc_pacote IS NOT NULL AND a.nr_seq_proc_pacote::text <> '') or (ie_pacote_w = 'A'))
group 	by coalesce(a.cd_procedimento_convenio,to_char(cd_procedimento)),
	coalesce(substr(tiss_obter_tabela(a.cd_edicao_amb,
					b.cd_estabelecimento,
					b.cd_convenio_parametro,
					b.cd_categoria_parametro,
					a.dt_conta,
					'X',
					null,
					a.cd_procedimento,
					a.ie_origem_proced,
					a.nr_sequencia,
					a.nr_seq_proc_pacote,
					b.nr_atendimento,
					a.nr_seq_proc_interno,
					a.nr_seq_exame,
					a.cd_procedimento_tuss),1,20),'00'),
	coalesce(a.nr_doc_convenio, obter_desc_expressao(778770)),
	coalesce(a.cd_cgc_prestador_tiss, a.cd_cgc_prestador),
	substr(coalesce(a.ds_proc_tiss, obter_descricao_procedimento(a.cd_procedimento, a.ie_origem_proced)),1,60),
	a.ie_tiss_tipo_guia_desp,
	a.cd_prestador_tiss,
	a.cd_cgc_prest_solic_tiss,
	a.ds_prestador_tiss,
	tiss_obter_regra_senha(b.cd_estabelecimento, b.cd_convenio_parametro, b.ie_tipo_atend_tiss, ie_tiss_tipo_guia_desp,
		ie_senha_guia_w, a.cd_senha),
	a.cd_medico_exec_tiss,
	CASE WHEN ie_agrupar_opme_w='N' THEN a.cd_setor_atendimento  ELSE null END ,
	CASE WHEN ie_agrupar_opme_w='N' THEN a.nr_sequencia  ELSE null END ,
	b.ie_tipo_atend_tiss,
	a.ie_tiss_tipo_despesa;
	
c02 CURSOR FOR
SELECT	coalesce(ie_senha_guia,'N')
from	tiss_regra_senha
where	cd_estabelecimento						= cd_estabelecimento_w
and	coalesce(cd_convenio, coalesce(cd_convenio_w,0))				= coalesce(cd_convenio_w,0)
and	coalesce(ie_tipo_atend_tiss, coalesce(ie_tipo_atend_tiss_conta_w,'X'))	= coalesce(ie_tipo_atend_tiss_conta_w,'X')
and	coalesce(ie_tipo_guia, coalesce(ie_tiss_tipo_guia_desp_w,'X'))			= coalesce(ie_tiss_tipo_guia_desp_w,'X')
order by	coalesce(cd_convenio, 0),
	coalesce(ie_tipo_atend_tiss,'X'),
	coalesce(ie_tipo_guia,'X');


BEGIN

select	max(b.cd_cgc),
	max(obter_tipo_atendimento(a.nr_atendimento)),
	max(a.cd_convenio_parametro),	
	max(b.cd_estabelecimento),
	max(a.cd_categoria_parametro),
	max(c.nr_seq_classificacao),
	max(c.ie_clinica),
	max(c.ie_tipo_atend_tiss),
	max(a.dt_mesano_referencia)
into STRICT	cd_cgc_estab_w,
	ie_tipo_atendimento_w,
	cd_convenio_w,	
	cd_estabelecimento_w,
	cd_categoria_w,	
	nr_seq_classificacao_w,
	ie_clinica_w,	
	ie_tipo_atend_tiss_w,
	dt_mesano_referencia_w
from	atendimento_paciente c,
	estabelecimento b,
	conta_paciente a
where	a.nr_interno_conta 	= nr_interno_conta_p
and	a.nr_atendimento	= c.nr_atendimento
and	a.cd_estabelecimento	= b.cd_estabelecimento;

select	coalesce(max(ie_emite_opm_zerado), 'S'),
	coalesce(max(ie_valor_unitario_opm),'U'),
	coalesce(max(ie_pacote),'P'),
	coalesce(max(ie_senha_guia),'ACA'),
	coalesce(max(ie_agrupar_opme),'S'),
	coalesce(max(ie_conversao_qtde_mat),'M'),
	coalesce(max(ie_qtd_material),'M'),
	coalesce(max(ie_digitos_desp),'N')
into STRICT	ie_emite_opm_zerado_w,
	ie_valor_unitario_opm_w,
	ie_pacote_w,
	ie_senha_guia_w,
	ie_agrupar_opme_w,
	ie_conversao_qtde_mat_w,
	ie_qtd_material_w,
	ie_digitos_desp_w
from	tiss_parametros_convenio
where	cd_convenio		= cd_convenio_w
and	cd_estabelecimento	= cd_estabelecimento_w;

select	max(tiss_obter_versao(cd_convenio_w, cd_estabelecimento_w,dt_mesano_referencia_w))
into STRICT	ds_versao_w
;

--Para o TISS 3, as OPME sao geradas como despesas, entao nao deve gerar na TISS_CONTA_OPM_EXEC
if (obter_se_projeto_versao(0,12,ds_versao_w,0) = 'N') then

	open c01;
	loop
	fetch c01 into
		cd_opm_w,
		qt_opm_w,
		cd_tabela_w,
		vl_opm_w,
		cd_autorizacao_w,
		cd_cgc_prestador_w,
		ds_opm_w,
		ie_tiss_tipo_guia_desp_w,
		cd_prestador_tiss_w,
		cd_cgc_prest_solic_tiss_w,
		vl_unitario_w,
		ds_prestador_tiss_w,
		cd_senha_w,
		cd_medico_exec_tiss_w,
		cd_setor_atendimento_w,
		cd_barra_material_w,
		nr_seq_mat_paci_w,
		ie_tipo_atend_tiss_conta_w,
		ie_tiss_tipo_despesa_w,
		ie_procedimento_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */

		open C02;
		loop
		fetch C02 into	
			ie_senha_guia_regra_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin
			ie_senha_guia_regra_w	:= ie_senha_guia_regra_w;
			end;
		end loop;
		close C02;

		ie_senha_guia_w	:= coalesce(ie_senha_guia_regra_w, ie_senha_guia_w);

		if (ie_senha_guia_w		<> 'P') and (coalesce(nr_interno_conta_p,0)	> 0) then

			select	max(a.nr_atendimento)
			into STRICT	nr_atendimento_w
			from	conta_paciente a
			where	a.nr_interno_conta	= nr_interno_conta_p;

			select	count(*)
			into STRICT	cont_w
			from	autorizacao_convenio a
			where	a.nr_atendimento	= nr_atendimento_w
			and	a.cd_autorizacao	= cd_autorizacao_w;

			if (cont_w > 0) then
				select	max(a.cd_senha)
				into STRICT	cd_senha_w
				from	autorizacao_convenio a
				where	a.nr_atendimento	= nr_atendimento_w
				and	a.cd_autorizacao	= cd_autorizacao_w
				and	a.nr_sequencia		=
					(SELECT		max(x.nr_sequencia)
					from		autorizacao_convenio x
					where		x.nr_atendimento	= a.nr_atendimento
					and		x.cd_autorizacao	= a.cd_autorizacao);
			end if;

		end if;

		if (ie_valor_unitario_opm_w = 'TQ') then
			vl_unitario_w	:= dividir_sem_round(vl_opm_w, qt_opm_w);
		end if;	
		
		if (ie_digitos_desp_w	= 'N') then
			if (length(trim(both cd_opm_w)) < 8) then
				cd_opm_w	:= lpad(trim(both cd_opm_w), 8, '0');
			end if;
		elsif (ie_digitos_desp_w	= 'S') then
			if (length(trim(both cd_opm_w)) < 10) then
				cd_opm_w	:= lpad(trim(both cd_opm_w), 10, '0');
			end if;
		elsif (ie_digitos_desp_w	= 'M') then
			if (length(trim(both cd_opm_w)) < 10) then
				if (ie_procedimento_w	= 'N') then
					cd_opm_w	:= lpad(trim(both cd_opm_w), 10, '0');
				else
					cd_opm_w	:= lpad(trim(both cd_opm_w), 8, '0');
				end if;
			end if;
		elsif (ie_digitos_desp_w	= 'R') then
			if (length(trim(both cd_opm_w)) < 8) then
				cd_opm_w	:= substr(lpad(trim(both cd_opm_w), 8, '0'),1,8);
			elsif (length(trim(both cd_opm_w)) = 9) then
				cd_opm_w	:= substr(trim(both cd_opm_w),2,8);
			elsif (length(trim(both cd_opm_w)) > 9) then
				cd_opm_w	:= substr(trim(both cd_opm_w),3,8);
			end if;
		elsif (ie_digitos_desp_w	= 'D') then /*lhalves OS258181*/
			if (length(trim(both cd_opm_w)) < 10) then
				if (ie_procedimento_w	= 'S') then
					cd_opm_w	:= lpad(trim(both cd_opm_w), 8, ' ');
				else
					cd_opm_w	:= lpad(trim(both cd_opm_w), 8, '0');
				end if;
			end if;	
		elsif (ie_digitos_desp_w	= 'I') then --Conforme Regra		
			cd_opm_w	:= TISS_OBTER_REGRA_CODIGO_DESP(cd_estabelecimento_w,cd_convenio_w,ie_tiss_tipo_despesa_w,cd_opm_w,null,null,null);
		end if;

		if (coalesce(cd_cgc_prestador_w::text, '') = '') then
			cd_cgc_prestador_w		:= cd_cgc_estab_w;
		end if;	
		
		if (cd_medico_exec_tiss_w IS NOT NULL AND cd_medico_exec_tiss_w::text <> '') then --lhalves OS 200142 18/03/2010 - Aplicar regra prestador de PF sobre a OPM
			cd_cgc_prestador_w		:= null;
		end if;

		if (coalesce(qt_opm_w,0) > 0) and
			((ie_emite_opm_zerado_w	= 'S') or (coalesce(vl_opm_w, 0) > 0)) then
		
			insert into tiss_conta_opm_exec(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_interno_conta,
				cd_autorizacao,
				nr_seq_guia,
				cd_opm,
				cd_barras,
				cd_tabela,
				ds_opm,
				qt_opm,
				vl_unitario_opm,
				vl_opm,
				cd_cgc_prestador,
				ie_tiss_tipo_guia_desp,
				cd_prestador_tiss,
				cd_cgc_prest_solic_tiss,
				cd_medico_exec_tiss,
				ds_prestador_tiss,
				cd_senha)
			values (nextval('tiss_conta_opm_exec_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_interno_conta_p,
				cd_autorizacao_w,
				null,
				cd_opm_w,
				substr(cd_barra_material_w,1,20),
				cd_tabela_w,
				tiss_eliminar_caractere(ds_opm_w),
				qt_opm_w,
				tiss_obter_regra_campo(ie_tiss_tipo_guia_desp_w,'VL_UNITARIO_OPM',cd_convenio_w,vl_unitario_w,ie_tipo_atendimento_w,cd_categoria_w,'N',0,cd_estabelecimento_w,ie_clinica_w,nr_seq_classificacao_w,cd_setor_atendimento_w,ie_tipo_atend_tiss_w||'#@',cd_setor_atendimento_w),
				vl_opm_w,
				cd_cgc_prestador_w,
				ie_tiss_tipo_guia_desp_w,
				cd_prestador_tiss_w,
				cd_cgc_prest_solic_tiss_w,
				cd_medico_exec_tiss_w,
				ds_prestador_tiss_w,
				cd_senha_w);
		end if;

	end loop;
	close c01;

	if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tiss_gerar_conta_opm_exec ( nr_interno_conta_p bigint, nm_usuario_p text) FROM PUBLIC;
