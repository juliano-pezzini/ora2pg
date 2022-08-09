-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE registra_data_fim_equipamento ( nr_sequencia_p bigint, nr_atendimento_p bigint, dt_fim_p timestamp) AS $body$
DECLARE


qt_existe_w smallint;


BEGIN

if (dt_fim_p IS NOT NULL AND dt_fim_p::text <> '') then
	Select	count(*)
	into STRICT	qt_existe_w
	from	equipamento_cirurgia
	where	nr_atendimento	= nr_atendimento_p
	and		nr_sequencia 	= nr_sequencia_p;

	if (qt_existe_w > 0) then
		update  equipamento_cirurgia
		set 	dt_fim 		   = dt_fim_p,
				dt_atualizacao = clock_timestamp()
		where 	nr_atendimento = nr_atendimento_p
		and 	nr_sequencia = nr_sequencia_p;
		commit;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE registra_data_fim_equipamento ( nr_sequencia_p bigint, nr_atendimento_p bigint, dt_fim_p timestamp) FROM PUBLIC;
