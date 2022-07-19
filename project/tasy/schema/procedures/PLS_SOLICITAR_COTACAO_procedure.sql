-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_solicitar_cotacao ( nr_seq_cotacao_p bigint, nm_usuario_p text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Solicitar a cotação dos itens da análise
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [X] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:Performance.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
nr_seq_item_cotacao_w		pls_item_cotacao.nr_sequencia%type;

C01 CURSOR(nr_seq_cotacao_pc bigint) FOR
	SELECT	nr_sequencia
	from	pls_item_cotacao
	where	nr_seq_cotacao	= nr_seq_cotacao_pc
	and	coalesce(cd_procedimento::text, '') = '';


BEGIN

if (nr_seq_cotacao_p IS NOT NULL AND nr_seq_cotacao_p::text <> '') then

	for r_C01_w in C01(nr_seq_cotacao_p) loop
		begin
		-- Alterar o status dos materiais para Enviado
		update	pls_item_cotacao
		set	ie_status	= 2,
			dt_atualizacao	= clock_timestamp(),
			nm_usuario	= nm_usuario_p
		where	nr_sequencia	= r_C01_w.nr_sequencia
		and	coalesce(cd_procedimento::text, '') = '';

		insert into pls_item_cotacao_hist(
				nr_sequencia, dt_atualizacao, ie_tipo_historico,
				nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
				nr_seq_item_cotacao, ds_historico)
		values (
				nextval('pls_item_cotacao_hist_seq'), clock_timestamp(), 1,
				nm_usuario_p, clock_timestamp(), nm_usuario_p,
				r_C01_w.nr_sequencia, 'O usuário '||nm_usuario_p||' solicitou a cotação.');

		end;
	end loop;

	select	nr_sequencia
	into STRICT	nr_seq_item_cotacao_w
	from	pls_item_cotacao
	where	nr_seq_cotacao	= nr_seq_cotacao_p
	and	(cd_procedimento IS NOT NULL AND cd_procedimento::text <> '');

	-- Alterar o status dos procedimentos para Finalizado
	update	pls_item_cotacao
	set	ie_status	= 4,
		dt_atualizacao	= clock_timestamp(),
		nm_usuario	= nm_usuario_p
	where	nr_sequencia	= nr_seq_item_cotacao_w;

	insert into pls_item_cotacao_hist(
			nr_sequencia, dt_atualizacao, ie_tipo_historico,
			nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
			nr_seq_item_cotacao, ds_historico)
	values (
			nextval('pls_item_cotacao_hist_seq'), clock_timestamp(), 1,
			nm_usuario_p, clock_timestamp(), nm_usuario_p,
			nr_seq_item_cotacao_w, 'O usuário '||nm_usuario_p||' solicitou a cotação.');


	-- Alterar o status da cotação para Em andamento
	update	pls_cotacao
	set	ie_status	= 2,
		dt_atualizacao	= clock_timestamp(),
		nm_usuario	= nm_usuario_p
	where	nr_sequencia	= nr_seq_cotacao_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_solicitar_cotacao ( nr_seq_cotacao_p bigint, nm_usuario_p text) FROM PUBLIC;

