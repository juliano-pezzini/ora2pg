-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_nr_controle_exame ( nm_usuario_p text, nr_controle_exame_ant_p text, nr_controle_exame_nov_p text, nr_sequencia_p bigint, nr_prescricao_p bigint) AS $body$
BEGIN


if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') then

	/*insert into logxxxx_tasy values (sysdate,nm_usuario_p,55892,'Novo nr controle: ' || nr_controle_exame_nov_p || ' Nr controle anterior : ' || nr_controle_exame_ant_p ||
				    ' Prescrição: ' || nr_prescricao_p || ' Nr sequencia: ' ||nr_sequencia_p);*/
	update	prescr_procedimento
	set	nr_controle_exame = nr_controle_exame_nov_p,
		dt_atualizacao 	  = clock_timestamp(),
		nm_usuario        = nm_usuario_p
	where	nr_prescricao     = nr_prescricao_p
	and	nr_sequencia      = nr_sequencia_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_nr_controle_exame ( nm_usuario_p text, nr_controle_exame_ant_p text, nr_controle_exame_nov_p text, nr_sequencia_p bigint, nr_prescricao_p bigint) FROM PUBLIC;
