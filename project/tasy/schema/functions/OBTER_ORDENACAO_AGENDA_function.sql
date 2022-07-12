-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ordenacao_agenda ( cd_agenda_p bigint, nr_seq_proc_interno_p bigint default null, cd_medico_p text default null) RETURNS varchar AS $body$
DECLARE



nr_seq_prioridade_w	bigint := 0;


BEGIN

if (coalesce(nr_seq_proc_interno_p,0) > 0) then
	select	coalesce(max(nr_seq_prioridade),0)
	into STRICT		nr_seq_prioridade_w
	from		agenda_proc_prioridade
	where		cd_agenda				=	cd_agenda_p
	and		nr_seq_proc_interno	=	nr_seq_proc_interno_p;
end if;

if (nr_seq_prioridade_w = 0) and (cd_medico_p IS NOT NULL AND cd_medico_p::text <> '') then
	select	coalesce(max(nr_seq_prioridade),0)
	into STRICT		nr_seq_prioridade_w
	from		agenda_medico_prioridade
	where		cd_agenda			=	cd_agenda_p
	and		cd_pessoa_fisica	=	cd_medico_p;
end if;

if (nr_seq_prioridade_w = 0) then
	nr_seq_prioridade_w	:= 9999999999;
end if;

return	nr_seq_prioridade_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ordenacao_agenda ( cd_agenda_p bigint, nr_seq_proc_interno_p bigint default null, cd_medico_p text default null) FROM PUBLIC;
