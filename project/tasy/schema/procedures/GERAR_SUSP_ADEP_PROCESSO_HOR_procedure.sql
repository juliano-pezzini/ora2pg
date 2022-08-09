-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_susp_adep_processo_hor (nr_seq_horario_p bigint, ie_evento_p text, nm_usuario_p text) AS $body$
DECLARE


nr_seq_item_proc_w	bigint;
ie_suspender_w		varchar(1);


BEGIN
if (nr_seq_horario_p IS NOT NULL AND nr_seq_horario_p::text <> '') and (ie_evento_p IS NOT NULL AND ie_evento_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then

	/* obter item processo horario */

	select	coalesce(max(nr_sequencia),0)
	into STRICT	nr_seq_item_proc_w
	from	adep_processo_item
	where	nr_seq_horario = nr_seq_horario_p;

	/* suspender item processo horario */

	if (nr_seq_item_proc_w > 0) then

		if (ie_evento_p in ('1','5')) then
			ie_suspender_w := 'S';
		else
			ie_suspender_w := 'N';
		end if;

		CALL suspender_item_adep_processo(nr_seq_item_proc_w,ie_suspender_w,nm_usuario_p);

		CALL gerar_evento_item_adep_proc(nr_seq_item_proc_w,ie_evento_p,clock_timestamp(),nm_usuario_p);

	end if;

end if;

if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_susp_adep_processo_hor (nr_seq_horario_p bigint, ie_evento_p text, nm_usuario_p text) FROM PUBLIC;
