-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_paciente_doacao (nr_seq_doacao_p bigint) AS $body$
DECLARE


nr_seq_status_doacao_w	bigint;


BEGIN

select	coalesce(max(nr_sequencia),0)
into STRICT	nr_seq_status_doacao_w
from    san_status_doacao
where   ie_status_doacao = 3
and     coalesce(ie_situacao,'A') = 'A';

if (nr_seq_status_doacao_w > 0) then
	
	update	san_doacao
	set	dt_atualizacao = clock_timestamp(),
	    dt_triagem_clinica = clock_timestamp(),
		nr_Seq_status = nr_seq_status_doacao_w
	where	nr_Sequencia = nr_Seq_Doacao_p;
	
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_paciente_doacao (nr_seq_doacao_p bigint) FROM PUBLIC;

