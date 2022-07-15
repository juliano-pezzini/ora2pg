-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ajusta_lote_baixa_js ( nr_seq_lote_fornec_p bigint, nr_devolucao_p bigint, nr_sequencia_p bigint, nm_usuario_p text) AS $body$
BEGIN

update	item_devolucao_material_pac
set	nr_seq_lote_fornec	= nr_seq_lote_fornec_p
where	nr_devolucao	= nr_devolucao_p
and	nr_sequencia	= nr_sequencia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ajusta_lote_baixa_js ( nr_seq_lote_fornec_p bigint, nr_devolucao_p bigint, nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

