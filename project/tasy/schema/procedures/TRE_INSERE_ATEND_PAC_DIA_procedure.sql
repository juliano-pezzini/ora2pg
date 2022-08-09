-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tre_insere_atend_pac_dia ( nr_atendimento_p bigint, nr_seq_inscrito_p bigint, dt_registro_p timestamp, nm_usuario_p text) AS $body$
DECLARE


nr_seq_pac_dia_w	bigint;


BEGIN
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (nr_seq_inscrito_p IS NOT NULL AND nr_seq_inscrito_p::text <> '') then
	select	coalesce(max(nr_sequencia),0)
	into STRICT	nr_seq_pac_dia_w
	from	tre_paciente_dia
	where	nr_seq_inscrito = nr_seq_inscrito_p
	and	trunc(dt_registro) = trunc(dt_registro_p);

	if (nr_seq_pac_dia_w = 0) then
		nr_seq_pac_dia_w := tre_insere_pac_dia(nr_seq_inscrito_p, dt_registro_p, nm_usuario_p, nr_seq_pac_dia_w);
	end if;

	if (nr_seq_pac_dia_w > 0) then

		update	tre_paciente_dia
		set	nr_atendimento = nr_atendimento_p,
			ie_status_paciente = 'AD'
		where	nr_sequencia = nr_seq_pac_dia_w;

	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tre_insere_atend_pac_dia ( nr_atendimento_p bigint, nr_seq_inscrito_p bigint, dt_registro_p timestamp, nm_usuario_p text) FROM PUBLIC;
