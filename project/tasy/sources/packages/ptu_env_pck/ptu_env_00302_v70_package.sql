-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--------------------------------------------------------------------------------00302 Pedido de Insistencia--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



CREATE OR REPLACE PROCEDURE ptu_env_pck.ptu_env_00302_v70 ( nr_seq_requisicao_p ptu_pedido_autorizacao.nr_seq_requisicao%type, nr_seq_guia_p ptu_pedido_autorizacao.nr_seq_guia%type, ds_mensagem_p text, nr_versao_ptu_p ptu_pedido_insistencia.nr_versao%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_pedido_novo_p INOUT ptu_pedido_insistencia.nr_sequencia%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Gerar a transacao de pedido de insitencia do PTU, via SCS
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta:
[ X ]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:Performance.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

ie_tipo_cliente_w		ptu_resposta_autorizacao.ie_tipo_cliente%type;
cd_unimed_executora_w		ptu_resposta_autorizacao.cd_unimed_executora%type;
cd_unimed_beneficiario_w	ptu_resposta_autorizacao.cd_unimed_beneficiario%type;
nr_seq_origem_w			ptu_resposta_autorizacao.nr_seq_origem%type;
nr_seq_resp_autoriz_w		ptu_resposta_autorizacao.nr_sequencia%type;
nr_seq_execucao_w		ptu_controle_execucao.nr_sequencia%type;
ds_mensagem_w			ptu_pedido_insistencia.ds_mensagem%type;
ie_tipo_resposta_w		varchar(2);
qt_reg_auditoria_w		integer := 0;


BEGIN

if (nr_seq_requisicao_p IS NOT NULL AND nr_seq_requisicao_p::text <> '') then
	begin
		select	a.nr_sequencia,
			'PA'
		into STRICT	nr_seq_execucao_w,
			ie_tipo_resposta_w
		from	ptu_pedido_autorizacao	b,
			ptu_controle_execucao	a
		where	a.nr_seq_pedido_aut	= b.nr_sequencia
		and	b.nr_seq_requisicao	= nr_seq_requisicao_p;
	exception
	when others then
		begin
			select	a.nr_sequencia,
				'PC'
			into STRICT	nr_seq_execucao_w,
				ie_tipo_resposta_w
			from	ptu_pedido_compl_aut	b,
				ptu_controle_execucao	a
			where	a.nr_seq_pedido_compl	= b.nr_sequencia
			and	b.nr_seq_requisicao	= nr_seq_requisicao_p;
		exception
		when others then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(179721);
		end;
	end;

	select 	max(nr_sequencia)
	into STRICT	nr_seq_resp_autoriz_w
	from	ptu_resposta_autorizacao
	where	nr_seq_requisicao	= nr_seq_requisicao_p
	and	ie_tipo_resposta	= ie_tipo_resposta_w;

	if (nr_seq_resp_autoriz_w = 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(179721);
	else
		select	ie_tipo_cliente,
			cd_unimed_executora,
			cd_unimed_beneficiario,
			nr_seq_execucao,
			nr_seq_origem
		into STRICT	ie_tipo_cliente_w,
			cd_unimed_executora_w,
			cd_unimed_beneficiario_w,
			nr_seq_execucao_w,
			nr_seq_origem_w
		from	ptu_resposta_autorizacao
		where	nr_sequencia	= nr_seq_resp_autoriz_w;

		if (nr_seq_origem_w = 0) then
			select	max(nr_seq_origem)
			into STRICT	nr_seq_origem_w
			from	ptu_resposta_auditoria
			where	nr_seq_execucao = nr_seq_execucao_w
			and	cd_unimed_executora = cd_unimed_executora_w;
		end if;
	end if;

	CALL pls_requisicao_gravar_hist(nr_seq_requisicao_p,'L',substr(wheb_mensagem_pck.get_texto(1108693,'CD_UNIMED_BENEF=' || cd_unimed_beneficiario_w)||chr(10)||ds_mensagem_p,1,4000),null,nm_usuario_p);
elsif (nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '') then
	begin
		select	a.nr_sequencia,
			'PA'
		into STRICT	nr_seq_execucao_w,
			ie_tipo_resposta_w
		from	ptu_pedido_autorizacao	b,
			ptu_controle_execucao	a
		where	a.nr_seq_pedido_aut	= b.nr_sequencia
		and	b.nr_seq_guia		= nr_seq_guia_p;
	exception
	when others then
		begin
			select	a.nr_sequencia,
				'PC'
			into STRICT	nr_seq_execucao_w,
				ie_tipo_resposta_w
			from	ptu_pedido_compl_aut	b,
				ptu_controle_execucao	a
			where	a.nr_seq_pedido_compl	= b.nr_sequencia
			and	b.nr_seq_guia		= nr_seq_guia_p;
		exception
		when others then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(179721);
		end;
	end;

	select 	max(nr_sequencia)
	into STRICT	nr_seq_resp_autoriz_w
	from	ptu_resposta_autorizacao
	where	nr_seq_guia		= nr_seq_guia_p
	and	ie_tipo_resposta	= ie_tipo_resposta_w;

	if (nr_seq_resp_autoriz_w = 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(179721);
	else
		select	ie_tipo_cliente,
			cd_unimed_executora,
			cd_unimed_beneficiario,
			nr_seq_execucao,
			nr_seq_origem
		into STRICT	ie_tipo_cliente_w,
			cd_unimed_executora_w,
			cd_unimed_beneficiario_w,
			nr_seq_execucao_w,
			nr_seq_origem_w
		from	ptu_resposta_autorizacao
		where	nr_sequencia	= nr_seq_resp_autoriz_w;

		if (nr_seq_origem_w = 0) then
			select	max(nr_seq_origem)
			into STRICT	nr_seq_origem_w
			from	ptu_resposta_auditoria
			where	nr_seq_execucao = nr_seq_execucao_w
			and	cd_unimed_executora = cd_unimed_executora_w;
		end if;
	end if;

	CALL pls_guia_gravar_historico(nr_seq_guia_p,2,substr(wheb_mensagem_pck.get_texto(1108693,'CD_UNIMED_BENEF=' || cd_unimed_beneficiario_w)||chr(10)||ds_mensagem_p,1,4000),'',nm_usuario_p);
end if;

select	substr(replace(replace(ds_mensagem_p,chr(13),''),chr(10),''),1,999)
into STRICT	ds_mensagem_w
;

select	count(1)
into STRICT	qt_reg_auditoria_w
from	ptu_pedido_insistencia
where	nr_seq_execucao		= nr_seq_execucao_w
and	cd_unimed_executora	= cd_unimed_executora_w
and	coalesce(ie_enviado, 'N')	= 'N';

if (qt_reg_auditoria_w	> 0) then
	update	ptu_pedido_insistencia
	set	ie_enviado	= 'S',
		nm_usuario	= nm_usuario_p
	where	nr_seq_execucao		= nr_seq_execucao_w
	and	cd_unimed_executora	= cd_unimed_executora_w
	and	coalesce(ie_enviado, 'N')	= 'N';
end if;

insert	into ptu_pedido_insistencia(nr_sequencia, ie_tipo_cliente, cd_unimed_executora,
	cd_unimed_beneficiario, nr_seq_execucao, nr_seq_origem,
	dt_atualizacao, nm_usuario, nr_seq_guia,
	cd_transacao, ds_mensagem, nr_seq_requisicao,
	nr_versao, nm_usuario_nrec, dt_atualizacao_nrec,
	ie_enviado)
values (nextval('ptu_pedido_insistencia_seq'), ie_tipo_cliente_w, cd_unimed_executora_w,
	cd_unimed_beneficiario_w, nr_seq_execucao_w, nr_seq_origem_w,
	clock_timestamp(), nm_usuario_p, nr_seq_guia_p,
	'00302', ds_mensagem_w, nr_seq_requisicao_p,
	pls_obter_versao_scs, nm_usuario_p, clock_timestamp(),
	'N') returning nr_sequencia into nr_seq_pedido_novo_p;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_env_pck.ptu_env_00302_v70 ( nr_seq_requisicao_p ptu_pedido_autorizacao.nr_seq_requisicao%type, nr_seq_guia_p ptu_pedido_autorizacao.nr_seq_guia%type, ds_mensagem_p text, nr_versao_ptu_p ptu_pedido_insistencia.nr_versao%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_pedido_novo_p INOUT ptu_pedido_insistencia.nr_sequencia%type) FROM PUBLIC;
