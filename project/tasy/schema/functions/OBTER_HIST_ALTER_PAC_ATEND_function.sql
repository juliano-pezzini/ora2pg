-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_hist_alter_pac_atend (nr_prescricao_p bigint) RETURNS bigint AS $body$
DECLARE


nr_retorno_w			bigint;
nr_seq_atendimento_w	bigint;
ie_possui_hist_w		varchar(1);


BEGIN
nr_retorno_w	:=	0;

if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') then

	select 	coalesce(max(nr_seq_atendimento),0)
	into STRICT	nr_seq_atendimento_w
	from	paciente_atendimento
	where	nr_prescricao	=	nr_prescricao_p;

	if (nr_seq_atendimento_w > 0) then

		select  coalesce(max('S'),'N')
		into STRICT	ie_possui_hist_w
		from	paciente_prot_medic_hist
		where	nr_seq_atendimento = nr_seq_atendimento_w;

		if (ie_possui_hist_w = 'S') then

			nr_retorno_w 	:= 	nr_seq_atendimento_w;

		end if;

	end if;

end if;


return	nr_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_hist_alter_pac_atend (nr_prescricao_p bigint) FROM PUBLIC;
