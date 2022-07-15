-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_agenda_regras_permissao ( cd_pessoa_fisica_p text, cd_agenda_p bigint, ie_permite_cancelar_p INOUT text, ie_permite_encaixar_p INOUT text) AS $body$
BEGIN

select	obter_agenda_regra_permissao(cd_pessoa_fisica_p, cd_agenda_p, 'C', null),
	obter_agenda_regra_permissao(cd_pessoa_fisica_p, cd_agenda_p, 'E', null)
into STRICT	ie_permite_cancelar_p,
	ie_permite_encaixar_p
;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_agenda_regras_permissao ( cd_pessoa_fisica_p text, cd_agenda_p bigint, ie_permite_cancelar_p INOUT text, ie_permite_encaixar_p INOUT text) FROM PUBLIC;

