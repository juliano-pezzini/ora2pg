-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE desfazer_geracao_lote_fluxo ( nr_seq_lote_fluxo_p text) AS $body$
BEGIN

delete	from fluxo_caixa_item
where	nr_seq_lote_fluxo	= nr_seq_lote_fluxo_p;

delete	from fluxo_caixa_data
where	nr_seq_lote_fluxo	= nr_seq_lote_fluxo_p;


update 	fluxo_caixa_lote
set 	dt_geracao = ''
where 	nr_sequencia  = nr_seq_lote_fluxo_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE desfazer_geracao_lote_fluxo ( nr_seq_lote_fluxo_p text) FROM PUBLIC;

