-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_atend_problema (nr_atendimento_p bigint, ie_opcao_p text, nr_seq_problema_p bigint default null) RETURNS varchar AS $body$
DECLARE




-- IE_OPCAO_P
--  I  -  Início  de problema.
--  F -  Fim de problema.
--  R -  Reincidência de prolema.
ie_problema_w	varchar(1) := 'N';


BEGIN

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then

	if (ie_opcao_p = 'I') then
		select	coalesce(max('S'),'N')
		into STRICT  ie_problema_w
		from  lista_problema_pac a
		where  a.nr_atendimento = nr_atendimento_p
		and	  (dt_inicio IS NOT NULL AND dt_inicio::text <> '');
	elsif (ie_opcao_p = 'F') then
		select	coalesce(max('S'),'N')
		into STRICT  ie_problema_w
		from  lista_problema_pac a
		where  a.nr_atendimento = nr_atendimento_p
		and	  (dt_inicio IS NOT NULL AND dt_inicio::text <> '');
	elsif (ie_opcao_p = 'R') then
		select	coalesce(max('S'),'N')
		into STRICT  ie_problema_w
		from  lista_problema_pac_incid a
		where  a.nr_atendimento = nr_atendimento_p;
	elsif (ie_opcao_p = 'P') then
		select	coalesce(max('S'),'N')
		into STRICT  ie_problema_w
		from  lista_problema_pac_incid a
		where  a.nr_atendimento = nr_atendimento_p
		AND	A.NR_SEQ_PROBLEMA = nr_seq_problema_p;
	end if;
end if;
return	ie_problema_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_atend_problema (nr_atendimento_p bigint, ie_opcao_p text, nr_seq_problema_p bigint default null) FROM PUBLIC;

