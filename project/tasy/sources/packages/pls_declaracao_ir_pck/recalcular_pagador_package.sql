-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_declaracao_ir_pck.recalcular_pagador ( nr_seq_lote_p pls_lote_mens_ir.nr_sequencia%type, nr_seq_pagador_ir_p pls_mens_pagador_ir.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN
CALL CALL pls_declaracao_ir_pck.carregar_dados_lote(nr_seq_lote_p);

delete	from	pls_mens_detalhe_ir a
where	exists (	SELECT	1
		from	pls_mens_beneficiario_ir x
		where	x.nr_sequencia		= a.nr_seq_beneficiario_ir
		and	x.nr_seq_pagador_ir	= nr_seq_pagador_ir_p);

delete	from	pls_mens_beneficiario_ir
where	nr_seq_pagador_ir	= nr_seq_pagador_ir_p;

CALL CALL pls_declaracao_ir_pck.inserir_beneficiarios(nr_seq_lote_p,nr_seq_pagador_ir_p,nm_usuario_p);

gerar_valores_ir(nr_seq_lote_p,nr_seq_pagador_ir_p,nm_usuario_p);

CALL gerar_arredondamento(nr_seq_lote_p, nr_seq_pagador_ir_p, nm_usuario_p);

CALL pls_declaracao_ir_pck.deletar_beneficiarios(nr_seq_lote_p,nr_seq_pagador_ir_p,nm_usuario_p);

CALL pls_declaracao_ir_pck.atualizar_benef_ir(nr_seq_lote_p,nr_seq_pagador_ir_p);

CALL pls_declaracao_ir_pck.atualizar_pagador_ir(nr_seq_lote_p,nr_seq_pagador_ir_p);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_declaracao_ir_pck.recalcular_pagador ( nr_seq_lote_p pls_lote_mens_ir.nr_sequencia%type, nr_seq_pagador_ir_p pls_mens_pagador_ir.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;