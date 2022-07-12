-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_pp_gerar_titulo_pck.obter_prest_sem_dado_pgto ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE


ds_nr_seq_prest_w	varchar(100);

c01 CURSOR(	nr_seq_lote_pc	pls_pp_lote.nr_sequencia%type) FOR
	SELECT	a.nr_seq_prestador
	from	pls_pp_prestador a
	where	a.nr_seq_lote = nr_seq_lote_p
	and not exists (	SELECT	1
			from	pls_prestador_pagto b
			where	b.nr_seq_prestador = a.nr_seq_prestador
			and	a.dt_venc_titulo between b.dt_inicio_vigencia_ref and b.dt_fim_vigencia_ref);

BEGIN
-- se existir algum prestador no lote que nao tenha uma regra de pagamento vigente retorna como string concatenando todo

-- para apresentar na mensagem mostrada ao usuario

for r_c01_w in c01(nr_seq_lote_p) loop
	ds_nr_seq_prest_w := pls_util_pck.concatena_string(ds_nr_seq_prest_w, r_c01_w.nr_seq_prestador, ', ', 100);
end loop;

return ds_nr_seq_prest_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_pp_gerar_titulo_pck.obter_prest_sem_dado_pgto ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type) FROM PUBLIC;