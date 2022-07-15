-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_recurso_disponivel (nr_seq_agenda_p bigint, nr_seq_recurso_p bigint, ds_erro_p INOUT text) AS $body$
DECLARE


dt_inicial_w		timestamp;
dt_final_w		timestamp;
qt_recurso_agen_w	bigint;
qt_recurso_w		bigint;
ie_consiste_w		varchar(1);
ds_erro_w		varchar(4000);


BEGIN

ds_erro_w := '';

select	dt_agenda,
	coalesce(dt_final,dt_agenda + (nr_minuto_duracao/ 1440) - (1/86400))
into STRICT	dt_inicial_w,
	dt_final_w
from	agenda_tasy
where	nr_sequencia	= nr_seq_agenda_p;

select	count(*)
into STRICT	qt_recurso_agen_w
from	agenda_tasy_recurso a
where	a.nr_seq_recurso = nr_seq_recurso_p
and	exists (SELECT	1
		from 	agenda_tasy b
		where	a.nr_seq_agenda = b.nr_sequencia
		and	b.ie_status in ('M','E')
		and	((b.dt_agenda between dt_inicial_w and dt_final_w) or
			(b.dt_agenda + (b.nr_minuto_duracao / 1440) - (1/86400) between dt_inicial_w and dt_final_w) or
			((b.dt_agenda < dt_inicial_w) and (b.dt_agenda + (b.nr_minuto_duracao / 1440) - (1/86400) > dt_final_w))))
and	a.nr_seq_agenda <> nr_seq_agenda_p;

select	coalesce(max(qt_recurso),999)
into STRICT	qt_recurso_w
from	recurso_agenda
where	nr_sequencia = nr_seq_recurso_p;

if (qt_recurso_w <= qt_recurso_agen_w) then
	ds_erro_w := wheb_mensagem_pck.get_texto(279149);
end if;

ds_erro_p := ds_erro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_recurso_disponivel (nr_seq_agenda_p bigint, nr_seq_recurso_p bigint, ds_erro_p INOUT text) FROM PUBLIC;

