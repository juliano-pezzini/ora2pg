-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_reaj_cobranca_retro_pck.excluir_lote_cobranca_retro ( nr_seq_lote_retro_p pls_reajuste_cobr_retro.nr_sequencia%type) AS $body$
DECLARE


qt_registros_w	integer;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_segurado_mensalidade
	where	nr_seq_reaj_retro = nr_seq_lote_retro_p;

BEGIN

select	count(1)
into STRICT	qt_registros_w
from	pls_mensalidade_seg_item	a,
	pls_segurado_mensalidade	b
where	b.nr_sequencia	= a.nr_seq_segurado_mens
and	b.nr_seq_reaj_retro = nr_seq_lote_retro_p;

if (qt_registros_w > 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1140209); --Nao e possivel excluir o lote, pois existem itens que ja foram cobrados em mensalidade
end if;

for c01_w in C01 loop
	begin
	delete	from	pls_lancamento_mens_aprop
	where	nr_seq_lanc_auto = c01_w.nr_sequencia;
	end;
end loop;

delete	from	pls_segurado_mensalidade
where	nr_seq_reaj_retro = nr_seq_lote_retro_p;

delete	from	pls_reajuste_cobr_retro
where	nr_sequencia = nr_seq_lote_retro_p;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_reaj_cobranca_retro_pck.excluir_lote_cobranca_retro ( nr_seq_lote_retro_p pls_reajuste_cobr_retro.nr_sequencia%type) FROM PUBLIC;