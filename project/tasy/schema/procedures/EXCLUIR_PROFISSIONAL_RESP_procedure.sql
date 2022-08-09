-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE excluir_profissional_resp ( nr_atendimento_p bigint, cd_pessoa_fisica_p text, ie_profissional_p text, nm_usuario_p text, nr_seq_nursing_team_p bigint default null) AS $body$
BEGIN

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
	delete 	from atend_profissional
	where	nr_atendimento 	 = nr_atendimento_p
	and	cd_pessoa_fisica = cd_pessoa_fisica_p
	and	ie_profissional  = ie_profissional_p;
elsif (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (nr_seq_nursing_team_p IS NOT NULL AND nr_seq_nursing_team_p::text <> '') then
  delete 	from atend_profissional
	where	nr_atendimento 	 = nr_atendimento_p
	and	ie_profissional  = ie_profissional_p
  and nr_seq_nursing_team = nr_seq_nursing_team_p;
end if;	

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE excluir_profissional_resp ( nr_atendimento_p bigint, cd_pessoa_fisica_p text, ie_profissional_p text, nm_usuario_p text, nr_seq_nursing_team_p bigint default null) FROM PUBLIC;
