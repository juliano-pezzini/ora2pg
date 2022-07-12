-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--------------------------------------------------------------------------------00360 Status da Transacao---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



CREATE OR REPLACE PROCEDURE ptu_env_pck.ptu_env_00360_v70 ( nr_seq_guia_p ptu_pedido_autorizacao.nr_seq_guia%type, nr_seq_requisicao_p ptu_pedido_autorizacao.nr_seq_requisicao%type, nr_versao_ptu_p ptu_pedido_status.nr_versao%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_pedido_novo_p INOUT ptu_pedido_status.nr_sequencia%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Gerar a transacao pra verificar o status das transacoes na operadora de origem, via SCS
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta:
[  X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:Performance.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

nr_seq_execucao_w			ptu_controle_execucao.nr_sequencia%type;
nr_seq_pedido_aut_w			ptu_pedido_autorizacao.nr_sequencia%type;
nr_seq_pedido_compl_w			ptu_pedido_compl_aut.nr_sequencia%type;
cd_unimed_beneficiario_w		ptu_pedido_autorizacao.cd_unimed_beneficiario%type;
cd_unimed_executora_w			ptu_pedido_autorizacao.cd_unimed_executora%type;


BEGIN

if (nr_seq_requisicao_p IS NOT NULL AND nr_seq_requisicao_p::text <> '') then
	begin
		select	a.nr_sequencia,
			b.nr_sequencia
		into STRICT	nr_seq_execucao_w,
			nr_seq_pedido_aut_w
		from	ptu_pedido_autorizacao	b,
			ptu_controle_execucao	a
		where	a.nr_seq_pedido_aut	= b.nr_sequencia
		and	b.nr_seq_requisicao	= nr_seq_requisicao_p;
	exception
	when others then
		begin
			select	a.nr_sequencia,
				b.nr_sequencia
			into STRICT	nr_seq_execucao_w,
				nr_seq_pedido_compl_w
			from	ptu_pedido_compl_aut	b,
				ptu_controle_execucao	a
			where	a.nr_seq_pedido_compl	= b.nr_sequencia
			and	b.nr_seq_requisicao	= nr_seq_requisicao_p;
		exception
		when others then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(179719);
		end;
	end;

	if (coalesce(nr_seq_pedido_aut_w,0)	<> 0) then
		select	cd_unimed_beneficiario,
			cd_unimed_executora
		into STRICT	cd_unimed_beneficiario_w,
			cd_unimed_executora_w
		from	ptu_pedido_autorizacao
		where	nr_sequencia	= nr_seq_pedido_aut_w;
	elsif (coalesce(nr_seq_pedido_compl_w,0)	<> 0) then
		select	cd_unimed_beneficiario,
			cd_unimed_executora
		into STRICT	cd_unimed_beneficiario_w,
			cd_unimed_executora_w
		from	ptu_pedido_compl_aut
		where	nr_sequencia	= nr_seq_pedido_compl_w;
	end if;

	CALL pls_requisicao_gravar_hist(nr_seq_requisicao_p, 'L', 'Enviado pedido de status para a Unimed '||cd_unimed_beneficiario_w, null, nm_usuario_p);
elsif (nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '') then
	begin
		select	a.nr_sequencia,
			b.nr_sequencia
		into STRICT	nr_seq_execucao_w,
			nr_seq_pedido_aut_w
		from	ptu_pedido_autorizacao	b,
			ptu_controle_execucao	a
		where	a.nr_seq_pedido_aut	= b.nr_sequencia
		and	b.nr_seq_guia		= nr_seq_guia_p;
	exception
	when others then
		begin
			select	a.nr_sequencia,
				b.nr_sequencia
			into STRICT	nr_seq_execucao_w,
				nr_seq_pedido_compl_w
			from	ptu_pedido_compl_aut	b,
				ptu_controle_execucao	a
			where	a.nr_seq_pedido_compl	= b.nr_sequencia
			and	b.nr_seq_guia		= nr_seq_guia_p;
		exception
		when others then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(179719);
		end;
	end;

	if (coalesce(nr_seq_pedido_aut_w,0)	<> 0) then
		select	cd_unimed_beneficiario,
			cd_unimed_executora
		into STRICT	cd_unimed_beneficiario_w,
			cd_unimed_executora_w
		from	ptu_pedido_autorizacao
		where	nr_sequencia	= nr_seq_pedido_aut_w;
	elsif (coalesce(nr_seq_pedido_compl_w,0)	<> 0) then
		select	cd_unimed_beneficiario,
			cd_unimed_executora
		into STRICT	cd_unimed_beneficiario_w,
			cd_unimed_executora_w
		from	ptu_pedido_compl_aut
		where	nr_sequencia	= nr_seq_pedido_compl_w;
	end if;

	CALL pls_guia_gravar_historico(nr_seq_guia_p, 2, 'Enviado pedido de status para a Unimed '||cd_unimed_beneficiario_w, '', nm_usuario_p);
end if;

insert	into ptu_pedido_status(nr_sequencia, cd_transacao, cd_unimed_beneficiario,
	cd_unimed_executora, dt_atualizacao, dt_atualizacao_nrec,
	ie_tipo_cliente, nm_usuario, nm_usuario_nrec,
	nr_transacao_uni_exec, nr_seq_guia, nr_seq_requisicao,
	nr_versao)
values (nextval('ptu_pedido_status_seq'), '00360', cd_unimed_beneficiario_w,
	cd_unimed_executora_w, clock_timestamp(), clock_timestamp(),
	'U', nm_usuario_p, nm_usuario_p,
	nr_seq_execucao_w, nr_seq_guia_p, nr_seq_requisicao_p,
	pls_obter_versao_scs) returning nr_sequencia into nr_seq_pedido_novo_p;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_env_pck.ptu_env_00360_v70 ( nr_seq_guia_p ptu_pedido_autorizacao.nr_seq_guia%type, nr_seq_requisicao_p ptu_pedido_autorizacao.nr_seq_requisicao%type, nr_versao_ptu_p ptu_pedido_status.nr_versao%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_pedido_novo_p INOUT ptu_pedido_status.nr_sequencia%type) FROM PUBLIC;
