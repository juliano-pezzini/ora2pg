-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualizar_saldo_lanc_prog ( nr_seq_lanc_prog_p pls_lancamento_mensalidade.nr_sequencia%type, ie_commit_p text) AS $body$
DECLARE


vl_lancamento_mensalidade_w	double precision;
					

BEGIN

select 	coalesce(sum(a.vl_item), 0)
into STRICT 	vl_lancamento_mensalidade_w
from 	pls_mensalidade_seg_item a
where 	a.nr_seq_lancamento_mens = nr_seq_lanc_prog_p;

CALL wheb_usuario_pck.set_ie_executar_trigger('N');

update	pls_lancamento_mensalidade
set	vl_saldo 	= vl_lancamento - abs(vl_lancamento_mensalidade_w)
where	nr_sequencia 	= nr_seq_lanc_prog_p;

CALL wheb_usuario_pck.set_ie_executar_trigger('S');

if (ie_commit_p = 'S') then
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualizar_saldo_lanc_prog ( nr_seq_lanc_prog_p pls_lancamento_mensalidade.nr_sequencia%type, ie_commit_p text) FROM PUBLIC;

