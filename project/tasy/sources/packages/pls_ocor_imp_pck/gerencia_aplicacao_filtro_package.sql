-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

/*
procedure alimenta_selecao_excecao(	nr_id_transacao_p	in pls_oc_cta_selecao_ocor_v.nr_id_transacao%type,
					ie_incidencia_selecao_p	in pls_oc_cta_filtro.ie_incidencia_selecao%type
					nm_usuario_p		in usuario.nm_usuario%type,
					cd_estabelecimento_p	in estabelecimento.cd_estabelecimento%type,
					nr_id_transacao_ex_p	out pls_selecao_ex_ocor_cta.nr_id_transacao%type) is
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Finalidade: 	Alimentar todo o atendimento dos registros que estao como validos na tabela de
	seleaao para a tabela de processamento da exceaao do atendimento
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[ X ]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatarios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atenaao:

Alteraaaes:
 ------------------------------------------------------------------------------------------------------------------

 usuario OS XXXXXX 01/01/2000 - 	
 Alteraaao:	Descriaao da alteraaao.
Motivo:	Descriaao do motivo.
 ------------------------------------------------------------------------------------------------------------------

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 


tb_tipo_registro_w	pls_util_cta_pck.t_varchar2_table_1;
tb_seq_conta_w		pls_util_cta_pck.t_number_table;
tb_seq_conta_proc_w	pls_util_cta_pck.t_number_table;
tb_seq_conta_mat_w	pls_util_cta_pck.t_number_table;
tb_seq_segurado_w	pls_util_cta_pck.t_number_table;
tb_cd_guia_referencia_w	pls_util_cta_pck.t_varchar2_table_20;

cursor c01(	nr_id_transacao_pc	pls_oc_cta_selecao_ocor_v.nr_id_transacao%type) is
	select	distinct a.nr_seq_segurado,
		a.cd_guia_referencia
	from	pls_selecao_ocor_cta a
	where	a.nr_id_transacao = nr_id_transacao_pc
	and	a.ie_valido = 'S';

cursor c_conta(	nr_seq_segurado_pc	pls_selecao_ocor_cta.nr_seq_segurado%type,
		cd_guia_referencia_pc	pls_selecao_ocor_cta.cd_guia_referencia%type) is
	select	'C' ie_tipo_registro,
		b.nr_sequencia nr_seq_conta,
		null nr_seq_conta_proc,
		null nr_seq_conta_mat,
		b.nr_seq_segurado,
		b.cd_guia_referencia
	from	pls_conta_ocor_v b
	where	b.nr_seq_segurado = nr_seq_segurado_pc
	and	b.cd_guia_referencia = cd_guia_referencia_pc;
	
cursor c_proc(	nr_seq_segurado_pc	pls_selecao_ocor_cta.nr_seq_segurado%type,
		cd_guia_referencia_pc	pls_selecao_ocor_cta.cd_guia_referencia%type) is
	select	'P' ie_tipo_registro,
		b.nr_seq_conta,
		b.nr_sequencia nr_seq_conta_proc,
		null nr_seq_conta_mat,
		b.nr_seq_segurado,
		b.cd_guia_referencia
	from	pls_conta_proc_ocor_v b
	where	b.nr_seq_segurado = nr_seq_segurado_pc
	and	b.cd_guia_referencia = cd_guia_referencia_pc;
	
cursor c_mat(	nr_seq_segurado_pc	pls_selecao_ocor_cta.nr_seq_segurado%type,
		cd_guia_referencia_pc	pls_selecao_ocor_cta.cd_guia_referencia%type) is
	select	'M' ie_tipo_registro,
		b.nr_seq_conta,
		null nr_seq_conta_proc,
		b.nr_sequencia nr_seq_conta_mat,
		b.nr_seq_segurado,
		b.cd_guia_referencia
	from	pls_conta_mat_ocor_v b
	where	b.nr_seq_segurado = nr_seq_segurado_pc
	and	b.cd_guia_referencia = cd_guia_referencia_pc;

begin
-- busca a transaaao da exceaao

select	pls_id_transacao_ocor_seq.nextval
into	nr_id_transacao_ex_p
from	dual;

for r_c01_w in c01(nr_id_transacao_p) loop
	
	-- incidancia por conta

	if	(ie_incidencia_selecao_p = 'C') then
		
		open c_conta(r_c01_w.nr_seq_segurado, r_c01_w.cd_guia_referencia);
		loop
			tb_tipo_registro_w.delete;
			tb_seq_conta_w.delete;
			tb_seq_conta_proc_w.delete;
			tb_seq_conta_mat_w.delete;
			tb_seq_segurado_w.delete;
			tb_cd_guia_referencia_w.delete;
			
			fetch c_conta bulk collect into 	tb_tipo_registro_w, tb_seq_conta_w,
								tb_seq_conta_proc_w, tb_seq_conta_mat_w,
								tb_seq_segurado_w, tb_cd_guia_referencia_w
			limit pls_util_pck.qt_registro_transacao_w;
			
			exit when tb_tipo_registro_w.count = 0;
			
			-- manda para o banco

			insere_selecao_excecao(	tb_tipo_registro_w, tb_seq_conta_w,
						tb_seq_conta_proc_w, tb_seq_conta_mat_w,
						tb_seq_segurado_w, tb_cd_guia_referencia_w,
						nr_id_transacao_ex_p);
		end loop;
		close c_conta;
	
	-- incidancia por procedimento

	elsif	(ie_incidencia_selecao_p = 'P') then
		
		open c_proc(r_c01_w.nr_seq_segurado, r_c01_w.cd_guia_referencia);
		loop
			tb_tipo_registro_w.delete;
			tb_seq_conta_w.delete;
			tb_seq_conta_proc_w.delete;
			tb_seq_conta_mat_w.delete;
			tb_seq_segurado_w.delete;
			tb_cd_guia_referencia_w.delete;
			
			fetch c_proc bulk collect into 	tb_tipo_registro_w, tb_seq_conta_w,
							tb_seq_conta_proc_w, tb_seq_conta_mat_w,
							tb_seq_segurado_w, tb_cd_guia_referencia_w
			limit pls_util_pck.qt_registro_transacao_w;
			
			exit when tb_tipo_registro_w.count = 0;
			
			-- manda para o banco

			insere_selecao_excecao(	tb_tipo_registro_w, tb_seq_conta_w,
						tb_seq_conta_proc_w, tb_seq_conta_mat_w,
						tb_seq_segurado_w, tb_cd_guia_referencia_w,
						nr_id_transacao_ex_p);
		end loop;
		close c_proc;
	
	-- incidancia por material

	elsif	(ie_incidencia_selecao_p = 'M') then
				
		open c_mat(r_c01_w.nr_seq_segurado, r_c01_w.cd_guia_referencia);
		loop
			tb_tipo_registro_w.delete;
			tb_seq_conta_w.delete;
			tb_seq_conta_proc_w.delete;
			tb_seq_conta_mat_w.delete;
			tb_seq_segurado_w.delete;
			tb_cd_guia_referencia_w.delete;
			
			fetch c_mat bulk collect into 	tb_tipo_registro_w, tb_seq_conta_w,
							tb_seq_conta_proc_w, tb_seq_conta_mat_w,
							tb_seq_segurado_w, tb_cd_guia_referencia_w
			limit pls_util_pck.qt_registro_transacao_w;
			
			exit when tb_tipo_registro_w.count = 0;
			
			-- manda para o banco

			insere_selecao_excecao(	tb_tipo_registro_w, tb_seq_conta_w,
						tb_seq_conta_proc_w, tb_seq_conta_mat_w,
						tb_seq_segurado_w, tb_cd_guia_referencia_w,
						nr_id_transacao_ex_p);
		end loop;
		close c_mat;
	end if;
end loop;
	
end alimenta_selecao_excecao;

procedure aplica_filtro_protocolo_ex(	ie_considera_selecao_p		in out boolean,
					ie_incidencia_selecao_regra_p	in varchar2,
					ie_incidencia_selecao_filtro_p	in varchar2,
					ie_processo_excecao_p		in varchar2,
					ie_regra_excecao_p		in pls_oc_cta_combinada.ie_excecao%type,
					ie_filtro_excecao_p		in pls_oc_cta_filtro.ie_excecao%type,
					nr_seq_combinada_p		in pls_oc_cta_combinada.nr_sequencia%type,
					nr_seq_ocorrencia_p		in pls_ocorrencia.nr_sequencia%type,
					nr_id_transacao_p		in pls_oc_cta_selecao_imp.nr_id_transacao%type,
					nr_seq_filtro_p			in pls_oc_cta_filtro.nr_sequencia%type,
					nr_seq_lote_protocolo_p		in pls_protocolo_conta_imp.nr_seq_lote_protocolo%type,
					nr_seq_protocolo_p		in pls_protocolo_conta_imp.nr_sequencia%type,
					nr_seq_lote_processo_p		in pls_cta_lote_processo.nr_sequencia%type,
					nr_seq_conta_p			in pls_conta_imp.nr_sequencia%type,
					nr_seq_conta_proc_p		in pls_conta_proc_imp.nr_sequencia%type,
					nr_seq_conta_mat_p		in pls_conta_mat_imp.nr_sequencia%type,
					dt_inicio_vigencia_p		in pls_oc_cta_combinada.dt_inicio_vigencia%type,
					dt_fim_vigencia_p		in pls_oc_cta_combinada.dt_fim_vigencia%type,
					cd_estabelecimento_p		in estabelecimento.cd_estabelecimento%type,
					nm_usuario_p			in usuario.nm_usuario%type) is
					
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: 	gerencia a aplicaaao do filtro de protocolo para todo atendimento em filtro de 
	exceaao.
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[  X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatarios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atenaao:
Nao incluir restriaaes nessa procedure, ela a responsavel apenas  por passar no cursor
dos filtros e incluir na seleaao das contas que devem ter a ocorrancia gerada.

Alteraaaes:
 ------------------------------------------------------------------------------------------------------------------

 usuario OS XXXXXX 01/01/2000 - 	
 Alteraaao:	Descriaao da alteraaao.
Motivo:	Descriaao do motivo.
 ------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

tb_seq_selecao_w	pls_util_cta_pck.t_number_table;

dados_filtro_prot_w	pls_tipos_ocor_pck.dados_filtro_prot;
ds_select_w		varchar2(8000);
valor_bind_w		sql_pck.t_dado_bind;
dados_restricao_w	pls_tipos_ocor_pck.dados_select;
cursor_w		sql_pck.t_cursor;

cursor c_filtro(	nr_seq_filtro_pc	pls_oc_cta_filtro.nr_sequencia%type) is
	select	a.nr_sequencia,
		a.ie_apresentacao,
		a.cd_versao_tiss
	from	pls_oc_cta_filtro_prot a
	where	a.nr_seq_oc_cta_filtro	= nr_seq_filtro_pc;

begin

-- Se nao tiver informaaaes da regra nao sera possavel aplicar os filtros.

if	(dados_filtro_p.nr_sequencia is not null) then

	-- Atualizar o campo auxiliar que sera utilizado para sinalizar os registros que foram processados

	atualiza_campo_auxiliar_ex(nr_id_transacao_ex_p);
	
	-- Abrir vetor com todas as combinaaaes de filtro da regra 

	for r_c_filtro in c_filtro(dados_filtro_p.nr_sequencia) loop
	
		-- Preencher dados do filtro para passar como parametro

		dados_filtro_prot_w.nr_sequencia	:= r_c_filtro.nr_sequencia;
		dados_filtro_prot_w.ie_apresentacao	:= r_c_filtro.ie_apresentacao;
		dados_filtro_prot_w.cd_versao_tiss	:= r_c_filtro.cd_versao_tiss;
		
		begin
			-- restriaao para todas as outras situaaaes

			dados_restricao_w := pls_ocor_imp_pck.obter_restricao_protocolo(	dados_regra_p,
									dados_filtro_p,
									dados_filtro_prot_w,
									null,
									valor_bind_w);
			
			-- Montar o select padrao juntamente as restriaaes.

			ds_select_w := obter_select_filtro_ex(	dados_filtro_p, dados_restricao_w,
								nr_id_transacao_ex_p, valor_bind_w);

			-- executa o comando sql com os respectivos binds

			cursor_w := sql_pck.executa_sql_cursor(	ds_select_w, valor_bind_w);
			
			loop
				fetch cursor_w bulk collect into tb_seq_selecao_w
				limit pls_util_pck.qt_registro_transacao_w;
				exit when tb_seq_selecao_w.count = 0;
				
				-- Insere todos os registros das listas na tabela de seleaao

				gerencia_selecao_filtro_ex (	tb_seq_selecao_w, 'S', nm_usuario_p);
				
			end loop;
			close cursor_w;
			
		exception
			when others then
			
			if	(cursor_w%isopen) then
				close cursor_w;
			end if;
			
			-- Tratar erro gerado no sql dinamico, sera inserido registro no log e abortado o processo exibindo mensagem de erro.

			pls_tipos_ocor_pck.trata_erro_sql_dinamico(	dados_regra_p, ds_select_w, 
									null, nm_usuario_p);
		end;
	end loop;
	
	-- Atualizar o campo definitivo que sera utilizado para sinalizar os registros que foram processados

	atualiza_campo_valido_ex(nr_id_transacao_ex_p);
end if;

end aplica_filtro_protocolo_ex;

procedure atualiza_ie_valido_ex(	nr_id_transacao_ex_p	pls_selecao_ex_ocor_cta.nr_id_transacao%type,
					nr_id_transacao_p	pls_oc_cta_selecao_ocor_v.nr_id_transacao%type) is
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: 	Todo registro em que no processamento dos filtros de exceaao tiver algum registro
	casado em alguma parte do seu atendimento, invalida o registro original da tabela
	de seleaao que esta valido.
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[ X ]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatarios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atenaao:

Alteraaaes:
 ------------------------------------------------------------------------------------------------------------------

 usuario OS XXXXXX 01/01/2000 - 
 Alteraaao:	Descriaao da alteraaao.
Motivo:	Descriaao do motivo.
 ------------------------------------------------------------------------------------------------------------------

 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 

tb_seq_w	pls_util_cta_pck.t_number_table;

-- busca todo mundo que esta valido na tabela de seleaao e que algum registro do atendimento

-- casou na regra de exceaao.

-- logo abaixo invalida os registros

cursor c01(	nr_id_transacao_ex_pc	pls_selecao_ex_ocor_cta.nr_id_transacao%type,
		nr_id_transacao_pc	pls_oc_cta_selecao_ocor_v.nr_id_transacao%type) is
	select	a.nr_sequencia nr_seq_selecao
	from	pls_selecao_ocor_cta a
	where	a.nr_id_transacao = nr_id_transacao_pc
	and	a.ie_valido = 'S'
	and	exists (select	1
			from	pls_selecao_ex_ocor_cta b
			where	b.nr_id_transacao = nr_id_transacao_ex_pc
			and	b.nr_seq_segurado = a.nr_seq_segurado
			and	b.cd_guia_referencia = a.cd_guia_referencia
			and	b.ie_valido = 'S');
begin

open c01(nr_id_transacao_ex_p, nr_id_transacao_p);
loop
	tb_seq_w.delete;
	
	fetch c01 bulk collect into tb_seq_w
	limit pls_util_pck.qt_registro_transacao_w;
	
	exit when tb_seq_w.count = 0;
	
	forall i in tb_seq_w.first .. tb_seq_w.last
		update	pls_selecao_ocor_cta
		set	ie_valido = 'N'
		where	nr_sequencia = tb_seq_w(i);
	
	commit;
end loop;
close c01;

end atualiza_ie_valido_ex;

procedure limpa_selecao_excecao(	nr_id_transacao_ex_p	pls_selecao_ex_ocor_cta.nr_id_transacao%type) is

tb_seq_w	pls_util_cta_pck.t_number_table;

-- retorna as sequencias que devem ser apagadas para a tabela de exceaao

cursor c01(	nr_id_transacao_ex_pc	pls_selecao_ex_ocor_cta.nr_id_transacao%type) is
	select	b.nr_sequencia
	from	pls_selecao_ex_ocor_cta b
	where	b.nr_id_transacao = nr_id_transacao_ex_pc;

begin
-- apaga as exceaaes

open c01(nr_id_transacao_ex_p);
loop
	tb_seq_w.delete;
	
	fetch c01 bulk collect into tb_seq_w
	limit pls_util_pck.qt_registro_transacao_w;
	
	exit when tb_seq_w.count = 0;
	
	forall i in tb_seq_w.first .. tb_seq_w.last
		delete	from pls_selecao_ex_ocor_cta
		where	nr_sequencia = tb_seq_w(i);
	
	commit;
end loop;
close c01;

end limpa_selecao_excecao;

procedure gerencia_aplic_filtro_ex_atend(	nr_id_transacao_p	in pls_oc_cta_selecao_imp.nr_id_transacao%type,
						nr_seq_filtro_p		in pls_oc_cta_filtro.nr_sequencia%type,
						ie_filtro_protocolo_p	in pls_oc_cta_filtro.ie_filtro_protocolo%type,
						ie_filtro_conta_p	in pls_oc_cta_filtro.ie_filtro_conta%type,
						ie_filtro_prest_p	in pls_oc_cta_filtro.ie_filtro_prest%type,
						ie_filtro_prof_p	in pls_oc_cta_filtro.ie_filtro_prof%type,
						ie_filtro_contrato_p	in pls_oc_cta_filtro.ie_filtro_contrato%type,
						ie_filtro_produto_p	in pls_oc_cta_filtro.ie_filtro_produto%type,
						ie_filtro_interc_p	in pls_oc_cta_filtro.ie_filtro_interc%type,
						ie_filtro_benef_p	in pls_oc_cta_filtro.ie_filtro_benef%type,
						ie_filtro_proc_p	in pls_oc_cta_filtro.ie_filtro_proc%type,
						ie_filtro_mat_p		in pls_oc_cta_filtro.ie_filtro_mat%type,
						ie_filtro_oper_benef_p	in pls_oc_cta_filtro.ie_filtro_oper_benef%type,
						ie_excecao_p		in pls_oc_cta_filtro.ie_excecao%type,
						ie_valida_todo_atend_p	in pls_oc_cta_filtro.ie_valida_todo_atend%type,
						ie_incidencia_selecao_p	in pls_oc_cta_filtro.ie_incidencia_selecao%type,
						nr_seq_combinada_p	in pls_oc_cta_combinada.nr_sequencia%type,
						nr_seq_ocorrencia_p	in pls_ocorrencia.nr_sequencia%type,
						dt_inicio_vigencia_p	in pls_oc_cta_combinada.dt_inicio_vigencia%type,
						dt_fim_vigencia_p	in pls_oc_cta_combinada.dt_fim_vigencia%type,
						nm_usuario_p		usuario.nm_usuario%type,
						cd_estabelecimento_p	estabelecimento.cd_estabelecimento%type) is

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Finalidade: 	Verificar o atendimento de todos os registros que ficaram validos apas processar o
	filtro de exceaao. Em resumo, o filtro de exceaao a processado novamente para
	todo o atendimento e se "casar" algum registro, a exceaao nao a mais gerada para
	o item original que esta na tabela de seleaao. A tabela de seleaao original a a 
	pls_selecao_ocor_cta e a tabela utilizada para este novo processamento de 
	exceaao a a pls_selecao_ex_ocor_cta. Foi separado por motivos de performance e
	facilidade de manutenaao.
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[ X ]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatarios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atenaao:
Nao deve ser mudada a sequencia de aplicaaao dos filtros, pois a mesma precisa seguir a
granularidade dos dados.

Alteraaaes:
 ------------------------------------------------------------------------------------------------------------------

 usuario OS XXXXXX 01/01/2000 - 	
Alteraaao:	Descriaao da alteraaao.
Motivo:	Descriaao do motivo.
 ------------------------------------------------------------------------------------------------------------------

 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
nr_id_transacao_ex_w	pls_selecao_ex_ocor_cta.nr_id_transacao%type;
begin

-- se for filtro de exceaao e a opaao para validar o atendimento estiver marcada


if	(ie_excecao_p = 'S' and
	 ie_valida_todo_atend_p = 'S') then

	 -- modifica o comportamento de algumas rotinas para trabalhar verificando todo o atendimento

	 ie_controle_todo_atendimento_w := 'S';
	
	-- alimenta a tabela de seleaao

	alimenta_selecao_excecao(	nr_id_transacao_p, ie_incidencia_selecao_p,
					nm_usuario_p, cd_estabelecimento_p,
					nr_id_transacao_ex_w);
	-- filtro de Protocolo

	if	(ie_filtro_protocolo_p = 'S') then
		nr_seq_filtro_p
		aplica_filtro_protocolo_ex(	dados_regra_p, dados_filtro_p, nm_usuario_p, nr_id_transacao_ex_w);
	end if;
	
	-- filtro de conta

	if	(ie_filtro_conta_p = 'S') then
		aplica_filtro_conta_ex(		dados_regra_p, dados_filtro_p, nm_usuario_p, nr_id_transacao_ex_w);
	end if;
	
	-- Prestador

	if	(ie_filtro_prest_p = 'S') then
		aplica_filtro_prestador_ex(	dados_regra_p, dados_filtro_p, nm_usuario_p, nr_id_transacao_ex_w);
	end if;
	
	-- Profissional

	if	(ie_filtro_prof_p = 'S') then
		aplica_filtro_profissional_ex(	dados_regra_p, dados_filtro_p, nm_usuario_p, nr_id_transacao_ex_w);
	end if;
	
	-- contrato

	if	(ie_filtro_contrato_p = 'S') then
		aplica_filtro_contrato_ex(	dados_regra_p, dados_filtro_p, nm_usuario_p, nr_id_transacao_ex_w);
	end if;
	
	-- produto

	if	(ie_filtro_produto_p = 'S') then
		aplica_filtro_produto_ex(	dados_regra_p, dados_filtro_p, nm_usuario_p, nr_id_transacao_ex_w);
	end if;
	
	-- Intercambio

	if	(ie_filtro_interc_p = 'S') then
		aplica_filtro_intercambio_ex(	dados_regra_p, dados_filtro_p, nm_usuario_p, nr_id_transacao_ex_w);
	end if;
	
	-- beneficiario

	if	(ie_filtro_benef_p = 'S') then
		aplica_filtro_beneficiario_ex(	dados_regra_p, dados_filtro_p, nm_usuario_p, nr_id_transacao_ex_w);
	end if;
	
	-- procedimento

	if	(ie_filtro_proc_p = 'S')  then
		aplica_filtro_procedimento_ex(	dados_regra_p, dados_filtro_p, nm_usuario_p, nr_id_transacao_ex_w);
	end if;
	
	-- material

	if	(ie_filtro_mat_p = 'S')  then
		aplica_filtro_material_ex(	dados_regra_p, dados_filtro_p, nm_usuario_p, nr_id_transacao_ex_w);
	end if;
	
	-- operadora

	if	(ie_filtro_oper_benef_p = 'S') then
		aplica_filtro_operadora_ex(	dados_regra_p, dados_filtro_p, nm_usuario_p, nr_id_transacao_ex_w);
	end if;
	
	-- invalida os registros que estao como validos se acaso algum item do seu atendimento casar na regra de exceaao

	atualiza_ie_valido_ex(nr_id_transacao_ex_w, nr_id_transacao_p);
	-- limpa os registros da tabela

	limpa_selecao_excecao(nr_id_transacao_ex_w);
	
	ie_controle_todo_atendimento_w := 'N';
end if;

end gerencia_aplic_filtro_ex_atend;
*/



CREATE OR REPLACE PROCEDURE pls_ocor_imp_pck.gerencia_aplicacao_filtro ( nr_seq_lote_protocolo_p pls_protocolo_conta_imp.nr_seq_lote_protocolo%type, nr_seq_protocolo_p pls_protocolo_conta_imp.nr_sequencia%type, nr_seq_conta_p pls_conta_imp.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc_imp.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat_imp.nr_sequencia%type, nr_seq_ocorrencia_p pls_ocorrencia.nr_sequencia%type, nr_seq_combinada_p pls_oc_cta_combinada.nr_sequencia%type, dt_inicio_vigencia_p pls_oc_cta_combinada.dt_inicio_vigencia%type, dt_fim_vigencia_p pls_oc_cta_combinada.dt_fim_vigencia%type, cd_validacao_p pls_oc_cta_tipo_validacao.cd_validacao%type, ie_utiliza_filtro_p pls_oc_cta_combinada.ie_utiliza_filtro%type, ie_regra_excecao_p pls_oc_cta_combinada.ie_excecao%type, nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type, ie_incidencia_selecao_regra_p text, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


ie_processo_excecao_w		varchar(1);
ie_incidencia_selecao_w		varchar(1);
qt_filtro_processado_w		integer;
ie_considera_tab_selecao_w	boolean;
ie_processa_regra_w		varchar(1);

-- Dados da PLS_OC_CTA_FILTRO, responsavel por armazenar os dados dos filtros criados pelo usuario.

-- o order by serve para trazer os filtros de exceaao para o final e priorizar para ser executado os que sao a navel de conta antes

-- a feito isso porque mais abaixo existe um controle de performance que deixa de executar os filtros caso todos estejam invalidos

c_comb_filtro CURSOR(	nr_seq_regra_pc	pls_oc_cta_combinada.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia,
		a.nm_filtro,
		a.ie_filtro_protocolo,
		a.ie_filtro_conta,
		a.ie_filtro_proc,
		a.ie_filtro_mat,
		a.ie_filtro_benef,
		a.ie_filtro_prest,
		a.ie_filtro_interc,
		a.ie_filtro_contrato,
		a.ie_filtro_produto,
		a.ie_filtro_prof,
		a.ie_filtro_oper_benef,
		coalesce(a.ie_excecao, 'N') ie_excecao,
		coalesce(a.ie_valida_todo_atend, 'N') ie_valida_todo_atend
	from	pls_oc_cta_filtro a
	where	a.nr_seq_oc_cta_comb	= nr_seq_regra_pc
	and	a.ie_situacao	= 'A'
	order by a.ie_excecao,
		 a.ie_filtro_proc,
		 a.ie_filtro_mat;
BEGIN
-- Gravar em uma tabela as contas/itens que se apliquem nos combinaaaes de filtros

-- de ocorrancias. Tambam gerencia a inseraao de todos os registros necessarios quando nao for

-- utilizada uma configuraaao de filtro.


if (nr_seq_combinada_p IS NOT NULL AND nr_seq_combinada_p::text <> '') then	

	-- se for uma regra que nao utiliza filtros

	if (ie_utiliza_filtro_p = 'N' and cd_validacao_p <> 1) then
	
		-- se for exceaao independente do tipo, alimenta 

		if (ie_regra_excecao_p = 'S') then
			ie_processo_excecao_w := 'S';
		else
			ie_processo_excecao_w := 'N';
		end if;
		
		-- filtro padrao nao precisa ser processado em regras de exceaao

		if (ie_regra_excecao_p = 'N') then
			-- insere todos os registros necessarios na tabela de seleaao de acordo com 

			-- os "grandes filtros" ou "filtros padrao" (lote analise, protocolo, lote processamento, conta, etc.)

			CALL CALL pls_ocor_imp_pck.aplica_filtro_padrao( 	ie_incidencia_selecao_regra_p, ie_processo_excecao_w,
						ie_regra_excecao_p, nr_seq_combinada_p,
						nr_seq_ocorrencia_p, dt_inicio_vigencia_p,
						dt_fim_vigencia_p, nr_id_transacao_p,
						nr_seq_lote_protocolo_p, nr_seq_protocolo_p,
						nr_seq_conta_p,	nr_seq_conta_proc_p,
						nr_seq_conta_mat_p, cd_estabelecimento_p,
						nm_usuario_p);
		end if;
	else
		qt_filtro_processado_w := 0;
		
		for r_c_comb_filtro in c_comb_filtro(nr_seq_combinada_p) loop
			
			-- alimenta a incidancia do filtro

			if (r_c_comb_filtro.ie_filtro_proc = 'S') then
				ie_incidencia_selecao_w := 'P';
			elsif (r_c_comb_filtro.ie_filtro_mat = 'S') then
				ie_incidencia_selecao_w := 'M';
			else
				ie_incidencia_selecao_w := 'C';
			end if;
			
			-- se for exceaao independente do tipo, alimenta 

			if (ie_regra_excecao_p = 'S' or r_c_comb_filtro.ie_excecao = 'S') then
				ie_processo_excecao_w := 'S';
			else
				ie_processo_excecao_w := 'N';
			end if;
			
			-- faz uma verificaaao se existe a necessidade de processar a regra de filtro

			-- o objetivo a melhorar a performance nao processando filtros que nao irao alterar nada da tabela de seleaao

			ie_processa_regra_w := pls_ocor_imp_pck.obter_se_processa_filtro(	nr_id_transacao_p, qt_filtro_processado_w,
										ie_regra_excecao_p, r_c_comb_filtro.ie_excecao,
										ie_incidencia_selecao_regra_p, ie_incidencia_selecao_w,
										ie_processo_excecao_w, nr_seq_ocorrencia_p,
										r_c_comb_filtro.nr_sequencia, nr_seq_lote_protocolo_p,
										nr_seq_protocolo_p, nr_seq_conta_p,
										nr_seq_conta_proc_p, nr_seq_conta_mat_p,
										dt_inicio_vigencia_p, dt_fim_vigencia_p,
										cd_estabelecimento_p);
			-- para de validar os filtros

			if (ie_processa_regra_w = 'Z') then
				exit;
			-- se for necessario processar a regra entao processa

			elsif (ie_processa_regra_w = 'S') then
				
				-- faz a devida alimentaaao dos campos de acordo com o tipo de regra para realizar o correto processamento dos filtros

				CALL CALL CALL CALL CALL pls_ocor_imp_pck.prepara_reg_proces_filtro(	nr_id_transacao_p, ie_regra_excecao_p,
								r_c_comb_filtro.ie_excecao, ie_incidencia_selecao_w);
												
				/*
				Verificar cada checkbox da combinaaao de filtros, para filtrar cada tipo.
				Para executar a verificaaao dos filtros deve ser respeitada a ordem de aplicaaao dos mesmos, passando do navel mais alto
				para o navel mais baixo, comeaando do Protocolo para as contas, das contas para os itens, para que os filtros
				respeitem os outros filtros cadastrados.  Isto evita  casos em que a conta nao atende aos filtros e a ocorrancia a lanaada para os itens.
				Alam disto este conceito ajuda no quesito de performance da aplicaaao de filtros, por exemplo, o filtro por protocolo deve ser aplicado
				primeiro, pois se o protocolo nao atender ao cadastro do filtro entao nem busca as contas do mesmo, assim para as contas, os itens, 
				participantes e assim por diante. */

				
				-- se for regras boas e filtros bons

				if	(ie_regra_excecao_p = 'N' AND r_c_comb_filtro.ie_excecao = 'N') then
					-- para cada novo filtro nao considera o que tem na tabela de seleaao

					-- pois cada filtro bom influencia somente o que for inserido por ele

					ie_considera_tab_selecao_w := false;
				else
					-- se for exceaao sempre deve considerar a tabela de seleaao

					ie_considera_tab_selecao_w := true;
				end if;
				
				-- filtro de Protocolo

				if (r_c_comb_filtro.ie_filtro_protocolo = 'S') then
								
						ie_considera_tab_selecao_w := pls_ocor_imp_pck.aplica_filtro_protocolo(	ie_considera_tab_selecao_w, ie_incidencia_selecao_regra_p, ie_incidencia_selecao_w, ie_processo_excecao_w, ie_regra_excecao_p, r_c_comb_filtro.ie_excecao, nr_seq_combinada_p, nr_seq_ocorrencia_p, nr_id_transacao_p, r_c_comb_filtro.nr_sequencia, nr_seq_lote_protocolo_p, nr_seq_protocolo_p, nr_seq_conta_p, nr_seq_conta_proc_p, nr_seq_conta_mat_p, dt_inicio_vigencia_p, dt_fim_vigencia_p, cd_estabelecimento_p, nm_usuario_p);

				end if;
				
				-- filtro de conta

				if (r_c_comb_filtro.ie_filtro_conta = 'S') then
					
							ie_considera_tab_selecao_w := pls_ocor_imp_pck.aplica_filtro_conta(		ie_considera_tab_selecao_w, ie_incidencia_selecao_regra_p, ie_incidencia_selecao_w, ie_processo_excecao_w, ie_regra_excecao_p, r_c_comb_filtro.ie_excecao, nr_seq_combinada_p, nr_seq_ocorrencia_p, nr_id_transacao_p, r_c_comb_filtro.nr_sequencia, nr_seq_lote_protocolo_p, nr_seq_protocolo_p, nr_seq_conta_p, nr_seq_conta_proc_p, nr_seq_conta_mat_p, dt_inicio_vigencia_p, dt_fim_vigencia_p, cd_estabelecimento_p, nm_usuario_p);
				end if;
				
				-- Prestador

				if (r_c_comb_filtro.ie_filtro_prest = 'S') then
				
					-- Prestador do atendimento (protocolo)

						ie_considera_tab_selecao_w := pls_ocor_imp_pck.aplica_filtro_prestador(	ie_considera_tab_selecao_w, ie_incidencia_selecao_regra_p, ie_incidencia_selecao_w, ie_processo_excecao_w, ie_regra_excecao_p, r_c_comb_filtro.ie_excecao, nr_seq_combinada_p, nr_seq_ocorrencia_p, nr_id_transacao_p, r_c_comb_filtro.nr_sequencia, nr_seq_lote_protocolo_p, nr_seq_protocolo_p, nr_seq_conta_p, nr_seq_conta_proc_p, nr_seq_conta_mat_p, dt_inicio_vigencia_p, dt_fim_vigencia_p, 'A', cd_estabelecimento_p, nm_usuario_p);
									
					-- Prestador solicitante (solic ref da conta)

						ie_considera_tab_selecao_w := pls_ocor_imp_pck.aplica_filtro_prestador(	ie_considera_tab_selecao_w, ie_incidencia_selecao_regra_p, ie_incidencia_selecao_w, ie_processo_excecao_w, ie_regra_excecao_p, r_c_comb_filtro.ie_excecao, nr_seq_combinada_p, nr_seq_ocorrencia_p, nr_id_transacao_p, r_c_comb_filtro.nr_sequencia, nr_seq_lote_protocolo_p, nr_seq_protocolo_p, nr_seq_conta_p, nr_seq_conta_proc_p, nr_seq_conta_mat_p, dt_inicio_vigencia_p, dt_fim_vigencia_p, 'S', cd_estabelecimento_p, nm_usuario_p);
									
					-- Prestador executor (exec da conta)

						ie_considera_tab_selecao_w := pls_ocor_imp_pck.aplica_filtro_prestador(	ie_considera_tab_selecao_w, ie_incidencia_selecao_regra_p, ie_incidencia_selecao_w, ie_processo_excecao_w, ie_regra_excecao_p, r_c_comb_filtro.ie_excecao, nr_seq_combinada_p, nr_seq_ocorrencia_p, nr_id_transacao_p, r_c_comb_filtro.nr_sequencia, nr_seq_lote_protocolo_p, nr_seq_protocolo_p, nr_seq_conta_p, nr_seq_conta_proc_p, nr_seq_conta_mat_p, dt_inicio_vigencia_p, dt_fim_vigencia_p, 'E', cd_estabelecimento_p, nm_usuario_p);
				end if;
				
				-- Profissional

				if (r_c_comb_filtro.ie_filtro_prof = 'S') then
					
						ie_considera_tab_selecao_w := pls_ocor_imp_pck.aplica_filtro_profissional(	ie_considera_tab_selecao_w, ie_incidencia_selecao_regra_p, ie_incidencia_selecao_w, ie_processo_excecao_w, ie_regra_excecao_p, r_c_comb_filtro.ie_excecao, nr_seq_combinada_p, nr_seq_ocorrencia_p, nr_id_transacao_p, r_c_comb_filtro.nr_sequencia, nr_seq_lote_protocolo_p, nr_seq_protocolo_p, nr_seq_conta_p, nr_seq_conta_proc_p, nr_seq_conta_mat_p, dt_inicio_vigencia_p, dt_fim_vigencia_p, 'S', r_c_comb_filtro.ie_filtro_mat, cd_estabelecimento_p, nm_usuario_p);
									
									
						ie_considera_tab_selecao_w := pls_ocor_imp_pck.aplica_filtro_profissional(	ie_considera_tab_selecao_w, ie_incidencia_selecao_regra_p, ie_incidencia_selecao_w, ie_processo_excecao_w, ie_regra_excecao_p, r_c_comb_filtro.ie_excecao, nr_seq_combinada_p, nr_seq_ocorrencia_p, nr_id_transacao_p, r_c_comb_filtro.nr_sequencia, nr_seq_lote_protocolo_p, nr_seq_protocolo_p, nr_seq_conta_p, nr_seq_conta_proc_p, nr_seq_conta_mat_p, dt_inicio_vigencia_p, dt_fim_vigencia_p, 'E', r_c_comb_filtro.ie_filtro_mat, cd_estabelecimento_p, nm_usuario_p);
									
						ie_considera_tab_selecao_w := pls_ocor_imp_pck.aplica_filtro_profissional(	ie_considera_tab_selecao_w, ie_incidencia_selecao_regra_p, ie_incidencia_selecao_w, ie_processo_excecao_w, ie_regra_excecao_p, r_c_comb_filtro.ie_excecao, nr_seq_combinada_p, nr_seq_ocorrencia_p, nr_id_transacao_p, r_c_comb_filtro.nr_sequencia, nr_seq_lote_protocolo_p, nr_seq_protocolo_p, nr_seq_conta_p, nr_seq_conta_proc_p, nr_seq_conta_mat_p, dt_inicio_vigencia_p, dt_fim_vigencia_p, 'P', r_c_comb_filtro.ie_filtro_mat, cd_estabelecimento_p, nm_usuario_p);				
				end if;
				
				-- contrato

				if (r_c_comb_filtro.ie_filtro_contrato = 'S') then
					
						ie_considera_tab_selecao_w := pls_ocor_imp_pck.aplica_filtro_contrato(	ie_considera_tab_selecao_w, ie_incidencia_selecao_regra_p, ie_incidencia_selecao_w, ie_processo_excecao_w, ie_regra_excecao_p, r_c_comb_filtro.ie_excecao, nr_seq_combinada_p, nr_seq_ocorrencia_p, nr_id_transacao_p, r_c_comb_filtro.nr_sequencia, nr_seq_lote_protocolo_p, nr_seq_protocolo_p, nr_seq_conta_p, nr_seq_conta_proc_p, nr_seq_conta_mat_p, dt_inicio_vigencia_p, dt_fim_vigencia_p, cd_estabelecimento_p, nm_usuario_p);
				end if;
			
				-- produto

				if (r_c_comb_filtro.ie_filtro_produto = 'S') then
				
						ie_considera_tab_selecao_w := pls_ocor_imp_pck.aplica_filtro_produto(	ie_considera_tab_selecao_w, ie_incidencia_selecao_regra_p, ie_incidencia_selecao_w, ie_processo_excecao_w, ie_regra_excecao_p, r_c_comb_filtro.ie_excecao, nr_seq_combinada_p, nr_seq_ocorrencia_p, nr_id_transacao_p, r_c_comb_filtro.nr_sequencia, nr_seq_lote_protocolo_p, nr_seq_protocolo_p, nr_seq_conta_p, nr_seq_conta_proc_p, nr_seq_conta_mat_p, dt_inicio_vigencia_p, dt_fim_vigencia_p, cd_estabelecimento_p, nm_usuario_p);
				end if;
				
				
				-- Intercambio: Conforme alinhado, nao iremos utilizar o filtro de intercambio pois nao ha necessidade deste filtro 

				-- na importaaao de XML.


				-- beneficiario

				if (r_c_comb_filtro.ie_filtro_benef = 'S') then
					
						ie_considera_tab_selecao_w := pls_ocor_imp_pck.aplica_filtro_beneficiario(	ie_considera_tab_selecao_w, ie_incidencia_selecao_regra_p, ie_incidencia_selecao_w, ie_processo_excecao_w, ie_regra_excecao_p, r_c_comb_filtro.ie_excecao, nr_seq_combinada_p, nr_seq_ocorrencia_p, nr_id_transacao_p, r_c_comb_filtro.nr_sequencia, nr_seq_lote_protocolo_p, nr_seq_protocolo_p, nr_seq_conta_p, nr_seq_conta_proc_p, nr_seq_conta_mat_p, dt_inicio_vigencia_p, dt_fim_vigencia_p, cd_estabelecimento_p, nm_usuario_p);
				end if;
				
				--filtro de Operadora

				if (r_c_comb_filtro.ie_filtro_oper_benef = 'S') then
					
						ie_considera_tab_selecao_w := pls_ocor_imp_pck.aplica_filtro_operadora(	ie_considera_tab_selecao_w, ie_incidencia_selecao_regra_p, ie_incidencia_selecao_w, ie_processo_excecao_w, ie_regra_excecao_p, r_c_comb_filtro.ie_excecao, nr_seq_combinada_p, nr_seq_ocorrencia_p, nr_id_transacao_p, r_c_comb_filtro.nr_sequencia, nr_seq_lote_protocolo_p, nr_seq_protocolo_p, nr_seq_conta_p, nr_seq_conta_proc_p, nr_seq_conta_mat_p, dt_inicio_vigencia_p, dt_fim_vigencia_p, cd_estabelecimento_p, nm_usuario_p);
					
				end if;
				
				-- procedimento

				if (r_c_comb_filtro.ie_filtro_proc = 'S')  then
					
						ie_considera_tab_selecao_w := pls_ocor_imp_pck.aplica_filtro_procedimento(	ie_considera_tab_selecao_w, ie_incidencia_selecao_regra_p, ie_incidencia_selecao_w, ie_processo_excecao_w, ie_regra_excecao_p, r_c_comb_filtro.ie_excecao, nr_seq_combinada_p, nr_seq_ocorrencia_p, nr_id_transacao_p, r_c_comb_filtro.nr_sequencia, nr_seq_lote_protocolo_p, nr_seq_protocolo_p, nr_seq_conta_p, nr_seq_conta_proc_p, nr_seq_conta_mat_p, dt_inicio_vigencia_p, dt_fim_vigencia_p, cd_estabelecimento_p, nm_usuario_p);
				end if;
				
				-- material

				if (r_c_comb_filtro.ie_filtro_mat = 'S')  then
					
							ie_considera_tab_selecao_w := pls_ocor_imp_pck.aplica_filtro_material(		ie_considera_tab_selecao_w, ie_incidencia_selecao_regra_p, ie_incidencia_selecao_w, ie_processo_excecao_w, ie_regra_excecao_p, r_c_comb_filtro.ie_excecao, nr_seq_combinada_p, nr_seq_ocorrencia_p, nr_id_transacao_p, r_c_comb_filtro.nr_sequencia, nr_seq_lote_protocolo_p, nr_seq_protocolo_p, nr_seq_conta_p, nr_seq_conta_proc_p, nr_seq_conta_mat_p, dt_inicio_vigencia_p, dt_fim_vigencia_p, cd_estabelecimento_p, nm_usuario_p);
				end if;
				
				-- Atualizar o campo definitivo que sera utilizado para sinalizar os registros que foram processados

				CALL CALL CALL CALL CALL pls_ocor_imp_pck.atualiza_campo_valido(	'F', ie_processo_excecao_w,
							ie_regra_excecao_p, r_c_comb_filtro.ie_excecao,
							nr_id_transacao_p, r_c_comb_filtro.nr_sequencia,
							'F');
		/*		
				-- processa novamente o filtro de exceaao para todo o atendimento

				-- Implementar no futuro apas todos os filtros normais serem desenvolvidos

			
				gerencia_aplic_filtro_ex_atend(	nr_id_transacao_p, r_c_comb_filtro.nr_sequencia, 
								r_c_comb_filtro.ie_filtro_protocolo, r_c_comb_filtro.ie_filtro_conta, 
								r_c_comb_filtro.ie_filtro_prest, r_c_comb_filtro.ie_filtro_prof, 
								r_c_comb_filtro.ie_filtro_contrato, r_c_comb_filtro.ie_filtro_produto,
								r_c_comb_filtro.ie_filtro_interc, r_c_comb_filtro.ie_filtro_benef,
								r_c_comb_filtro,ie_filtro_proc, r_c_comb_filtro.ie_filtro_mat, 
								r_c_comb_filtro.ie_filtro_oper_benef, r_c_comb_filtro.ie_excecao, 
								r_c_comb_filtro.ie_valida_todo_atend, ie_incidencia_selecao_w,
								nr_seq_combinada_p, nr_seq_ocorrencia_p, 
								dt_inicio_vigencia_p, dt_fim_vigencia_p, 
								nm_usuario_p, cd_estabelecimento_p);
				*/

				
				-- seta N para todos os campos auxiliares por uma questao de seguranaa para manter os registros antegros

				CALL CALL pls_ocor_imp_pck.reinicializa_campos_ie_valido(nr_id_transacao_p);
			end if;
			
			qt_filtro_processado_w := qt_filtro_processado_w + 1;
		end loop; -- loop combinaaaes
		-- faz as finalizaaaes do processamento dos filtros

		CALL CALL pls_ocor_imp_pck.finaliza_processo_filtro(nr_id_transacao_p);
	end if;	
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_ocor_imp_pck.gerencia_aplicacao_filtro ( nr_seq_lote_protocolo_p pls_protocolo_conta_imp.nr_seq_lote_protocolo%type, nr_seq_protocolo_p pls_protocolo_conta_imp.nr_sequencia%type, nr_seq_conta_p pls_conta_imp.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc_imp.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat_imp.nr_sequencia%type, nr_seq_ocorrencia_p pls_ocorrencia.nr_sequencia%type, nr_seq_combinada_p pls_oc_cta_combinada.nr_sequencia%type, dt_inicio_vigencia_p pls_oc_cta_combinada.dt_inicio_vigencia%type, dt_fim_vigencia_p pls_oc_cta_combinada.dt_fim_vigencia%type, cd_validacao_p pls_oc_cta_tipo_validacao.cd_validacao%type, ie_utiliza_filtro_p pls_oc_cta_combinada.ie_utiliza_filtro%type, ie_regra_excecao_p pls_oc_cta_combinada.ie_excecao%type, nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type, ie_incidencia_selecao_regra_p text, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;