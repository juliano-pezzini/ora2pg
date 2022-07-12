-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_obter_se_proc_bpa ( nr_sequencia_p bigint, cd_procedimento_p bigint) RETURNS varchar AS $body$
DECLARE



ds_retorno_w		varchar(1)	:= 'N';
qt_bpa_w		integer	:= 0;
ie_proc_bpa_w		varchar(2);
ie_tipo_atendimento_w	smallint;



BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	select	coalesce(max(ie_tipo_atendimento),1)
	into STRICT	ie_tipo_atendimento_w
	from	atendimento_paciente	c,
		conta_paciente		b,
		procedimento_paciente	a
	where	a.nr_sequencia		= nr_sequencia_p
	and	a.nr_interno_conta	= b.nr_interno_conta
	and	b.nr_atendimento	= c.nr_atendimento;

	if (ie_tipo_atendimento_w	<> 1) then
		select	count(*)
		into STRICT	qt_bpa_w
		from	sus_bpa_unif 		c,
			conta_paciente		b,
			procedimento_paciente	a
		where	a.nr_interno_conta	= b.nr_interno_conta
		and	b.nr_interno_conta	= c.nr_interno_conta
		and	a.nr_sequencia		= nr_sequencia_p;

		if (qt_bpa_w	= 0) then
			select	Sus_Obter_TipoReg_Proc(cd_procedimento_p, 7, 'C', 1)
			into STRICT	ie_proc_bpa_w
			;
		end if;
	end if;
elsif (coalesce(nr_sequencia_p::text, '') = '') and (cd_procedimento_p IS NOT NULL AND cd_procedimento_p::text <> '') then
	select	Sus_Obter_TipoReg_Proc(cd_procedimento_p, 7, 'C', 1)
	into STRICT	ie_proc_bpa_w
	;
end if;

if (qt_bpa_w > 0) then
	ds_retorno_w	:= 'S';
elsif (ie_proc_bpa_w in (1,2)) then
	ds_retorno_w	:= 'S';
end if;

return ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_obter_se_proc_bpa ( nr_sequencia_p bigint, cd_procedimento_p bigint) FROM PUBLIC;
