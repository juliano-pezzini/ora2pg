-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_insere_observacao_scs ( ds_observacao_p text, nr_seq_segurado_p bigint, nr_seq_guia_p bigint, nr_seq_requisicao_p bigint, nr_seq_transacao_p bigint, ie_tipo_pedido_p text, nm_usuario_p text) AS $body$
BEGIN

if (ie_tipo_pedido_p	= 'PA') then
	update	ptu_pedido_autorizacao
	set	ds_observacao	= ds_observacao_p,
		dt_atualizacao	= clock_timestamp(),
		nm_usuario	= nm_usuario_p
	where	nr_sequencia	= nr_seq_transacao_p;

	if (nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '')  then
		if (nr_seq_segurado_p IS NOT NULL AND nr_seq_segurado_p::text <> '') then
			update	pls_guia_plano
			set	ds_observacao	= ds_observacao_p,
				dt_atualizacao	= clock_timestamp(),
				nm_usuario	= nm_usuario_p
			where	nr_sequencia	= nr_seq_guia_p;
		end if;
	elsif (nr_seq_requisicao_p IS NOT NULL AND nr_seq_requisicao_p::text <> '') then
		if (nr_seq_segurado_p IS NOT NULL AND nr_seq_segurado_p::text <> '') then
			update	pls_requisicao
			set	ds_observacao	= ds_observacao_p,
				dt_atualizacao	= clock_timestamp(),
				nm_usuario	= nm_usuario_p
			where	nr_sequencia	= nr_seq_requisicao_p;
		end if;
	end if;
elsif (ie_tipo_pedido_p	= 'PC') then
	update	ptu_pedido_compl_aut
	set	ds_observacao	= ds_observacao_p,
		dt_atualizacao	= clock_timestamp(),
		nm_usuario	= nm_usuario_p
	where	nr_sequencia	= nr_seq_transacao_p;

	if (nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '')  then
		if (nr_seq_segurado_p IS NOT NULL AND nr_seq_segurado_p::text <> '') then
			update	pls_guia_plano
			set	ds_observacao	= ds_observacao_p,
				dt_atualizacao	= clock_timestamp(),
				nm_usuario	= nm_usuario_p
			where	nr_sequencia	= nr_seq_guia_p;
		end if;
	elsif (nr_seq_requisicao_p IS NOT NULL AND nr_seq_requisicao_p::text <> '') then
		if (nr_seq_segurado_p IS NOT NULL AND nr_seq_segurado_p::text <> '') then
			update	pls_requisicao
			set	ds_observacao	= ds_observacao_p,
				dt_atualizacao	= clock_timestamp(),
				nm_usuario	= nm_usuario_p
			where	nr_sequencia	= nr_seq_requisicao_p;
		end if;
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_insere_observacao_scs ( ds_observacao_p text, nr_seq_segurado_p bigint, nr_seq_guia_p bigint, nr_seq_requisicao_p bigint, nr_seq_transacao_p bigint, ie_tipo_pedido_p text, nm_usuario_p text) FROM PUBLIC;

