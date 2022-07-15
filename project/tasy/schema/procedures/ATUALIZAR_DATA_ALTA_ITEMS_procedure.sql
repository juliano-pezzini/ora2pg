-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_data_alta_items (nr_atendimento_p bigint, dt_alta_p timestamp ) AS $body$
DECLARE


qt_proc_w	integer;
qt_mat_w	integer;
nr_sequencia_w 	bigint;
nr_sequencia_w2 	bigint;

C01 CURSOR FOR
	SELECT	x.nr_sequencia
	from 	procedimento_paciente 	x,
		conta_paciente		y
	where 	x.nr_interno_conta = y.nr_interno_conta
	and 	y.nr_atendimento   = nr_atendimento_p
	and	y.ie_status_acerto = 1
	and 	x.dt_conta > dt_alta_p;

C02 CURSOR FOR
	SELECT	x.nr_sequencia
	from 	material_atend_paciente 	x,
		conta_paciente			y
	where 	x.nr_interno_conta = y.nr_interno_conta
	and 	y.nr_atendimento   = nr_atendimento_p
	and	y.ie_status_acerto = 1
	and 	x.dt_conta > dt_alta_p;


BEGIN

select	count(*)
into STRICT	qt_proc_w
from 	procedimento_paciente 	x,
	conta_paciente		y
where 	x.nr_interno_conta = y.nr_interno_conta
and 	y.nr_atendimento   = nr_atendimento_p
and	y.ie_status_acerto = 1
and 	x.dt_conta > dt_alta_p;


if (qt_proc_w > 0) then

	open C01;
	loop
	fetch C01 into
		nr_Sequencia_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin


			update	procedimento_paciente a
			set	a.dt_conta = dt_alta_p
			where 	a.nr_atendimento = nr_atendimento_p
			and	a.nr_sequencia = nr_sequencia_w;
		end;
	end loop;
	close C01;

end if;

select	count(*)
into STRICT	qt_mat_w
from 	material_atend_paciente 	x,
	conta_paciente			y
where 	x.nr_interno_conta = y.nr_interno_conta
and 	y.nr_atendimento   = nr_atendimento_p
and	y.ie_status_acerto = 1
and 	x.dt_conta > dt_alta_p;


if (qt_mat_w > 0) then

	open C02;
	loop
	fetch C02 into
		nr_sequencia_w2;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin


			update	material_atend_paciente a
			set	a.dt_conta = dt_alta_p
			where 	a.nr_atendimento = nr_atendimento_p
			and	a.nr_sequencia = nr_sequencia_w2;
		end;
	end loop;
	close C02;

end if;

if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_data_alta_items (nr_atendimento_p bigint, dt_alta_p timestamp ) FROM PUBLIC;

