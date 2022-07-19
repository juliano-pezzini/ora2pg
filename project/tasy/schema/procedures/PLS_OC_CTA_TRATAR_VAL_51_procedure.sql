-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_oc_cta_tratar_val_51 ( dados_regra_p pls_tipos_ocor_pck.dados_regra, nr_id_transacao_p pls_oc_cta_selecao_ocor_v.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:  Aplicar validacao referente a existencia de liminar judicial na requisicao ou na autorizacao
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[ X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------

Alteracoes:

------------------------------------------------------------------------------------------------------------------

dlehmkuhl OS 688483 - 14/04/2014 -

Alteracao:	Modificada a forma de trabalho em relacao a atualizacao dos campos de controle
	que basicamente decidem se a ocorrencia sera ou bao gerada. Foi feita tambem a 
	substituicao da rotina obterX_seX_geraX.

Motivo:	Necessario realizar essas alteracoes para corrigir bugs principalmente no que se
	refere a questao de aplicacao de filtros (passo anterior ao da validacao). Tambem
	tivemos um foco especial em performance, visto que a mesma precisou ser melhorada
	para nao inviabilizar a nova solicitacao que diz que a excecao deve verificar todo
	o atendimento.
------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
nr_seq_selecao_w	pls_oc_cta_selecao_ocor_v.nr_sequencia%type;
qt_liminar_guia_w	integer;
qt_liminar_req_w	integer;
ie_gera_ocorrencia_w	varchar(1);
ds_sql_w		varchar(4000);
tb_seq_selecao_w	dbms_sql.number_table;
tb_observacao_w		dbms_sql.varchar2_table;
tb_valido_w		dbms_sql.varchar2_table;
v_cur			pls_util_pck.t_cursor;
qt_iteracoes_w		integer;

qt_liminar_benef_w	pls_conta_proc.qt_procedimento%type;
nr_seq_mat_jud_w	processo_judicial_mat.nr_sequencia%type;
nr_seq_proc_jud_w	processo_judicial_proc.nr_sequencia%type;
nr_seq_conta_w		pls_conta.nr_sequencia%type;

cd_area_w		processo_judicial_proc.cd_area_procedimento%type;
cd_especialidade_w	processo_judicial_proc.cd_especialidade%type;
cd_grupo_w		processo_judicial_proc.cd_grupo_proc%type;
cd_procedimento_w	pls_conta_proc.cd_procedimento%type;
ie_origem_proced_w	pls_conta_proc.ie_origem_proced%type;
nr_seq_material_w	pls_conta_mat.nr_seq_material%type;
ie_origem_proc_w	pls_conta_proc.ie_origem_proced%type;
nr_seq_jud_proc_w	processo_judicial_proc.nr_sequencia%type;
nr_seq_jud_mat_w	processo_judicial_mat.nr_sequencia%type;

C01 CURSOR(	nr_seq_oc_cta_comb_p	dados_regra_p.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia	nr_seq_validacao,
		a.ie_valida_liminar
	from	pls_oc_cta_val_liminar_jud a
	where	a.nr_seq_oc_cta_comb	= nr_seq_oc_cta_comb_p;
	
C02 CURSOR FOR
	SELECT	procj.nr_sequencia nr_seq_liminar,
		conta.nr_sequencia nr_seq_conta
	from	pls_conta_ocor_v conta,
		processo_judicial_liminar procj	
	where	conta.nr_sequencia = nr_seq_conta_w
	and	conta.nr_seq_segurado 	= procj.nr_seq_segurado
	and 	procj.ie_estagio 	= 2
	and	ie_impacto_autorizacao	= 'S';
	
C03 CURSOR FOR
	SELECT	cd_procedimento,
		ie_origem_proced
	from	pls_conta_proc
	where	nr_seq_conta	= nr_seq_conta_w
	and	ie_status <> 'D';
	
C04 CURSOR FOR
	SELECT	nr_seq_material
	from	pls_conta_mat
	where	nr_seq_conta	= nr_seq_conta_w
	and	ie_status <> 'D';

BEGIN

if (dados_regra_p.nr_sequencia IS NOT NULL AND dados_regra_p.nr_sequencia::text <> '') then
	
	--Percorre a lista da selecao, criando select conforme restricoes definidas na regra
	for	r_C01_w in C01(dados_regra_p.nr_sequencia) loop
		
		--Zera contador de registros nas listas
		qt_iteracoes_w 	:= 0;
		
		-- tratamento em campo auxiliar para identificar posteriormente os registros que foram alterados
		CALL pls_tipos_ocor_pck.atualiza_campo_auxiliar('V', nr_id_transacao_p, null, dados_regra_p);
		
		if ( r_C01_w.ie_valida_liminar = 'S' ) then
		
			--Select com 2 count para buscar a quantidade de liminar judicial vinculada na requisicao ou na guia
			ds_sql_w :=	'select	sel.nr_sequencia nr_seq_selecao, ' || pls_tipos_ocor_pck.enter_w ||
				'		(select	count(1) ' || pls_tipos_ocor_pck.enter_w ||
				'		from	processo_judicial_liminar procj, ' || pls_tipos_ocor_pck.enter_w ||
				'			pls_guia_liminar_judicial  liminar ' || pls_tipos_ocor_pck.enter_w ||
				'		where	procj.nr_sequencia 	= liminar.nr_seq_processo ' || pls_tipos_ocor_pck.enter_w ||							
				'		and 	liminar.nr_Seq_guia 	= conta.nr_seq_guia) qt_liminar_guia, ' || pls_tipos_ocor_pck.enter_w ||
				'		(select	count(1) ' || pls_tipos_ocor_pck.enter_w ||
				'		from	processo_judicial_liminar procj,  ' || pls_tipos_ocor_pck.enter_w ||
				'			pls_req_liminar_judicial  liminar,  ' || pls_tipos_ocor_pck.enter_w ||
				'			pls_execucao_requisicao exec ' || pls_tipos_ocor_pck.enter_w ||
				'		where	procj.nr_sequencia 	= liminar.nr_seq_processo  ' || pls_tipos_ocor_pck.enter_w ||
				'		and	exec.nr_seq_requisicao  = liminar.nr_seq_requisicao ' || pls_tipos_ocor_pck.enter_w ||
				'		and 	exec.nr_Seq_guia 	= conta.nr_seq_guia) qt_liminar_req, ' || pls_tipos_ocor_pck.enter_w ||
				'		(select count(1) ' || pls_tipos_ocor_pck.enter_w ||
				'		from 	processo_judicial_liminar procj ' || pls_tipos_ocor_pck.enter_w ||
				'		where 	conta.nr_seq_segurado 	= procj.nr_seq_segurado	' || pls_tipos_ocor_pck.enter_w ||
				'		and	procj.ie_estagio 	= 2 ' || pls_tipos_ocor_pck.enter_w ||
				'		and 	procj.ie_impacto_autorizacao = ''S'' ) qt_liminar_benef, ' || pls_tipos_ocor_pck.enter_w ||
				'		conta.nr_sequencia nr_seq_conta ' || pls_tipos_ocor_pck.enter_w ||
				'	from	pls_oc_cta_selecao_ocor_v sel, ' || pls_tipos_ocor_pck.enter_w ||				
				'		pls_conta_ocor_v conta ' || pls_tipos_ocor_pck.enter_w || 				
				'	where	sel.nr_id_transacao = :nr_id_transacao ' || pls_tipos_ocor_pck.enter_w || 
				'	and	sel.ie_valido = ''S'' ' || pls_tipos_ocor_pck.enter_w || 				
				'	and	conta.nr_sequencia = sel.nr_seq_conta ';					
		--Limpa as listas.
		tb_seq_selecao_w.delete;
		tb_observacao_w.delete;
		tb_valido_w.delete;	
		begin
			open v_cur for EXECUTE ds_sql_w using 	nr_id_transacao_p;		
			loop	
				fetch v_cur
				into  nr_seq_selecao_w, qt_liminar_guia_w, qt_liminar_req_w, qt_liminar_benef_w, nr_seq_conta_w;
					
				EXIT WHEN NOT FOUND; /* apply on v_cur */
					
					ie_gera_ocorrencia_w	:= 'N';
					
					--Verificar se existe liminar judicial na requisicao ou na guia, se existir em qualquer uma delas ira gerar a ocorrencia
					if ( (qt_liminar_guia_w + qt_liminar_req_w) > 0 ) then
						ie_gera_ocorrencia_w	:= 'S';
					end if;
					
					if (qt_liminar_benef_w > 0) then
					
						for	r_C02_w in C02 loop
														
							select	max(nr_sequencia)
							into STRICT	nr_seq_jud_proc_w
							from	processo_judicial_proc
							where	nr_seq_processo	= r_C02_w.nr_seq_liminar;
							
							select	max(nr_sequencia)
							into STRICT	nr_seq_jud_mat_w
							from	processo_judicial_mat
							where	nr_seq_processo	= r_C02_w.nr_seq_liminar;
							
							if ((coalesce(nr_seq_jud_proc_w::text, '') = '') and (coalesce(nr_seq_jud_mat_w::text, '') = '')) then
							
							ie_gera_ocorrencia_w	:= 'S';
							
							elsif ((nr_seq_jud_proc_w IS NOT NULL AND nr_seq_jud_proc_w::text <> '') or (nr_seq_jud_mat_w IS NOT NULL AND nr_seq_jud_mat_w::text <> '')) then							
							
								open C03;
								loop
								fetch C03 into
									cd_procedimento_w,
									ie_origem_proced_w;
								EXIT WHEN NOT FOUND; /* apply on C03 */
									begin
									SELECT * FROM pls_obter_estrut_proc(	cd_procedimento_w, ie_origem_proced_w, cd_area_w, cd_especialidade_w, cd_grupo_w, ie_origem_proc_w) INTO STRICT cd_area_w, cd_especialidade_w, cd_grupo_w, ie_origem_proc_w;
									select	max(a.nr_sequencia)
									into STRICT	nr_seq_proc_jud_w
									from	processo_judicial_proc		a,
										processo_judicial_liminar	b
									where	b.nr_sequencia					= r_C02_w.nr_seq_liminar
									and	a.nr_seq_processo				= b.nr_sequencia
									and	coalesce(a.cd_procedimento,cd_procedimento_w)	= cd_procedimento_w
									and	coalesce(a.ie_origem_proced,ie_origem_proc_w) 	= ie_origem_proc_w
									and	coalesce(a.cd_grupo_proc,cd_grupo_w)			= cd_grupo_w
									and	coalesce(a.cd_especialidade, cd_especialidade_w)	= cd_especialidade_w
									and	coalesce(a.cd_area_procedimento, cd_area_w) 		= cd_area_w;
								
									if (nr_seq_proc_jud_w IS NOT NULL AND nr_seq_proc_jud_w::text <> '') then
										ie_gera_ocorrencia_w	:= 'S';
									end if;
									end;
								end loop;
								close C03;
								
								open C04;
								loop
								fetch C04 into
									nr_seq_material_w;
								EXIT WHEN NOT FOUND; /* apply on C04 */
									begin
									select	max(a.nr_sequencia)
									into STRICT	nr_seq_mat_jud_w
									from	processo_judicial_mat		a,
										processo_judicial_liminar	b
									where	b.nr_sequencia					= r_C02_w.nr_seq_liminar
									and	a.nr_seq_processo				= b.nr_sequencia
									and (coalesce(a.nr_seq_material::text, '') = '' or 	a.nr_seq_material 	= nr_seq_material_w)
									and (coalesce(a.nr_seq_estrut_mat::text, '') = '' or 	
										pls_obter_se_estruturas_mat(a.nr_seq_estrut_mat, nr_seq_material_w)  = 'S');
									
									if (nr_seq_mat_jud_w IS NOT NULL AND nr_seq_mat_jud_w::text <> '') then
										ie_gera_ocorrencia_w	:= 'S';
									end if;
									end;
								end loop;
								close C04;
							end if;
						end loop;
					end if;
						
					if (ie_gera_ocorrencia_w = 'S') then
						qt_iteracoes_w := qt_iteracoes_w + 1;
						
						--Alimenta as listas com a sequencia da selecao...
						tb_seq_selecao_w(qt_iteracoes_w):= nr_seq_selecao_w;
						tb_observacao_w(qt_iteracoes_w) := null;	
						tb_valido_w(qt_iteracoes_w)	:= 'S';
						
						if (qt_iteracoes_w = pls_util_cta_pck.qt_registro_transacao_w) then
							
							CALL pls_tipos_ocor_pck.gerencia_selecao_validacao( tb_seq_selecao_w, pls_util_cta_pck.clob_table_vazia_w,
													'SEQ', tb_observacao_w, tb_valido_w, nm_usuario_p);
							qt_iteracoes_w := 0;
							tb_seq_selecao_w.delete;
							tb_observacao_w.delete;
							tb_valido_w.delete;
						end if;	
					end if;
			end loop;
			--Se sobrar registros nas listas, os mesmos devem ser atualizados.
			if (qt_iteracoes_w > 0) then
				
				CALL pls_tipos_ocor_pck.gerencia_selecao_validacao( tb_seq_selecao_w, pls_util_cta_pck.clob_table_vazia_w,
										'SEQ', tb_observacao_w, tb_valido_w, nm_usuario_p);
				qt_iteracoes_w := 0;
				tb_seq_selecao_w.delete;
				tb_observacao_w.delete;
				tb_valido_w.delete;
			end if;	
			close v_cur;
			
		exception			
		when others then
			--Fecha cursor
			close v_cur;
			-- Insere o log na tabela e aborta a operacao
			CALL pls_tipos_ocor_pck.trata_erro_sql_dinamico(dados_regra_p,ds_sql_w,nr_id_transacao_p,nm_usuario_p);
		end;
		end if;	
		
	end loop; -- C01
	-- seta os registros que serao validos ou invalidos apos o processamento 
	CALL pls_tipos_ocor_pck.atualiza_campo_valido('V', nr_id_transacao_p, null, dados_regra_p);
	
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_oc_cta_tratar_val_51 ( dados_regra_p pls_tipos_ocor_pck.dados_regra, nr_id_transacao_p pls_oc_cta_selecao_ocor_v.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

