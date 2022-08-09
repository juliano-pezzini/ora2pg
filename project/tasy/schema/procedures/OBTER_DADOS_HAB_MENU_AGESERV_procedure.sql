-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_dados_hab_menu_ageserv ( cd_pessoa_fisica_p text, cd_agenda_p bigint, nr_seq_agecons_p bigint, dt_agenda_p timestamp, nr_atendimento_p bigint, nm_usuario_prof_p text, cd_perfil_p bigint, ie_permite_cancelar_p INOUT text, ie_permite_encaixar_p INOUT text, ie_pront_solic_agenda_p INOUT text, dt_alta_p INOUT text, qt_agecons_p INOUT bigint, ie_profissional_p INOUT text, ie_status_agenda_p INOUT text, ie_consulta_p INOUT text) AS $body$
BEGIN
if (cd_agenda_p IS NOT NULL AND cd_agenda_p::text <> '') then
	begin
	select	substr(obter_agenda_regra_permissao(cd_pessoa_fisica_p, cd_agenda_p, 'C', cd_perfil_p), 1,1),
		substr(obter_agenda_regra_permissao(cd_pessoa_fisica_p, cd_agenda_p, 'E', cd_perfil_p), 1,1),
		substr(obter_se_pront_solic_agenda(cd_pessoa_fisica_p, cd_agenda_p, nr_seq_agecons_p, dt_agenda_p), 1,1)
	into STRICT	ie_permite_cancelar_p,
		ie_permite_encaixar_p,
		ie_pront_solic_agenda_p
	;
	end;
end if;

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then
	begin
	select	substr(obter_dados_atendimento(nr_atendimento_p, 'DA'), 1,19)
	into STRICT	dt_alta_p
	;
	end;
end if;

if (nr_seq_agecons_p IS NOT NULL AND nr_seq_agecons_p::text <> '') then
	begin
	select	count(*)
	into STRICT	qt_agecons_p
	from	prescr_medica
	where	nr_seq_agecons = nr_seq_agecons_p;

	select	substr(obter_status_ageservico(nr_seq_agecons_p), 1,3)
	into STRICT	ie_status_agenda_p
	;
	end;
end if;

if (nr_seq_agecons_p IS NOT NULL AND nr_seq_agecons_p::text <> '') then
	select CASE WHEN count(1)=0 THEN 'N'  ELSE 'S' END
	into STRICT ie_consulta_p
	from orcamento_paciente
	where exists (SELECT 1
	             from 	orcamento_paciente a,
			agenda_consulta b
             	             where 	a.nr_seq_agecons = b.nr_sequencia
	             and 	b.nr_sequencia = nr_seq_agecons_p);
end if;

select	substr(obter_classe_prof_usuario(nm_usuario_prof_p), 1,15)
into STRICT	ie_profissional_p
;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_dados_hab_menu_ageserv ( cd_pessoa_fisica_p text, cd_agenda_p bigint, nr_seq_agecons_p bigint, dt_agenda_p timestamp, nr_atendimento_p bigint, nm_usuario_prof_p text, cd_perfil_p bigint, ie_permite_cancelar_p INOUT text, ie_permite_encaixar_p INOUT text, ie_pront_solic_agenda_p INOUT text, dt_alta_p INOUT text, qt_agecons_p INOUT bigint, ie_profissional_p INOUT text, ie_status_agenda_p INOUT text, ie_consulta_p INOUT text) FROM PUBLIC;
