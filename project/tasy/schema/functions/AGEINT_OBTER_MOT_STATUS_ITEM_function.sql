-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ageint_obter_mot_status_item (nr_seq_agenda_int_p bigint, nr_sequencia_item_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w    varchar(255);
nr_seq_agenda_cons_w    bigint;
nr_seq_agenda_exame_w   bigint;
ds_status_w             varchar(100);
ie_status_agenda_w      varchar(3);
nr_seq_agequi_w		bigint;


BEGIN

select  coalesce(nr_seq_agenda_cons,0),
        coalesce(nr_seq_agenda_exame,0),
	coalesce(nr_seq_agequi,0)
into STRICT    nr_seq_agenda_cons_w,
        nr_seq_agenda_exame_w,
	nr_seq_agequi_w
from    agenda_integrada_item
where   nr_sequencia = nr_sequencia_item_p
and     nr_seq_agenda_int = nr_seq_agenda_int_p;

if (nr_seq_agenda_cons_w <> 0) then
        select  substr(max(a.ds_motivo_Status),1,255)
        into STRICT    ds_retorno_w
        from    agenda_consulta a
        where   a.nr_sequencia = nr_seq_agenda_cons_w;
elsif (nr_seq_agenda_exame_w <> 0) then
        select  substr(max(a.ds_motivo_Status),1,255)
        into STRICT    ds_retorno_w
        from    agenda_paciente a
        where   a.nr_sequencia = nr_seq_agenda_exame_w;
elsif (nr_seq_agequi_w <> 0) then
        select  substr(max(a.ds_motivo_status),1,255)
        into STRICT    ds_retorno_w
        from    agenda_quimio a
        where   a.nr_sequencia = nr_seq_agequi_w;
end if;

return  ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ageint_obter_mot_status_item (nr_seq_agenda_int_p bigint, nr_sequencia_item_p bigint) FROM PUBLIC;
