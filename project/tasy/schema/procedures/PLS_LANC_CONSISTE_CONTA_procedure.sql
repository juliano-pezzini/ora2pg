-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_lanc_consiste_conta ( nr_seq_conta_p pls_conta.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Efetuar os lançamentos automáticos dos itens de conta médica na consistência da
mesma. É utilizada quando o evento a regra de lançamento for OPS - Contas medicas (iConta).
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[ X ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
				
ie_tipo_guia_w			pls_conta.ie_tipo_guia%type;
dt_emissao_w	 		pls_conta.dt_emissao%type;
nr_seq_ult_regra_w		pls_regra_lanc_automatico.nr_sequencia%type;
cd_procedimento_w		pls_regra_lanc_aut_item.cd_procedimento%type;
ie_origem_proced_w		pls_regra_lanc_aut_item.ie_origem_proced%type;
nr_seq_material_w		pls_regra_lanc_aut_item.nr_seq_material%type;
nr_seq_prest_fornecedor_w	pls_solic_lib_mat_med.nr_seq_prest_fornec%type;
cd_guia_ref_w			pls_conta.cd_guia_referencia%type;
nr_seq_segurado_w		pls_conta.nr_seq_segurado%type;
qt_aprovado_w			pls_conta_mat.qt_material_imp%type;
vl_unit_aprovado_w		pls_solic_lib_mat_med.vl_unit_aprovado%type;
nr_seq_prestador_exec_w		pls_conta.nr_seq_prestador_exec%type;
nr_seq_prestador_solic_w	pls_conta.nr_seq_prestador%type;
qt_contador_w			integer;
nr_seq_regra_w			pls_util_cta_pck.t_number_table;
ie_material_especial_ausente_w	pls_util_cta_pck.t_varchar2_table_1;
nr_seq_prest_fornec_w		pls_util_cta_pck.t_number_table;
nr_seq_conta_proc_w		pls_conta_proc.nr_sequencia%type;
nr_seq_conta_mat_w		pls_conta_mat.nr_sequencia%type;

--Obtém as regras de lançamento automático quando oevento for  OPS - Contas Médicas(Contas)
C01 CURSOR(	ie_tipo_guia_pc			pls_conta.ie_tipo_guia%type,
		dt_emissao_pc			pls_conta.dt_emissao%type,
		nr_seq_prestador_exec_pc	pls_conta.nr_seq_prestador_exec%type,
		nr_seq_prestador_solic_pc	pls_conta.nr_seq_prestador%type) FOR
	SELECT	nr_sequencia,
		ie_material_especial_ausente,
		nr_seq_prest_fornec
	from	pls_regra_lanc_automatico
	where	coalesce(ie_tipo_guia, ie_tipo_guia_pc) = ie_tipo_guia_pc
	and	trunc(dt_emissao_pc) between trunc(coalesce(dt_inicio_vigencia, dt_emissao_pc)) and trunc(coalesce(dt_fim_vigencia, dt_emissao_pc))
	and	ie_situacao 	= 'A'
	and	(('N' = ie_tipo_prestador) or
		 (('E' = ie_tipo_prestador) and (coalesce(nr_seq_prestador,0)  =  coalesce(nr_seq_prestador_exec_pc,0))) or
		 (('S' = ie_tipo_prestador) and (coalesce(nr_seq_prestador,0)  = coalesce(nr_seq_prestador_solic_pc,0))) or
		 (('A' = ie_tipo_prestador) and ((coalesce(nr_seq_prestador,0) = coalesce(nr_seq_prestador_exec_pc,0))
					    and (coalesce(nr_seq_prestador,0) = coalesce(nr_seq_prestador_solic_pc,0)))))
	and	ie_evento = '7'
	order by case ie_tipo_prestador when 'N' then 3
					when 'E' then 2
					when 'S' then 2
					when 'A' then 1
		 end,
		 coalesce(ie_tipo_guia, 'X'),
		 nr_sequencia;

--Obtém as ações de regra(Procedimento\Materiais) que podem ser lançados		 
C02 CURSOR(	nr_sequencia_regra_pc		pls_regra_lanc_automatico.nr_sequencia%type,
		cd_guia_referencia_pc		pls_conta.cd_guia_referencia%type,
		nr_seq_conta_pc			pls_conta.nr_sequencia%type)FOR
	SELECT	a.cd_procedimento cd_procedimento,
		a.ie_origem_proced ie_origem_proced,
		a.nr_seq_material nr_seq_material
	from	pls_regra_lanc_aut_item a
	where	a.nr_seq_regra = nr_sequencia_regra_pc
	and	ie_situacao	= 'A'
	and	not exists (	SELECT		1
				 from		pls_conta_mat 	x,
						pls_conta	y
				 where		x.nr_seq_conta		= y.nr_sequencia
				 and		(((coalesce(cd_guia_referencia_pc::text, '') = '') and (y.nr_sequencia = nr_seq_conta_pc)) or
						((y.cd_guia_referencia = cd_guia_referencia_pc) or (y.cd_guia = cd_guia_referencia_pc)))
				 and		x.nr_seq_material	= a.nr_seq_material )
	and	not exists (	select		1
				 from		pls_conta_proc 	x,
						pls_conta	y
				 where		x.nr_seq_conta		= y.nr_sequencia
				 and		(((coalesce(cd_guia_referencia_pc::text, '') = '') and (y.nr_sequencia = nr_seq_conta_pc)) or
						((y.cd_guia_referencia = cd_guia_referencia_pc) or (y.cd_guia = cd_guia_referencia_pc)))
				 and		x.ie_origem_proced = a.ie_origem_proced
				 and		x.cd_procedimento  = a.cd_procedimento)
	order by 1;

C03 CURSOR(	nr_seq_prest_fornec_regraq_pc 	pls_regra_lanc_automatico.nr_seq_prest_fornec%type,
		cd_guia_ref_pc			pls_conta.cd_guia_referencia%type,
		nr_seq_segurado_pc		pls_conta.nr_seq_segurado%type,
		nr_seq_conta_pc			pls_conta.nr_sequencia%type) FOR
	SELECT	a.nr_seq_material,
		a.qt_aprovado,
		a.vl_unit_aprovado,
		a.nr_seq_prest_fornec		
	from	pls_solic_lib_mat_med a,
		pls_guia_plano b
	where	a.nr_seq_guia		= b.nr_sequencia
	and	((a.nr_seq_prest_fornec = nr_seq_prest_fornec_regraq_pc) or (coalesce(nr_seq_prest_fornec_regraq_pc::text, '') = ''))
	and	b.cd_guia		= cd_guia_ref_pc
	and	b.nr_seq_segurado	= nr_seq_segurado_pc
	and	a.ie_status 		= 3
	and	not exists (SELECT		1
				 from		pls_conta_mat 	x,
						pls_conta	y
				 where		x.nr_seq_conta		= y.nr_sequencia
				 and		x.nr_seq_material	= a.nr_seq_material
				 and		x.ie_status 		<> 'D'
				 and		y.ie_status 		<> 'C'
				 and 		y.nr_sequencia 		= nr_seq_conta_pc
				 and		coalesce(cd_guia_ref_pc::text, '') = ''
				 
union all

				 select		1
				 from		pls_conta_mat 	x,
						pls_conta	y
				 where		x.nr_seq_conta		= y.nr_sequencia
				 and		x.nr_seq_material	= a.nr_seq_material
				 and		x.ie_status 		<> 'D'
				 and		y.ie_status 		<> 'C'
				 and		y.cd_guia_ok 		= cd_guia_ref_pc)
	order by 1;

BEGIN

select	max(ie_tipo_guia),
	max(dt_atendimento_referencia),
	max(coalesce(cd_guia_referencia, cd_guia)),
	max(nr_seq_segurado),
	max(nr_seq_prestador_exec),
	max(nr_seq_prestador)
into STRICT	ie_tipo_guia_w,
	dt_emissao_w,
	cd_guia_ref_w,
	nr_seq_segurado_w,
	nr_seq_prestador_exec_w,
	nr_seq_prestador_solic_w
from	pls_conta
where	nr_sequencia = nr_seq_conta_p;

qt_contador_w := 0;
for r_C01_w in C01(	ie_tipo_guia_w, dt_emissao_w, nr_seq_prestador_exec_w, nr_seq_prestador_solic_w) loop

	nr_seq_regra_w(qt_contador_w) := r_C01_w.nr_sequencia;
	ie_material_especial_ausente_w(qt_contador_w) := r_C01_w.ie_material_especial_ausente;
	nr_seq_prest_fornec_w(qt_contador_w) := r_C01_w.nr_seq_prest_fornec;
	
	qt_contador_w := qt_contador_w + 1;
end loop;

-- feito isso porque abaixo se precisa utilizar o último registro do cursor acima
qt_contador_w 		:= qt_contador_w - 1;
nr_seq_ult_regra_w	:= null;

--Teste se cursor das regras de lançamento retorna ao menos um registro
if (qt_contador_w >= 0) then
	nr_seq_ult_regra_w	:= nr_seq_regra_w(qt_contador_w);

	for r_C02_w in C02(	nr_seq_ult_regra_w, cd_guia_ref_w, nr_seq_conta_p) loop
		
		--Não lançará materiais quando for guia de consulta ou de honorário.
		if (((r_C02_w.nr_seq_material IS NOT NULL AND r_C02_w.nr_seq_material::text <> '') and ie_tipo_guia_w not in ('3','6')) or (r_C02_w.cd_procedimento IS NOT NULL AND r_C02_w.cd_procedimento::text <> '')) then
			ie_origem_proced_w := r_C02_w.ie_origem_proced;
			cd_procedimento_w := r_C02_w.cd_procedimento;
			nr_seq_material_w := r_C02_w.nr_seq_material;
			
			if (coalesce(cd_procedimento_w,0) > 0) then		
								
				insert into pls_conta_proc(nr_sequencia, cd_procedimento, ie_origem_proced,
					 qt_procedimento, dt_procedimento, ie_via_acesso,
					 nr_seq_conta, nm_usuario, nm_usuario_nrec,
					 dt_atualizacao, dt_atualizacao_nrec, ie_situacao,
					 ie_status, qt_procedimento_imp, nr_seq_regra_lanc_aut)
				values (nextval('pls_conta_proc_seq'), cd_procedimento_w, ie_origem_proced_w,
					 0, dt_emissao_w, null,
					 nr_seq_conta_p, nm_usuario_p, nm_usuario_p,
					 clock_timestamp(), clock_timestamp(), 'D',
					 'U', 1, nr_seq_ult_regra_w) returning nr_sequencia into nr_seq_conta_proc_w;	
				
				CALL pls_cta_proc_mat_regra_pck.cria_registro_regra_proc(nr_seq_conta_proc_w, nm_usuario_p);
				
				CALL pls_gravar_log_conta(	nr_seq_conta_p, nr_seq_conta_proc_w, null,
							'Procedimento '||nr_seq_conta_proc_w||' gerado a partir do lançamento automático! ', nm_usuario_p);

			end if;
				
			if (coalesce(nr_seq_material_w,0) > 0) then	

				insert into pls_conta_mat(nr_sequencia, nr_seq_material, qt_material_imp,
					 qt_material, vl_unitario_imp, vl_material_imp,
					 dt_atendimento, nr_seq_conta, nm_usuario, 
					 nm_usuario_nrec, dt_atualizacao, dt_atualizacao_nrec, 
					 ie_situacao, ie_status, nr_nota_fiscal,
					 nr_seq_prest_fornec, nr_seq_regra_lanc_aut)
				values (nextval('pls_conta_mat_seq'), nr_seq_material_w, 1,
					 0, 0, 0,
					 dt_emissao_w, nr_seq_conta_p, nm_usuario_p, 
					 nm_usuario_p, clock_timestamp(), clock_timestamp(), 
					 'D', 'U', null,
					 null,nr_seq_ult_regra_w ) returning nr_sequencia into nr_seq_conta_mat_w;
				
				CALL pls_cta_proc_mat_regra_pck.cria_registro_regra_mat(nr_seq_conta_mat_w, nm_usuario_p);
				
					CALL pls_gravar_log_conta(	nr_seq_conta_p, null,nr_seq_conta_mat_w,
								'Material '||nr_seq_conta_mat_w||' gerado a partir do lançamento automático! ', nm_usuario_p);

			end if;
		end if;
		
	end loop;
	
	--Enquanto tiver registro na variável tabela
	if (nr_seq_regra_w.count > 0) then
		
		--Percorre a variável tabela
		for i in nr_seq_regra_w.first .. nr_seq_regra_w.last loop
		
			if (coalesce(ie_material_especial_ausente_w(i),'N') = 'S') then
			
				for r_C03_w in C03(	nr_seq_prest_fornec_w(i) , cd_guia_ref_w, nr_seq_segurado_w, nr_seq_conta_p) loop
					
					nr_seq_material_w 		:= r_C03_w.nr_seq_material;
					qt_aprovado_w 			:= r_C03_w.qt_aprovado;
					vl_unit_aprovado_w 		:= r_C03_w.vl_unit_aprovado;
					nr_seq_prest_fornecedor_w 	:= r_C03_w.nr_seq_prest_fornec;
					
					insert into pls_conta_mat(nr_sequencia, nr_seq_material, qt_material_imp,
						 qt_material, vl_unitario_imp, vl_material_imp,
						 dt_atendimento, nr_seq_conta, nm_usuario, 
						 nm_usuario_nrec, dt_atualizacao, dt_atualizacao_nrec, 
						 ie_situacao, ie_status, nr_nota_fiscal,
						 nr_seq_prest_fornec, nr_seq_regra_lanc_aut)
					values (nextval('pls_conta_mat_seq'), nr_seq_material_w, qt_aprovado_w,
						 0, vl_unit_aprovado_w, (vl_unit_aprovado_w * qt_aprovado_w),
						 dt_emissao_w, nr_seq_conta_p, nm_usuario_p, 
						 nm_usuario_p, clock_timestamp(), clock_timestamp(), 
						 'D', 'U', null,
						 nr_seq_prest_fornecedor_w, nr_seq_regra_w(i))returning nr_sequencia into nr_seq_conta_mat_w;
				
					CALL pls_cta_proc_mat_regra_pck.cria_registro_regra_mat(nr_seq_conta_mat_w, nm_usuario_p);
					
						CALL pls_gravar_log_conta(	nr_seq_conta_p, null,nr_seq_conta_mat_w,
									'Material '||nr_seq_conta_mat_w||' gerado a partir do lançamento automático(2)! ', nm_usuario_p);
				end loop;
			end if;
		end loop;
	end if;
	
	CALL pls_cta_proc_mat_regra_pck.gera_seq_tiss_conta_proc(nr_seq_conta_p, nm_usuario_p);
	CALL pls_cta_proc_mat_regra_pck.gera_seq_tiss_conta_mat(nr_seq_conta_p, nm_usuario_p);
	
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_lanc_consiste_conta ( nr_seq_conta_p pls_conta.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
