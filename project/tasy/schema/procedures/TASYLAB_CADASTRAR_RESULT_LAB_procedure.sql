-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tasylab_cadastrar_result_lab ( nr_prescricao_p bigint, nr_seq_prescricao_p bigint, ie_cobranca_p text, ds_resultado_p text, dt_coleta_p timestamp, ie_status_conversao_p text, ds_result_codigo_p text, ie_formato_texto_p text, cd_procedimento_p text, ie_origem_proced_p text, dt_retificacao_p timestamp, ie_status_p text) AS $body$
BEGIN

if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_prescricao_p IS NOT NULL AND nr_seq_prescricao_p::text <> '') then

	insert into result_laboratorio(	nr_sequencia,
					nr_prescricao,
					nr_seq_prescricao,
					nm_usuario,
					dt_atualizacao,
					ie_cobranca,
					cd_procedimento,
					ie_origem_proced,
					ds_resultado,
					dt_coleta,
					ie_status_conversao,
					ds_result_codigo,
					ie_formato_texto,
					--nr_seq_exame,
					dt_retificacao,
					ie_status)
			values (nextval('result_laboratorio_seq'),
					nr_prescricao_p,
					nr_seq_prescricao_p,
					'TasyLab-ResLab',
					clock_timestamp(),
					ie_cobranca_p,
					cd_procedimento_p,
					ie_origem_proced_p,
					ds_resultado_p,
					dt_coleta_p,
					ie_status_conversao_p,
					ds_result_codigo_p,
					ie_formato_texto_p,
					--
					dt_retificacao_p,
					ie_status_p
					);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tasylab_cadastrar_result_lab ( nr_prescricao_p bigint, nr_seq_prescricao_p bigint, ie_cobranca_p text, ds_resultado_p text, dt_coleta_p timestamp, ie_status_conversao_p text, ds_result_codigo_p text, ie_formato_texto_p text, cd_procedimento_p text, ie_origem_proced_p text, dt_retificacao_p timestamp, ie_status_p text) FROM PUBLIC;

