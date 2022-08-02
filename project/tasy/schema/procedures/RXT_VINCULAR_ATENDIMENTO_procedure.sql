-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE rxt_vincular_atendimento ( nr_seq_tumor_p bigint, nr_atendimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_checklist_w	bigint;

BEGIN

if (nr_seq_tumor_p IS NOT NULL AND nr_seq_tumor_p::text <> '') then
	select	nr_seq_checklist
	into STRICT	nr_seq_checklist_w
	from	rxt_tumor
	where	nr_sequencia = nr_seq_tumor_p;

	update	rxt_tumor
	set	nr_atendimento	= nr_atendimento_p,
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where	nr_sequencia	= nr_seq_tumor_p;

	if (nr_seq_checklist_w IS NOT NULL AND nr_seq_checklist_w::text <> '') then
		update	atendimento_checklist
		set	nr_atendimento 	= nr_atendimento_p,
			nm_usuario	= nm_usuario_p,
			dt_atualizacao	= clock_timestamp()
		where	nr_sequencia 	= nr_seq_checklist_w;
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE rxt_vincular_atendimento ( nr_seq_tumor_p bigint, nr_atendimento_p bigint, nm_usuario_p text) FROM PUBLIC;

