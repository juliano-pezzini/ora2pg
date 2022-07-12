-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qtd_registros_agenda (nr_seq_agenda_p integer) RETURNS integer AS $body$
DECLARE


qt_registros_w	integer(10) := 0;


BEGIN

select 	count(*)
into STRICT	qt_registros_w
from 	prescr_medica a, prescr_material b
where 	a.nr_prescricao = b.nr_prescricao
and 	nr_seq_agenda = nr_seq_agenda_p;


return	qt_registros_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qtd_registros_agenda (nr_seq_agenda_p integer) FROM PUBLIC;
