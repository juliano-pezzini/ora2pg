-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION eis_obter_se_conta_exige_laudo (nr_interno_conta_p bigint) RETURNS varchar AS $body$
DECLARE


qt_registro_w		bigint;
ie_exige_laudo_w	procedimento.ie_exige_laudo%type;


BEGIN

begin
select	coalesce(max(b.ie_exige_laudo),'N')
into STRICT	ie_exige_laudo_w
from  	procedimento b,
   	procedimento_paciente a
where 	nr_interno_conta		= nr_interno_conta_p
and	a.cd_procedimento		= b.cd_procedimento
and	a.ie_origem_proced 		= b.ie_origem_proced;
exception
when others then
	ie_exige_laudo_w := 'N';
end;

if (ie_exige_laudo_w = 'S') then
	begin

	select	coalesce(count(*),0)
	into STRICT	qt_registro_w
	from  	procedimento b,
		procedimento_paciente a
	where 	nr_interno_conta		= nr_interno_conta_p
	and	a.cd_procedimento		= b.cd_procedimento
	and	a.ie_origem_proced 		= b.ie_origem_proced
	and	coalesce(b.ie_exige_laudo,'N') 	= 'S'
	and	exists (SELECT 	1
			from 	laudo_paciente x
			where	x.nr_seq_proc = a.nr_sequencia
			and	x.nr_prescricao = a.nr_prescricao)  LIMIT 1;

	if (qt_registro_w	= 0) then
		return	'N';
	else
		return	'S';
	end if;

	end;
else
	return wheb_mensagem_pck.get_texto(305520);
	--return 'Não exige';
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION eis_obter_se_conta_exige_laudo (nr_interno_conta_p bigint) FROM PUBLIC;

