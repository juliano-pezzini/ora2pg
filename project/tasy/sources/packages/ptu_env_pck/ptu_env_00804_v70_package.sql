-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

--------------------------------------------------------------------------------00804 Autorizacao de Ordem de Servico----------------------------------------------------------------------------------------------------------------------------------------------------------------



CREATE OR REPLACE PROCEDURE ptu_env_pck.ptu_env_00804_v70 ( nr_seq_guia_p pls_guia_plano.nr_sequencia%type, nr_seq_requisicao_p pls_requisicao.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_aut_ordem_serv_p INOUT ptu_autorizacao_ordem_serv.nr_sequencia%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Gerar o pedido de autorizacao da ordem de servico

Rotina utilizada nas transacoes ptu via scs homologadas com a unimed brasil.
quando for alterar, favor verificar com o analista responsavel para a realizacao de testes.
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta:
[  ]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:Performance.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


ie_tipo_cliente_w			ptu_requisicao_ordem_serv.ie_tipo_cliente%type;
cd_unimed_executora_w			ptu_requisicao_ordem_serv.cd_unimed_executora%type;
cd_unimed_beneficiario_w		ptu_requisicao_ordem_serv.cd_unimed_beneficiario%type;
dt_validade_w				ptu_requisicao_ordem_serv.dt_validade%type;
cd_unimed_solicitante_w			ptu_requisicao_ordem_serv.cd_unimed_solicitante%type;
nr_transacao_solicitante_w		ptu_requisicao_ordem_serv.nr_transacao_solicitante%type;
nr_seq_origem_w				ptu_resposta_autorizacao.nr_seq_origem%type;
ds_observacao_w				ptu_requisicao_ordem_serv.ds_observacao%type;
nr_seq_execucao_w			ptu_resposta_req_ord_serv.nr_seq_execucao%type;
nr_seq_resp_autorizacao_w		ptu_resposta_autorizacao.nr_sequencia%type;
nr_seq_resp_auditoria_w			ptu_resposta_auditoria.nr_sequencia%type;
qt_registros_w				integer;

ds_servico_w				ptu_resposta_aut_servico.ds_servico%type;
qt_registro_w				integer;

C01 CURSOR FOR
	SELECT	ie_tipo_tabela,
		cd_servico,
		ie_origem_servico,
		ds_servico,
		ie_autorizado,
		qt_autorizado,
		nr_seq_guia_mat,
		nr_seq_guia_proc,
		nr_seq_req_mat,
		nr_seq_req_proc,
		nr_seq_item
	from	ptu_resposta_aut_servico
	where	nr_seq_pedido	= nr_seq_resp_autorizacao_w;

C02 CURSOR FOR
	SELECT	ie_tipo_tabela,
		cd_servico,
		ie_origem_servico,
		ds_servico,
		ie_autorizado,
		qt_autorizado,
		nr_seq_guia_mat,
		nr_seq_guia_proc,
		nr_seq_req_mat,
		nr_seq_req_proc,
		nr_seq_item
	from	ptu_resp_auditoria_servico
	where	nr_seq_auditoria	= nr_seq_resp_auditoria_w;

BEGIN

if (nr_seq_requisicao_p	<> 0) then
	select	count(1)
	into STRICT	qt_registros_w
	from	ptu_autorizacao_ordem_serv
	where	nr_seq_requisicao	= nr_seq_requisicao_p;

	if (qt_registros_w	> 0) then
		select	max(nr_sequencia)
		into STRICT	nr_seq_aut_ordem_serv_p
		from	ptu_autorizacao_ordem_serv
		where	nr_seq_requisicao = nr_seq_requisicao_p;

		goto final;
	end if;

	begin
	-- Buscar as informacoes referentes a Ordem de Servico gerada pela Unimed Solicitante

		select	ie_tipo_cliente,
			cd_unimed_executora,
			cd_unimed_beneficiario,
			dt_validade,
			cd_unimed_solicitante,
			nr_transacao_solicitante,
			ds_observacao
		into STRICT	ie_tipo_cliente_w,
			cd_unimed_executora_w,
			cd_unimed_beneficiario_w,
			dt_validade_w,
			cd_unimed_solicitante_w,
			nr_transacao_solicitante_w,
			ds_observacao_w
		from	ptu_requisicao_ordem_serv
		where	nr_seq_requisicao	= nr_seq_requisicao_p;
	exception
	when others then
		-- Nao e possivel enviar a Autorizacao de Ordem de Servico que nao possui uma Solicitacao de Ordem de Servico.

		CALL wheb_mensagem_pck.exibir_mensagem_abort(289785);
	end;

	begin
	-- Buscar as informacoes referentes a Resposta da Ordem de Servico gerada pela Unimed Solicitante

		select	nr_seq_execucao
		into STRICT 	nr_seq_execucao_w
		from	ptu_resposta_req_ord_serv
		where	nr_seq_origem		= nr_transacao_solicitante_w
		and 	cd_unimed_solicitante	= cd_unimed_solicitante_w;
	exception
	when others then
		-- Nao e possivel enviar a Autorizacao de Ordem de Servico que nao possui uma Resposta de Solicitacao da Ordem de Servico.

		CALL wheb_mensagem_pck.exibir_mensagem_abort(289787);
	end;


	select	max(nr_sequencia)
	into STRICT	nr_seq_resp_auditoria_w
	from	ptu_resposta_auditoria
	where	nr_seq_requisicao	= nr_seq_requisicao_p;

	if (coalesce(nr_seq_resp_auditoria_w::text, '') = '') then
		select	max(nr_sequencia)
		into STRICT	nr_seq_resp_autorizacao_w
		from	ptu_resposta_autorizacao
		where	nr_seq_requisicao	= nr_seq_requisicao_p;

		if (nr_seq_resp_autorizacao_w IS NOT NULL AND nr_seq_resp_autorizacao_w::text <> '') then
			select	nr_seq_origem
			into STRICT	nr_seq_origem_w
			from	ptu_resposta_autorizacao
			where	nr_sequencia	= nr_seq_resp_autorizacao_w;
		else
			-- Nao e possivel enviar uma Autorizacao de Ordem de Servico sem ter recebido uma Resposta de Pedido de Autorizacao.

			CALL wheb_mensagem_pck.exibir_mensagem_abort(289788);
		end if;
	else
		select	nr_seq_origem
		into STRICT	nr_seq_origem_w
		from	ptu_resposta_auditoria
		where	nr_sequencia	= nr_seq_resp_auditoria_w;
	end if;
elsif (nr_seq_guia_p	<> 0) then
	select	count(1)
	into STRICT	qt_registros_w
	from	ptu_autorizacao_ordem_serv
	where	nr_seq_guia	= nr_seq_guia_p;

	if (qt_registros_w	> 0) then
		select	max(nr_sequencia)
		into STRICT	nr_seq_aut_ordem_serv_p
		from	ptu_autorizacao_ordem_serv
		where	nr_seq_guia	= nr_seq_guia_p;

		goto final;
	end if;

	begin
	-- Buscar as informacoes referentes a Ordem de Servico gerada pela Unimed Solicitante

		select	ie_tipo_cliente,
			cd_unimed_executora,
			cd_unimed_beneficiario,
			dt_validade,
			cd_unimed_solicitante,
			nr_transacao_solicitante,
			ds_observacao
		into STRICT	ie_tipo_cliente_w,
			cd_unimed_executora_w,
			cd_unimed_beneficiario_w,
			dt_validade_w,
			cd_unimed_solicitante_w,
			nr_transacao_solicitante_w,
			ds_observacao_w
		from	ptu_requisicao_ordem_serv
		where	nr_seq_guia	= nr_seq_guia_p;
	exception
	when others then
		-- Nao e possivel enviar uma Autorizacao de Ordem de Servico que nao possui uma Solicitacao de Ordem de Servico.

		CALL wheb_mensagem_pck.exibir_mensagem_abort(289785);
	end;

	begin
	-- Buscar as informacoes referentes a Resposta da Ordem de Servico gerada pela Unimed Solicitante

		select	nr_seq_execucao
		into STRICT 	nr_seq_execucao_w
		from	ptu_resposta_req_ord_serv
		where	nr_seq_origem		= nr_transacao_solicitante_w
		and 	cd_unimed_solicitante	= cd_unimed_solicitante_w;
	exception
	when others then
		-- Nao e possivel enviar uma Autorizacao de Ordem de Servico que nao possui uma Resposta de Solicitacao de Ordem de Servico.

		CALL wheb_mensagem_pck.exibir_mensagem_abort(289787);
	end;

	select	max(nr_sequencia)
	into STRICT	nr_seq_resp_auditoria_w
	from	ptu_resposta_auditoria
	where	nr_seq_guia	= nr_seq_guia_p;

	if (coalesce(nr_seq_resp_auditoria_w::text, '') = '') then
		select	max(nr_sequencia)
		into STRICT	nr_seq_resp_autorizacao_w
		from	ptu_resposta_autorizacao
		where	nr_seq_guia	= nr_seq_guia_p;

		if (nr_seq_resp_autorizacao_w IS NOT NULL AND nr_seq_resp_autorizacao_w::text <> '') then
			select	nr_seq_origem
			into STRICT	nr_seq_origem_w
			from	ptu_resposta_autorizacao
			where	nr_sequencia	= nr_seq_resp_autorizacao_w;
		else
			-- Nao e possivel enviar uma Autorizacao de Ordem de Servico sem ter recebido uma Resposta de Pedido de Autorizacao.

			CALL wheb_mensagem_pck.exibir_mensagem_abort(289788);
		end if;
	else
		select	nr_seq_origem
		into STRICT	nr_seq_origem_w
		from	ptu_resposta_auditoria
		where	nr_sequencia	= nr_seq_resp_auditoria_w;
	end if;
end if;

if	((nr_seq_guia_p	<> 0) or (nr_seq_requisicao_p	<> 0)) then
	insert into ptu_autorizacao_ordem_serv(nr_sequencia, dt_atualizacao, nm_usuario,
		 dt_atualizacao_nrec, nm_usuario_nrec, cd_transacao,
		 ie_tipo_cliente, cd_unimed_executora, cd_unimed_beneficiario,
		 nr_seq_execucao, nr_seq_origem, dt_validade,
		 nr_seq_requisicao, nr_seq_guia, ds_arquivo_pedido,
		 nr_transacao_solicitante, cd_unimed_solicitante, nr_versao,
		 ds_mensagem)
	values (nextval('ptu_autorizacao_ordem_serv_seq'), clock_timestamp(), nm_usuario_p,
		 clock_timestamp(), nm_usuario_p, '00804',
		 ie_tipo_cliente_w, cd_unimed_executora_w, cd_unimed_beneficiario_w,
		 nr_seq_execucao_w, nr_seq_origem_w, dt_validade_w,
		 CASE WHEN nr_seq_requisicao_p=0 THEN null  ELSE nr_seq_requisicao_p END , CASE WHEN nr_seq_guia_p=0 THEN null  ELSE nr_seq_guia_p END , '',
		 nr_transacao_solicitante_w, cd_unimed_solicitante_w, pls_obter_versao_scs,
		 ds_observacao_w) returning nr_sequencia into nr_seq_aut_ordem_serv_p;

	if (nr_seq_resp_autorizacao_w IS NOT NULL AND nr_seq_resp_autorizacao_w::text <> '') then
		for	r_c01_w	in c01	loop
			if (pls_obter_versao_scs = '090') then
				select	count(1)
				into STRICT	qt_registro_w
				from	pls_regra_generico_ptu
				where 	cd_proc_mat_generico	= r_c01_w.cd_servico
				and	ie_situacao		= 'A';

				if (qt_registro_w > 0) then
					if (coalesce(r_c01_w.ds_servico,'X')	= 'X') then
						CALL wheb_mensagem_pck.exibir_mensagem_abort(216706);
					else
						ds_servico_w	:= r_c01_w.ds_servico;
					end if;
				else
					ds_servico_w	:= '';
				end if;
			else
				ds_servico_w := r_c01_w.ds_servico;
			end if;

			insert into ptu_aut_ordem_serv_servico(nr_sequencia, ie_tipo_tabela, cd_servico,
				 ie_origem_servico, ds_servico, ie_autorizado,
				 dt_atualizacao, nm_usuario, dt_atualizacao_nrec,
				 nm_usuario_nrec, qt_autorizado, nr_seq_aut_ord_serv,
				 nr_seq_guia_mat, nr_seq_guia_proc, nr_seq_req_mat,
				 nr_seq_req_proc, nr_seq_item)
			values (nextval('ptu_aut_ordem_serv_servico_seq'), r_c01_w.ie_tipo_tabela, r_c01_w.cd_servico,
				 r_c01_w.ie_origem_servico, ds_servico_w, r_c01_w.ie_autorizado,
				 clock_timestamp(), nm_usuario_p, clock_timestamp(),
				 nm_usuario_p, r_c01_w.qt_autorizado, nr_seq_aut_ordem_serv_p,
				 r_c01_w.nr_seq_guia_mat, r_c01_w.nr_seq_guia_proc, r_c01_w.nr_seq_req_mat,
				 r_c01_w.nr_seq_req_proc, r_c01_w.nr_seq_item);
		end loop;
	elsif (nr_seq_resp_auditoria_w IS NOT NULL AND nr_seq_resp_auditoria_w::text <> '') then
		for	r_c02_w	in c02	loop
			if (pls_obter_versao_scs = '090') then
				select	count(1)
				into STRICT	qt_registro_w
				from	pls_regra_generico_ptu
				where 	cd_proc_mat_generico	= r_c02_w.cd_servico
				and	ie_situacao		= 'A';

				if (qt_registro_w > 0) then
					if (coalesce(r_c02_w.ds_servico,'X')	= 'X') then
						CALL wheb_mensagem_pck.exibir_mensagem_abort(216706);
					else
						ds_servico_w	:= r_c02_w.ds_servico;
					end if;
				else
					ds_servico_w	:= '';
				end if;
			else
				ds_servico_w := r_c02_w.ds_servico;
			end if;

			insert into ptu_aut_ordem_serv_servico(nr_sequencia, ie_tipo_tabela, cd_servico,
				 ie_origem_servico, ds_servico, ie_autorizado,
				 dt_atualizacao, nm_usuario, dt_atualizacao_nrec,
				 nm_usuario_nrec, qt_autorizado, nr_seq_aut_ord_serv,
				 nr_seq_guia_mat, nr_seq_guia_proc, nr_seq_req_mat,
				 nr_seq_req_proc, nr_seq_item)
			values (nextval('ptu_aut_ordem_serv_servico_seq'), r_c02_w.ie_tipo_tabela, r_c02_w.cd_servico,
				 r_c02_w.ie_origem_servico, ds_servico_w, r_c02_w.ie_autorizado,
				 clock_timestamp(), nm_usuario_p, clock_timestamp(),
				 nm_usuario_p, r_c02_w.qt_autorizado, nr_seq_aut_ordem_serv_p,
				 r_c02_w.nr_seq_guia_mat, r_c02_w.nr_seq_guia_proc, r_c02_w.nr_seq_req_mat,
				 r_c02_w.nr_seq_req_proc, r_c02_w.nr_seq_item);
		end loop;
	end if;

	commit;
end if;

<<final>>
qt_registros_w	:= 0;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_env_pck.ptu_env_00804_v70 ( nr_seq_guia_p pls_guia_plano.nr_sequencia%type, nr_seq_requisicao_p pls_requisicao.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_aut_ordem_serv_p INOUT ptu_autorizacao_ordem_serv.nr_sequencia%type) FROM PUBLIC;
