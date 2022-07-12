-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_status_ageservico (nr_seq_agenda_p bigint) RETURNS varchar AS $body$
DECLARE


nr_atendimento_w	bigint;
cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;
nr_prescricao_w		bigint;
nr_seq_prescricao_w	prescr_procedimento.nr_sequencia%type;
nr_interno_conta_w	bigint;
ie_status_agenda_w	varchar(2) := '';


BEGIN
if (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '') then
	/* obter dados agenda */

	select	coalesce(a.nr_atendimento,0),
		coalesce(a.cd_procedimento,0),
		coalesce(a.ie_origem_proced,0)
	into STRICT	nr_atendimento_w,
		cd_procedimento_w,
		ie_origem_proced_w
	from	agenda_consulta a
	where	nr_sequencia	= nr_seq_agenda_p;

	/* obter dados prescricao */

	select	/*+index(c PRESMED_AGECONS_FK_I, c PRESPRO_PRESMED_FK_I)*/		coalesce(max(b.nr_prescricao),0),
		coalesce(max(c.nr_sequencia),0)
	into STRICT	nr_prescricao_w,
		nr_seq_prescricao_w
	from	prescr_procedimento c,
		prescr_medica b
	where	c.nr_prescricao		= b.nr_prescricao
	and	c.cd_procedimento	= cd_procedimento_w
	and	c.ie_origem_proced	= ie_origem_proced_w
	and	b.nr_seq_agecons	= nr_seq_agenda_p;

	/* obter dados conta */

	select	coalesce(max(nr_interno_conta),0)
	into STRICT	nr_interno_conta_w
	from	procedimento_paciente
	where	nr_prescricao		= nr_prescricao_w
	and	nr_sequencia_prescricao	= nr_seq_prescricao_w
	and	cd_procedimento		= cd_procedimento_w
	and	ie_origem_proced 	= ie_origem_proced_w;

	/* obter status servico */

	if (nr_interno_conta_w > 0) then
		ie_status_agenda_w	:= 'PE';
	elsif (nr_prescricao_w > 0) or
		((nr_atendimento_w > 0) and (cd_procedimento_w > 0) and (ie_origem_proced_w > 0)) then
		ie_status_agenda_w	:= 'P';
	elsif (nr_atendimento_w > 0) then
		ie_status_agenda_w	:= 'A';
	else
		ie_status_agenda_w	:= 'AA';
	end if;
end if;

return ie_status_agenda_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_status_ageservico (nr_seq_agenda_p bigint) FROM PUBLIC;
