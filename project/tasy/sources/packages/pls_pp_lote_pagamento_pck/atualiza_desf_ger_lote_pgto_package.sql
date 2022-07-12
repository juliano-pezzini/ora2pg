-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_pp_lote_pagamento_pck.atualiza_desf_ger_lote_pgto ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type, ie_sucesso_p text, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN

-- se der tudo certo

if (ie_sucesso_p = 'S') then

	update	pls_pp_lote
	set	dt_geracao_lote  = NULL,
		nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp(),
		ie_status = 'P'
	where	nr_sequencia = nr_seq_lote_p;

	-- atualiza o campo utilizado caso nao exista outro lote gerado utilizando o mesmo periodo / deixar o cliente dar manutencao nos cadastros

	/*for r_c01_w in pls_pp_lote_pagamento_pck.c_dados_lote(nr_seq_lote_p) loop
		
		update	pls_pp_regra_periodo
		set	ie_utilizado = 'N',
			nm_usuario = nm_usuario_p,
			dt_atualizacao = sysdate
		where	nr_sequencia = r_c01_w.nr_seq_regra_periodo
		and not exists(	select	1
				from	pls_pp_lote x
				where	x.nr_seq_regra_periodo = r_c01_w.nr_seq_regra_periodo
				and	x.dt_geracao_lote is not null
				and	x.nr_sequencia != nr_seq_lote_p);
	end loop;*/

else
	-- caso der algum erro

	update	pls_pp_lote
	set	nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp(),
		ie_status = 'E'
	where	nr_sequencia = nr_seq_lote_p;

end if;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pp_lote_pagamento_pck.atualiza_desf_ger_lote_pgto ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type, ie_sucesso_p text, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
