-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_oc_cta_tratar_val_99_imp ( nr_seq_combinada_p pls_oc_cta_combinada.nr_sequencia%type, ie_regra_excecao_p pls_oc_cta_combinada.ie_excecao%type, nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type) AS $body$
DECLARE

_ora2pg_r RECORD;
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: 	Consistir a incidencia do grupo de procedimento cadastrado na funcao 
	"OPS - Glosas e Ocorrencias" pasta "Regra / Ocorrencia / Grupo procedimentos"
-------------------------------------------------------------------------------------------------------------------

Logica:
	1 - Percorre as validacoes da regra combinada
		2 - Abre o cursor dos itens
		2.1 - Verifica se o item esta cadastrado no grupo de procedimento
		2.2 - Caso sim, alimenta a variavel de incidencia
		2.3 - Caso a variavel de incidencia ultrapasse o limite estabelecido na regra, 
		entao aplica a validacao.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
nr_seq_conta_ant_w	pls_conta.nr_sequencia%type;
dt_procedimento_ant_w	pls_conta_proc.dt_procedimento_referencia%type;
dt_fim_proc_ant_w	pls_conta_proc.dt_fim_proc%type;
cd_procedimento_ant_w	pls_conta_proc.cd_procedimento%type;
ie_origem_proced_ant_w	pls_conta_proc.ie_origem_proced%type;
dt_material_ant_w	pls_conta_mat.dt_atendimento_referencia%type;
qt_incidencia_w		integer;
qt_cnt_w		integer;
qt_valido_w		integer;
idx_w			integer;
i			integer;
z			integer;
y			integer;
tb_seq_selecao_w	pls_util_cta_pck.t_number_table;
tb_valido_w		pls_util_cta_pck.t_varchar2_table_1;
tb_observacao_w		pls_util_cta_pck.t_varchar2_table_4000;
tb_seq_conta_proc_w	pls_util_cta_pck.t_number_table;
tb_seq_cta_proc_tmp_w	pls_util_cta_pck.t_number_table;
tb_seq_conta_mat_w	pls_util_cta_pck.t_number_table;
tb_seq_cta_mat_tmp_w	pls_util_cta_pck.t_number_table;
ds_lista_proc_w		varchar(4000);
ds_lista_mat_w		varchar(4000);
ds_lista_conta_w	varchar(4000);
ds_observacao_w		varchar(4000);

--Cursor de Regras
C01 CURSOR(nr_seq_oc_cta_comb_pc	pls_oc_cta_combinada.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia,
		a.qt_incidencia,
		a.nr_seq_regra_ocor_grupo nr_seq_regra,
		ie_contagem_item_princ,
		coalesce(ie_considera_data_item,'N') ie_considera_data_item,
		coalesce(ie_valida_todos_itens,'N') ie_valida_todos_itens
	from	pls_oc_cta_val_grupo_inc a
	where	a.nr_seq_oc_cta_comb = nr_seq_oc_cta_comb_pc;
	
-- Cursor para retirar os itens que nao se encaixam no grupo de incidencia que estejam na selecao. Performance.	
C02 CURSOR(	nr_seq_regra_pc		pls_regra_ocor_grupo_serv.nr_sequencia%type,
		nr_id_transacao_pc	pls_oc_cta_selecao_imp.nr_id_transacao%type) FOR
	SELECT	sel.nr_sequencia nr_seq_selecao,
		(SELECT	count(1)
		 from	pls_regra_ocor_proc proc
		 where	proc.cd_procedimento = sel.cd_procedimento
		 and	proc.ie_origem_proced = sel.ie_origem_proced
		 and	proc.nr_seq_regra_ocor_grupo = nr_seq_regra_pc) qt_proc,
		(select	count(1)
		 from	pls_regra_ocor_mat mat
		 where	mat.nr_seq_material = sel.nr_seq_material
		 and	mat.nr_seq_regra_ocor_grupo = nr_seq_regra_pc) qt_mat
	from	pls_oc_cta_selecao_imp sel
	where	sel.nr_id_transacao = nr_id_transacao_pc;

-- Cursor para retornar o segurado e a guia referencia dos itens da selecao
C03 CURSOR(	nr_seq_regra_pc		pls_regra_ocor_grupo_serv.nr_sequencia%type,
		nr_id_transacao_pc	pls_oc_cta_selecao_imp.nr_id_transacao%type) FOR
	SELECT	distinct a.nr_seq_segurado,
		a.cd_guia_referencia cd_guia_ok
	from	pls_oc_cta_selecao_imp a
	where	a.nr_id_transacao = nr_id_transacao_pc
	and	a.ie_valido = 'S'
	and	exists (SELECT	count(1)
			from	pls_regra_ocor_proc proc
			where	proc.cd_procedimento = a.cd_procedimento
			and	proc.ie_origem_proced = a.ie_origem_proced
			and	proc.nr_seq_regra_ocor_grupo = nr_seq_regra_pc
			
union all

			select	count(1)
			from	pls_regra_ocor_mat mat
			where	mat.nr_seq_material = a.nr_seq_material
			and	mat.nr_seq_regra_ocor_grupo = nr_seq_regra_pc);

-- Cursor dos procedimentos que se encaixam no grupo de incidencia de todo o atendimento		
C04 CURSOR(	nr_seq_regra_pc			pls_regra_ocor_grupo_serv.nr_sequencia%type,
		nr_seq_segurado_pc		pls_conta.nr_seq_segurado%type,
		cd_guia_pc			pls_conta.cd_guia_ok%type,
		nr_id_transacao_pc		pls_selecao_ocor_cta.nr_id_transacao%type) FOR
		
	SELECT	cd_procedimento,
		nr_seq_conta_proc,
		nr_seq_conta,
		qt_proc,
		qt_proc_sel,
		ie_origem_proced,
		trunc(dt_procedimento,'DD') dt_procedimento,
		trunc(dt_fim_proc,'DD') dt_fim_proc
	from
	(	SELECT	proc.cd_procedimento_conv	cd_procedimento,
			proc.nr_sequencia nr_seq_conta_proc,
			conta.nr_sequencia nr_seq_conta,
			(select	count(1)
			 from	pls_regra_ocor_proc regra
			 where	regra.cd_procedimento = proc.cd_procedimento_conv
			 and	regra.ie_origem_proced = proc.ie_origem_proced_conv
			 and	regra.nr_seq_regra_ocor_grupo = nr_seq_regra_pc) qt_proc,
			(select	count(1)
			 from	pls_selecao_ocor_cta sel
			 where	sel.nr_seq_conta_proc = proc.nr_sequencia
			 and	sel.nr_id_transacao = nr_id_transacao_pc
			 and	sel.ie_valido = 'S') qt_proc_sel,
			 proc.ie_origem_proced_conv ie_origem_proced,
			 proc.dt_execucao_trunc_conv dt_procedimento,
			 proc.dt_fim dt_fim_proc
		from	pls_conta_proc_imp proc,
			pls_conta_imp conta,
			pls_protocolo_conta_imp prot
		where	proc.nr_seq_conta		= conta.nr_sequencia
		and	conta.nr_seq_segurado_conv	= nr_seq_segurado_pc
		and	conta.cd_guia_ok_conv		= cd_guia_pc
		and	conta.nr_seq_protocolo		= prot.nr_sequencia
		and 	prot.ie_situacao not in ('RE', 'T')
		
union all

		select	proc.cd_procedimento,
			proc.nr_sequencia nr_seq_conta_proc,
			conta.nr_sequencia nr_seq_conta,
			(select	count(1)
			 from	pls_regra_ocor_proc regra
			 where	regra.cd_procedimento = proc.cd_procedimento
			 and	regra.ie_origem_proced = proc.ie_origem_proced
			 and	regra.nr_seq_regra_ocor_grupo = nr_seq_regra_pc) qt_proc,
			(select	count(1)
			 from	pls_selecao_ocor_cta sel
			 where	sel.nr_seq_conta_proc = proc.nr_sequencia
			 and	sel.nr_id_transacao = nr_id_transacao_pc
			 and	sel.ie_valido = 'S') qt_proc_sel,
			 proc.ie_origem_proced,
			 proc.dt_procedimento_referencia dt_procedimento,
			 proc.dt_fim_proc
		from	pls_conta_proc proc,
			pls_conta conta
		where	proc.nr_seq_conta		= conta.nr_sequencia
		and	conta.nr_seq_segurado		= nr_seq_segurado_pc
		and	conta.cd_guia_ok		= cd_guia_pc
		and	proc.ie_status			not in ('D','M')) alias13
	order by qt_proc_sel, dt_procedimento;

-- Cursor dos materiais que se encaixam no grupo de incidencia de todo o atendimento				
C05 CURSOR(	nr_seq_regra_pc		pls_regra_ocor_grupo_serv.nr_sequencia%type,
		nr_seq_segurado_pc	pls_conta.nr_seq_segurado%type,
		cd_guia_pc		pls_conta.cd_guia_ok%type,
		nr_id_transacao_pc	pls_selecao_ocor_cta.nr_id_transacao%type) FOR
	SELECT	nr_seq_material,
		nr_seq_conta_mat,
		nr_seq_conta,
		qt_mat,
		qt_mat_sel,
		dt_atendimento
	from
		(	
		SELECT	mat.nr_seq_material_conv nr_seq_material,
			mat.nr_sequencia nr_seq_conta_mat,
			conta.nr_sequencia nr_seq_conta,
			(select	count(1)
			 from	pls_regra_ocor_mat regra
			 where	regra.nr_seq_material = mat.nr_seq_material_conv
			 and	regra.nr_seq_regra_ocor_grupo = nr_seq_regra_pc) qt_mat,
			(select	count(1)
			 from	pls_selecao_ocor_cta sel
			 where	sel.nr_seq_conta_mat = mat.nr_sequencia
			 and	sel.nr_id_transacao = nr_id_transacao_pc
			 and	sel.ie_valido = 'S') qt_mat_sel,
			mat.dt_execucao_trunc_conv dt_atendimento
		from	pls_conta_mat_imp mat,
			pls_conta_imp conta,
			pls_protocolo_conta_imp prot
		where	mat.nr_seq_conta = conta.nr_sequencia
		and	conta.nr_seq_segurado_conv = nr_seq_segurado_pc
		and	conta.cd_guia_ok_conv = cd_guia_pc
		and	conta.nr_seq_protocolo = prot.nr_sequencia
		and 	prot.ie_situacao not in ('RE', 'T')
		
union all

		select	mat.nr_seq_material,
			mat.nr_sequencia nr_seq_conta_mat,
			conta.nr_sequencia nr_seq_conta,
			(select	count(1)
			 from	pls_regra_ocor_mat regra
			 where	regra.nr_seq_material = mat.nr_seq_material
			 and	regra.nr_seq_regra_ocor_grupo = nr_seq_regra_pc) qt_mat,
			(select	count(1)
			 from	pls_selecao_ocor_cta sel
			 where	sel.nr_seq_conta_mat = mat.nr_sequencia
			 and	sel.nr_id_transacao = nr_id_transacao_pc
			 and	sel.ie_valido = 'S') qt_mat_sel,
			mat.dt_atendimento_referencia dt_atendimento
		from	pls_conta_mat mat,
			pls_conta conta
		where	mat.nr_seq_conta = conta.nr_sequencia
		and	conta.nr_seq_segurado = nr_seq_segurado_pc
		and	conta.cd_guia_ok = cd_guia_pc
		and	mat.ie_status			not in ('D','M')) alias11
	order by
		qt_mat_sel,
		dt_atendimento;

-- Procedure para inserir a ocorrencia nos itens da selecao
procedure insere_ocorrencia(	tb_nr_seq_item_p	pls_util_cta_pck.t_number_table,
				nr_id_transacao_p	pls_oc_cta_selecao_ocor_v.nr_id_transacao%type,
				ds_obervacao_p		text,
				ie_opcao_p		text) is
				
--Variaveis table					
tb_seq_selecao_w	pls_util_cta_pck.t_number_table;
tb_valido_w		pls_util_cta_pck.t_varchar2_table_1;
tb_observacao_w		pls_util_cta_pck.t_varchar2_table_4000;
-- Contador
nr_contador_w		integer;
j			integer;

-- Cursor que ira retornar o procedimento que devera receber a ocorrencia na selecao				
C01 CURSOR(	nr_id_transacao_pc		pls_oc_cta_selecao_imp.nr_id_transacao%type,
		nr_seq_conta_proc_pc		pls_conta_proc.nr_sequencia%type) FOR
	SELECT	s.nr_sequencia
	from	pls_oc_cta_selecao_imp s
	where	s.nr_id_transacao = nr_id_transacao_pc
	and	s.ie_valido = 'S'
	and	s.nr_seq_conta_proc = nr_seq_conta_proc_pc;
	
-- Cursor que ira retornar o material que devera receber a ocorrencia na selecao	
C02 CURSOR(	nr_id_transacao_pc		pls_oc_cta_selecao_imp.nr_id_transacao%type,
		nr_seq_conta_mat_pc		pls_conta_mat.nr_sequencia%type) FOR
	SELECT	s.nr_sequencia
	from	pls_oc_cta_selecao_imp s
	where	s.nr_id_transacao = nr_id_transacao_pc
	and	s.ie_valido = 'S'
	and	s.nr_seq_conta_mat = nr_seq_conta_mat_pc;


BEGIN
-- Caso seja procedimento
if (ie_opcao_p = 'P') then
	
	for j in tb_nr_seq_item_p.first .. tb_nr_seq_item_p.last loop
		open C01(nr_id_transacao_p, tb_nr_seq_item_p(j));
		loop
			fetch C01 bulk collect into tb_seq_selecao_w
			limit pls_util_pck.qt_registro_transacao_w;
			exit when tb_seq_selecao_w.count = 0;
			
			-- Atribui a observacao e o "ie_valido" para as variaveis table
			nr_contador_w := 0;
			for nr_contador_w in tb_seq_selecao_w.first .. tb_seq_selecao_w.last loop				
				tb_observacao_w(nr_contador_w) := ds_obervacao_p;
				tb_valido_w(nr_contador_w) := 'S';
			end loop;
			-- Gerencia a selecao, gerando a ocorrencia			
			CALL pls_ocor_imp_pck.gerencia_selecao_validacao(	tb_seq_selecao_w, tb_valido_w, tb_observacao_w,
									nr_id_transacao_p,'SEQ');
									
			-- Incializar as listas para cada regra.
			SELECT * FROM pls_ocor_imp_pck.limpar_nested_tables(tb_seq_selecao_w, tb_valido_w, tb_observacao_w) INTO STRICT _ora2pg_r;
 tb_seq_selecao_w := _ora2pg_r.tb_nr_seq_selecao_p; tb_valido_w := _ora2pg_r.tb_ie_valido_p; tb_observacao_w := _ora2pg_r.tb_ds_observacao_p;

		end loop;
		close C01;
	end loop;
	
-- Caso for material
else
	for k in tb_nr_seq_item_p.first .. tb_nr_seq_item_p.last loop
		open C02(nr_id_transacao_p, tb_nr_seq_item_p(k));
		loop
			fetch C02 bulk collect into tb_seq_selecao_w
			limit pls_util_pck.qt_registro_transacao_w;
			exit when tb_seq_selecao_w.count = 0;
			
			-- Atribui a observacao e o "ie_valido" para as variaveis table
			nr_contador_w := 0;
			for nr_contador_w in tb_seq_selecao_w.first .. tb_seq_selecao_w.last loop
				
				tb_observacao_w(nr_contador_w) := ds_obervacao_p;
				tb_valido_w(nr_contador_w) := 'S';
			end loop;
			-- Gerencia a selecao, gerando a ocorrencia
			CALL pls_ocor_imp_pck.gerencia_selecao_validacao(	tb_seq_selecao_w, tb_valido_w, tb_observacao_w,
									nr_id_transacao_p,'SEQ');
			
			-- Incializar as listas para cada regra.
			SELECT * FROM pls_ocor_imp_pck.limpar_nested_tables(tb_seq_selecao_w, tb_valido_w, tb_observacao_w) INTO STRICT _ora2pg_r;
 tb_seq_selecao_w := _ora2pg_r.tb_nr_seq_selecao_p; tb_valido_w := _ora2pg_r.tb_ie_valido_p; tb_observacao_w := _ora2pg_r.tb_ds_observacao_p;
			
		end loop;
		close C02;
	end loop;
end if;

end;


begin

if (nr_seq_combinada_p IS NOT NULL AND nr_seq_combinada_p::text <> '') then
	
	-- tratamento em campo auxiliar para identificar posteriormente os registros que foram alterados
	CALL pls_ocor_imp_pck.atualiza_campo_auxiliar('V', ie_regra_excecao_p, nr_id_transacao_p, null);	
	
	--Grava a quantidade de registro por transacao
	qt_cnt_w := pls_util_pck.qt_registro_transacao_w;
	
	-- Incializar as listas para cada regra.
	SELECT * FROM pls_ocor_imp_pck.limpar_nested_tables(tb_seq_selecao_w, tb_valido_w, tb_observacao_w) INTO STRICT _ora2pg_r;
 tb_seq_selecao_w := _ora2pg_r.tb_nr_seq_selecao_p; tb_valido_w := _ora2pg_r.tb_ie_valido_p; tb_observacao_w := _ora2pg_r.tb_ds_observacao_p;
	i			:= 0;
	z			:= 0;
	y			:= 0;
	
	-- Abre o cursor de regras
	for r_C01_w in C01(nr_seq_combinada_p) loop
		-- Abre o cursor dos itens que serao retirados da selecao caso nao se encaixem no grupo de incidencia selecionado
		for r_C02_w in C02(r_C01_w.nr_seq_regra, nr_id_transacao_p) loop
			-- Caso tenha quantidade de procedimento ou material insere como valido

			-- pois caso nao possua quantidade, sera automaticamente setado para nao valido

			-- e nao sera verificado a incidencia do mesmo
			if (r_C02_w.qt_proc > 0) or (r_C02_w.qt_mat > 0) then
				
				tb_seq_selecao_w(i)	:= r_C02_w.nr_seq_selecao;
				tb_observacao_w(i) 	:= null;
				tb_valido_w(i) 		:= 'S';
				
				if (tb_seq_selecao_w.count >= qt_cnt_w) then
					
					-- Gerencia a selecao, gerando a ocorrencia
					CALL pls_ocor_imp_pck.gerencia_selecao_validacao(	tb_seq_selecao_w, tb_valido_w, tb_observacao_w,
											nr_id_transacao_p,'SEQ');
					
					-- Incializar as listas para cada regra.
					SELECT * FROM pls_ocor_imp_pck.limpar_nested_tables(tb_seq_selecao_w, tb_valido_w, tb_observacao_w) INTO STRICT _ora2pg_r;
 tb_seq_selecao_w := _ora2pg_r.tb_nr_seq_selecao_p; tb_valido_w := _ora2pg_r.tb_ie_valido_p; tb_observacao_w := _ora2pg_r.tb_ds_observacao_p;	
					i			:= 0;
				else
					i := i + 1;
				end if;
			end if;
		end loop;
		
		--Se sobrou algo nas estruturas, deve enviar para atualizar no banco.
		if (tb_seq_selecao_w.count > 0) then
			-- Gerencia a selecao, gerando a ocorrencia
			CALL pls_ocor_imp_pck.gerencia_selecao_validacao(	tb_seq_selecao_w, tb_valido_w, tb_observacao_w,
									nr_id_transacao_p,'SEQ');
			
			-- Incializar as listas para cada regra.
			SELECT * FROM pls_ocor_imp_pck.limpar_nested_tables(tb_seq_selecao_w, tb_valido_w, tb_observacao_w) INTO STRICT _ora2pg_r;
 tb_seq_selecao_w := _ora2pg_r.tb_nr_seq_selecao_p; tb_valido_w := _ora2pg_r.tb_ie_valido_p; tb_observacao_w := _ora2pg_r.tb_ds_observacao_p;
		end if;
	end loop;
	
	-- seta os registros que serao validos ou invalidos apos o processamento 
	CALL pls_ocor_imp_pck.atualiza_campo_valido('V', 'N', ie_regra_excecao_p, null, nr_id_transacao_p, null);
	
	-- tratamento em campo auxiliar para identificar posteriormente os registros que foram alterados
	CALL pls_ocor_imp_pck.atualiza_campo_auxiliar('V', ie_regra_excecao_p, nr_id_transacao_p, null);
	
	-- Verifica se ainda restou algum item a ser validado na selecao
	select	count(1)
	into STRICT	qt_valido_w
	from	pls_oc_cta_selecao_imp
	where	nr_id_transacao = nr_id_transacao_p
	and	ie_valido = 'S';
	
	if (qt_valido_w > 0) then
		-- Abre o cursor da regra
		for r_C01_w in C01(nr_seq_combinada_p) loop
		
			-- Como nao e limitado o numero de regras, para cada uma devera ser apagado as variaveis usadas como controle de historico

			-- Atualmente nao deve zerar a nivel de guia (C03), para considerar tudo que for ser validado.
			cd_procedimento_ant_w	:= null;
			ie_origem_proced_ant_w	:= null;
			dt_procedimento_ant_w	:= null;
			dt_fim_proc_ant_w	:= null;
			
			-- Abre o cursor do segurado e do codigo da guia
			for r_C03_w in C03(r_C01_w.nr_seq_regra, nr_id_transacao_p) loop
				
				i			:= 0;
				qt_incidencia_w 	:= 0;
				nr_seq_conta_ant_w	:= 0;
				ds_lista_proc_w		:= '';
				ds_lista_conta_w	:= '';
				ds_observacao_w		:= '';
				
				-- Abre o cursor dos procedimentos
				for r_C04_w in C04(r_C01_w.nr_seq_regra, r_C03_w.nr_seq_segurado, r_C03_w.cd_guia_ok, nr_id_transacao_p) loop
					-- Caso o procedimento esteja no grupo de incidencia			
					if (r_C04_w.qt_proc > 0) then
					
						-- Se a regra estiver configurada para considerar apenas o procedimento principal, sera feito o seguinte

						--	1. Verificar se o procedimento atual do cursor existe na lista de procedimentos ja verificados, com uma data de execucao diferente.

						--		1. Se o procedimento existir :

						--			Sera considerado entao que o procedimento esta duplicado e devera constar como uma incidencia

						--		2. Se o procedimento NAO existir

						--			O procedimento sera considerado como "principal" e nao vai constar como uma incidencia

						--	2. O procedimento sera inserido na lista de procedimentos ja verificados

						-- Se a regra nao estiver configurada para considerar apenas o procedimento principal, ou o evento for de Importacao de XML, a regra isera desconsiderada

						-- Verifica se o parametro "Considera data do item" esta marcado, caso sim, somente ira contar a incidencia de itens do mesmo dia
						if (r_C01_w.ie_considera_data_item = 'S') and
							((r_C04_w.dt_procedimento <> dt_procedimento_ant_w) or (coalesce(dt_procedimento_ant_w::text, '') = '')) and
							(((cd_procedimento_ant_w <> r_C04_w.cd_procedimento) or (coalesce(cd_procedimento_ant_w::text, '') = '')) or
							((ie_origem_proced_ant_w <> r_C04_w.ie_origem_proced) or (coalesce(ie_origem_proced_ant_w::text, '') = ''))) then
							qt_incidencia_w := 1;
							
							if (r_C01_w.ie_valida_todos_itens = 'S') then
								tb_seq_cta_proc_tmp_w.delete;
								z := 0;
								
								tb_seq_cta_proc_tmp_w(z) := r_C04_w.nr_seq_conta_proc;
							end if;
						elsif	((cd_procedimento_ant_w	<> r_C04_w.cd_procedimento) or (coalesce(cd_procedimento_ant_w::text, '') = ''))or
							((ie_origem_proced_ant_w <> r_C04_w.ie_origem_proced) or (coalesce(ie_origem_proced_ant_w::text, '') = ''))then
							
							qt_incidencia_w := qt_incidencia_w + 1;
							
							if (r_C01_w.ie_valida_todos_itens = 'S') then
								tb_seq_cta_proc_tmp_w(z) := r_C04_w.nr_seq_conta_proc;
								
								z := z + 1;
							end if;
						end if;
						-- Variavel de data referencia recebe a data atual
						dt_procedimento_ant_w := r_C04_w.dt_procedimento;
						cd_procedimento_ant_w	:= r_C04_w.cd_procedimento;
						ie_origem_proced_ant_w	:= r_C04_w.ie_origem_proced;
						
					
						-- Concatena a lista de procedimentos para a observacao
						ds_lista_proc_w := pls_util_pck.concatena_string(ds_lista_proc_w, r_C04_w.cd_procedimento);
						-- Concatena a lista de contas para a observacao
						if (r_C04_w.nr_seq_conta <> nr_seq_conta_ant_w) then
							ds_lista_conta_w := pls_util_pck.concatena_string(ds_lista_conta_w, r_C04_w.nr_seq_conta);
						end if;
						
						-- Caso a incidencia tenha ultrapassado o permitido na regra, gera a ocorrencia para os proximo itens						
						if (qt_incidencia_w > r_C01_w.qt_incidencia) then
							ds_observacao_w := substr('O item supera a quantidade maxima de incidencia cadastrada na regra de grupo de incidencia.' || pls_util_pck.enter_w ||
									'Regra de grupo de incidencia: ' || r_C01_w.nr_seq_regra || '.' || pls_util_pck.enter_w ||
									'Quantidade maxima de incidencia para o grupo: ' || r_C01_w.qt_incidencia || '. Quantidade encontrada: ' || qt_incidencia_w || '.' || pls_util_pck.enter_w ||
									'Itens do grupo presentes no atendimento: ' || ds_lista_proc_w || '.' || pls_util_pck.enter_w ||
									'Contas dos itens: ' || ds_lista_conta_w || '.', 1, 4000);
									
							if (r_C01_w.ie_valida_todos_itens = 'S') then
								if (tb_seq_cta_proc_tmp_w.count > 0) then
									for y in tb_seq_cta_proc_tmp_w.first .. tb_seq_cta_proc_tmp_w.last loop
										tb_seq_conta_proc_w(i) := tb_seq_cta_proc_tmp_w(y);
										
										i := i + 1;
									end loop;
									
									tb_seq_cta_proc_tmp_w.delete;
									z := 0;
								end if;
							else
								tb_seq_conta_proc_w(i) := r_C04_w.nr_seq_conta_proc;
														
								i := i + 1;
							end if;
							-- Caso tenha alcancado o numero de registros insere a ocorrencia.
							if (tb_seq_conta_proc_w.count >= qt_cnt_w) then
								insere_ocorrencia(	tb_seq_conta_proc_w, nr_id_transacao_p,
											ds_observacao_w, 'P');
								
								tb_seq_conta_proc_w.delete;
								i := 0;
							end if;
						end if;
					end if;
					nr_seq_conta_ant_w := r_C04_w.nr_seq_conta;
				end loop;				
				-- Caso tenha sobrado algum registro, insere a ocorrencia.
				if (tb_seq_conta_proc_w.count > 0) then				
					insere_ocorrencia(	tb_seq_conta_proc_w, nr_id_transacao_p,
								ds_observacao_w, 'P');
					
					tb_seq_conta_proc_w.delete;
					i := 0;
				end if;
				
				ds_lista_mat_w := '';
				ds_observacao_w := '';
				
				-- Abre o cursor dos materiais		
				for r_C05_w in C05(r_C01_w.nr_seq_regra, r_C03_w.nr_seq_segurado, r_C03_w.cd_guia_ok, nr_id_transacao_p) loop
					-- Caso o material esteja no grupo de incidencia				
					if (r_C05_w.qt_mat > 0) then
						-- Acrescenta na variavel
						if (r_C01_w.ie_considera_data_item = 'S') and (r_C05_w.dt_atendimento <> dt_material_ant_w) then
							qt_incidencia_w := 1;
							
							if (r_C01_w.ie_valida_todos_itens = 'S') then
								tb_seq_cta_mat_tmp_w.delete;
								z := 0;
								
								tb_seq_cta_mat_tmp_w(z) := r_C05_w.nr_seq_conta_mat;
							end if;
						else
							qt_incidencia_w := qt_incidencia_w + 1;
							if (r_C01_w.ie_valida_todos_itens = 'S') then
								tb_seq_cta_mat_tmp_w(z) := r_C05_w.nr_seq_conta_mat;
								
								z := z + 1;
							end if;
						end if;
						
						dt_material_ant_w := r_C05_w.dt_atendimento;
						
						-- Concatena a lista de materiais para a observacao
						ds_lista_mat_w := pls_util_pck.concatena_string(ds_lista_mat_w, r_C05_w.nr_seq_material);
						-- Concatena a lista de contas para a observacao
						if (r_C05_w.nr_seq_conta <> nr_seq_conta_ant_w) then
							ds_lista_conta_w := pls_util_pck.concatena_string(ds_lista_conta_w, r_C05_w.nr_seq_conta);
						end if;
						-- Caso a incidencia tenha ultrapassado o permitido na regra, gera a ocorrencia para os proximo itens
						if (qt_incidencia_w > r_C01_w.qt_incidencia) then
							ds_observacao_w := substr('O item supera a quantidade maxima de incidencia cadastrada na regra de grupo de incidencia.' || pls_util_pck.enter_w ||
									'Regra de grupo de incidencia: ' || r_C01_w.nr_seq_regra || '.' || pls_util_pck.enter_w ||
									'Quantidade maxima de incidencia para o grupo: ' || r_C01_w.qt_incidencia || '. Quantidade encontrada: ' || qt_incidencia_w || '.' || pls_util_pck.enter_w ||
									'Procedimentos do grupo presentes no atendimento: ' || ds_lista_proc_w || '.' || pls_util_pck.enter_w ||
									'Materiais do grupo presentes no atendimento: ' || ds_lista_mat_w || '.' || pls_util_pck.enter_w ||
									'Contas dos itens: ' || ds_lista_conta_w || '.', 1, 4000);
									
							if (r_C01_w.ie_valida_todos_itens = 'S') then
								if (tb_seq_cta_mat_tmp_w.count > 0) then
									for y in tb_seq_cta_mat_tmp_w.first .. tb_seq_cta_mat_tmp_w.last loop
										tb_seq_conta_mat_w(i) := tb_seq_cta_mat_tmp_w(y);
										
										i := i + 1;
									end loop;
								end if;
							else
								tb_seq_conta_mat_w(i) := r_C05_w.nr_seq_conta_mat;
								
								i := i + 1;
							end if;	
							
							-- Caso tenha alcancado o numero de registros insere a ocorrencia.
							if (tb_seq_conta_mat_w.count >= qt_cnt_w) then
								insere_ocorrencia(	tb_seq_conta_mat_w, nr_id_transacao_p,
											ds_observacao_w, 'M');
											
								tb_seq_conta_mat_w.delete;
								i := 0;
							end if;							
						end if;
					end if;
					
					nr_seq_conta_ant_w := r_C05_w.nr_seq_conta;
				end loop;
				-- Caso tenha sobrado algum registro, insere a ocorrencia.
				if (tb_seq_conta_mat_w.count > 0) then	
					insere_ocorrencia(	tb_seq_conta_mat_w, nr_id_transacao_p,
								ds_observacao_w, 'M');
								
					tb_seq_conta_mat_w.delete;
				end if;
			end loop;
		end loop;
		-- seta os registros que serao validos ou invalidos apos o processamento 
		CALL pls_ocor_imp_pck.atualiza_campo_valido('V', 'N', ie_regra_excecao_p, null, nr_id_transacao_p, null);
		
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_oc_cta_tratar_val_99_imp ( nr_seq_combinada_p pls_oc_cta_combinada.nr_sequencia%type, ie_regra_excecao_p pls_oc_cta_combinada.ie_excecao%type, nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type) FROM PUBLIC;
