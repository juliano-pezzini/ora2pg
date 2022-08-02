-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_inserir_token ( nr_seq_guia_p pls_guia_plano.nr_sequencia%type, nr_seq_req_p pls_requisicao.nr_sequencia%type, ie_tipo_transacao_p text, ds_token_p text, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE


/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:   Inserir o token na transacao
----------------------------------------------------------------------------------------------------------------------------------------------------

Locais de chamada direta:
[  ]  Objetos do dicionario [  ] Tasy (Delphi/Java) [ x ] Portal [  ] Relatorios [ ] Outros:
 ----------------------------------------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*/nr_seq_transacao_w		bigint;
ie_tipo_transacao_w		varchar(2);


BEGIN
--Tratamento realizado devido ao portal
if (ie_tipo_transacao_p = 'P') then
	if (nr_seq_req_p IS NOT NULL AND nr_seq_req_p::text <> '') then
		select	coalesce(max(nr_sequencia),0)
		into STRICT	nr_seq_transacao_w
		from	ptu_pedido_compl_aut
		where	nr_seq_requisicao = nr_seq_req_p;

		if (nr_seq_transacao_w IS NOT NULL AND nr_seq_transacao_w::text <> '') and (nr_seq_transacao_w <> 0) then
			ie_tipo_transacao_w := 'PC';
		else
			select	coalesce(max(nr_sequencia),0)
			into STRICT	nr_seq_transacao_w
			from	ptu_pedido_autorizacao
			where	nr_seq_requisicao = nr_seq_req_p;

			if (nr_seq_transacao_w IS NOT NULL AND nr_seq_transacao_w::text <> '') and (nr_seq_transacao_w <> 0) then
				ie_tipo_transacao_w := 'PA';
			end if;
		end if;
	elsif (nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '') then
		select	coalesce(max(nr_sequencia),0)
		into STRICT	nr_seq_transacao_w
		from	ptu_pedido_compl_aut
		where	nr_seq_guia = nr_seq_guia_p;

		if (nr_seq_transacao_w IS NOT NULL AND nr_seq_transacao_w::text <> '') and (nr_seq_transacao_w <> 0) then
			ie_tipo_transacao_w := 'PC';
		else
			select	coalesce(max(nr_sequencia),0)
			into STRICT	nr_seq_transacao_w
			from	ptu_pedido_autorizacao
			where	nr_seq_guia = nr_seq_guia_p;

			if (nr_seq_transacao_w IS NOT NULL AND nr_seq_transacao_w::text <> '') and (nr_seq_transacao_w <> 0) then
				ie_tipo_transacao_w := 'PA';
			end if;
		end if;
	end if;
else
	ie_tipo_transacao_w := ie_tipo_transacao_p;
end if;

if (nr_seq_req_p IS NOT NULL AND nr_seq_req_p::text <> '') then
	if (ie_tipo_transacao_w = 'PA') then
		select	coalesce(max(nr_sequencia),0)
		into STRICT	nr_seq_transacao_w
		from	ptu_pedido_autorizacao
		where	nr_seq_requisicao = nr_seq_req_p;

		if (nr_seq_transacao_w > 0) then
			update	ptu_pedido_autorizacao
			set	ds_token = ds_token_p,
				nm_usuario = nm_usuario_p,
				dt_atualizacao = clock_timestamp()
			where	nr_sequencia = nr_seq_transacao_w;
		end if;
	elsif (ie_tipo_transacao_w = 'PC') then
		select	coalesce(max(nr_sequencia),0)
		into STRICT	nr_seq_transacao_w
		from	ptu_pedido_compl_aut
		where	nr_seq_requisicao = nr_seq_req_p;

		if (nr_seq_transacao_w > 0) then
			update	ptu_pedido_compl_aut
			set	ds_token = ds_token_p,
				nm_usuario = nm_usuario_p,
				dt_atualizacao = clock_timestamp()
			where	nr_sequencia = nr_seq_transacao_w;
		end if;
	elsif (ie_tipo_transacao_w = 'IA') then
		select	coalesce(max(nr_sequencia),0)
		into STRICT	nr_seq_transacao_w
		from	ptu_comunicacao_internacao
		where	nr_seq_requisicao = nr_seq_req_p;

		if (nr_seq_transacao_w > 0) then
			update	ptu_comunicacao_internacao
			set	ds_token = ds_token_p,
				nm_usuario = nm_usuario_p,
				dt_atualizacao = clock_timestamp()
			where	nr_sequencia = nr_seq_transacao_w;
		end if;
	end if;
elsif (nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '') then
	if (ie_tipo_transacao_w = 'PA') then
		select	coalesce(max(nr_sequencia),0)
		into STRICT	nr_seq_transacao_w
		from	ptu_pedido_autorizacao
		where	nr_seq_guia = nr_seq_guia_p;

		if (nr_seq_transacao_w > 0) then
			update	ptu_pedido_autorizacao
			set	ds_token = ds_token_p,
				nm_usuario = nm_usuario_p,
				dt_atualizacao = clock_timestamp()
			where	nr_sequencia = nr_seq_transacao_w;
		end if;
	elsif (ie_tipo_transacao_w = 'PC') then
		select	coalesce(max(nr_sequencia),0)
		into STRICT	nr_seq_transacao_w
		from	ptu_pedido_compl_aut
		where	nr_seq_guia = nr_seq_guia_p;

		if (nr_seq_transacao_w > 0) then
			update	ptu_pedido_compl_aut
			set	ds_token = ds_token_p,
				nm_usuario = nm_usuario_p,
				dt_atualizacao = clock_timestamp()
			where	nr_sequencia = nr_seq_transacao_w;
		end if;
	elsif (ie_tipo_transacao_w = 'IA') then
		select	coalesce(max(nr_sequencia),0)
		into STRICT	nr_seq_transacao_w
		from	ptu_comunicacao_internacao
		where	nr_seq_guia = nr_seq_guia_p;

		if (nr_seq_transacao_w > 0) then
			update	ptu_comunicacao_internacao
			set	ds_token = ds_token_p,
				nm_usuario = nm_usuario_p,
				dt_atualizacao = clock_timestamp()
			where	nr_sequencia = nr_seq_transacao_w;
		end if;
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_inserir_token ( nr_seq_guia_p pls_guia_plano.nr_sequencia%type, nr_seq_req_p pls_requisicao.nr_sequencia%type, ie_tipo_transacao_p text, ds_token_p text, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;

