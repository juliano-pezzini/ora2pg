-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pep_hfp_inserir_paciente ( cd_pessoa_fisica_p text, cd_medico_solic_p text, ds_diagnostico_p text, nm_usuario_p text, cd_doenca_p text, nr_atend_origem_p bigint) AS $body$
DECLARE

ie_health_w	varchar(10);

BEGIN

select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END  ie_health
into STRICT	ie_health_w
from	hfp_paciente
where	nr_atend_origem = nr_atend_origem_p;

if (ie_health_w	 = 'S') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(268074);
end if;

CALL hfp_inserir_paciente(	cd_pessoa_fisica_p,
						cd_medico_solic_p	,
						ds_diagnostico_p	,
						nm_usuario_p		,
						cd_doenca_p		,
						nr_atend_origem_p	);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pep_hfp_inserir_paciente ( cd_pessoa_fisica_p text, cd_medico_solic_p text, ds_diagnostico_p text, nm_usuario_p text, cd_doenca_p text, nr_atend_origem_p bigint) FROM PUBLIC;

