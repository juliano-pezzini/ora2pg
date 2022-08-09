-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE excluir_w_importa_cliente ( nr_sequencia_p bigint) AS $body$
BEGIN

delete
from	w_importa_cliente_incons
where	nr_seq_cliente = nr_sequencia_p;

delete
from	w_importa_conta_cliente
where	nr_seq_cliente = nr_sequencia_p;

delete
from	w_importa_clientes
where	nr_sequencia = nr_sequencia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE excluir_w_importa_cliente ( nr_sequencia_p bigint) FROM PUBLIC;
