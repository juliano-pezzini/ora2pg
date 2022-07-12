-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS proj_projeto_atual_wheb ON proj_projeto CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_proj_projeto_atual_wheb() RETURNS trigger AS $BODY$
declare
dt_ordem_servico_w		timestamp;
qt_historico_w			bigint;
qt_equipe_analise_w		bigint;
qt_equipe_solicitante_w		bigint;
qt_equipe_desenv_w		bigint;
ie_permissao_w			bigint;
qt_requisito_def_w		bigint;
qt_requisito_inc_w		bigint;
qt_requisito_nao_aprov_w	bigint;
qt_historico_envio_w		bigint;
qt_historico_req_w		bigint;
qt_historico_plano_w		bigint;
qt_cronograma_w			bigint;
qt_requisito_nao_atend_w	bigint;
qt_riscos_nao_encerrados_w	bigint;
qt_conteudo_ata_w		bigint;
nr_seq_proj_w			bigint;
nm_cadastro_w			varchar(255);
ie_email_nao_inform_w		varchar(15);
ie_ficha_projeto_w		varchar(1);
qt_historico_prog_w		bigint;
qt_anexo_w			bigint;
qt_ficha_proj_w			bigint;

BEGIN
if (NEW.ie_origem = 'D') and (NEW.dt_cancelamento is null) then /*Projetos de desenvolvimento*/

	BEGIN
	/* Consistencias de datas */


	if (trunc(NEW.dt_projeto) > trunc(NEW.dt_inicio_prev)) then
		/*'A data de inicio previsto (' || :new.dt_inicio_prev || ') tem que ser maior ou igual a data do 
projeto (' || 
					:new.dt_projeto || '). Projeto: ' || :new.nr_sequencia || ' #@#@');*/

		CALL wheb_mensagem_pck.exibir_mensagem_abort(209953,'DT_INICIO_PREV=' || NEW.dt_inicio_prev || ';' ||
								'DT_PROJETO=' || NEW.dt_projeto || ';' ||
								'NR_SEQUENCIA=' || NEW.nr_sequencia);
	end if;
	if (NEW.dt_inicio_prev > coalesce(NEW.dt_fim_prev,NEW.dt_inicio_prev)) then
		/*A data de inicio previsto tem que ser menor ou igual a data de termino previsto*/


		CALL wheb_mensagem_pck.exibir_mensagem_abort(209954);
	end if;
	if (NEW.dt_inicio_real > NEW.dt_fim_real) then
		/*A data de inicio real tem que ser menor ou igual a data de termino real*/


		CALL wheb_mensagem_pck.exibir_mensagem_abort(209955);
	end if;
	/*Atualizar fim previsto do projeto na ordem de sevico de origem*/


	if (NEW.DT_FIM_PREV is not null) then
		update man_ordem_servico
		set	dt_fim_previsto  = NEW.dt_fim_prev
		where	nr_sequencia = NEW.nr_seq_ordem_serv;
	end if;
	
	/*Garantir que seja o gerente quem cadastra o projeto*/


	if (TG_OP = 'INSERT') then
		select	count(*)
		into STRICT	ie_permissao_w
		from	usuario a
		where	a.nm_usuario		= NEW.nm_usuario
		and exists(	SELECT 1
					from  proj_permissao_cadastro b 
					where b.ie_situacao = 'A' 
					and	coalesce(b.ie_tipo,'A') in ('C','A') 
					and (b.nm_usuario_perm = a.nm_usuario 
					or b.cd_cargo_perm = (	select cd_cargo 
								from pessoa_fisica c 
								where c.cd_pessoa_fisica = a.cd_pessoa_fisica)));
		if (ie_permissao_w = 0) then
					
			/*Voce nao possui permissao para cadastrar projetos no sistesma, conforme cadastro geral "#@nome_cadastro#@".*/


			
			select obter_desc_expressao((select CD_EXP_CADASTRO
			from tabela_sistema where nm_tabela = 'PROJ_PERMISSAO_CADASTRO'), 'Permissao cadastro de projetos')
			into STRICT nm_cadastro_w
			;
		
			CALL wheb_mensagem_pck.exibir_mensagem_abort(745374, 'NOME_CADASTRO=' || nm_cadastro_w || '''');
		end if;
	end if;
	
	if (NEW.NR_SEQ_CLASSIF 	<> 45) then
	
		/* Garantir estudo de viabilidade e vinculo com OS com data correta */


		if (NEW.nr_seq_ordem_serv is not null) and (OLD.nr_seq_ordem_serv is null) then
			select	dt_ordem_servico
			into STRICT	dt_ordem_servico_w
			from	man_ordem_servico
			where	nr_sequencia	= NEW.nr_seq_ordem_serv;
			if (trunc(dt_ordem_servico_w,'dd') > NEW.dt_projeto) then
				/*A data da ordem de servico que deu origem ao projeto deve ser inferior a data do projeto*/


				CALL wheb_mensagem_pck.exibir_mensagem_abort(209958);
			end if;
			if (NEW.nr_seq_classif <> 14) then
				BEGIN
				select	count(*)
				into STRICT	qt_historico_w
				from	man_ordem_serv_tecnico
				where	nr_seq_tipo	= 21 /*Historico do tipo Estudo de viabilidade*/

				and	nr_seq_ordem_serv = NEW.nr_seq_ordem_serv
				and	dt_liberacao is not null;
				if (qt_historico_w = 0) then
					/*Para que uma OS gere um projeto a mesma deve possuir um historico do tipo Estudo de 
	viabilidade liberado*/

					CALL wheb_mensagem_pck.exibir_mensagem_abort(209959);
				end if;
				end;
			end if;
		end if;
	
	end if;
	
	if (NEW.NR_SEQ_CLASSIF 	<> 45) then
	
		if (NEW.nr_seq_estagio = 20) and /*Levantamento dos requisitos*/

			(OLD.nr_seq_estagio = 1) then
			select	count(*)
			into STRICT	qt_equipe_analise_w
			from	proj_equipe_papel b,
				proj_equipe a
			where	a.nr_sequencia	= b.nr_seq_equipe
			and	a.nr_seq_proj	= NEW.nr_sequencia
			and	a.nr_seq_equipe_funcao	= 10; /*Equipe de analise*/

			if (qt_equipe_analise_w = 0) then
				/*O projeto precisa ter equipe de analise definida. Verificar com o Gerente*/


				CALL wheb_mensagem_pck.exibir_mensagem_abort(209960);
			end if;
			select	count(*)
			into STRICT	qt_equipe_solicitante_w
			from	proj_equipe_papel b,
				proj_equipe a
			where	a.nr_sequencia	= b.nr_seq_equipe
			and	a.nr_seq_proj	= NEW.nr_sequencia
			and	a.nr_seq_equipe_funcao	= 13; /*Equipe do solicitante*/

			if (qt_equipe_solicitante_w = 0) then
				/*O projeto precisa ter equipe do solicitante definida. Verificar com o Gerente.#@#@');*/


				CALL wheb_mensagem_pck.exibir_mensagem_abort(209961);
			end if;
			select	CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END
			into STRICT	ie_email_nao_inform_w
			from	proj_equipe_papel b,
				proj_equipe a
			where	a.nr_sequencia	= b.nr_seq_equipe
			and	a.nr_seq_proj	= NEW.nr_sequencia
			and	b.ds_email is null
			and	b.nr_seq_funcao is not null;

			if (ie_email_nao_inform_w = 'S') then
				/*Devem ser informados os e-mails de todos os integrantes das equipes*/


				CALL wheb_mensagem_pck.exibir_mensagem_abort(983988);
			end if;
		end if;
	
	end if;
	if (NEW.nr_seq_estagio = 2) and /*Requisito definido*/

		(OLD.nr_seq_estagio = 20) then
		select	count(*)
		into STRICT	qt_requisito_def_w
		from	des_requisito_item b,
			des_requisito a
		where	a.nr_seq_projeto	= NEW.nr_sequencia
		and	a.nr_sequencia		= b.nr_seq_requisito;
		if (qt_requisito_def_w = 0) then
			/*'O projeto precisa ter os requisitos definidos.#@#@');*/


			CALL wheb_mensagem_pck.exibir_mensagem_abort(209962);
		end if;
		select	count(*)
		into STRICT	qt_requisito_inc_w
		from	des_requisito_item b,
			des_requisito a
		where	a.nr_seq_projeto	= NEW.nr_sequencia
		and	a.nr_sequencia		= b.nr_seq_requisito
		and	((b.ie_status is null) or (b.ie_tipo_requisito is null));
		if (qt_requisito_inc_w > 0) then
			/*Existem requisitos sem status ou sem tipo definido.#@#@');*/


			CALL wheb_mensagem_pck.exibir_mensagem_abort(209963);
		end if;
	end if;
	if (NEW.NR_SEQ_CLASSIF 	<> 45) then
		if (NEW.nr_seq_estagio = 4) and /*Aguardando aprov. requisito*/

			(OLD.nr_seq_estagio = 3) then
			select	count(*)
			into STRICT	qt_historico_envio_w
			from	com_cliente_hist
			where	nr_seq_projeto	= NEW.nr_sequencia
			and	dt_liberacao is not null
			and	nr_seq_tipo	= 12;
			if (qt_historico_envio_w = 0) then
				/*O projeto precisa ter um historico de envio dos requisitos para aprovacao do cliente.#@#@');*/


				CALL wheb_mensagem_pck.exibir_mensagem_abort(209964);
			end if;
		end if;
		
	end if;
	
	
	if (NEW.nr_seq_estagio = 5) and /*Requisito aprovado*/

		(OLD.nr_seq_estagio = 4) then
		select	count(*)
		into STRICT	qt_requisito_nao_aprov_w
		from	des_requisito
		where	nr_seq_projeto	= NEW.nr_sequencia
		and	dt_aprovacao is null;
		if (qt_requisito_nao_aprov_w > 0) then
			/*'O projeto possui requisitos nao aprovados.#@#@');*/


			CALL wheb_mensagem_pck.exibir_mensagem_abort(209965);
		end if;
		if (NEW.NR_SEQ_CLASSIF 	<> 45) then
			select	count(*)
			into STRICT	qt_historico_req_w
			from	com_cliente_hist
			where	nr_seq_projeto	= NEW.nr_sequencia
			and	dt_liberacao is not null
			and	nr_seq_tipo	= 13;
			if (qt_historico_req_w = 0) then
				/*O projeto precisa ter um historico de requisitos aprovados pelo cliente.#@#@');*/


				CALL wheb_mensagem_pck.exibir_mensagem_abort(209966);
			end if;
			
		end if;
		
	end if;
	
	if (NEW.NR_SEQ_CLASSIF 	<> 45) then
		if (NEW.nr_seq_estagio = 8) and /*Aguardando aprovacao do plano*/

			(OLD.nr_seq_estagio = 7) then
			select	count(*)
			into STRICT	qt_equipe_desenv_w
			from	proj_equipe_papel b,
				proj_equipe a
			where	a.nr_sequencia	= b.nr_seq_equipe
			and	a.nr_seq_proj	= NEW.nr_sequencia
			and	a.nr_seq_equipe_funcao in (11, 20); /*Equipe de desenvolvimento*/

			if (qt_equipe_desenv_w = 0) then
				/*O projeto precisa ter equipe de desenvolvimento definida. Verificar com o Gerente.#@#@');*/


				CALL wheb_mensagem_pck.exibir_mensagem_abort(209967);
			end if;
			
			select	CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END
			into STRICT	ie_email_nao_inform_w
			from	proj_equipe_papel b,
				proj_equipe a
			where	a.nr_sequencia	= b.nr_seq_equipe
			and	a.nr_seq_proj	= NEW.nr_sequencia
			and	b.nr_seq_funcao is not null
			and	b.ds_email is null;
			
			if (ie_email_nao_inform_w = 'S') then
			/*Devem ser informados os e-mails de todos os integrantes das equipes*/


				CALL wheb_mensagem_pck.exibir_mensagem_abort(983988);
			end if;
			
			select	count(*)
			into STRICT	qt_historico_plano_w
			from	com_cliente_hist
			where	nr_seq_projeto	= NEW.nr_sequencia
			and	dt_liberacao is not null
			and	nr_seq_tipo	= 14;
			if (qt_historico_plano_w = 0) then
				/*'O projeto precisa ter um historico de envio do plano para aprovacao do solicitante.#@#@');*/


				CALL wheb_mensagem_pck.exibir_mensagem_abort(209971);
			end if;
			select	count(*)
			into STRICT	qt_historico_plano_w
			from	pessoa_fisica p,
				com_cliente_hist a,
				usuario u
			where	a.nr_seq_projeto	= NEW.nr_sequencia
			and	a.cd_profissional	= p.cd_pessoa_fisica
			and	u.CD_PESSOA_FISICA	= p.cd_pessoa_fisica
			and	a.dt_liberacao is not null
			and	a.nr_seq_tipo	= 16
			and 	exists (	SELECT 	1
					from 	proj_permissao_cadastro b 
					where 	b.ie_situacao = 'A' 
					and	coalesce(b.ie_tipo,'A') in ('P','A') 
					and (b.nm_usuario_perm = u.nm_usuario or b.cd_cargo_perm = p.cd_cargo));
	
				
			if (qt_historico_plano_w = 0) then
				/*O projeto precisa ter um historico de aprovacao interna do plano pelo gerente 
	operacional.#@#@');*/

				CALL wheb_mensagem_pck.exibir_mensagem_abort(209972);
			end if;
			select	count(*)
			into STRICT	qt_cronograma_w
			from	proj_cronograma
			where	nr_seq_proj		= NEW.nr_sequencia
			and	ie_tipo_cronograma	= 'E'
			and	ie_situacao 		= 'A'
			and	coalesce(IE_CLASSIFICACAO, 'D')	= 'D';
			if (qt_cronograma_w = 0) then
				/*O projeto precisa ter um cronograma de execucao.#@#@');*/


				CALL wheb_mensagem_pck.exibir_mensagem_abort(209973);
			end if;	
		end if;
		
		
		if (NEW.nr_seq_estagio = 9) and /*Plano aprovado*/

			(OLD.nr_seq_estagio = 8) then
			select	count(*)
			into STRICT	qt_cronograma_w
			from	proj_cronograma
			where	nr_seq_proj		= NEW.nr_sequencia
			and	ie_tipo_cronograma	= 'E'
			and	ie_situacao 		= 'A'
			and	IE_CLASSIFICACAO	= 'D'
			and	dt_aprovacao is null;
			if (qt_cronograma_w > 0) then
				/*O projeto precisa ter um cronograma de execucao com data de aprovacao informada.#@#@');*/


				CALL wheb_mensagem_pck.exibir_mensagem_abort(209974);
			end if;
			select	count(*)
			into STRICT	qt_historico_plano_w
			from	com_cliente_hist
			where	nr_seq_projeto	= NEW.nr_sequencia
			and	dt_liberacao is not null
			and	nr_seq_tipo	= 15;
			if (qt_historico_plano_w = 0) then
				/*O projeto precisa ter um historico de aprovacao do plano pelo solicitante.#@#@');*/


				CALL wheb_mensagem_pck.exibir_mensagem_abort(209975);
			end if;	
		end if;


		if (OLD.nr_seq_estagio = 10) /*Reuniao de Implementacao */
 and (NEW.nr_seq_estagio = 42) /*Aguardando Inicio Execucao */
 then
			/*Reuniao de implementacao*/


			select	count(*)
			into STRICT	qt_historico_plano_w
			from	com_cliente_hist
			where	nr_seq_projeto	= NEW.nr_sequencia
			and	dt_liberacao is not null
			and	nr_seq_tipo	= 27;
			if (qt_historico_plano_w = 0 ) then
				/*'O projeto precisa ter uma ata de Reuniao de Implementacao com a equipe*/


				CALL wheb_mensagem_pck.exibir_mensagem_abort(209952);
			end if;
		end if;
	
	end if;
	if (NEW.nr_seq_estagio = 12) and /*Programacao*/

		(OLD.nr_seq_estagio <> 12) then
		if (NEW.dt_fim_prev is null) then
			/*Projetos em programacao devem possuir a data de fim previsto informada.#@#@');*/


			CALL wheb_mensagem_pck.exibir_mensagem_abort(209976);
		end if;

		if (NEW.nr_seq_proj_sup is null) then

			select	count(1)
			into STRICT	qt_historico_prog_w
			from	com_cliente_hist
			where	nr_seq_projeto = NEW.nr_sequencia
			and	dt_liberacao is not null
			and	nr_seq_tipo = 55; -- Ausencia de modelagem de dados e objetos

			if (qt_historico_prog_w = 0) then

				select	count(1)
				into STRICT	qt_historico_prog_w
				from	com_cliente_hist
				where	nr_seq_projeto = NEW.nr_sequencia
				and	dt_liberacao is not null
				and	nr_seq_tipo = 54; -- Aprovacao de Modelagem de dados

				select	count(1)
				into STRICT	qt_anexo_w
				from	proj_documento
				where	nr_seq_proj = NEW.nr_sequencia
				and	nr_seq_tipo_documento = 23; -- Modelo de dados

				if (qt_historico_prog_w = 0 or qt_anexo_w = 0) then
					/* Para avancar para o estagio "Programacao", e necessario que exista um documento com o tipo "Modelagem de dados" e um historico do tipo "Aprovacao de modelagem de dados" ou um historico 
					do tipo "Ausencia de modelagem de dados e objetos" */

					CALL wheb_mensagem_pck.exibir_mensagem_abort(1029792);
				end if;
			end if;
		end if;
	end if;
	if (NEW.nr_seq_estagio = 17) and /*Teste no Cliente*/

		(OLD.nr_seq_estagio <> 17) then
		SELECT  COUNT(*)
		into STRICT	qt_requisito_nao_atend_w
		FROM   	DES_REQUISITO a,
		 	DES_REQUISITO_item b
		WHERE   a.nr_sequencia = b.nr_seq_requisito
		AND	b.ie_status = 'N'
		AND	a.nr_seq_projeto = NEW.nr_sequencia
		/* Francisco - 07/08/2013 - Considerar apenas requisitos nossos, sao estes que o cliente aprova */


		and	a.ie_cliente_wheb = 'W';
		if (qt_requisito_nao_atend_w > 0 ) then
			/*Para colocar o projeto em teste no cliente nao podem existir requisitos nao 
atendidos.#@#@');*/

			CALL wheb_mensagem_pck.exibir_mensagem_abort(209977);
		end if;

		NEW.dt_teste_cliente := LOCALTIMESTAMP;
	end if;
	if (NEW.nr_seq_estagio = 16) and /*Encerramento*/

		(OLD.nr_seq_estagio <> 16) then
		select  count(*)
		into STRICT	qt_riscos_nao_encerrados_w
		from   	proj_risco_implantacao
		where   nr_seq_proj = NEW.nr_sequencia
		and	dt_fim_real is null;
		if (qt_riscos_nao_encerrados_w > 0 ) then
			/* Nao e permitido encerrar o projeto se todos os riscos nao estiverem encerrados.#@#@');*/


			CALL wheb_mensagem_pck.exibir_mensagem_abort(241326);
		end if;
	end if;
	if (NEW.IE_STATUS  = 'E') and /*Desenvolvimento e Implementacao*/

		(NEW.dt_fim_prev is null) then		
			/* Nao permitir que um projeto tenha seu status alterado para Desenvolvimento e Implementacao caso nao possua um Termino previsto*/


			CALL wheb_mensagem_pck.exibir_mensagem_abort(243490);
	end if;	

	if (OLD.IE_STATUS  <> 'F') and (NEW.IE_STATUS  = 'F') then

		select	count(1)
		into STRICT	qt_ficha_proj_w
		from	proj_ficha_projeto b
		where	NEW.nr_sequencia = b.nr_seq_projeto
		and	dt_liberacao is not null;

		select	max(
					case	when	NEW.nr_seq_classif = 45
						or	qt_ficha_proj_w >= 1 then
							'N'
						else
							'S'
					end
				)
		into STRICT	ie_ficha_projeto_w
		;

		if (ie_ficha_projeto_w = 'S') then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(1012262);			
		end if;
	end if;
	
	if (OLD.IE_STATUS  = 'E') and (NEW.IE_STATUS  = 'P') then
		NEW.dt_inicio_real := null;
	end if;	

	/*OS*/


	if (NEW.IE_STATUS = 'E') then
		NEW.IE_PLANEJ_ESTRATEG := 'E'; /*Execucao*/


		select	max(nr_seq_proj)
		into STRICT	nr_seq_proj_w
		from	proj_cronograma
		where	nr_seq_proj = NEW.nr_sequencia
		and	dt_aprovacao is not null
		and	ie_situacao = 'A';

		if (nr_seq_proj_w is not null) and (NEW.nr_seq_estagio = 12) then
			update	proj_cronograma
			set	dt_inicio_real = LOCALTIMESTAMP
			where	nr_seq_proj = nr_seq_proj_w
			and	dt_inicio_real is null
			and	ie_classificacao = 'D'
			and	ie_situacao = 'A';
		end if;

		if (NEW.nr_seq_estagio = 12) and (NEW.dt_inicio_real is null) then
			NEW.dt_inicio_real := LOCALTIMESTAMP;
		end if;
		
		if (NEW.IE_STATUS_GANT is null ) then
			NEW.ie_status_gant := 1; /*Verde*/

		end if;
	end if;
	
	if (NEW.ie_status = 'F') and (NEW.dt_fim_real is null) then
		NEW.dt_fim_real	:= LOCALTIMESTAMP;
	end if;
	end;
end if;
RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_proj_projeto_atual_wheb() FROM PUBLIC;

CREATE TRIGGER proj_projeto_atual_wheb
	BEFORE INSERT OR UPDATE ON proj_projeto FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_proj_projeto_atual_wheb();

