-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE registra_ciente_comunic_cih ( nr_sequencia_p bigint, cd_pessoa_fisica_p text, ie_concordo_p text default 'S') AS $body$
BEGIN

if (ie_concordo_p = 'S') then
	CALL CPOE_GERAR_SUBS_SUG_CIH(nr_sequencia_p, wheb_usuario_pck.get_nm_usuario);
end if;

update	prescr_mat_comunic_cih
set	cd_pessoa_ciente	= cd_pessoa_fisica_p,
	dt_ciente		  = clock_timestamp(),
	ie_concordo 	  = ie_concordo_p
where	nr_sequencia  = nr_sequencia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE registra_ciente_comunic_cih ( nr_sequencia_p bigint, cd_pessoa_fisica_p text, ie_concordo_p text default 'S') FROM PUBLIC;
