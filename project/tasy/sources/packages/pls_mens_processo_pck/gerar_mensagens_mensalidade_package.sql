-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_mens_processo_pck.gerar_mensagens_mensalidade ( nr_seq_lote_p pls_lote_mensalidade.nr_sequencia%type, nr_seq_mensalidade_p pls_mensalidade.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


C01 CURSOR(	nr_seq_lote_pc		pls_lote_mensalidade.nr_sequencia%type,
		nr_seq_mensalidade_pc	pls_mensalidade.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia nr_seq_mensalidade,
		a.dt_referencia,
		a.ie_tipo_estipulante,
		a.nr_seq_pagador,
		a.nr_seq_conta_banco,
		c.nr_seq_classif_itens
	from	pls_mensalidade	a,
		pls_lote_mensalidade b,
		pls_contrato_pagador c
	where	b.nr_sequencia	= a.nr_seq_lote
	and	c.nr_sequencia	= a.nr_seq_pagador
	and	b.nr_sequencia	= nr_seq_lote_pc
	and	((a.nr_sequencia = nr_seq_mensalidade_pc) or (coalesce(nr_seq_mensalidade_pc::text, '') = ''));

BEGIN

for r_c01_w in C01(nr_seq_lote_p, nr_seq_mensalidade_p) loop
	begin
	CALL pls_mens_gerar_mensagem(r_c01_w.nr_seq_mensalidade, r_c01_w.nr_seq_pagador, r_c01_w.dt_referencia, r_c01_w.ie_tipo_estipulante, r_c01_w.nr_seq_conta_banco, r_c01_w.nr_seq_classif_itens, cd_estabelecimento_p, nm_usuario_p);
	end;
end loop;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_mens_processo_pck.gerar_mensagens_mensalidade ( nr_seq_lote_p pls_lote_mensalidade.nr_sequencia%type, nr_seq_mensalidade_p pls_mensalidade.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;