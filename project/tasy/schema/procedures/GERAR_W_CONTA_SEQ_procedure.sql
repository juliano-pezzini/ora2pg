-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_conta_seq ( seq_inicio_p bigint, seq_final_p bigint) AS $body$
DECLARE



qt_contador_w		bigint;


BEGIN

delete
from w_sequencia_coluna;


for qt_contador_w in seq_inicio_p..seq_final_p loop
	begin

	insert into w_sequencia_coluna(nr_seq_impressao)
	values (qt_contador_w);

	end;
end loop;
commit;



end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_conta_seq ( seq_inicio_p bigint, seq_final_p bigint) FROM PUBLIC;

