-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_funcao_medico_partic (nr_seq_propaci_p procedimento_participante.nr_sequencia%type, nr_seq_partic_p procedimento_participante.nr_seq_partic%type) RETURNS varchar AS $body$
DECLARE

			
ie_funcao_w	procedimento_participante.ie_funcao%type;
			

BEGIN

	if (coalesce(nr_seq_propaci_p,0) > 0) and (coalesce(nr_seq_partic_p,0) > 0) then
		
		select	a.ie_funcao
		into STRICT	ie_funcao_w
		from	procedimento_participante a
		where	a.nr_sequencia = nr_seq_propaci_p
		and	a.nr_seq_partic = nr_seq_partic_p;
		
	end if;

	return ie_funcao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_funcao_medico_partic (nr_seq_propaci_p procedimento_participante.nr_sequencia%type, nr_seq_partic_p procedimento_participante.nr_seq_partic%type) FROM PUBLIC;
