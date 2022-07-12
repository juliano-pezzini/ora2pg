-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_consiste_severidade_apres ( cd_perfil_p bigint, nr_atendimento_p text, ie_severidade_p text) RETURNS varchar AS $body$
DECLARE

					nr_seq_regra_w 			bigint:= 0;
ie_severidade_exibe_w	varchar(5):= 'N';
cd_setor_atendimento_w	integer;

c01 CURSOR FOR
SELECT	b.ie_severidade_exibe
from	cpoe_regra_consistencia a,
		cpoe_regra_interacao b
where	coalesce(a.cd_perfil,cd_perfil_p) = cd_perfil_p
and		((coalesce(a.cd_setor_atendimento,cd_setor_atendimento_w) = cd_setor_atendimento_w) or (coalesce(a.cd_setor_atendimento::text, '') = '' and coalesce(nr_atendimento_p::text, '') = ''))
and		b.nr_seq_regra = a.nr_sequencia
and   coalesce(b.ie_situacao, 'A') = 'A'
order by coalesce(a.cd_perfil,0), coalesce(a.cd_setor_atendimento,0);


BEGIN

cd_setor_atendimento_w := obter_setor_atendimento(nr_atendimento_p);

open c01;
loop
fetch c01 into ie_severidade_exibe_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	
	if (ie_severidade_exibe_w = 'L') then
		return 'S';
	elsif ((ie_severidade_exibe_w = 'M')  and (ie_severidade_p in ('M', 'S', 'I'))) then
		return 'S';
	elsif ((ie_severidade_exibe_w = 'S') and (ie_severidade_p in ('S', 'I'))) then
		return 'S';
	elsif (ie_severidade_p = ie_severidade_exibe_w) then
		return 'S';
	end if;
		
	end;
end loop;
close c01;

return 'N';

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_consiste_severidade_apres ( cd_perfil_p bigint, nr_atendimento_p text, ie_severidade_p text) FROM PUBLIC;

