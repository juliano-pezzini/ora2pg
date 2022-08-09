-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_oc_cta_tratar_val_105 ( dados_regra_p pls_tipos_ocor_pck.dados_regra, nr_id_transacao_p pls_selecao_ocor_cta.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: 
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[ ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------

Pontos de atenção:

Alterações:
-------------------------------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
tb_seq_selecao_w		dbms_sql.number_table;
tb_observacao_w			dbms_sql.varchar2_table;
tb_valido_w			dbms_sql.varchar2_table;
tb_seq_item_w			pls_util_cta_pck.t_number_table;
tb_qt_item_w			pls_util_cta_pck.t_number_table;
tb_qt_permitido_w		pls_util_cta_pck.t_number_table;
i				integer;
j				integer;
qt_cnt_w			integer;
qt_valido_w			integer;
qt_permitido_w			pls_oc_cta_val_util_inter.qt_permitido%type;
dt_proc_ref_w			pls_conta_proc.dt_procedimento_referencia%type;
dt_proc_ref_ant_w		pls_conta_proc.dt_procedimento_referencia%type;
cd_procedimento_ant_w		pls_conta_proc.cd_procedimento%type;
ie_origem_proced_ant_w		pls_conta_proc.ie_origem_proced%type;	
nr_seq_grau_partic_ant_w	pls_grau_participacao.nr_sequencia%type;
qt_item_w			pls_conta_proc.qt_procedimento_imp%type;
nr_seq_material_ant_w		pls_material.nr_sequencia%type;

C01 CURSOR(nr_seq_oc_cta_comb_pc	pls_oc_cta_combinada.nr_sequencia%type) FOR
	SELECT	nr_seq_estrutura,
		qt_permitido,
		ie_data_referencia,
		ie_considerar_grau_part
	from	pls_oc_cta_val_util_inter a
	where	a.nr_seq_oc_cta_comb = nr_seq_oc_cta_comb_pc;
	
C02 CURSOR(	nr_seq_estrutura_pc		pls_ocorrencia_estrutura.nr_sequencia%type,
		nr_id_transacao_pc		pls_selecao_ocor_cta.nr_id_transacao%type) FOR
	SELECT	sel.nr_sequencia nr_seq_selecao,
		(SELECT	count(1)
		 from	pls_ocorrencia_estrut_item c
		 where	c.nr_seq_estrutura = nr_seq_estrutura_pc
		 and	c.cd_procedimento = sel.cd_procedimento
		 and	c.ie_origem_proced = sel.ie_origem_proced) qt_proc,
		(select	count(1)
		 from	pls_ocorrencia_estrut_item c
		 where	c.nr_seq_estrutura = nr_seq_estrutura_pc
		 and	c.nr_seq_material = sel.nr_seq_material) qt_mat
	from	pls_selecao_ocor_cta sel
	where	sel.nr_id_transacao = nr_id_transacao_pc;
				
C03 CURSOR(nr_id_transacao_pc		pls_selecao_ocor_cta.nr_id_transacao%type) FOR
	SELECT	distinct sel.nr_seq_segurado,
		sel.cd_guia_referencia cd_guia_ok,
		a.qt_dias_internacao,
		a.dt_entrada_ref dt_entrada,
		a.dt_alta_ref dt_alta
	from	pls_conta_v a,
		pls_selecao_ocor_cta sel
	where	a.nr_sequencia		= sel.nr_seq_conta
	and	a.ie_tipo_guia		= '5'
	and	sel.nr_id_transacao 	= nr_id_transacao_pc
	and	sel.ie_valido 		= 'S';
	
C04 CURSOR(	nr_seq_segurado_pc		pls_segurado.nr_sequencia%type,
		cd_guia_ok_pc			pls_conta.cd_guia_ok%type,
		dt_entrada_pc			pls_conta.dt_entrada%type,
		dt_alta_pc			pls_conta.dt_alta%type) FOR
	SELECT	proc.nr_sequencia nr_seq_conta_proc,
		proc.qt_procedimento_imp qt_proc,
		proc.cd_procedimento,
		proc.ie_origem_proced,
		proc.dt_procedimento dt_proc,
		proc.dt_inicio_proc,
		proc.dt_fim_proc,
		(SELECT	max(nr_seq_grau_partic)
		 from	pls_proc_participante partic
		 where	partic.nr_seq_conta_proc = proc.nr_sequencia) nr_seq_grau_partic
	from	pls_conta conta,
		pls_conta_proc_v proc
	where	conta.nr_sequencia		= proc.nr_seq_conta
	and	conta.cd_guia_ok 		= cd_guia_ok_pc
	and	conta.nr_seq_segurado 		= nr_seq_segurado_pc
	and	proc.dt_procedimento between dt_entrada_pc and dt_alta_pc
	order by
		proc.cd_procedimento,
		proc.ie_origem_proced,
		proc.dt_procedimento;
		
C05 CURSOR(	nr_seq_segurado_pc		pls_segurado.nr_sequencia%type,
		cd_guia_ok_pc			pls_conta.cd_guia_ok%type,
		dt_entrada_pc			pls_conta.dt_entrada%type,
		dt_alta_pc			pls_conta.dt_alta%type) FOR
	SELECT	mat.nr_sequencia nr_seq_conta_mat,
		mat.qt_material_imp qt_mat,
		mat.nr_seq_material
	from	pls_conta_mat mat,
		pls_conta conta
	where	conta.nr_sequencia 	= mat.nr_seq_conta
	and	conta.cd_guia_ok 	= cd_guia_ok_pc
	and	conta.nr_seq_segurado 	= nr_seq_segurado_pc
	and	mat.dt_atendimento between dt_entrada_pc and dt_alta_pc
	order by
		mat.nr_seq_material,
		mat.dt_atendimento;
		
procedure gerar_ocorrencia(	tb_seq_proc_p		in out	pls_util_cta_pck.t_number_table,
				tb_qt_proc_p		in out	pls_util_cta_pck.t_number_table,
				tb_qt_permitido_p	in out	pls_util_cta_pck.t_number_table,
				nr_id_transacao_p	in 	pls_selecao_ocor_cta.nr_id_transacao%type,
				ie_tipo_item_p		in	text) is

idx	integer;
				
C01 CURSOR(	nr_seq_item_pc		pls_conta_proc.nr_sequencia%type,
		nr_id_transacao_pc	pls_selecao_ocor_cta.nr_id_transacao%type,
		ie_tipo_item_pc		text) FOR
	SELECT	sel.nr_sequencia nr_seq_selecao
	from	pls_selecao_ocor_cta sel
	where	sel.nr_seq_conta_proc	= nr_seq_item_pc
	and	sel.nr_id_transacao	= nr_id_transacao_pc
	and	ie_tipo_item_pc		= 'P'
	and	sel.ie_valido = 'S'
	
union all

	SELECT	sel.nr_sequencia nr_seq_selecao
	from	pls_selecao_ocor_cta sel
	where	sel.nr_seq_conta_mat	= nr_seq_item_pc
	and	sel.nr_id_transacao	= nr_id_transacao_pc
	and	ie_tipo_item_pc		= 'M'
	and	sel.ie_valido = 'S';
				
BEGIN
tb_seq_selecao_w	:= pls_tipos_ocor_pck.num_table_vazia;
tb_observacao_w		:= pls_tipos_ocor_pck.vchr2_table_vazia;
tb_valido_w		:= pls_tipos_ocor_pck.vchr2_table_vazia;
i			:= 0;

for idx in tb_seq_proc_p.first .. tb_seq_proc_p.last loop
	for r_C01_w in C01(tb_seq_proc_p(idx), nr_id_transacao_p, ie_tipo_item_p) loop
		
		tb_seq_selecao_w(i) := r_C01_w.nr_seq_selecao;
		tb_observacao_w(i) := '	Quantidade informada ultrapassa quantidade permitida por dia de internação. ' || pls_util_pck.enter_w ||
				      '	Quantidade informada: ' || tb_qt_proc_p(idx) || '.' || pls_util_pck.enter_w ||
				      '	Quantidade permitida: ' || tb_qt_permitido_p(idx) || '.';
		tb_valido_w(i) := 'S';
		
		if (tb_seq_selecao_w.count > qt_cnt_w) then
			CALL pls_tipos_ocor_pck.gerencia_selecao_validacao(	tb_seq_selecao_w,
									pls_tipos_ocor_pck.clob_table_vazia,
									'SEQ',
									tb_observacao_w,
									tb_valido_w,
									nm_usuario_p);
										
			tb_seq_selecao_w	:= pls_tipos_ocor_pck.num_table_vazia;
			tb_observacao_w		:= pls_tipos_ocor_pck.vchr2_table_vazia;
			tb_valido_w		:= pls_tipos_ocor_pck.vchr2_table_vazia;
			i			:= 0;
		else
			i := i + 1;
		end if;
	end loop;
end loop;

if (tb_seq_selecao_w.count > 0) then
	CALL pls_tipos_ocor_pck.gerencia_selecao_validacao(	tb_seq_selecao_w,
							pls_tipos_ocor_pck.clob_table_vazia,
							'SEQ',
							tb_observacao_w,
							tb_valido_w,
							nm_usuario_p);
							
	tb_seq_selecao_w	:= pls_tipos_ocor_pck.num_table_vazia;
	tb_observacao_w		:= pls_tipos_ocor_pck.vchr2_table_vazia;
	tb_valido_w		:= pls_tipos_ocor_pck.vchr2_table_vazia;
	i			:= 0;
end if;

tb_seq_proc_p.delete;
tb_qt_proc_p.delete;
tb_qt_permitido_p.delete;

end;
		
begin
-- Somente executa se tiver regra cadastrada
if (dados_regra_p.nr_sequencia IS NOT NULL AND dados_regra_p.nr_sequencia::text <> '') then
	-- tratamento em campo auxiliar para identificar posteriormente os registros que foram alterados
	CALL pls_tipos_ocor_pck.atualiza_campo_auxiliar('V', nr_id_transacao_p, null, dados_regra_p);
	
	--Grava a quantidade de registro por transação
	qt_cnt_w := pls_cta_consistir_pck.qt_registro_transacao_w;
	
	-- Inicializa as variáveis
	tb_seq_selecao_w	:= pls_tipos_ocor_pck.num_table_vazia;
	tb_observacao_w		:= pls_tipos_ocor_pck.vchr2_table_vazia;
	tb_valido_w		:= pls_tipos_ocor_pck.vchr2_table_vazia;
	i			:= 0;
	
	for r_C01_w in C01(dados_regra_p.nr_sequencia) loop
	
		tb_seq_selecao_w		:= pls_tipos_ocor_pck.num_table_vazia;
		tb_observacao_w			:= pls_tipos_ocor_pck.vchr2_table_vazia;
		tb_valido_w			:= pls_tipos_ocor_pck.vchr2_table_vazia;
		i 				:= 0;
		j 				:= 0;
		qt_permitido_w 			:= 0;
		nr_seq_grau_partic_ant_w	:= 0;
		qt_item_w 			:= 0;
		cd_procedimento_ant_w 		:= 0;
		ie_origem_proced_ant_w 		:= 0;
		dt_proc_ref_ant_w 		:= to_date('01/01/1999', 'dd/mm/yyyy');
		tb_seq_item_w.delete;
		tb_qt_item_w.delete;
		tb_qt_permitido_w.delete;
		
		for r_C02_w in C02(r_C01_w.nr_seq_estrutura, nr_id_transacao_p) loop
			
			if (r_C02_w.qt_proc > 0) or (r_C02_w.qt_mat > 0) then
				
				tb_seq_selecao_w(i) := r_C02_w.nr_seq_selecao;
				tb_observacao_w(i) := '';
				tb_valido_w(i) := 'S';
				
				if (tb_seq_selecao_w.count > qt_cnt_w) then
					CALL pls_tipos_ocor_pck.gerencia_selecao_validacao(	tb_seq_selecao_w,
											pls_tipos_ocor_pck.clob_table_vazia,
											'SEQ',
											tb_observacao_w,
											tb_valido_w,
											nm_usuario_p);
											
					tb_seq_selecao_w	:= pls_tipos_ocor_pck.num_table_vazia;
					tb_observacao_w		:= pls_tipos_ocor_pck.vchr2_table_vazia;
					tb_valido_w		:= pls_tipos_ocor_pck.vchr2_table_vazia;
					i			:= 0;
				else
					i := i + 1;
				end if;
			end if;
		end loop;
		
		if (tb_seq_selecao_w.count > 0) then
			CALL pls_tipos_ocor_pck.gerencia_selecao_validacao(	tb_seq_selecao_w,
									pls_tipos_ocor_pck.clob_table_vazia,
									'SEQ',
									tb_observacao_w,
									tb_valido_w,
									nm_usuario_p);
									
			tb_seq_selecao_w	:= pls_tipos_ocor_pck.num_table_vazia;
			tb_observacao_w		:= pls_tipos_ocor_pck.vchr2_table_vazia;
			tb_valido_w		:= pls_tipos_ocor_pck.vchr2_table_vazia;
			i			:= 0;
		end if;
	end loop;
	
	-- seta os registros que serão válidos ou inválidos após o processamento 
	CALL pls_tipos_ocor_pck.atualiza_campo_valido('V', nr_id_transacao_p, null, dados_regra_p);
	
	-- tratamento em campo auxiliar para identificar posteriormente os registros que foram alterados
	CALL pls_tipos_ocor_pck.atualiza_campo_auxiliar('V', nr_id_transacao_p, null, dados_regra_p);
	
	-- Verifica se ainda restou algum item à ser validado na seleção
	select	count(1)
	into STRICT	qt_valido_w
	from	pls_selecao_ocor_cta
	where	nr_id_transacao = nr_id_transacao_p
	and	ie_valido = 'S';
	
	if (qt_valido_w > 0) then
		
		for r_C01_w in C01(dados_regra_p.nr_sequencia) loop
			
			tb_seq_selecao_w		:= pls_tipos_ocor_pck.num_table_vazia;
			tb_observacao_w			:= pls_tipos_ocor_pck.vchr2_table_vazia;
			tb_valido_w			:= pls_tipos_ocor_pck.vchr2_table_vazia;
			i 				:= 0;
			j 				:= 0;
			qt_permitido_w 			:= 0;
			nr_seq_grau_partic_ant_w	:= 0;
			qt_item_w 			:= 0;
			nr_seq_material_ant_w		:= 0;
			cd_procedimento_ant_w 		:= 0;
			ie_origem_proced_ant_w 		:= 0;
			dt_proc_ref_ant_w 		:= to_date('01/01/1999', 'dd/mm/yyyy');
			tb_seq_item_w.delete;
			tb_qt_item_w.delete;
			tb_qt_permitido_w.delete;
			
			for r_C03_w in C03(nr_id_transacao_p) loop
				
				qt_permitido_w := r_C03_w.qt_dias_internacao * r_C01_w.qt_permitido;
				
				for r_C04_w in C04(r_C03_w.nr_seq_segurado, r_C03_w.cd_guia_ok, r_C03_w.dt_entrada, r_C03_w.dt_alta) loop
					
					if (r_C01_w.ie_data_referencia = 'DA') then
						dt_proc_ref_w := r_C04_w.dt_proc;
					elsif (r_C01_w.ie_data_referencia = 'HI') then
						dt_proc_ref_w := r_C04_w.dt_inicio_proc;
					elsif (r_C01_w.ie_data_referencia = 'HF') then
						dt_proc_ref_w := r_C04_w.dt_fim_proc;
					end if;
					
					if (r_C04_w.cd_procedimento = cd_procedimento_ant_w) and (r_C04_w.ie_origem_proced = ie_origem_proced_ant_w) then
						
						if (r_C01_w.ie_considerar_grau_part = 'S') and (r_C04_w.nr_seq_grau_partic IS NOT NULL AND r_C04_w.nr_seq_grau_partic::text <> '') then
							
							if (r_C04_w.nr_seq_grau_partic <> nr_seq_grau_partic_ant_w) then
								if (dt_proc_ref_w <> dt_proc_ref_ant_w) then
									qt_item_w := qt_item_w + r_C04_w.qt_proc;
								end if;
							else
								qt_item_w := qt_item_w + r_C04_w.qt_proc;
							end if;
						else
							qt_item_w := qt_item_w + r_C04_w.qt_proc;
						end if;
					else
						qt_item_w := r_C04_w.qt_proc;
					end if;
					
					cd_procedimento_ant_w := r_C04_w.cd_procedimento;
					ie_origem_proced_ant_w := r_C04_w.ie_origem_proced;
					nr_seq_grau_partic_ant_w := r_C04_w.nr_seq_grau_partic;
					dt_proc_ref_ant_w := dt_proc_ref_w;
					
					if (qt_item_w > qt_permitido_w) then
						
						tb_seq_item_w(j) := r_C04_w.nr_seq_conta_proc;
						tb_qt_item_w(j) := qt_item_w;
						tb_qt_permitido_w(j) := qt_permitido_w;
						
						if (tb_seq_item_w.count > qt_cnt_w) then
							gerar_ocorrencia(tb_seq_item_w, tb_qt_item_w, tb_qt_permitido_w, nr_id_transacao_p, 'P');
							
							j := 0;
						else
							j := j + 1;
						end if;						
					end if;
				end loop;
				
				if (tb_seq_item_w.count > 0) then
					gerar_ocorrencia(tb_seq_item_w, tb_qt_item_w, tb_qt_permitido_w, nr_id_transacao_p, 'P');
							
					j := 0;
				end if;
				
				qt_item_w := 0;
				
				for r_C05_w in C05(r_C03_w.nr_seq_segurado, r_C03_w.cd_guia_ok, r_C03_w.dt_entrada, r_C03_w.dt_alta) loop
					
					if (r_C05_w.nr_seq_material = nr_seq_material_ant_w) then
						qt_item_w := qt_item_w + r_C05_w.qt_mat;
					else
						qt_item_w := r_C05_w.qt_mat;
					end if;
					
					nr_seq_material_ant_w := r_C05_w.nr_seq_material;
					
					if (qt_item_w > qt_permitido_w) then
					
						tb_seq_item_w(j) := r_C05_w.nr_seq_conta_mat;
						tb_qt_item_w(j) := qt_item_w;
						tb_qt_permitido_w(j) := qt_permitido_w;
						
						if (tb_seq_item_w.count > qt_cnt_w) then
							gerar_ocorrencia(tb_seq_item_w, tb_qt_item_w, tb_qt_permitido_w, nr_id_transacao_p, 'M');
							
							j := 0;
						else
							j := j + 1;						
						end if;
					end if;
				end loop;
				
				if (tb_seq_item_w.count > 0) then
					gerar_ocorrencia(tb_seq_item_w, tb_qt_item_w, tb_qt_permitido_w, nr_id_transacao_p, 'M');
				end if;
			end loop;
		end loop;
		-- seta os registros que serão válidos ou inválidos após o processamento 
		CALL pls_tipos_ocor_pck.atualiza_campo_valido('V', nr_id_transacao_p, null, dados_regra_p);
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_oc_cta_tratar_val_105 ( dados_regra_p pls_tipos_ocor_pck.dados_regra, nr_id_transacao_p pls_selecao_ocor_cta.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
