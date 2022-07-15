-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE del_part_carta_medica ( NM_USUARIO_RESP_P text, NR_SEQ_CARTA_P bigint) AS $body$
BEGIN
	if (nm_usuario_resp_p IS NOT NULL AND nm_usuario_resp_p::text <> '') then
		update  PARTICIPANTE_CARTA_MEDICA
		set     DT_ASSINATURA  = NULL,
				IE_DEVE_ASSINAR = 'N',
				IE_INCLUSO = 'N'
		where   nm_usuario_resp = nm_usuario_resp_p
		and 	NR_SEQ_CARTA_MAE = NR_SEQ_CARTA_P;
		commit;
	end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE del_part_carta_medica ( NM_USUARIO_RESP_P text, NR_SEQ_CARTA_P bigint) FROM PUBLIC;

