-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_resp_atend_agenda_param ( cd_estabelecimento_p bigint, ie_agenda_p text) RETURNS varchar AS $body$
DECLARE


/*
Esta function retorna o nome do atributo no dicionário de dados.
Será utilizada no momento de geração do atendimento a partir da agenda na Agenda Exames Nova
*/
/*
ie_agenda_p
E = agenda de Exames
S = agenda de Serviços

*/
ie_medico_resp_atend_w		varchar(1);
nm_atributo_w			varchar(50);


BEGIN
if (cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') and (ie_agenda_p = 'E') then
	select	obter_parametro_agenda(cd_estabelecimento_p, 'IE_MEDICO_RESP_ATEND', 'R')
	into STRICT	ie_medico_resp_atend_w
	;

	if (ie_medico_resp_atend_w = 'R') then
		nm_atributo_w := 'CD_MEDICO';
	elsif (ie_medico_resp_atend_w = 'E') then
		nm_atributo_w := 'CD_MEDICO_EXEC';
	end if;
elsif (cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') and (ie_agenda_p = 'S') then
	begin
	select	obter_parametro_agenda(cd_estabelecimento_p, 'IE_MEDICO_RESP_ATEND_SERVICO', 'E')
	into STRICT	ie_medico_resp_atend_w
	;

	if (ie_medico_resp_atend_w = 'S') then
		nm_atributo_w := 'CD_MEDICO_SOLIC';
	elsif (ie_medico_resp_atend_w = 'E') then
		nm_atributo_w := 'CD_MEDICO';
	end if;
	end;
end if;

return nm_atributo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_resp_atend_agenda_param ( cd_estabelecimento_p bigint, ie_agenda_p text) FROM PUBLIC;
