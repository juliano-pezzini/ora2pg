-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ageint_valores_hor_check_dt ( nr_seq_item_p bigint, nr_minuto_duracao_p INOUT bigint, hr_reserva_p INOUT timestamp, qt_marcado_p INOUT bigint) AS $body$
BEGIN
	select	max(nr_minuto_duracao)
	into STRICT	nr_minuto_duracao_p
	from	agenda_integrada_item
	where	nr_sequencia = nr_seq_item_p;
	
	select	max(hr_Agenda)
	into STRICT	hr_reserva_p
	from	ageint_marcacao_usuario
	where	nr_seq_ageint_item = nr_seq_item_p;
	
	select	count(*)
	into STRICT	qt_marcado_p
	from	ageint_marcacao_usuario
	where	nr_seq_ageint_item = nr_seq_item_p
	and	coalesce(ie_horario_auxiliar,'N') = 'N';
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_valores_hor_check_dt ( nr_seq_item_p bigint, nr_minuto_duracao_p INOUT bigint, hr_reserva_p INOUT timestamp, qt_marcado_p INOUT bigint) FROM PUBLIC;

