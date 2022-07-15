-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_inserir_data_movto ( nr_sequencia_p bigint, dt_movimento_p timestamp) AS $body$
DECLARE

 
	 
nr_seq_agrupamento_w		 w_ctb_dados_lancamento.nr_seq_agrupamento%type;
		

BEGIN 
 
select nr_seq_agrupamento 
into STRICT	nr_seq_agrupamento_w 
from	w_ctb_dados_lancamento 
where	nr_sequencia = nr_sequencia_p;
 
update	w_ctb_lancamento 
set	dt_movimento 	 = dt_movimento_p, 
	nr_seq_agrupamento = nr_seq_agrupamento_w 
where	nr_seq_lancamento = nr_sequencia_p;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_inserir_data_movto ( nr_sequencia_p bigint, dt_movimento_p timestamp) FROM PUBLIC;

