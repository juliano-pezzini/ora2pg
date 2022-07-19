-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_finalizar_imp_a100_simp ( nr_seq_lote_p ptu_intercambio_lote_receb.nr_sequencia%type, cd_estabelecimento_p usuario.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN
CALL ptu_a100_simplificado_pck.consistir_lote(nr_seq_lote_p, cd_estabelecimento_p, nm_usuario_p);
ptu_a100_simplificado_pck.confirmar_lote(nr_seq_lote_p, cd_estabelecimento_p, nm_usuario_p);

update	ptu_intercambio_lote_receb
set	dt_importacao = clock_timestamp()
where	nr_sequencia = nr_seq_lote_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_finalizar_imp_a100_simp ( nr_seq_lote_p ptu_intercambio_lote_receb.nr_sequencia%type, cd_estabelecimento_p usuario.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

