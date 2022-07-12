-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION agenserv_regra_permissao (cd_agenda_p bigint, nr_seq_exame_p bigint, nr_seq_proc_interno_p bigint, cd_procedimento_p bigint, ie_origem_proced_p text, ie_somente_proced_adic_p text, ie_situacao_p text, nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


qt_regra	bigint;
retorno		varchar(255);


BEGIN

select 	count(1)
into STRICT 	qt_regra
from	ageserv_proced_permissao
where	coalesce(cd_agenda,0) 			= coalesce(cd_agenda_p,0)
and	coalesce(nr_seq_exame,0)			= coalesce(nr_seq_exame_p,0)
and    	coalesce(nr_seq_proc_interno,0) 		= coalesce(nr_seq_proc_interno_p,0)
and    	coalesce(cd_procedimento,0) 			= coalesce(cd_procedimento_p,0)
and    	coalesce(ie_origem_proced,0) 		= coalesce(ie_origem_proced_p,0)
and    	coalesce(ie_somente_proced_adic,'X')		= coalesce(ie_somente_proced_adic_p,'X')
and    	coalesce(ie_situacao,'X') 			= coalesce(ie_situacao_p ,'X')
and	nr_sequencia 				<> nr_sequencia_p;

if (qt_regra > 0) then
	retorno :=  'N';
else
	retorno :=  'S';
end if;

return	retorno;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION agenserv_regra_permissao (cd_agenda_p bigint, nr_seq_exame_p bigint, nr_seq_proc_interno_p bigint, cd_procedimento_p bigint, ie_origem_proced_p text, ie_somente_proced_adic_p text, ie_situacao_p text, nr_sequencia_p bigint) FROM PUBLIC;
