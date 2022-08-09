-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_inserir_hist_rel_aud (nr_seq_analise_p pls_analise_conta.nr_sequencia%type, ds_observacao_p pls_hist_analise_conta.ds_observacao%type, nm_usuario_p text) AS $body$
DECLARE

cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;

BEGIN
if (nr_seq_analise_p IS NOT NULL AND nr_seq_analise_p::text <> '') then

	select	max(cd_estabelecimento)
	into STRICT	cd_estabelecimento_w
	from	pls_analise_conta
	where	nr_sequencia	= nr_seq_analise_p;

	CALL pls_inserir_hist_analise(null,
			 nr_seq_analise_p,
			 35, -- Alteração dados do relatório
			 null,
			 null,
			 null,
			 null,
			 ds_observacao_p,
			 null,
			 nm_usuario_p,
			 cd_estabelecimento_w);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_inserir_hist_rel_aud (nr_seq_analise_p pls_analise_conta.nr_sequencia%type, ds_observacao_p pls_hist_analise_conta.ds_observacao%type, nm_usuario_p text) FROM PUBLIC;
