-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inativar_cig ( nr_atendimento_p bigint, nr_seq_glicemia_p bigint, nr_cig_atend_p bigint, nr_seq_medicao_p bigint, nm_usuario_p text ) AS $body$
DECLARE


qt_medicao_w	bigint;


BEGIN

if (coalesce(nr_seq_medicao_p,0) = 0) then
	begin

	update 	atendimento_cig
	set	ie_status_cig = 'V'
	where	nr_atendimento = nr_atendimento_p
	and	nr_cig_atend = nr_cig_atend_p;

	end;
else
	begin

	update	atendimento_cig
	set	ie_status_cig = 'V'
	where	nr_atendimento = nr_atendimento_p
	and	nr_cig_atend = nr_cig_atend_p
	and	nr_sequencia = nr_seq_medicao_p;

	/* validar status glicemia atendimento */

	if (coalesce(nr_seq_glicemia_p,0) > 0) then
		select	count(*)
		into STRICT	qt_medicao_w
		from	atendimento_cig
		where	nr_seq_glicemia = nr_seq_glicemia_p;

		if (qt_medicao_w = 0) then
			update	atend_glicemia
			set	ie_status_glic	= 'P',
				dt_inicio_glic	 = NULL,
				cd_pf_inic_glic	 = NULL
			where	nr_sequencia	= nr_seq_glicemia_p;
		end if;
	end if;

	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inativar_cig ( nr_atendimento_p bigint, nr_seq_glicemia_p bigint, nr_cig_atend_p bigint, nr_seq_medicao_p bigint, nm_usuario_p text ) FROM PUBLIC;

