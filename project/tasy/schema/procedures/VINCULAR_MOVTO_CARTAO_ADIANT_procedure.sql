-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE vincular_movto_cartao_adiant ( nr_adiantamento_p bigint, nr_seq_movto_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_adiantamento_w	bigint;


BEGIN

select	max(a.nr_adiantamento)
into STRICT	nr_adiantamento_w
from	movto_cartao_cr a
where	a.nr_adiantamento	= nr_adiantamento_p;

if (nr_adiantamento_w IS NOT NULL AND nr_adiantamento_w::text <> '') then

	/* A movimentação de cartão nr_seq_movto_p já está vinculada ao adiantamento nr_adiantamento_w! */

	CALL wheb_mensagem_pck.exibir_mensagem_abort(270895,
						'NR_SEQ_MOVTO_P='||nr_seq_movto_p||';'||
						'NR_ADIANTAMENTO_W='||nr_adiantamento_w);

end if;

update	movto_cartao_cr
set	nr_adiantamento = nr_adiantamento_p,
	nm_usuario = nm_usuario_p,
	dt_atualizacao = clock_timestamp()
where	nr_sequencia = nr_seq_movto_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE vincular_movto_cartao_adiant ( nr_adiantamento_p bigint, nr_seq_movto_p bigint, nm_usuario_p text) FROM PUBLIC;

