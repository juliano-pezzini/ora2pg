-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lab_obter_etapa_ant (nr_prescricao_p bigint, nr_seq_prescricao_p bigint, ie_etapa_atual_p bigint, ie_opcao_p bigint) RETURNS varchar AS $body$
DECLARE


nr_seq_etapa_atual_w	bigint;
nr_seq_etapa_ant_w	bigint;
ie_etapa_ant_w		varchar(10);
dt_etapa_ant_w		timestamp;

/* 	0 - etapa
	1 - data */
BEGIN
select 	min(nr_sequencia)
into STRICT	nr_seq_etapa_atual_w
from 	prescr_proc_etapa
where 	nr_prescricao = nr_prescricao_p
and	nr_seq_prescricao = nr_seq_prescricao_p
and	ie_etapa	= ie_etapa_atual_p;


select 	max(nr_sequencia)
into STRICT	nr_seq_etapa_ant_w
from 	prescr_proc_etapa
where 	nr_prescricao = nr_prescricao_p
and	nr_seq_prescricao = nr_seq_prescricao_p
and	nr_sequencia	< nr_seq_etapa_atual_w;

select	max(ie_etapa),
	max(dt_atualizacao)
into STRICT	ie_etapa_ant_w,
	dt_etapa_ant_w
from 	prescr_proc_etapa
where	nr_sequencia = nr_seq_etapa_ant_w
and	nr_prescricao = nr_prescricao_p
and	nr_seq_prescricao = nr_seq_prescricao_p;

if (ie_opcao_p = 1) then
	return	to_char(dt_etapa_ant_w, 'dd/mm/yyyy hh24:mi:ss');
else
	return 	ie_etapa_ant_w;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lab_obter_etapa_ant (nr_prescricao_p bigint, nr_seq_prescricao_p bigint, ie_etapa_atual_p bigint, ie_opcao_p bigint) FROM PUBLIC;
