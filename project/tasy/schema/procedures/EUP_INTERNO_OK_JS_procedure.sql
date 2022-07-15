-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE eup_interno_ok_js ( dt_entrada_p timestamp, cd_estabelecimento_p bigint, dt_alta_p timestamp, cd_medico_p text, dt_prescricao_p timestamp, nm_usuario_p text) AS $body$
DECLARE


ie_gera_passagem_alta_w	varchar(1);


BEGIN


select	coalesce(max(ie_gerar_passagem_alta), 'S')
into STRICT	ie_gera_passagem_alta_w
from    parametro_atendimento
where   cd_estabelecimento = cd_estabelecimento_p;

if (ie_gera_passagem_alta_w = 'N') and (dt_alta_p IS NOT NULL AND dt_alta_p::text <> '') and (dt_prescricao_p > dt_alta_p) then

	CALL wheb_mensagem_pck.exibir_mensagem_abort(121220);
end if;

if (dt_prescricao_p < dt_entrada_p) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(121221);
end if;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE eup_interno_ok_js ( dt_entrada_p timestamp, cd_estabelecimento_p bigint, dt_alta_p timestamp, cd_medico_p text, dt_prescricao_p timestamp, nm_usuario_p text) FROM PUBLIC;

