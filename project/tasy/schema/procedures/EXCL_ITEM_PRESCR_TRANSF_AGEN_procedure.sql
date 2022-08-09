-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE excl_item_prescr_transf_agen ( nm_usuario_p text, nr_seq_agenda_p bigint ) AS $body$
DECLARE


qt_motivo_baixa_w	bigint;
nr_prescricao_w		bigint;
nr_cirurgia_w		bigint;
cd_pessoa_agenda_w	varchar(10);
cd_pessoa_prescricao_w	varchar(10);
dt_liberacao_w		timestamp;


BEGIN

if (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '') then
	select 	coalesce(max(nr_prescricao),0)
	into STRICT	nr_prescricao_w
	from	prescr_medica
	where	nr_seq_agenda =	nr_seq_agenda_p;

	if (nr_prescricao_w = 0)	then
		select 	coalesce(max(nr_cirurgia),0)
		into STRICT	nr_cirurgia_w
		from	cirurgia
		where	nr_seq_agenda = nr_seq_agenda_p;

		select 	coalesce(max(nr_prescricao),0)
		into STRICT	nr_prescricao_w
		from	cirurgia
		where	nr_cirurgia = nr_cirurgia_w;
	end if;

	select 	max(dt_liberacao)
	into STRICT	dt_liberacao_w
	from	prescr_medica
	where	nr_prescricao =  nr_prescricao_w;

	select 	max(cd_pessoa_fisica)
	into STRICT	cd_pessoa_agenda_w
	from	agenda_paciente
	where	nr_sequencia = 	nr_seq_agenda_p;

	select  max(cd_pessoa_fisica)
	into STRICT	cd_pessoa_prescricao_w
	from	prescr_medica
	where	nr_prescricao =	nr_prescricao_w;

	select 	sum(total)
	into STRICT	qt_motivo_baixa_w
	from (
		SELECT 	count(*) total
		from	prescr_material
		where	nr_prescricao = nr_prescricao_w
		and	cd_motivo_baixa <> 0
		
union

		SELECT	count(*)
		from	prescr_procedimento
		where	nr_prescricao = nr_prescricao_w
		and	cd_motivo_baixa <> 0) alias3;

	if (qt_motivo_baixa_w = 0) and (nr_prescricao_w IS NOT NULL AND nr_prescricao_w::text <> '') and (coalesce(dt_liberacao_w::text, '') = '') and (cd_pessoa_agenda_w = cd_pessoa_prescricao_w) then

		delete
		from	prescr_material
		where	nr_prescricao	=	nr_prescricao_w;

		delete
		from	prescr_procedimento
		where	nr_prescricao	=	nr_prescricao_w;

		update	agenda_paciente
		set	nr_cirurgia 	 = NULL,
			nm_usuario	=	nm_usuario_p,
			dt_atualizacao  = 	clock_timestamp()
		where	nr_sequencia	= 	nr_seq_agenda_p;

		update	prescr_medica
		set	nr_seq_agenda	 = NULL
		where	nr_prescricao	=	nr_prescricao_w;

		update	cirurgia
		set	nr_seq_agenda	 = NULL
		where	nr_seq_agenda	=	nr_seq_agenda_p;

	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE excl_item_prescr_transf_agen ( nm_usuario_p text, nr_seq_agenda_p bigint ) FROM PUBLIC;
