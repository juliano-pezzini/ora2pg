-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_oc_cta_tratar_val_57 ( dados_regra_p pls_tipos_ocor_pck.dados_regra, nr_id_transacao_p pls_oc_cta_selecao_ocor_v.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:  Aplicar a validacao para regra de correlacao de itens
------------------------------------------------------------------------------------------------------------------

Locais de chamada direta:
[ X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
------------------------------------------------------------------------------------------------------------------

Pontos de atencao:

Logica:
1 - Percorrer todas as validacoes da combinacao (regras de correlacao)
	2 - Para cada regra de correlacao:
	3.1 - Somar as quantidades do procedimento de referencia
	3.2 - Percorrer todos os itens relacionados
		4 - Buscar situacoes onde a soma da quantidade do codigo
		supera a quantidade maxima da regra
			5 - Colocar na selecao os procedimentos

Alteracoes:
------------------------------------------------------------------------------------------------------------------

Francisco - 02/12/2013 - Criacao da rotina
------------------------------------------------------------------------------------------------------------------

dlehmkuhl OS 688483 - 14/04/2014 -

Alteracao:	Modificada a forma de trabalho em relacao a atualizacao dos campos de controle
	que basicamente decidem se a ocorrencia sera ou nao gerada. Foi feita tambem a
	substituicao da rotina obterX_seX_geraX.

Motivo:	Necessario realizar essas alteracoes para corrigir bugs principalmente no que se
	refere a questao de aplicacao de filtros (passo anterior ao da validacao). Tambem
	tivemos um foco especial em performance, visto que a mesma precisou ser melhorada
	para nao inviabilizar a nova solicitacao que diz que a excecao deve verificar todo
	o atendimento.
------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
tb_seq_selecao_w		dbms_sql.number_table;
tb_observacao_w			dbms_sql.varchar2_table;
tb_valido_w			dbms_sql.varchar2_table;
qt_cnt_w			integer;
i				integer;
qt_item_valido_w		integer;
qt_proc_princ_w			integer;
qt_maxima_cor_w			integer;
qt_procedimento_w		double precision;
qt_material_w			double precision;
ds_observacao_cta_w		varchar(1000);
ds_observacao_cta_ww		varchar(1000);
ds_observacao_proc_w		varchar(1000);
ds_observacao_proc_ww		varchar(1000);
ds_observacao_mat_w		varchar(1000);
ds_observacao_mat_ww		varchar(1000);
ds_observacao_w			varchar(4000);
ie_origem_proced_ant_w		procedimento.ie_origem_proced%type;
cd_procedimento_ant_w		procedimento.cd_procedimento%type;
nr_seq_material_ant_w		pls_material.nr_sequencia%type;
nr_seq_grau_partic_ref_w	pls_grau_participacao.nr_sequencia%type;
nr_seq_grau_partic_ant_w	pls_grau_participacao.nr_sequencia%type;
dt_procedimento_ant_w		pls_conta_proc.dt_procedimento_referencia%type;
-- Regras
C01 CURSOR(nr_seq_oc_cta_comb_pc	dados_regra_p.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia,
		a.ie_considera_grau_partic,
		b.nr_sequencia nr_seq_regra_correlacao,
		b.cd_procedimento,
		b.ie_origem_proced,
		b.nr_seq_grupo_servico,
		a.ie_arredondar
	from	pls_regra_correlacao b,
		pls_oc_cta_val_correlacao a
	where	a.nr_seq_regra_correlacao = b.nr_sequencia
	and	a.nr_seq_oc_cta_comb	= nr_seq_oc_cta_comb_pc;

/*Localiza todos os procedimentos referencias(Pode ser informado grupo de servico, fazendo com que muitos procedimentos possam ser retornados)	
	OBS : Apenas devera ser cadastrado na regra de correlacao um procedimento como referencias ou um grupo de servico, nao podera ser 
	nulo e tambem nao podera ter as duas informacoes para cada regra.
*/
C01_itens CURSOR(	nr_seq_grupo_servico_pc	pls_regra_correlacao.nr_seq_grupo_servico%type,
			cd_procedimento_pc	procedimento.cd_procedimento%type,
			ie_origem_proced_pc	procedimento.ie_origem_proced%type) FOR
	SELECT	cd_procedimento,
		ie_origem_proced
	from	table(pls_grupos_pck.obter_procs_grupo_servico( nr_seq_grupo_servico_pc, null, null))
	where	coalesce(cd_procedimento_pc::text, '') = ''
	
union

	SELECT	cd_procedimento,
		ie_origem_proced
	from	procedimento
	where	cd_procedimento = cd_procedimento_pc
	and	ie_origem_proced = ie_origem_proced_pc
	and	coalesce(nr_seq_grupo_servico_pc::text, '') = '';
	
-- Cursor para descartar itens que nao se encaixam na regra de correlacao. Melhora a performance
C02 CURSOR(	nr_id_transacao_pc		pls_selecao_ocor_cta.nr_id_transacao%type,
		nr_seq_regra_pc			pls_regra_correlacao.nr_sequencia%type)FOR
	SELECT	sel.nr_sequencia nr_seq_selecao,
		(SELECT	count(1)
		from	pls_regra_correlacao_proc proc
		where	sel.cd_procedimento 	= proc.cd_procedimento
		and	sel.ie_origem_proced	= proc.ie_origem_proced
		and	proc.nr_seq_regra 	= nr_seq_regra_pc) qt_proc,
		(select	count(1)
		from	pls_regra_correlacao_mat mat
		where	sel.nr_seq_material 	= mat.nr_seq_material
		and	mat.nr_seq_regra 	= nr_seq_regra_pc) qt_mat
	from	pls_selecao_ocor_cta sel
	where	sel.nr_id_transacao = nr_id_transacao_pc;

--Cursor para retornar o segurado e o codigo da guia referencia
C03 CURSOR(	nr_id_transacao_pc	pls_selecao_ocor_cta.nr_id_transacao%type,
		nr_seq_regra_pc		pls_regra_correlacao.nr_sequencia%type)FOR
	SELECT	distinct a.nr_seq_segurado,
		a.cd_guia_referencia cd_guia_ok
	from	pls_selecao_ocor_cta a
	where	a.nr_id_transacao = nr_id_transacao_pc
	and	a.ie_valido	= 'S'
	and	exists (	SELECT	1
			from	pls_regra_correlacao_proc c
			where	c.nr_seq_regra = nr_seq_regra_pc
			and	c.cd_procedimento = a.cd_procedimento
			and	c.ie_origem_proced = a.ie_origem_proced
			
union all

			select	1
			from	pls_regra_correlacao_mat c
			where	c.nr_seq_regra = nr_seq_regra_pc
			and	c.nr_seq_material = a.nr_seq_material);

-- Cursor que ira retornar as guais que possuem o procedimento referencia
C04 CURSOR(	nr_seq_segurado_pc		pls_conta.nr_seq_segurado%type,
		cd_guia_referencia_pc		pls_conta.cd_guia_referencia%type,
		cd_procedimento_pc		procedimento.cd_procedimento%type,
		ie_origem_proced_pc		procedimento.ie_origem_proced%type) FOR
	SELECT	conta.nr_sequencia nr_seq_conta,
		conta.nr_seq_grau_partic nr_seq_grau_partic_conta,
		proc.qt_procedimento_imp qt_proc_princ,
		proc.dt_procedimento_referencia dt_procedimento,
		(SELECT	count(1)
		 from	pls_proc_participante partic
		 where	proc.nr_sequencia = partic.nr_seq_conta_proc) qt_partic,
		(select	max(nr_seq_grau_partic)
		 from	pls_proc_participante partic
		 where	proc.nr_sequencia = partic.nr_seq_conta_proc) nr_seq_grau_partic		
	from	pls_conta conta,
		pls_conta_proc proc
	where	conta.nr_seq_segurado 	= nr_seq_segurado_pc
	and	conta.cd_guia_ok 	= cd_guia_referencia_pc
	and	proc.nr_seq_conta 	= conta.nr_sequencia
	and	proc.cd_procedimento 	= cd_procedimento_pc
	and	proc.ie_origem_proced	= ie_origem_proced_pc
	and	proc.ie_status		not in ('D', 'M');

-- Cursor que ira retornar as guias que possuem os procedimentos secundarios da regra
C05 CURSOR(	nr_id_transacao_pc		pls_selecao_ocor_cta.nr_id_transacao%type,
		cd_guia_referencia_pc		pls_conta.cd_guia_referencia%type,
		nr_seq_segurado_pc		pls_conta.nr_seq_segurado%type,
		nr_seq_regra_pc			pls_regra_correlacao.nr_sequencia%type) FOR
	SELECT	proc.qt_procedimento_imp qt_proc,
		proc.cd_procedimento,
		proc.ie_origem_proced,
		proc.nr_sequencia nr_seq_conta_proc,
		regra.qt_maxima,
		(SELECT	count(1)
		 from	pls_proc_participante partic
		 where	proc.nr_sequencia = partic.nr_seq_conta_proc) qt_partic,
		(select	max(nr_seq_grau_partic)
		 from	pls_proc_participante partic
		 where	proc.nr_sequencia = partic.nr_seq_conta_proc) nr_seq_grau_partic,
		conta.nr_seq_grau_partic nr_seq_grau_partic_conta,
		proc.dt_procedimento_referencia dt_procedimento
	from	pls_conta_proc proc,
		pls_conta conta,
		pls_regra_correlacao_proc regra
	where	conta.nr_sequencia 	= proc.nr_seq_conta
	and	regra.cd_procedimento 	= proc.cd_procedimento
	and	regra.ie_origem_proced 	= proc.ie_origem_proced
	and	conta.cd_guia_ok 	= cd_guia_referencia_pc
	and	conta.nr_seq_segurado 	= nr_seq_segurado_pc
	and	regra.nr_seq_regra 	= nr_seq_regra_pc
	order by
		regra.cd_procedimento,
		regra.ie_origem_proced;

-- Cursor que ira retornar as guais que possuem os materiais secundarios da regra
C06 CURSOR(	nr_id_transacao_pc		pls_selecao_ocor_cta.nr_id_transacao%type,
		cd_guia_referencia_pc		pls_conta.cd_guia_referencia%type,
		nr_seq_segurado_pc		pls_conta.nr_seq_segurado%type,
		nr_seq_regra_pc			pls_regra_correlacao.nr_sequencia%type) FOR
	SELECT	mat.qt_material_imp qt_mat,
		mat.nr_seq_material,
		mat.nr_sequencia nr_seq_conta_mat,
		regra.qt_maxima
	from	pls_conta_mat mat,
		pls_conta conta,
		pls_regra_correlacao_mat regra
	where	conta.nr_sequencia 	= mat.nr_seq_conta
	and	regra.nr_seq_material	= mat.nr_seq_material
	and	conta.cd_guia_ok 	= cd_guia_referencia_pc
	and	conta.nr_seq_segurado 	= nr_seq_segurado_pc
	and	regra.nr_seq_regra 	= nr_seq_regra_pc
	order by
		regra.nr_seq_material;

		
-- Procedure utilizada para inserir a ocorrencia nos itens que ultrapassaram a quantidade maxima
procedure insere_ocorrencia(	nr_seq_item_p		pls_conta_proc.nr_sequencia%type,
					nr_id_transacao_p	pls_oc_cta_selecao_ocor_v.nr_id_transacao%type,
					nm_usuario_p		usuario.nm_usuario%type,
					ds_obervacao_p		text,
					ie_opcao_p		text) is
--Variaveis table
tb_seq_selecao_w	dbms_sql.number_table;
tb_observacao_w		dbms_sql.varchar2_table;
tb_valido_w		dbms_sql.varchar2_table;
-- Contador
nr_contador_w		integer;

-- Cursor que ira retornar o procedimento que devera receber a ocorrencia na selecao
C01 CURSOR(	nr_id_transacao_pc		pls_selecao_ocor_cta.nr_id_transacao%type,
		nr_seq_conta_proc_pc		pls_conta_proc.nr_sequencia%type) FOR
	SELECT	s.nr_sequencia
	from	pls_selecao_ocor_cta s
	where	s.nr_id_transacao = nr_id_transacao_pc
	and	s.ie_valido = 'S'
	and	s.nr_seq_conta_proc = nr_seq_conta_proc_pc;

-- Cursor que ira retornar o material que devera receber a ocorrencia na selecao
C02 CURSOR(	nr_id_transacao_pc		pls_selecao_ocor_cta.nr_id_transacao%type,
		nr_seq_conta_mat_pc		pls_conta_mat.nr_sequencia%type) FOR
	SELECT	s.nr_sequencia
	from	pls_selecao_ocor_cta s
	where	s.nr_id_transacao = nr_id_transacao_pc
	and	s.ie_valido = 'S'
	and	s.nr_seq_conta_mat = nr_seq_conta_mat_pc;

BEGIN

-- Caso esteja inserindo a ocorrencia para procedimentos
if (ie_opcao_p = 'P') then
	-- Abre cursor da selecao
	open C01(nr_id_transacao_p, nr_seq_item_p);
	loop
		--Utilizado fetch por questao de performance
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
		CALL pls_tipos_ocor_pck.gerencia_selecao_validacao(	tb_seq_selecao_w,
								pls_tipos_ocor_pck.clob_table_vazia,
								'SEQ',
								tb_observacao_w,
								tb_valido_w,
								nm_usuario_p);
		-- Limpa as variaveis
		tb_seq_selecao_w.delete;
		tb_observacao_w.delete;
		tb_valido_w.delete;
	end loop;
	close C01;
else
-- Caso esteja inserindo a ocorrencia para materiais

	-- Abre o cursor da selecao
	open C02(nr_id_transacao_p, nr_seq_item_p);
	loop
		--Utilizado fetch por questao de performance
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
		CALL pls_tipos_ocor_pck.gerencia_selecao_validacao(	tb_seq_selecao_w,
								pls_tipos_ocor_pck.clob_table_vazia,
								'SEQ',
								tb_observacao_w,
								tb_valido_w,
								nm_usuario_p);
		-- Limpa as variaveis
		tb_seq_selecao_w.delete;
		tb_observacao_w.delete;
		tb_valido_w.delete;
	end loop;
	close C02;
end if;

commit;

end;

begin
-- Somente ira verificar caso haja regra
if (dados_regra_p.nr_sequencia IS NOT NULL AND dados_regra_p.nr_sequencia::text <> '') then

	-- Atribui a string padrao para cada tipo de item.
	ds_observacao_cta_w := 'Contas que possuem o procedimento referencia: ';
	ds_observacao_proc_w := 'Contas proc que possuem o procedimento secundario: ';
	ds_observacao_mat_w := 'Contas mat que possuem o material secundario: ';

	-- tratamento em campo auxiliar para identificar posteriormente os registros que foram alterados
	CALL pls_tipos_ocor_pck.atualiza_campo_auxiliar('V', nr_id_transacao_p, null, dados_regra_p);

	-- Variavel para restringir a quantidade de regstros que serao validados por vez.
	qt_cnt_w := pls_cta_consistir_pck.qt_registro_transacao_w;

	-- Inicializar vetor usado para gravar na selecao
	tb_seq_selecao_w	:= pls_tipos_ocor_pck.num_table_vazia;
	tb_observacao_w		:= pls_tipos_ocor_pck.vchr2_table_vazia;
	tb_valido_w		:= pls_tipos_ocor_pck.vchr2_table_vazia;
	i			:= 0;

	-- Abre as regras
	for	r_C01_w in C01(dados_regra_p.nr_sequencia) loop

		-- Abre o cursor para descartar os itens que nao se encaixam na regra. Melhora a performance
		for r_C02_w in C02(nr_id_transacao_p, r_C01_w.nr_seq_regra_correlacao)loop

			-- Caso o procedimento em questao se encaixe na regra ira setar o ie_valido para 'S'

			-- pois os itens que nao se encaixarem automaticamente irao receber 'N' e nao serao validados

			-- depois quando sera verificado a quantidade apresentada.
			if (r_C02_w.qt_proc > 0) or (r_C02_w.qt_mat > 0) then

				-- Alimenta as variaveis table
				tb_seq_selecao_w(i) 	:= r_C02_w.nr_seq_selecao;
				tb_observacao_w(i) 	:= null;
				tb_valido_w(i)		:= 'S';

				--Caso tenha alcancado a quantidade de registros, gerencia a selecao.
				if (tb_seq_selecao_w.count >= qt_cnt_w ) then
					CALL pls_tipos_ocor_pck.gerencia_selecao_validacao(	tb_seq_selecao_w,
											pls_tipos_ocor_pck.clob_table_vazia,
											'SEQ',
											tb_observacao_w,
											tb_valido_w,
											nm_usuario_p);
					-- Limpa as variaveis
					tb_seq_selecao_w.delete;
					tb_observacao_w.delete;
					tb_valido_w.delete;
					i := 0;
				else
					i := i + 1;
				end if;
			end if;
		end loop;
		-- Caso tenha restado algum registro, gerencia novamente a selecao.
		if (tb_seq_selecao_w.count > 0) then
			CALL pls_tipos_ocor_pck.gerencia_selecao_validacao(	tb_seq_selecao_w,
									pls_tipos_ocor_pck.clob_table_vazia,
									'SEQ',
									tb_observacao_w,
									tb_valido_w,
									nm_usuario_p);
		end if;
	end loop;-- Fecha o cursor de regras.

	-- seta os registros que serao validos ou invalidos apos o processamento
	CALL pls_tipos_ocor_pck.atualiza_campo_valido('V', nr_id_transacao_p, null, dados_regra_p);

	-- tratamento em campo auxiliar para identificar posteriormente os registros que foram alterados
	CALL pls_tipos_ocor_pck.atualiza_campo_auxiliar('V', nr_id_transacao_p, null, dados_regra_p);

	-- Verifica se possui ainda algum registro na selecao que deve ser validado

	-- caso nao reste nenhum registro pois foi descartado no processo anterior

	-- nao tem o porque continuar.
	select	count(1)
	into STRICT	qt_item_valido_w
	from	pls_selecao_ocor_cta
	where	nr_id_transacao	= nr_id_transacao_p
	and	ie_valido 	= 'S';

	-- Caso tenha registro
	if ( qt_item_valido_w > 0) then
		-- Abre o cursor de regras
		for	r_C01_w in C01(dados_regra_p.nr_sequencia) loop
			-- Abre o cursor de guia referencia e segurado
			for r_C03_w in C03(nr_id_transacao_p, r_C01_w.nr_seq_regra_correlacao)loop

				-- Inicia as variaveis de observacao e quantidade do procedimento referencia
				qt_proc_princ_w := 0;
				ds_observacao_cta_ww := '';
				dt_procedimento_ant_w := to_date('01/01/1899', 'dd/mm/yyyy');
				nr_seq_grau_partic_ant_w  := 0;
						
				for r_C01_itens in C01_itens( r_C01_w.nr_Seq_grupo_servico, r_C01_w.cd_procedimento, r_C01_w.ie_origem_proced) loop
							
					
							
					-- Percorre as guias que possuem o procedimento referencia para verificar quantas vezes o mesmo e apresentado
					for r_C04_w in C04(r_C03_w.nr_seq_segurado, r_C03_w.cd_guia_ok, r_C01_itens.cd_procedimento, r_C01_itens.ie_origem_proced)loop
						-- Se deve considerar o grau de participacao
						if (r_C01_w.ie_considera_grau_partic = 'S') then
							
							nr_seq_grau_partic_ref_w := null;
							-- Somente deve considerar o grau de participacao se tiver no maximo um participante
							if (r_C04_w.qt_partic < 2) then
								-- Caso nao possua nenhum, busca na conta

								-- Caso possua um, pega o grau de participacao do mesmo
								if (r_C04_w.qt_partic = 0) then
									nr_seq_grau_partic_ref_w := r_C04_w.nr_seq_grau_partic_conta;
								elsif (r_C04_w.qt_partic = 1) then
									nr_seq_grau_partic_ref_w := r_C04_w.nr_seq_grau_partic;
								end if;
							end if;
							-- Se achou grau de participacao continua, se nao soma a variavel
							if (nr_seq_grau_partic_ref_w IS NOT NULL AND nr_seq_grau_partic_ref_w::text <> '') then
								-- Caso a data seja diferente da anterior, ou o grau de participacao seja igual soma a variavel

								-- Caso contrario, nao deve somar
								if (r_C04_w.dt_procedimento <> dt_procedimento_ant_w) or (nr_seq_grau_partic_ref_w = nr_seq_grau_partic_ant_w) then
									ds_observacao_cta_ww 	:= pls_util_pck.concatena_string(ds_observacao_cta_ww, r_C04_w.nr_seq_conta);
									qt_proc_princ_w		:= qt_proc_princ_w + r_C04_w.qt_proc_princ;
								end if;
							else
								ds_observacao_cta_ww 	:= pls_util_pck.concatena_string(ds_observacao_cta_ww, r_C04_w.nr_seq_conta);
								qt_proc_princ_w		:= qt_proc_princ_w + r_C04_w.qt_proc_princ;
							end if;
						else
							ds_observacao_cta_ww 	:= pls_util_pck.concatena_string(ds_observacao_cta_ww, r_C04_w.nr_seq_conta);
							qt_proc_princ_w		:= qt_proc_princ_w + r_C04_w.qt_proc_princ;
						end if;
						-- Alimenta as variaveis
						dt_procedimento_ant_w := r_C04_w.dt_procedimento;
						nr_seq_grau_partic_ant_w := nr_seq_grau_partic_ref_w;
					end loop;
					
				end loop;
				
				-- Caso possua o procedimento referencia verifica os itens secundarios
				if (qt_proc_princ_w > 0) then

					-- Inicia as variaveis dos procedimentos
					cd_procedimento_ant_w 		:= 0;
					ie_origem_proced_ant_w 		:= 0;
					qt_maxima_cor_w			:= 0;
					qt_procedimento_w		:= 0;
					ds_observacao_proc_ww		:= '';
					dt_procedimento_ant_w 		:= to_date('01/01/1899', 'dd/mm/yyyy');
					nr_seq_grau_partic_ant_w  	:= 0;

					-- Abre o cursor de procedimentos secundarios para o atendimento
					for r_C05_w in C05(nr_id_transacao_p, r_C03_w.cd_guia_ok, r_C03_w.nr_seq_segurado, r_C01_w.nr_seq_regra_correlacao)loop

						-- Seta a quantidade maxima de correlacao, esta e baseada

						-- na quantidade que o procedimento referencia foi apresentado
						if (coalesce(r_C01_w.ie_arredondar,'N') = 'S') then
						qt_maxima_cor_w	:= Round(r_C05_w.qt_maxima * qt_proc_princ_w);
						else
						qt_maxima_cor_w	:= r_C05_w.qt_maxima * qt_proc_princ_w;
						end if;
						
						-- Caso tem que considerar grau de participacao
						if (r_C01_w.ie_considera_grau_partic = 'S') then
							-- Seta a variavel para nulo
							nr_seq_grau_partic_ref_w := null;
							-- Somente sera valida a tratativa caso possua no maximo 1 participante no item
							if (r_C05_w.qt_partic < 2) then
								-- Se nao tiver participante no item, busca na conta, se nao, busca na conta
								if (r_C05_w.qt_partic < 1) then
									nr_seq_grau_partic_ref_w := r_C05_w.nr_seq_grau_partic_conta;
								elsif (r_C05_w.qt_partic = 1) then
									nr_seq_grau_partic_ref_w := r_C05_w.nr_seq_grau_partic;
								end if;
							end if;		
							-- Caso possua grau de participacao, significa que tem no maximo um participante

							-- Caso nao possua, verifica somente se mudou o procedimento, se nao udou incrementa a variavel
							if (nr_seq_grau_partic_ref_w IS NOT NULL AND nr_seq_grau_partic_ref_w::text <> '') then
								-- Caso o procedimento seja igual deve-se verificar a data do item e o grau de participacao

								-- Caso mudou o procedimento apenas atribui o valor do item atual
								if (r_C05_w.cd_procedimento = cd_procedimento_ant_w) and (r_C05_w.ie_origem_proced = ie_origem_proced_ant_w) then
									-- Se nao for a mesma data, significa que sao procedimentos diferentes, entao incrementa a variavel

									-- Caso contrario, verifica o grau de participancao
									if (r_C05_w.dt_procedimento <> dt_procedimento_ant_w) or (nr_seq_grau_partic_ref_w = nr_seq_grau_partic_ant_w) then
										qt_procedimento_w := qt_procedimento_w + r_C05_w.qt_proc;
									end if;
								else
									qt_procedimento_w := qt_procedimento_w + r_C05_w.qt_proc;
								end if;
							else
								qt_procedimento_w := qt_procedimento_w + r_C05_w.qt_proc;
							end if;
						else
							-- Caso o procedimento que esta sendo validado seja diferente do anterior, zera a quantidade do mesmo
							if (r_C05_w.cd_procedimento <> cd_procedimento_ant_w) or (r_C05_w.ie_origem_proced <> ie_origem_proced_ant_w) then
								qt_procedimento_w := 0;
							end if;

							-- Soma a quantidade do procedimento na variavel
							qt_procedimento_w := qt_procedimento_w + r_C05_w.qt_proc;
						end if;
						
						-- Caso tenha ultrapassado a quantidade maxima de correlacao
						if (qt_procedimento_w > qt_maxima_cor_w) then

							-- Concatena a variavel de observacao com o sequencial das contas proc que possuem o procedimento secundario
							ds_observacao_proc_ww := pls_util_pck.concatena_string(ds_observacao_proc_ww, r_C05_w.nr_seq_conta_proc);

							-- Concatena a variavel de observacao que sera lancada na ocorrencia
							ds_observacao_w := substr('O procedimento supera a quantidade maxima permitida para a regra de correlacao.' || pls_util_pck.enter_w ||
								'Procedimento referencia: ' || r_C01_w.cd_procedimento || ', qtd encontrada: ' || qt_proc_princ_w || pls_util_pck.enter_w ||
								'Qtd permitida para este codigo: ' || qt_maxima_cor_w || ' Qtd apresentada: ' || qt_procedimento_w || pls_util_pck.enter_w ||
								ds_observacao_cta_w || ds_observacao_cta_ww || pls_util_pck.enter_w ||
								ds_observacao_proc_w || ds_observacao_proc_ww,1,4000);

							-- Chama a procedure para gerar a ocorrencia dos itens
							insere_ocorrencia(	r_C05_w.nr_seq_conta_proc, nr_id_transacao_p, nm_usuario_p,
										ds_observacao_w, 'P');
						end if;
						-- Alimenta as variaveis de comparacao com o procedimento
						cd_procedimento_ant_w := r_C05_w.cd_procedimento;
						ie_origem_proced_ant_w := r_C05_w.ie_origem_proced;
						dt_procedimento_ant_w := r_C05_w.dt_procedimento;
						nr_seq_grau_partic_ant_w := nr_seq_grau_partic_ref_w;
					end loop;

					-- Inicia as variaveis de materiais
					nr_seq_material_ant_w	:= 0;
					qt_maxima_cor_w		:= 0;
					qt_material_w		:= 0;
					ds_observacao_mat_ww	:= '';

					-- Abre o cursor de materiais secundarios para o atendimento
					
					for r_C06_w in C06(nr_id_transacao_p, r_C03_w.cd_guia_ok, r_C03_w.nr_seq_segurado, r_C01_w.nr_seq_regra_correlacao)loop

						-- Seta a quantidade maxima de correlacao, esta e baseada

						-- na quantidade que o procedimento referencia foi apresentado
						if (coalesce(r_C01_w.ie_arredondar,'N') = 'S') then
						qt_maxima_cor_w	:= Round(r_C06_w.qt_maxima * qt_proc_princ_w);
						else
						qt_maxima_cor_w	:= r_C06_w.qt_maxima * qt_proc_princ_w;
						end if;							

						-- Caso o material que esta sendo validado seja diferente do anterior, zera a quantidade do mesmo
						if (r_C06_w.nr_seq_material <>  nr_seq_material_ant_w) then
							qt_material_w := 0;
						end if;

						-- Soma a quantidade do material na variavel
						qt_material_w := qt_material_w + r_C06_w.qt_mat;

						-- Caso tenha ultrapassado a quantidade maxima de correlacao
						
						if (qt_material_w > qt_maxima_cor_w ) then

							-- Concatena a variavel de observacao com o sequencial das contas proc que possuem o procedimento secundario
							ds_observacao_mat_ww := substr(pls_util_pck.concatena_string(ds_observacao_mat_ww, r_C06_w.nr_seq_conta_mat), 1, 255);
							
							-- Concatena a variavel de observacao que sera lancada na ocorrencia
							ds_observacao_w := 'O material supera a quantidade maxima permitida para a regra de correlacao.' || pls_util_pck.enter_w ||
									'Procedimento referencia: ' || r_C01_w.cd_procedimento || ', qtd encontrada: ' || qt_proc_princ_w || pls_util_pck.enter_w ||
									'Qtd permitida para o material ' || qt_maxima_cor_w || ' Qtd apresentada: ' || qt_material_w || pls_util_pck.enter_w ||
									ds_observacao_cta_w || ds_observacao_cta_ww || pls_util_pck.enter_w ||
									ds_observacao_mat_w || ds_observacao_mat_ww;

							-- Chama a procedure para gerar a ocorrencia dos itens
							insere_ocorrencia(	r_C06_w.nr_seq_conta_mat, nr_id_transacao_p, nm_usuario_p,
										ds_observacao_w, 'M');
						end if;
						-- Alimenta as variaveis de comparacao com o procedimento
						nr_seq_material_ant_w := r_C06_w.nr_seq_material;
					end loop;
				end if;
			end loop;
		end loop;
		-- seta os registros que serao validos ou invalidos apos o processamento
		CALL pls_tipos_ocor_pck.atualiza_campo_valido('V', nr_id_transacao_p, null, dados_regra_p);
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_oc_cta_tratar_val_57 ( dados_regra_p pls_tipos_ocor_pck.dados_regra, nr_id_transacao_p pls_oc_cta_selecao_ocor_v.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

