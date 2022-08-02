-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_excluir_lote_seg_preco ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
BEGIN

delete	from	pls_lote_reajuste_log
where	nr_seq_lote_reaj	= nr_sequencia_p;

delete	from	pls_segurado_preco
where	nr_seq_lote		= nr_sequencia_p;

delete	from	pls_segurado_preco_origem
where	nr_seq_lote_reajuste	= nr_sequencia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_excluir_lote_seg_preco ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

