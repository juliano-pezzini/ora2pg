-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_conta_atual ON pls_conta CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_conta_atual() RETURNS trigger AS $BODY$
declare
nr_seq_guia_w			pls_guia_plano.nr_sequencia%type;
nr_seq_cong_prot_w		pls_protocolo_conta.nr_seq_congenere%type;
ie_situacao_prot_w		pls_protocolo_conta.ie_situacao%type;
dt_protocolo_w			pls_protocolo_conta.dt_protocolo%type;
dt_mes_competencia_w		pls_protocolo_conta.dt_mes_competencia%type;
ds_string_redundancia_w		pls_conta_proc.ds_redundancia%type;
ie_prestador_solic_util_w	pls_parametros.ie_prestador_solic_util%type;
nr_seq_congenere_sup_w		pls_congenere.nr_seq_congenere%type;
ds_log_call_w			pls_conta_log.ds_alteracao%type;
dt_atendimento_ref_bkp_w	pls_conta.dt_atendimento_referencia%type;
ie_desc_item_glosa_atend_w	pls_parametros.ie_desc_item_glosa_atend%type;
ie_origem_protocolo_w		pls_protocolo_conta.ie_origem_protocolo%type;
ie_tipo_protocolo_w			pls_protocolo_conta.ie_tipo_protocolo%type;
ie_status_prot_w 			pls_protocolo_conta.ie_status%type;
ie_tipo_guia_prot_w			pls_protocolo_conta.ie_tipo_guia%type;
ie_qt_contas_inf_prot_w		pls_protocolo_conta.qt_contas_informadas%type;
nm_usuario_nrec_prot_w		pls_protocolo_conta.nm_usuario_nrec%type;
dt_atual_nrec_prot_w		pls_protocolo_conta.dt_atualizacao_nrec%type;
count_user_params_w 	bigint;	
ie_data_tipo_segurado_w		pls_parametros.ie_data_tipo_segurado%type;
dt_recebimento_w		pls_protocolo_conta.dt_recebimento%type;
BEGIN
  BEGIN
if (coalesce(wheb_usuario_pck.get_ie_executar_trigger,'S') = 'S') then
	if (NEW.ie_status != OLD.ie_status) and (NEW.ie_origem_conta = 'Z') and (NEW.ie_status	not in ('F','S','C'))then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(250623);
	end if;
	
	ds_log_call_w := substr(pls_obter_detalhe_exec(false),1,1500);
	
	if (TG_OP = 'INSERT') then
		insert	into	plsprco_cta( 	nr_sequencia, dt_atualizacao, nm_usuario,
				dt_atualizacao_nrec, nm_usuario_nrec, nm_tabela, 
				ds_log, ds_log_call, ds_funcao_ativa, 
				ie_aplicacao_tasy, nm_maquina, ie_opcao,
				nr_seq_conta)
		values ( 	nextval('plsprco_cta_seq'), LOCALTIMESTAMP, substr(coalesce(wheb_usuario_pck.get_nm_usuario,'Usuario nao identificado '),1,14),
				LOCALTIMESTAMP, substr(coalesce(wheb_usuario_pck.get_nm_usuario,'Usuario nao identificado '),1,14), 'PLS_CONTA', 
				null, ds_log_call_w, obter_funcao_ativa, 
				pls_se_aplicacao_tasy, wheb_usuario_pck.get_machine, '1',
				NEW.nr_sequencia);
	end if;
	
	if (NEW.ie_status = 'F' AND OLD.ie_status !='F') then
		insert into pls_conta_log(nr_sequencia,dt_atualizacao, nm_usuario,
			dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_conta,
			nr_seq_conta_proc, nr_seq_conta_mat, nm_usuario_alteracao,
			dt_alteracao, ds_alteracao)
		values (nextval('pls_conta_log_seq'), LOCALTIMESTAMP, OLD.nm_usuario,
			LOCALTIMESTAMP, OLD.nm_usuario, NEW.nr_sequencia,
			null,  NULL, NEW.nm_usuario,
			LOCALTIMESTAMP, ds_log_call_w);
	end if;
	
	if (NEW.ie_status != 'F' AND OLD.ie_status ='F') then
		insert into pls_conta_log(nr_sequencia,dt_atualizacao, nm_usuario,
			dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_conta,
			nr_seq_conta_proc, nr_seq_conta_mat, nm_usuario_alteracao,
			dt_alteracao, ds_alteracao)
		values (nextval('pls_conta_log_seq'), LOCALTIMESTAMP, OLD.nm_usuario,
			LOCALTIMESTAMP, OLD.nm_usuario, NEW.nr_sequencia,
			null,  NULL, NEW.nm_usuario,
			LOCALTIMESTAMP, ds_log_call_w);
	end if;
	
	if (OLD.nr_seq_protocolo != NEW.nr_seq_protocolo) then
		ds_log_call_w := 'Conta tranferida do protocolo: ' || OLD.nr_seq_protocolo || ' para o protocolo: ' || NEW.nr_seq_protocolo || '.';
	
	select	max(b.ie_status),
			max(b.ie_situacao),
			max(b.ie_tipo_guia),
			max(b.qt_contas_informadas),
			max(b.nm_usuario_nrec),
			max(b.dt_atualizacao_nrec)
	  into STRICT	ie_status_prot_w,
			ie_situacao_prot_w,
			ie_tipo_guia_prot_w,
			ie_qt_contas_inf_prot_w,
			nm_usuario_nrec_prot_w,
			dt_atual_nrec_prot_w
	from	pls_protocolo_conta b
	where	b.nr_sequencia = NEW.nr_seq_protocolo;
	
	ds_log_call_w := ds_log_call_w || ' Proto. Novo: Status:' || ie_status_prot_w ||' Sit:' || ie_situacao_prot_w ||' Tp Guia:'|| ie_tipo_guia_prot_w
								   || ' Qt.Contas Infor:' || ie_qt_contas_inf_prot_w ||' User Criacao:' || nm_usuario_nrec_prot_w || ' Data Criacao: ' || dt_atual_nrec_prot_w;
								
	select	max(b.ie_status),
			max(b.ie_situacao),
			max(b.ie_tipo_guia),
			max(b.qt_contas_informadas),
			max(b.nm_usuario_nrec),
			max(b.dt_atualizacao_nrec)
	  into STRICT	ie_status_prot_w,
			ie_situacao_prot_w,
			ie_tipo_guia_prot_w,
			ie_qt_contas_inf_prot_w,
			nm_usuario_nrec_prot_w,
			dt_atual_nrec_prot_w
	from	pls_protocolo_conta b
	where	b.nr_sequencia = OLD.nr_seq_protocolo;
	
	ds_log_call_w := ds_log_call_w || ' Prot. Antigo: Status:' || ie_status_prot_w ||' Sit:' || ie_situacao_prot_w ||' Tp Guia:'|| ie_tipo_guia_prot_w
								   || ' Qt.Contas Infor:' || ie_qt_contas_inf_prot_w ||' User Criacao:' || nm_usuario_nrec_prot_w || ' Data Criacao: ' || dt_atual_nrec_prot_w;
								
	select count(1)
	  into STRICT count_user_params_w
	  from pls_web_param_usuario 
	 where cd_funcao = 1329 
	   and nr_seq_funcao_param = 9 
	   and vl_parametro = 'S';
	
	ds_log_call_w := ds_log_call_w || ' Qt. Param Ativo:' || count_user_params_w;
	
		ds_log_call_w := substr(ds_log_call_w || pls_util_pck.enter_w || dbms_utility.format_call_stack, 1, 2000);
		
		insert into pls_conta_log(nr_sequencia,dt_atualizacao, nm_usuario,
			dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_conta,
			nr_seq_conta_proc, nr_seq_conta_mat, nm_usuario_alteracao,
			dt_alteracao, ds_alteracao)
		values (nextval('pls_conta_log_seq'), LOCALTIMESTAMP, OLD.nm_usuario,
			LOCALTIMESTAMP, OLD.nm_usuario, NEW.nr_sequencia,
			null,  null, NEW.nm_usuario,
			LOCALTIMESTAMP, ds_log_call_w);
	end if;
	
	select	max(b.ie_situacao),
		max(b.nr_seq_congenere),
		max(b.dt_protocolo),
		max(b.dt_mes_competencia),
		max(b.ie_origem_protocolo),
		max(b.ie_tipo_protocolo),
		max(b.dt_recebimento)
	into STRICT	ie_situacao_prot_w,
		nr_seq_cong_prot_w,
		dt_protocolo_w,
		dt_mes_competencia_w,
		ie_origem_protocolo_w,
		ie_tipo_protocolo_w,
		dt_recebimento_w
	from	pls_protocolo_conta b
	where	b.nr_sequencia = NEW.nr_seq_protocolo;
	
	if	((OLD.nr_seq_protocolo is null AND NEW.nr_seq_protocolo is not null) or
		(OLD.ie_origem_conta is null AND NEW.ie_origem_conta is not null) or (NEW.ie_origem_conta <> OLD.ie_origem_conta)) and (ie_origem_protocolo_w <> NEW.ie_origem_conta) and (TG_OP = 'UPDATE') then
		ds_log_call_w := 'Conta com origem diferente da origem do protocolo. Origem da conta: ' || NEW.ie_origem_conta || '. Origem do protocolo: ' || ie_origem_protocolo_w;
		
		ds_log_call_w := substr(ds_log_call_w || pls_util_pck.enter_w || dbms_utility.format_call_stack, 1, 2000);
		
		insert into pls_conta_log(nr_sequencia,dt_atualizacao, nm_usuario,
			dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_conta,
			nr_seq_conta_proc, nr_seq_conta_mat, nm_usuario_alteracao,
			dt_alteracao, ds_alteracao)
		values (nextval('pls_conta_log_seq'), LOCALTIMESTAMP, coalesce(OLD.nm_usuario,coalesce(wheb_usuario_pck.get_nm_usuario,'Usuario nao identificado ')),
			LOCALTIMESTAMP, coalesce(OLD.nm_usuario, coalesce(wheb_usuario_pck.get_nm_usuario,'Usuario nao identificado ')), NEW.nr_sequencia,
			null,  null, coalesce(NEW.nm_usuario,coalesce(wheb_usuario_pck.get_nm_usuario,'Usuario nao identificado ')),
			LOCALTIMESTAMP, ds_log_call_w);	
	end if;
	
	if (TG_OP = 'INSERT') and (ie_tipo_protocolo_w = 'R') and (NEW.nr_seq_prest_inter is null) and (NEW.cd_pessoa_fisica is null) and (NEW.cd_cgc is null)then
		-- Favor informar a pessoa fisica ou pessoa juridica do documento na conta.

		CALL wheb_mensagem_pck.exibir_mensagem_abort(1023497);
	end if;
	
	if (OLD.ie_status <> NEW.ie_status) and (NEW.ie_status = 'A') and (ie_situacao_prot_w <> 'T') then
		
		ds_log_call_w := 'Conta em analise em protocolo nao integrado.';
		
		ds_log_call_w := substr(ds_log_call_w || pls_util_pck.enter_w || dbms_utility.format_call_stack, 1, 2000);
		
		insert into pls_conta_log(nr_sequencia,dt_atualizacao, nm_usuario,
			dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_conta,
			nr_seq_conta_proc, nr_seq_conta_mat, nm_usuario_alteracao,
			dt_alteracao, ds_alteracao)
		values (nextval('pls_conta_log_seq'), LOCALTIMESTAMP, OLD.nm_usuario,
			LOCALTIMESTAMP, OLD.nm_usuario, NEW.nr_sequencia,
			null,  null, NEW.nm_usuario,
			LOCALTIMESTAMP, ds_log_call_w);
	end if;
	
	--tratamento para buscar a data de referencia esta data deve ser utilizada em todas as regras do sistema

	if (NEW.dt_atendimento_referencia is null) or (NEW.dt_alta		!= OLD.dt_alta) or (NEW.dt_alta		is not null	and OLD.dt_alta is null) or (NEW.dt_emissao	is not null	and OLD.dt_emissao is null) or (NEW.dt_emissao	!= OLD.dt_emissao) or (NEW.dt_atendimento	!= OLD.dt_atendimento) or (NEW.dt_atendimento	is not null and  OLD.dt_atendimento is null) then
		
		select	coalesce(max(ie_desc_item_glosa_atend),'N')
		into STRICT	ie_desc_item_glosa_atend_w
		from	pls_parametros
		where	cd_estabelecimento = NEW.cd_estabelecimento;
		--faz um bkp pois em guias de consulta tava matando o valor e abaixa jogava jogava a data atual para a conta

		--abaixo e feito o tratamento para verificar se o :new.dt_atendimento_referencia ficou nulo e ajusta ele com o bkp amarzenado (***) .

		if (NEW.dt_atendimento_referencia is not null) then
			dt_atendimento_ref_bkp_w := NEW.dt_atendimento_referencia;
		end if;	
		
		--Se dt_alta estiver nulo, passa o dt_alta_imp. Isso corrigo uns problemas com vigencia de ocorrencia e validacao em guias de resumo no evento importacao

		NEW.dt_atendimento_referencia := pls_obter_dt_atendimento(NEW.nr_sequencia, NEW.ie_tipo_guia, coalesce(NEW.dt_alta, NEW.dt_alta_imp), NEW.dt_emissao, ie_desc_item_glosa_atend_w);	
		
		if (NEW.dt_atendimento	is null) then
			NEW.dt_atendimento	:= NEW.dt_atendimento_referencia;
		end if;
	end if;
	
	if ( NEW.dt_atendimento_referencia is null) then
		--(***) Se o  :new.dt_atendimento_referencia ficou nulo e o bkp tratado acima conseguiu guardar o valor anterior,  e ajustado o dt_atendimento_referencia

		if (dt_atendimento_ref_bkp_w is not null) then
			NEW.dt_atendimento_referencia := dt_atendimento_ref_bkp_w;
		--(***) nao conseguiu guardar o valor no tratamento acima e continua como era anteriormente e faz o tratamneot baixo	

		else
			NEW.dt_atendimento_referencia := coalesce(NEW.dt_atendimento,coalesce(NEW.dt_emissao, coalesce(NEW.dt_autorizacao, coalesce(NEW.dt_entrada, LOCALTIMESTAMP))));
		end if;	
	end if;
	--tratamento para buscar a data de referencia, quando da conta ainda nao estar integrada esta data deve ser utilizada em todas as regras do sistema que utilizem o campo imp

	if (NEW.dt_atendimento_imp_referencia	is null) then
		NEW.dt_atendimento_imp_referencia := pls_obter_dt_atendimento(NEW.nr_sequencia, NEW.ie_tipo_guia, NEW.dt_alta_imp, NEW.dt_emissao_imp);	
		
		if (NEW.dt_atendimento_imp is null) then
			NEW.dt_atendimento_imp	:= NEW.dt_atendimento_imp_referencia;
		end if;
	 end if;
	
	select	coalesce(max(ie_data_tipo_segurado),'A')
	into STRICT	ie_data_tipo_segurado_w
	from	pls_parametros
	where	cd_estabelecimento = NEW.cd_estabelecimento;
	
	if (ie_data_tipo_segurado_w = 'P') then
		NEW.ie_tipo_segurado := pls_obter_segurado_data(NEW.nr_seq_segurado, coalesce(coalesce(dt_recebimento_w,dt_mes_competencia_w),NEW.dt_atendimento_referencia));
	else
		NEW.ie_tipo_segurado := pls_obter_segurado_data(NEW.nr_seq_segurado, NEW.dt_atendimento_referencia);
	end if;

	-- performance

	if (NEW.ie_origem_conta <> 'E' or NEW.ie_origem_conta is null) then

		NEW.cd_guia_ok := coalesce(NEW.cd_guia_referencia, coalesce(NEW.cd_guia,NEW.cd_guia_prestador));
	else
		if (ie_situacao_prot_w in ('T','D')) then
		
			NEW.cd_guia_ok := coalesce(NEW.cd_guia_referencia, coalesce(NEW.cd_guia,NEW.cd_guia_prestador));
		else
			NEW.cd_guia_ok := coalesce(NEW.cd_guia_solic_imp,coalesce(NEW.cd_guia_imp,NEW.cd_guia_prestador_imp));
		end if;
	end if;

	/* Paulo - 11/09/2012 - Performance */


	BEGIN
	if (OLD.cd_guia is null) or (NEW.cd_guia <> OLD.cd_guia) or
		(OLD.cd_guia_pesquisa is null AND NEW.cd_guia is not null) then
		NEW.cd_guia_pesquisa	:= elimina_caracteres_especiais(coalesce(NEW.cd_guia,NEW.cd_guia_imp));
	end if;
	exception
	when others then
		NEW.cd_guia_pesquisa	:= null;
	end;

	/* Paulo - 11/09/2012 - Performance */


	BEGIN
	if (OLD.cd_guia_referencia is null) or (NEW.cd_guia_referencia <> OLD.cd_guia_referencia) or
		(OLD.cd_guia_ref_pesquisa is null AND NEW.cd_guia_referencia  is not null) then
		NEW.cd_guia_ref_pesquisa	:= elimina_caracteres_especiais(coalesce(NEW.cd_guia_referencia,NEW.cd_guia_solic_imp));
	end if;
	exception
	when others then
		NEW.cd_guia_ref_pesquisa	:= null;
	end;

	/* Paulo - 11/09/2012 - Performance */


	BEGIN
	if (OLD.cd_guia_prestador is null) or (NEW.cd_guia_prestador <> OLD.cd_guia_prestador) or
		(OLD.cd_guia_prest_pesquisa is null AND NEW.cd_guia_prestador  is not null) then
		NEW.cd_guia_prest_pesquisa	:= elimina_caracteres_especiais(NEW.cd_guia_prestador);
	end if;
	exception
	when others then
		NEW.cd_guia_prest_pesquisa	:= null;
	end;

	if (NEW.cd_guia_prestador is null) then
		NEW.cd_guia_prestador := NEW.cd_guia;
	end if;

	-- Comeca como nao tendo guia valida. Somente se encontrar uma guia valida que deve definir o NR_SEQ_GUIA.

	NEW.nr_seq_guia	:= null;
	
	NEW.nr_seq_guia	:= pls_conv_xml_cta_pck.obter_seq_guia_tasy(	NEW.ie_origem_conta, NEW.cd_guia,
										NEW.cd_guia_referencia, NEW.cd_guia_imp, 
										NEW.cd_guia_pesquisa, NEW.cd_guia_solic_imp,
										NEW.nr_seq_segurado, NEW.nr_sequencia, 
										nr_seq_cong_prot_w, NEW.cd_senha, 
										NEW.cd_senha_externa);
										
	if (NEW.nr_seq_guia is null) and (NEW.ie_origem_conta = 'C') and (TG_OP = 'INSERT') and (NEW.nr_seq_conta_princ is null) then
		ds_log_call_w := substr(	' Conta de complemento que nao identificou guia. ' || chr(13) ||chr(10)||
						' Funcao ativa : '|| obter_funcao_ativa || chr(13) ||chr(10)||
						' CallStack: '|| chr(13) || chr(10)|| dbms_utility.format_call_stack,1,1500);
						
		
		
		insert into pls_conta_log(nr_sequencia,dt_atualizacao, nm_usuario,
			dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_conta,
			nr_seq_conta_proc, nr_seq_conta_mat, nm_usuario_alteracao,
			dt_alteracao, ds_alteracao)
		values (nextval('pls_conta_log_seq'), LOCALTIMESTAMP, OLD.nm_usuario,
			LOCALTIMESTAMP, OLD.nm_usuario, NEW.nr_sequencia,
			null,  null, NEW.nm_usuario,
			LOCALTIMESTAMP, ds_log_call_w);
	end if;
	
	if (NEW.nr_seq_prestador_solic_ref is null) or (coalesce(NEW.nr_seq_guia,0) != coalesce(OLD.nr_seq_guia,0)) or (coalesce(NEW.nr_seq_prestador,0) != coalesce(OLD.nr_seq_prestador,0))then
		
		select	max(ie_prestador_solic_util)
		into STRICT	ie_prestador_solic_util_w
		from	table(pls_parametros_pck.f_retorna_param(NEW.cd_estabelecimento));
		
		if ( ie_prestador_solic_util_w	= 'R') then
			select	max(c.nr_seq_prestador)
			into STRICT	NEW.nr_seq_prestador_solic_ref
			from	pls_requisicao c,
				pls_execucao_req_item a
			where	a.nr_seq_requisicao	= c.nr_sequencia
			and	a.nr_seq_guia		= NEW.nr_seq_guia;
		end if;
		
		if (ie_prestador_solic_util_w	= 'G') or
			(ie_prestador_solic_util_w	= 'R' AND NEW.nr_seq_prestador_solic_ref	is null)then
			select	max(nr_seq_prestador)
			into STRICT	NEW.nr_seq_prestador_solic_ref
			from	pls_guia_plano
			where	nr_sequencia	= NEW.nr_seq_guia;
		end if;
		
		if (ie_prestador_solic_util_w		= 'C') or
			((ie_prestador_solic_util_w		in ('G','R')) and (NEW.nr_seq_prestador_solic_ref	is null)) then
			NEW.nr_seq_prestador_solic_ref	:= NEW.nr_seq_prestador;
		end if;
	end if;

	-- poderao ser feitas alteracoes sempre que o ie_tipo_conta for nulo ou diferente de D e sempre que o nr_seq_segurado mudar de valor

	-- esse tratamento nao inclui o ie_tipo_conta D porque o mesmo ja e inserido na importacao do arquivo e nao sofre alteracoes

	if	((NEW.ie_tipo_conta is null or coalesce(NEW.ie_tipo_conta, 'Z') != 'D') and (coalesce(NEW.nr_seq_segurado, 0) != coalesce(OLD.nr_seq_segurado, 0)) or
		 -- essa ultima condicao vai ser usada somente para atualizar todos os campos com o valor correto (sera feito um update para Y)

		 (NEW.ie_tipo_conta = 'Y')) then
		
		-- Se a origem da conta for de A500, e recebida de outras operadoras

		if (NEW.ie_origem_conta = 'A') then
			NEW.ie_tipo_conta	:= 'I';
			
		--Se o tipo de beneficiario for Usuario eventual (Resp. Assumida), Intercambio entre OPS congeneres (Resp. Assumida) ou 

		-- Intercambio entre cooperativas (Resp. Assumida) o tipo de conta e para ser faturado para outra operadora

		elsif (NEW.ie_tipo_segurado in ('H','I','C','T')) then
			NEW.ie_tipo_conta	:= 'C';
		else
			NEW.ie_tipo_conta	:= 'O';
		end if;
	end if;
	
	--pegar quando alguem setar nulo na analise ou algum processo fizer isso, como desfazer analise por exemplo

	if ( OLD.nr_seq_analise is not null and NEW.nr_seq_analise is null) then
	
		ds_log_call_w := substr(	' Desvinculada analise da conta. Funcao ativa : '|| obter_funcao_ativa || chr(13) ||chr(10)||
						' CallStack: '|| chr(13) || chr(10)|| dbms_utility.format_call_stack,1,1500);
		
		insert into pls_conta_log(nr_sequencia,dt_atualizacao, nm_usuario,
			dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_conta,
			nr_seq_conta_proc, nr_seq_conta_mat, nm_usuario_alteracao,
			dt_alteracao, ds_alteracao)
		values (nextval('pls_conta_log_seq'), LOCALTIMESTAMP, OLD.nm_usuario,
			LOCALTIMESTAMP, OLD.nm_usuario, NEW.nr_sequencia,
			null,  null, NEW.nm_usuario,
			LOCALTIMESTAMP, ds_log_call_w);
	
	end if;

	if (NEW.nr_seq_analise is not null) and (OLD.nr_seq_analise is null) and (ie_situacao_prot_w not in ('D', 'T')) then
		
		ds_log_call_w := substr(	' Conta com analise, porem ainda nao integrada. Funcao ativa : '|| obter_funcao_ativa || chr(13) ||chr(10)||
						' CallStack: '|| chr(13) || chr(10)|| dbms_utility.format_call_stack,1,1500);
		
		insert into pls_conta_log(nr_sequencia,dt_atualizacao, nm_usuario,
			dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_conta,
			nr_seq_conta_proc, nr_seq_conta_mat, nm_usuario_alteracao,
			dt_alteracao, ds_alteracao)
		values (nextval('pls_conta_log_seq'), LOCALTIMESTAMP, OLD.nm_usuario,
			LOCALTIMESTAMP, OLD.nm_usuario, NEW.nr_sequencia,
			null,  null, NEW.nm_usuario,
			LOCALTIMESTAMP, ds_log_call_w);
	end if;
	
	-- controle de redundancias para tratamento de procedimentos e materiais

	-- se for atualizacao somente, pois no insert ainda nao existem procedimentos ou materiais

	if (TG_OP = 'UPDATE') then
		
		-- se mudou alguma destas datas na conta significa que e necessario atualizar as redundancias que existem nos itens

		-- isso e feito por motivos de performance e principalmente para atender as regras de negocio de forma mais simples

		-- possibilita que exista no item a data correta do atendimento sem precisar efetuar calculos

		-- centraliza a regra de negocio da atualizacao dos itens na trigger dos itens

		if	((coalesce(NEW.nr_seq_prestador_exec, 0) != coalesce(OLD.nr_seq_prestador_exec, 0)) or (coalesce(NEW.dt_atendimento, to_date('31/12/1899', 'DD/MM/YYYY')) != coalesce(OLD.dt_atendimento, to_date('31/12/1899', 'DD/MM/YYYY'))) or (coalesce(NEW.dt_emissao, to_date('31/12/1899', 'DD/MM/YYYY')) != coalesce(OLD.dt_emissao, to_date('31/12/1899','DD/MM/YYYY'))) or (coalesce(NEW.dt_autorizacao, to_date('31/12/1899', 'DD/MM/YYYY')) != coalesce(OLD.dt_autorizacao, to_date('31/12/1899', 'DD/MM/YYYY'))) or (coalesce(NEW.dt_entrada, to_date('31/12/1899', 'DD/MM/YYYY')) != coalesce(OLD.dt_entrada, to_date('31/12/1899', 'DD/MM/YYYY'))) or (coalesce(NEW.dt_atendimento_imp, to_date('31/12/1899', 'DD/MM/YYYY')) != coalesce(OLD.dt_atendimento_imp, to_date('31/12/1899','DD/MM/YYYY')))) then
			
			-- seta para controlar para que partes das triggers dos itens nao rode

			pls_util_pck.get_ie_executar_redundancia_w := 'S';
			
			ds_string_redundancia_w := 'dt_atendimento_imp_referencia=' || to_char(NEW.dt_atendimento_imp_referencia) ||
						   ';dt_atendimento_referencia=' || to_char(NEW.dt_atendimento_referencia) ||
						   ';nr_seq_prestador_exec=' || to_char(NEW.nr_seq_prestador_exec) ||
						   ';dt_protocolo=' || to_char(dt_protocolo_w) ||
						   ';dt_mes_competencia=' || to_char(dt_mes_competencia_w);
			
			-- atualiza os procedimentos

			update	pls_conta_proc set
				ds_redundancia = ds_string_redundancia_w
			where	nr_seq_conta = NEW.nr_sequencia;
			
			-- atualiza os materiais

			update	pls_conta_mat set
				ds_redundancia = ds_string_redundancia_w
			where	nr_seq_conta = NEW.nr_sequencia;
			
			-- volta para o valor padrao

			pls_util_pck.get_ie_executar_redundancia_w := 'N';
		end if;
	end if;
end if;

  END;
RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_conta_atual() FROM PUBLIC;

CREATE TRIGGER pls_conta_atual
	BEFORE INSERT OR UPDATE ON pls_conta FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_conta_atual();
