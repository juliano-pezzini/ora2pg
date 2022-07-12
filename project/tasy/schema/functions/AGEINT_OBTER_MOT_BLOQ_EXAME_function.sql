-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ageint_obter_mot_bloq_exame ( nr_seq_proc_interno_p bigint, cd_agenda_p bigint, dt_agenda_p timestamp, nr_seq_item_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255):= 'N';
ie_dia_semana_w		integer;
ie_sexo_w			varchar(1)	 := 'A';
qt_idade_pac_w		integer	 := 0;
cd_pessoa_fisica_ww pessoa_fisica.cd_pessoa_fisica%type;


BEGIN
if (nr_seq_proc_interno_p IS NOT NULL AND nr_seq_proc_interno_p::text <> '') then
	select 	obter_cod_dia_semana(dt_agenda_p)
	into STRICT	ie_dia_semana_w
	;

	if (nr_seq_item_p IS NOT NULL AND nr_seq_item_p::text <> '') then

		select	max(a.cd_pessoa_fisica)
		into STRICT	cd_pessoa_fisica_ww
		from	agenda_integrada a,
				agenda_integrada_item b
		where	a.nr_sequencia = b.nr_seq_agenda_int
		and		b.nr_sequencia = nr_seq_item_p;

	end if;

	if (cd_pessoa_fisica_ww IS NOT NULL AND cd_pessoa_fisica_ww::text <> '') then

		select	coalesce(max(c.ie_sexo), 'A'),
				max(trunc(trunc(months_between(clock_timestamp(), c.dt_nascimento)) / 12))
				--max(obter_idade(c.dt_nascimento, sysdate, 'A'))
		into STRICT	ie_sexo_w,
				qt_idade_pac_w
		from	pessoa_fisica c
		where	c.cd_pessoa_fisica = cd_pessoa_fisica_ww;

	end if;

	select	max(substr(ds_motivo_bloqueio,1,255))
	into STRICT	ds_retorno_w
	from	ageint_bloqueio_exame
	where	nr_seq_proc_interno	= nr_seq_proc_interno_p
	and (trunc(dt_agenda_p) >= dt_inicial_vigencia or coalesce(dt_inicial_vigencia::text, '') = '')
	and (trunc(dt_agenda_p) <= dt_final_vigencia or coalesce(dt_final_vigencia::text, '') = '')
	and (dt_agenda_p between to_date(to_char(dt_agenda_p,'dd/mm/yyyy') ||' '|| to_char(hr_inicial,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss')
		and 	to_date(to_char(dt_agenda_p,'dd/mm/yyyy') ||' '|| to_char(hr_final,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss'))
	and	((coalesce(dt_dia_semana, ie_dia_semana_w) = ie_dia_semana_w) or ((dt_dia_semana = 9) and (ie_dia_Semana_w not in (7,1))))
	and	((cd_agenda = cd_agenda_p) or (coalesce(cd_agenda::text, '') = ''))
	and	((coalesce(ie_sexo, 'A') = ie_sexo_w) or (ie_sexo = 'A'))
	and	(((qt_idade_pac_w >= coalesce(qt_idade_min, qt_idade_pac_w)) and (qt_idade_pac_w <= coalesce(qt_idade_max, qt_idade_pac_w))) or (coalesce(qt_idade_pac_w::text, '') = ''));
end if;

return	ds_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ageint_obter_mot_bloq_exame ( nr_seq_proc_interno_p bigint, cd_agenda_p bigint, dt_agenda_p timestamp, nr_seq_item_p bigint) FROM PUBLIC;

