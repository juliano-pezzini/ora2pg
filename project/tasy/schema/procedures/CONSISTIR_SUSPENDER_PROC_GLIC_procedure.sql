-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_suspender_proc_glic (nr_prescricao_p bigint, nr_seq_procedimento_p bigint) AS $body$
DECLARE


qt_glicemia_w	bigint;


BEGIN
if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_procedimento_p IS NOT NULL AND nr_seq_procedimento_p::text <> '') then

	select	count(*)
	into STRICT	qt_glicemia_w
	from	atend_glicemia
	where	nr_prescricao		= nr_prescricao_p
	and	nr_seq_procedimento	= nr_seq_procedimento_p;

	if (qt_glicemia_w > 0) then

		select	count(*)
		into STRICT	qt_glicemia_w
		from	atend_glicemia
		where	nr_prescricao		= nr_prescricao_p
		and	nr_seq_procedimento	= nr_seq_procedimento_p
		and	ie_status_glic 	not in ('P','T','S');

		if (qt_glicemia_w > 0) then
			--- Esse CIG/CCG está em andamento e não pode ser suspenso pela Prescrição.Faz-se necessário terminá-lo pelo Adep.
			CALL Wheb_mensagem_pck.exibir_mensagem_abort(261437);
		else
			update	atend_glicemia
			set	ie_status_glic	= 'S'
			where	nr_prescricao		= nr_prescricao_p
			and	nr_seq_procedimento	= nr_seq_procedimento_p;
		end if;

	end if;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_suspender_proc_glic (nr_prescricao_p bigint, nr_seq_procedimento_p bigint) FROM PUBLIC;
