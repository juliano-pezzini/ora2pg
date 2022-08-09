-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sup_prog_planej_calendario ( nr_seq_planej_compras_p bigint, dt_planej_anterior_p timestamp, dt_planejamento_p timestamp, ie_opcao_p text, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w	bigint;


BEGIN

select	max(nr_sequencia)
into STRICT	nr_sequencia_w
from	planej_compras_calendario
where	nr_seq_planej_compras = nr_seq_planej_compras_p
and	dt_planejamento = dt_planej_anterior_p;

if (ie_opcao_p = 'A') then

	update	planej_compras_calendario
	set	dt_planejamento = dt_planejamento_p
	where	nr_sequencia = nr_sequencia_w;

elsif (ie_opcao_p = 'C') then

	update	planej_compras_calendario
	set	dt_cancelamento = clock_timestamp()
	where	nr_sequencia = nr_sequencia_w;

elsif (ie_opcao_p = 'D') then

	update	planej_compras_calendario
	set	dt_cancelamento  = NULL
	where	nr_sequencia = nr_sequencia_w;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sup_prog_planej_calendario ( nr_seq_planej_compras_p bigint, dt_planej_anterior_p timestamp, dt_planejamento_p timestamp, ie_opcao_p text, nm_usuario_p text) FROM PUBLIC;
