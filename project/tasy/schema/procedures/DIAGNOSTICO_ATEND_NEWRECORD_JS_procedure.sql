-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE diagnostico_atend_newrecord_js ( nr_atendimento_p bigint, cd_medico_p text, nm_usuario_p text, dt_diagnostico_p INOUT text, cd_medico_ret_p INOUT text, ie_tipo_atendimento_p INOUT text, ie_tipo_diagnostico_p INOUT text, ds_diagnostico_p INOUT text) AS $body$
DECLARE


dt_diagnostico_w	timestamp;


BEGIN

dt_diagnostico_w := Obter_Dados_Diagnostico(nr_atendimento_p, cd_medico_p, nm_usuario_p, dt_diagnostico_w);

select 	cd_medico,
	ie_tipo_atendimento,
	ie_tipo_diagnostico,
	ds_diagnostico
into STRICT	cd_medico_ret_p,
	ie_tipo_atendimento_p,
	ie_tipo_diagnostico_p,
	ds_diagnostico_p
from 	diagnostico_medico
where 	nr_Atendimento = nr_atendimento_p
and 	dt_diagnostico = dt_diagnostico_w;

dt_diagnostico_p := to_char(dt_diagnostico_w,'dd/mm/yyyy hh24:mi:ss');


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE diagnostico_atend_newrecord_js ( nr_atendimento_p bigint, cd_medico_p text, nm_usuario_p text, dt_diagnostico_p INOUT text, cd_medico_ret_p INOUT text, ie_tipo_atendimento_p INOUT text, ie_tipo_diagnostico_p INOUT text, ds_diagnostico_p INOUT text) FROM PUBLIC;

