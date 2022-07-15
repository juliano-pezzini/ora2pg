-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duplicar_prescr_enfer_html ( qt_horas_futura_p bigint, nr_sequencia_p bigint, cd_prescritor_p text, nr_atendimento_p bigint, dt_sae_p timestamp, ie_intervensao_p text, ie_agrupa_dia_p text, nm_usuario_p text, nr_seq_modelo_p bigint, nr_sequencia_sae_p INOUT bigint, ie_tipo_p text default 'SAE') AS $body$
BEGIN
 
if	((clock_timestamp() + coalesce(qt_horas_futura_p,0) / 24) < dt_SAE_p) then 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(281986,'QT_HORAS_FUTURA='||qt_horas_futura_p);
end if;
 
nr_sequencia_sae_p := duplicar_prescricao_enfemagem(nr_sequencia_p, cd_prescritor_p, nr_atendimento_p, dt_sae_p, ie_intervensao_p, ie_agrupa_dia_p, nm_usuario_p, nr_seq_modelo_p, nr_sequencia_sae_p, ie_tipo_p);
 
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duplicar_prescr_enfer_html ( qt_horas_futura_p bigint, nr_sequencia_p bigint, cd_prescritor_p text, nr_atendimento_p bigint, dt_sae_p timestamp, ie_intervensao_p text, ie_agrupa_dia_p text, nm_usuario_p text, nr_seq_modelo_p bigint, nr_sequencia_sae_p INOUT bigint, ie_tipo_p text default 'SAE') FROM PUBLIC;

