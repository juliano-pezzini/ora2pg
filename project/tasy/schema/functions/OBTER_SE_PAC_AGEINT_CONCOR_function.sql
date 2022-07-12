-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_pac_ageint_concor ( nr_Seq_ageint_p bigint, hr_agenda_p timestamp, nr_seq_Ageint_item_p bigint, nr_minuto_duracao_p bigint default 0) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(1)	:= 'N';
cd_pessoa_fisica_w	varchar(10);
cd_pessoa_fisica_int_w	agenda_integrada.cd_pessoa_fisica%type;
qt_marcado_w		integer:= 0;
qt_marcado_exame_w	integer:= 0;
qt_marcado_cons_w	integer:= 0;
qt_marcado_quimio_w	bigint:= 0;
nr_minuto_duracao_w	bigint;
ie_const_outro_agend_w	varchar(1);

BEGIN
ie_const_outro_agend_w := Obter_param_Usuario(865, 234, obter_perfil_ativo, obter_usuario_ativo, obter_estabelecimento_ativo, ie_const_outro_agend_w);

select	max(a.cd_pessoa_fisica),
		max(b.nr_minuto_duracao)
into STRICT	cd_pessoa_fisica_w,
		nr_minuto_duracao_w
from	agenda_integrada a,
		agenda_integrada_item b
where	a.nr_sequencia	= nr_seq_Ageint_p
and		a.nr_sequencia		= b.nr_seq_agenda_int
and		b.nr_sequencia		= nr_seq_ageint_item_p;

select	max(cd_pessoa_fisica)
into STRICT	cd_pessoa_fisica_int_w
from	agenda_integrada
where	nr_sequencia = (SELECT	max(nr_seq_ageint)
						from	ageint_marcacao_usuario
						where	nr_seq_Ageint_item = nr_seq_ageint_item_p);
						
if (coalesce(nr_minuto_duracao_w::text, '') = '') then
	nr_minuto_duracao_w	:= nr_minuto_duracao_p;
end if;

if (qt_marcado_w = 0) then
	begin
	select	1
	into STRICT	qt_marcado_w
	from	ageint_marcacao_usuario a		
	where	((a.hr_agenda	between hr_agenda_p and hr_agenda_p + (nr_minuto_duracao_w-1)/1440) or
			(hr_agenda_p	between a.hr_agenda   and a.hr_agenda + (a.nr_minuto_duracao - 1)/1440))
	and		cd_pessoa_fisica_int_w = cd_pessoa_fisica_w
	and		a.nr_seq_Ageint_item		<> nr_seq_Ageint_item_p
	and		coalesce(a.ie_gerado, 'N')		= 'N'  LIMIT 1;
	
	exception
	when no_data_found then
		qt_marcado_w := 0;
	end;
end if;

/*select	count(*)
into	qt_marcado_quimio_w
from	qt_pendencia_agenda a,
		agenda_quimio_marcacao b
where	a.nr_sequencia	= b.nr_seq_pend_agenda
and		b.dt_agenda	= hr_agenda_p
and		a.cd_pessoa_fisica	= cd_pessoa_fisica_w
and		b.nr_seq_Ageint_item		<> nr_seq_Ageint_item_p
and		nvl(b.ie_gerado, 'N')		= 'N';*/
if (qt_marcado_quimio_w = 0) then
	begin
	select	count(*)
	into STRICT	qt_marcado_quimio_w
	from	agenda_integrada_item a,
			agenda_quimio_marcacao b,
			agenda_integrada c
	where	a.nr_sequencia	= b.nr_seq_ageint_item
	and		a.nr_seq_agenda_int	= c.nr_sequencia
	and		((b.dt_agenda	between hr_agenda_p and hr_agenda_p +   (nr_minuto_duracao_w-1)/1440) or
			 (hr_agenda_p	between b.dt_agenda   and b.dt_agenda + (nr_minuto_duracao  -1)/1440))
	and		c.cd_pessoa_fisica	= cd_pessoa_fisica_w
	and		b.nr_seq_Ageint_item		<> nr_seq_Ageint_item_p
	and		coalesce(b.ie_gerado, 'N')		= 'N'  LIMIT 1;

	if (qt_marcado_quimio_w	= 0) then
		select	1
		into STRICT	qt_marcado_quimio_w
		from	agenda_quimio
		where	cd_pessoa_fisica	= cd_pessoa_fisica_w
		and	((dt_agenda	between hr_agenda_p and hr_agenda_p + (nr_minuto_duracao_w-1)/1440) or
			 (hr_agenda_p	between dt_agenda   and dt_agenda + (nr_minuto_duracao  -1)/1440))
		and		coalesce(nr_seq_ageint_item,0)	<> nr_seq_Ageint_item_p
		and		ie_status_agenda	<> 'C'  LIMIT 1;
	end if;

	exception
	when no_data_found then
		qt_marcado_quimio_w := 0;
	end;
end if;

if (qt_marcado_exame_w = 0) then
	begin
	select	count(*)
	into STRICT	qt_marcado_exame_w
	FROM agenda_paciente a
LEFT OUTER JOIN agenda_integrada_item b ON (a.nr_sequencia = b.nr_seq_agenda_exame)
WHERE ((a.hr_inicio		between hr_agenda_p and hr_agenda_p + (nr_minuto_duracao_w-1)/1440) or
		(hr_agenda_p		between a.hr_inicio and a.hr_inicio + (a.nr_minuto_duracao-1)/1440)) and a.cd_pessoa_fisica	= cd_pessoa_fisica_w and coalesce(b.nr_sequencia,0)	<> nr_seq_Ageint_item_p and ie_Status_Agenda <> 'C'   LIMIT 1;

	exception
	when no_data_found then
		qt_marcado_exame_w := 0;
	end;
end if;
	
	
if (qt_marcado_cons_w = 0) then	
	begin
	select	1
	into STRICT	qt_marcado_cons_w
	FROM agenda_consulta a
LEFT OUTER JOIN agenda_integrada_item b ON (a.nr_sequencia = b.nr_seq_agenda_cons)
WHERE ((a.dt_agenda		between hr_agenda_p and hr_agenda_p + (nr_minuto_duracao_w-1)/1440) or 
		 (hr_agenda_p		between a.dt_agenda and a.dt_agenda + (a.nr_minuto_duracao-1)/1440)) and a.cd_pessoa_fisica	= cd_pessoa_fisica_w and coalesce(b.nr_sequencia,0)	<> nr_seq_Ageint_item_p and a.ie_Status_Agenda <> 'C'   LIMIT 1;

	exception
	when no_data_found then
		qt_marcado_cons_w := 0;
	end;
end if;

if	
	((obter_funcao_ativa <> 865) or -- O parametro so deve ser consistido na Quimio, assim se tiver em funcao diferente da Quimio, ignora o valor do parametro e consiste sempre os agendamentos... OS 713040
	 (ie_const_outro_agend_w = 'S')) and
	((qt_marcado_w		> 0) or (qt_marcado_cons_w 	> 0) or (qt_marcado_exame_w	> 0) or (qt_marcado_quimio_w	> 0))	then
	ds_Retorno_w	:= 'S';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_pac_ageint_concor ( nr_Seq_ageint_p bigint, hr_agenda_p timestamp, nr_seq_Ageint_item_p bigint, nr_minuto_duracao_p bigint default 0) FROM PUBLIC;

