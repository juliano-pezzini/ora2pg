-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION plt_obter_prescricao ( nr_prescricao_p bigint, nr_prescricoes_p text, nr_prescr_titulo_p bigint, nm_usuario_p text, cd_pessoa_fisica_p text, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE


/*
	ie_opcao_p
	P = Prescrição do usuário que está estendendo
	U - Última(maior) prescrição do paciente
*/
nr_prescricao_w		bigint;


BEGIN

if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') then

	nr_prescricao_w	:= nr_prescricao_p;

elsif (nr_prescricoes_p IS NOT NULL AND nr_prescricoes_p::text <> '') then

	if (ie_opcao_p = 'U') then
		nr_prescricao_w := plt_obter_max_nr_prescricao(nr_prescricoes_p);
	else
		nr_prescricao_w := plt_obter_max_nr_prescr_user(nr_prescricoes_p, cd_pessoa_fisica_p, nm_usuario_p);
	end if;

elsif (nr_prescr_titulo_p IS NOT NULL AND nr_prescr_titulo_p::text <> '') and (nr_prescr_titulo_p <> 1) then

	nr_prescricao_w := (nr_prescr_titulo_p)::numeric;

end if;

return nr_prescricao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION plt_obter_prescricao ( nr_prescricao_p bigint, nr_prescricoes_p text, nr_prescr_titulo_p bigint, nm_usuario_p text, cd_pessoa_fisica_p text, ie_opcao_p text) FROM PUBLIC;
