-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE finaliza_movimentacao_fanep ( nr_seq_processo_p bigint, dt_termino_p timestamp, nm_usuario_p text) AS $body$
DECLARE

nr_seq_atepacu_w	bigint;

BEGIN

select 	max(nr_seq_atepacu)
into STRICT	nr_seq_atepacu_w
from 	pepo_cirurgia
where 	nr_sequencia = nr_seq_processo_p;

if (nr_seq_atepacu_w IS NOT NULL AND nr_seq_atepacu_w::text <> '') then
	update 	atend_paciente_unidade
	set 	dt_saida_interno = dt_termino_p,
		dt_saida_unidade = dt_termino_p
	where 	nr_seq_interno = nr_seq_atepacu_w;
end if;

update 	pepo_cirurgia
set 	dt_fim_cirurgia = dt_termino_p
where 	nr_sequencia = nr_seq_processo_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE finaliza_movimentacao_fanep ( nr_seq_processo_p bigint, dt_termino_p timestamp, nm_usuario_p text) FROM PUBLIC;

