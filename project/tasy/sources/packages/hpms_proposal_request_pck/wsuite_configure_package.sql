-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE hpms_proposal_request_pck.wsuite_configure (cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finality: Set up TWS - HPMS (locale and functions )
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[  ]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao: 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


qt_registro_w	integer;


BEGIN

if (cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') then
	update	pls_web_param_geral
	set	ie_plataforma_web = 2;
	
	select	count(1)
	into STRICT	qt_registro_w
	from	establishment_locale
	where	cd_estabelecimento = cd_estabelecimento_p;
	
	if (qt_registro_w = 0) then
		insert into establishment_locale(cd_estabelecimento, ds_locale, ds_calendar,
			ds_timezone , dt_atualizacao, nm_usuario,
			dt_atualizacao_nrec, nm_usuario_nrec, nr_first_week_day,
			ds_secondary_calendar, cd_default_currency, ds_locale_tws)
		values ( cd_estabelecimento_p, 'pt_BR', 'iso8601',
			null, clock_timestamp(), 'TWS',
			clock_timestamp(),'TWS', null,
			null, null, 'pt_BR');
	else
		update	establishment_locale
		set	ds_locale_tws = 'pt_BR',
			dt_atualizacao = clock_timestamp(),
			nm_usuario = 'TWS'
		where	cd_estabelecimento = cd_estabelecimento_p;
	end if;
	
	commit;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hpms_proposal_request_pck.wsuite_configure (cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;
