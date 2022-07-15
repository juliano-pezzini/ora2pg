-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fa_alterar_status_entrega (nr_seq_entrega_p bigint, nr_seq_entrega_item_p bigint, ie_status_medicacao_p text) AS $body$
DECLARE

qt bigint;

BEGIN

if (nr_seq_entrega_p <> 0) then

	if (ie_status_medicacao_p <> 'EM' ) then
		update 	fa_entrega_medicacao
		set	ie_status_medicacao  = ie_status_medicacao_p,
			dt_atualizacao	     = clock_timestamp()
		where	nr_sequencia = nr_seq_entrega_p;
	else
		update 	fa_entrega_medicacao
		set	ie_status_medicacao  = ie_status_medicacao_p,
			dt_entrega_medicacao = clock_timestamp(),
			dt_atualizacao	     = clock_timestamp()
		where	nr_sequencia = nr_seq_entrega_p;
	end if;

	update 	fa_entrega_medicacao_item
	set	ie_status_medicacao = ie_status_medicacao_p,
		dt_atualizacao	    = clock_timestamp()
	where	nr_seq_fa_entrega = nr_seq_entrega_p
	and	coalesce(nr_seq_motivo_canc::text, '') = '';

  CALL medic_entregue_regulacao(nr_seq_entrega_p,ie_status_medicacao_p);

select 	count(*)
into STRICT 	qt
from 	fa_entrega_medicacao_item
where	nr_sequencia = nr_seq_entrega_p
and 	coalesce(nr_seq_motivo_canc::text, '') = '';

elsif (nr_seq_entrega_item_p <> 0 ) then

	update 	fa_entrega_medicacao_item
	set	ie_status_medicacao = ie_status_medicacao_p,
		dt_atualizacao	    = clock_timestamp()
	where	nr_sequencia = nr_seq_entrega_item_p;

	select 	count(*)
	into STRICT 	qt
from 	fa_entrega_medicacao_item
where	nr_sequencia = nr_seq_entrega_item_p;
end if;

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fa_alterar_status_entrega (nr_seq_entrega_p bigint, nr_seq_entrega_item_p bigint, ie_status_medicacao_p text) FROM PUBLIC;

