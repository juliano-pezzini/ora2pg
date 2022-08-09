-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cons_dias_agend_duplic_pf ( nr_seq_agend_p bigint, cd_pessoa_fisica_p text, cd_estabelecimento_p bigint, qt_regra_p INOUT bigint, ds_mensagem_p INOUT text) AS $body$
DECLARE



dt_agenda_w 		timestamp;
qt_dias_regra_w		bigint;
qt_agendamentos_w 	bigint;
ds_mensagem_w		varchar(255) := null;
ds_agenda_w		varchar(80);
hr_inicio_w		varchar(40);
nr_sequencia_w		agenda_paciente.nr_sequencia%type;


BEGIN

ds_mensagem_p := null;

select	max(dt_agenda)
into STRICT	dt_agenda_w
from	agenda_paciente
where	nr_sequencia = nr_seq_agend_p;


select	obter_parametro_agenda(cd_estabelecimento_p, 'QT_AGENDA_PAC',null)
into STRICT	qt_dias_regra_w
;

if (qt_dias_regra_w IS NOT NULL AND qt_dias_regra_w::text <> '') and (qt_dias_regra_w > 0)then

	if (qt_dias_regra_w = 1) then
	
		select 	max(nr_sequencia)
		into STRICT	nr_sequencia_w
		from	agenda_paciente
		where	cd_pessoa_fisica = cd_pessoa_fisica_p
		and	trunc(dt_agenda) = dt_agenda_w
		and	nr_sequencia 	<> nr_seq_agend_p;
		
		if (nr_sequencia_w IS NOT NULL AND nr_sequencia_w::text <> '') then
			qt_agendamentos_w := 1;
		end if;	
	else if (qt_dias_regra_w > 1) then
	
		qt_dias_regra_w := qt_dias_regra_w -1;
		
		select 	max(nr_sequencia)
		into STRICT	nr_sequencia_w
		from	agenda_paciente
		where	cd_pessoa_fisica = cd_pessoa_fisica_p
		and	trunc(dt_agenda) between(dt_agenda_w - qt_dias_regra_w) and (dt_agenda_w + qt_dias_regra_w)
		and	nr_sequencia <> nr_seq_agend_p;
		
		if (nr_sequencia_w IS NOT NULL AND nr_sequencia_w::text <> '') then
			qt_agendamentos_w := 1;
		end if;	
	end if;
	end if;
end if;

if (qt_agendamentos_w > 0) then
	qt_regra_p		:= qt_agendamentos_w;
	if (nr_sequencia_w IS NOT NULL AND nr_sequencia_w::text <> '') then
		select	substr(obter_desc_agenda(cd_agenda),1,80),
			to_char(hr_inicio,'dd/mm/yyyy hh24:mi:ss')
		into STRICT	ds_agenda_w,
			hr_inicio_w
		from	agenda_paciente
		where	nr_sequencia = nr_sequencia_w;
		ds_mensagem_p := Wheb_mensagem_pck.get_texto(306312, 'DS_AGENDA_W=' || ds_agenda_w || ';' || 'HR_INICIO_W=' || hr_inicio_w); -- Esse paciente possui agendamento na sala #@DS_AGENDA_W#@ as #@HR_INICIO_W#@
	end if;	
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cons_dias_agend_duplic_pf ( nr_seq_agend_p bigint, cd_pessoa_fisica_p text, cd_estabelecimento_p bigint, qt_regra_p INOUT bigint, ds_mensagem_p INOUT text) FROM PUBLIC;
