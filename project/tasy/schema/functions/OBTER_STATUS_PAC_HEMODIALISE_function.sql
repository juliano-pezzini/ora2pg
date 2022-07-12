-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_status_pac_hemodialise (cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE


ie_status_w		varchar(30);


BEGIN

if (substr(hd_obter_se_em_dialise(cd_pessoa_fisica_p,'E'),1,1) = 'S') then
	ie_status_w := Wheb_mensagem_pck.get_texto(309930); --'Em hemodiálise';
elsif (hd_obter_hemodialise_atual(cd_pessoa_fisica_p, 'A') > 0) then
	ie_status_w := Wheb_mensagem_pck.get_texto(309931); --'Gerada';
elsif (substr(hd_obter_se_em_dialise(cd_pessoa_fisica_p,'F'),1,1)  = 'S') then
	ie_status_w := Wheb_mensagem_pck.get_texto(309932); --'Finalizada';
elsif (substr(hd_obter_se_em_dialise(cd_pessoa_fisica_p,'C'),1,1) = 'S') then
	ie_status_w := Wheb_mensagem_pck.get_texto(309933); --'Cancelada';
elsif (to_date(hd_obter_chegada_paciente(cd_pessoa_fisica_p), 'dd/mm/yyyy hh24:mi:ss') is not null) then
	ie_status_w := Wheb_mensagem_pck.get_texto(309934); --'Aguardando';
else
	ie_status_w := Wheb_mensagem_pck.get_texto(309935); --'Paciente não chegou';
end if;

return	ie_status_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_status_pac_hemodialise (cd_pessoa_fisica_p text) FROM PUBLIC;

