-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--------------------------------------------------------------------------------00311 Cancelamento-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



CREATE OR REPLACE PROCEDURE ptu_env_pck.ptu_env_00311_v70 ( nr_seq_guia_p ptu_pedido_autorizacao.nr_seq_guia%type, nr_seq_requisicao_p ptu_pedido_autorizacao.nr_seq_requisicao%type, ds_motivo_p ptu_cancelamento.ds_motivo_cancelamento%type, nr_versao_ptu_p ptu_cancelamento.nr_versao%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_cancelamento_p INOUT ptu_cancelamento.nr_sequencia%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Gerar a transacao de cancelamento do PTU via SCS.
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta:
[ X ]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao: Performance.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


cd_unimed_executora_w		ptu_resposta_autorizacao.cd_unimed_executora%type;
cd_unimed_beneficiario_w	ptu_resposta_autorizacao.cd_unimed_beneficiario%type;
nr_seq_origem_w			ptu_resposta_autorizacao.nr_seq_origem%type;
ie_tipo_cliente_w		ptu_resposta_autorizacao.ie_tipo_cliente%type;
nr_seq_resp_autor_w		ptu_resposta_autorizacao.nr_sequencia%type;
nr_seq_segurado_w		pls_segurado.nr_sequencia%type;
cd_guia_w			pls_guia_plano.cd_guia%type;
nr_seq_execucao_w		ptu_controle_execucao.nr_sequencia%type;
qt_contas_w			integer;
qt_reg_conta_w			integer;
qt_registros_w			integer;


BEGIN
if (nr_seq_requisicao_p IS NOT NULL AND nr_seq_requisicao_p::text <> '') then
	begin
		select	a.nr_sequencia
		into STRICT	nr_seq_execucao_w
		from	ptu_pedido_autorizacao		b,
			ptu_controle_execucao		a
		where	a.nr_seq_pedido_aut		= b.nr_sequencia
		and	b.nr_seq_requisicao			= nr_seq_requisicao_p;
	exception
	when others then
		begin
			select	a.nr_sequencia
			into STRICT	nr_seq_execucao_w
			from	ptu_pedido_compl_aut		b,
				ptu_controle_execucao		a
			where	a.nr_seq_pedido_compl		= b.nr_sequencia
			and	b.nr_seq_requisicao			= nr_seq_requisicao_p;
		exception
		when others then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(179724);
		end;
	end;

	select	max(nr_sequencia)
	into STRICT	nr_seq_resp_autor_w
	from	ptu_resposta_autorizacao
	where	nr_seq_execucao		= nr_seq_execucao_w
	and	nr_seq_requisicao	= nr_seq_requisicao_p;

	if (nr_seq_resp_autor_w IS NOT NULL AND nr_seq_resp_autor_w::text <> '') then
		begin
			select	cd_unimed_executora,
				cd_unimed_beneficiario,
				nr_seq_origem,
				ie_tipo_cliente
			into STRICT	cd_unimed_executora_w,
				cd_unimed_beneficiario_w,
				nr_seq_origem_w,
				ie_tipo_cliente_w
			from	ptu_resposta_autorizacao
			where	nr_sequencia	= nr_seq_resp_autor_w;
		exception
		when others then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(179729);
		end;
	else
		begin
			select	cd_unimed_executora,
				cd_unimed_beneficiario,
				ie_tipo_cliente
			into STRICT	cd_unimed_executora_w,
				cd_unimed_beneficiario_w,
				ie_tipo_cliente_w
			from	ptu_pedido_compl_aut
			where	nr_seq_requisicao		= nr_seq_requisicao_p;
		exception
		when others then
			begin
				select	cd_unimed_executora,
					cd_unimed_beneficiario,
					ie_tipo_cliente
				into STRICT	cd_unimed_executora_w,
					cd_unimed_beneficiario_w,
					ie_tipo_cliente_w
				from	ptu_pedido_autorizacao
				where	nr_seq_requisicao		= nr_seq_requisicao_p;
			exception
			when others then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(338519);
			end;
		end;
	end if;

	if (coalesce(nr_seq_origem_w,0)	= 0) then
		begin
			select	max(nr_seq_origem)
			into STRICT	nr_seq_origem_w
			from	ptu_resposta_auditoria
			where	nr_seq_execucao		= nr_seq_execucao_w
			and	nr_seq_requisicao	= nr_seq_requisicao_p;
		exception
		when others then
			nr_seq_origem_w        := 0;
		end;
	end if;

	CALL pls_requisicao_gravar_hist(nr_seq_requisicao_p,'L','Enviado o cancelamento para a Unimed '||cd_unimed_beneficiario_w,null,nm_usuario_p);
elsif (nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '') then
	begin
		select	a.nr_sequencia
		into STRICT	nr_seq_execucao_w
		from	ptu_pedido_autorizacao		b,
			ptu_controle_execucao		a
		where	a.nr_seq_pedido_aut		= b.nr_sequencia
		and	b.nr_seq_guia			= nr_seq_guia_p;
	exception
	when others then
		begin
			select	a.nr_sequencia
			into STRICT	nr_seq_execucao_w
			from	ptu_pedido_compl_aut		b,
				ptu_controle_execucao		a
			where	a.nr_seq_pedido_compl		= b.nr_sequencia
			and	b.nr_seq_guia			= nr_seq_guia_p;
		exception
		when others then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(179724);
		end;
	end;

	--Tratamento para verificar se existem contas vinculadas a guia, antes de permitir o envio de cancelamento.

	select	nr_seq_segurado,
		cd_guia
	into STRICT	nr_seq_segurado_w,
		cd_guia_w
	from	pls_guia_plano
	where	nr_sequencia	= nr_seq_guia_p;

	select	count(1)
	into STRICT	qt_contas_w
	from	pls_conta	a
	where	a.nr_seq_guia	= nr_seq_guia_p;

	if (qt_contas_w	= 0) then
		select  count(1)
		into STRICT	qt_reg_conta_w
		from    pls_conta
		where   nr_seq_segurado	= nr_seq_segurado_w
		and     cd_guia		= cd_guia_w
		and	ie_status	<> 'C';
	else
		select  count(1)
		into STRICT	qt_reg_conta_w
		from    pls_conta
		where   nr_seq_segurado	= nr_seq_segurado_w
		and     nr_seq_guia	= nr_seq_guia_p
		and	ie_status	<> 'C';
	end if;

	if (qt_reg_conta_w > 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(196005);
	end if;

	select	max(nr_sequencia)
	into STRICT	nr_seq_resp_autor_w
	from	ptu_resposta_autorizacao
	where	nr_seq_execucao	= nr_seq_execucao_w
	and	nr_seq_guia	= nr_seq_guia_p;

	if (nr_seq_resp_autor_w IS NOT NULL AND nr_seq_resp_autor_w::text <> '') then
		begin
			select	cd_unimed_executora,
				cd_unimed_beneficiario,
				nr_seq_origem,
				ie_tipo_cliente
			into STRICT	cd_unimed_executora_w,
				cd_unimed_beneficiario_w,
				nr_seq_origem_w,
				ie_tipo_cliente_w
			from	ptu_resposta_autorizacao
			where	nr_sequencia	= nr_seq_resp_autor_w;
		exception
		when others then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(179729);
		end;
	else
		begin
			select	cd_unimed_executora,
				cd_unimed_beneficiario,
				ie_tipo_cliente
			into STRICT	cd_unimed_executora_w,
				cd_unimed_beneficiario_w,
				ie_tipo_cliente_w
			from	ptu_pedido_compl_aut
			where	nr_seq_guia			= nr_seq_guia_p;
		exception
		when others then
			begin
				select	cd_unimed_executora,
					cd_unimed_beneficiario,
					ie_tipo_cliente
				into STRICT	cd_unimed_executora_w,
					cd_unimed_beneficiario_w,
					ie_tipo_cliente_w
				from	ptu_pedido_autorizacao
				where	nr_seq_guia			= nr_seq_guia_p;
			exception
			when others then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(338519);
			end;
		end;
	end if;

	if (coalesce(nr_seq_origem_w,0)	= 0) then
		begin
			select	max(nr_seq_origem)
			into STRICT	nr_seq_origem_w
			from	ptu_resposta_auditoria
			where	nr_seq_execucao	= nr_seq_execucao_w
			and	nr_seq_guia	= nr_seq_guia_p;
		exception
		when others then
			nr_seq_origem_w        := 0;
		end;
	end if;

	CALL pls_guia_gravar_historico(nr_seq_guia_p,2,'Enviado o cancelamento para a Unimed '||cd_unimed_beneficiario_w,'',nm_usuario_p);
end if;

select	count(1)
into STRICT	qt_registros_w
from	ptu_cancelamento
where	nr_seq_execucao		= nr_seq_execucao_w
and	cd_unimed_executora	= cd_unimed_executora_w
and	coalesce(ie_enviado, 'N')	= 'N';

if (qt_registros_w	> 0) then
	update	ptu_cancelamento
	set	ie_enviado		= 'S'
	where	nr_seq_execucao		= nr_seq_execucao_w
	and	cd_unimed_executora	= cd_unimed_executora_w
	and	coalesce(ie_enviado, 'N')	= 'N';
end if;

insert	into ptu_cancelamento(nr_sequencia, cd_transacao, ie_tipo_cliente,
	cd_unimed_executora, cd_unimed_beneficiario, nr_seq_execucao,
	dt_atualizacao, nm_usuario, nr_seq_origem,
	nr_seq_requisicao, nr_seq_guia, nm_usuario_nrec,
	dt_atualizacao_nrec, nr_versao, ds_motivo_cancelamento)
values (nextval('ptu_cancelamento_seq'), '00311', ie_tipo_cliente_w,
	cd_unimed_executora_w, cd_unimed_beneficiario_w, nr_seq_execucao_w,
	clock_timestamp(), nm_usuario_p, nr_seq_origem_w,
	nr_seq_requisicao_p, nr_seq_guia_p, nm_usuario_p,
	clock_timestamp(), pls_obter_versao_scs, substr(ds_motivo_p,1,999)) returning nr_sequencia into nr_seq_cancelamento_p;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_env_pck.ptu_env_00311_v70 ( nr_seq_guia_p ptu_pedido_autorizacao.nr_seq_guia%type, nr_seq_requisicao_p ptu_pedido_autorizacao.nr_seq_requisicao%type, ds_motivo_p ptu_cancelamento.ds_motivo_cancelamento%type, nr_versao_ptu_p ptu_cancelamento.nr_versao%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_cancelamento_p INOUT ptu_cancelamento.nr_sequencia%type) FROM PUBLIC;
