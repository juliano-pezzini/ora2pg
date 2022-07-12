-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_proc_ref (nr_sequencia_p bigint, ie_int_conv_p text) RETURNS varchar AS $body$
DECLARE


cd_proc_convenio_w		varchar(20);
cd_procedimento_w			bigint;
ie_origem_proced_w		bigint;
cd_convenio_w			integer;
cd_especialidade_medica_w	integer;
ie_tipo_atendimento_w	smallint;


BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	begin
	select cd_procedimento,
		ie_origem_proced,
		cd_convenio,
		cd_especialidade,
		obter_tipo_atendimento(nr_atendimento)
	into STRICT	cd_procedimento_w,
		ie_origem_proced_w,
		cd_convenio_w,
		cd_especialidade_medica_w,
		ie_tipo_atendimento_w
	from procedimento_paciente
	where nr_sequencia	= nr_sequencia_p;
	exception
		when others then
		cd_procedimento_w := null;
	end;
end if;

if (ie_int_conv_p	= 'C') then
	begin
	select Obter_Codigo_Item_Convenio(cd_convenio_w,1,cd_procedimento_w,ie_origem_proced_w,'N', cd_especialidade_medica_w, null, ie_tipo_atendimento_w)
	into STRICT	 cd_proc_convenio_w
	;
	exception
		when others then
		cd_proc_convenio_w := cd_procedimento_w;
	end;
end if;

if (ie_int_conv_p	= 'C') then
	RETURN cd_proc_convenio_w;
else
	RETURN cd_procedimento_w;
end if;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_proc_ref (nr_sequencia_p bigint, ie_int_conv_p text) FROM PUBLIC;

