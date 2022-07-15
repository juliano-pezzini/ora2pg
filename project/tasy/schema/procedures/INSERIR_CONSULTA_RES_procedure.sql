-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_consulta_res ( nr_atendimento_p text, cd_pf_usuario_p text, ie_tipo_consulta_p text, ie_tipo_area_p text, ds_parametros_p text DEFAULT NULL, dt_registro_p text DEFAULT NULL, ds_macro_p text DEFAULT NULL, nm_usuario_p text DEFAULT NULL, dt_coleta_p text DEFAULT NULL, cd_magnitude_p text DEFAULT NULL, ds_unidade_medida_p text DEFAULT NULL, nr_seq_xml_p text DEFAULT NULL, ds_observacao_p text DEFAULT NULL, ds_result1_p text DEFAULT NULL, ds_result2_p text DEFAULT NULL, ds_result3_p text DEFAULT NULL, ds_result4_p text DEFAULT NULL, ds_result5_p text DEFAULT NULL, ds_result6_p text DEFAULT NULL, ds_result7_p text DEFAULT NULL, ds_result8_p text DEFAULT NULL, ds_result9_p text DEFAULT NULL, ds_result10_p text DEFAULT NULL, ds_result11_p text DEFAULT NULL, ds_result12_p text DEFAULT NULL, ds_result13_p text DEFAULT NULL, ds_result14_p text DEFAULT NULL, ds_result15_p text DEFAULT NULL, ds_result16_p text DEFAULT NULL, ds_result17_p text DEFAULT NULL, ds_result18_p text DEFAULT NULL, ds_result19_p text DEFAULT NULL, ds_result20_p text DEFAULT NULL) AS $body$
DECLARE


cd_pessoa_fisica_w				varchar(10);
ie_tipo_consulta_w				varchar(3);
ie_tipo_w						varchar(3);
dt_registro_w						timestamp;
dt_coleta_w							timestamp;
qt_coleta_w						bigint;


BEGIN

if (coalesce(dt_registro_p::text, '') = '') then
dt_registro_w:= TO_DATE(dt_coleta_p, 'dd/mm/yyyy hh24:mi:ss');
else
dt_registro_w:= TO_DATE(dt_registro_p, 'dd/mm/yyyy hh24:mi:ss');
end if;

ie_tipo_w := obter_tipo_area_res(ie_tipo_area_p);
ie_tipo_consulta_w := 'C';


	IF (dt_registro_w IS NOT NULL AND dt_registro_w::text <> '') THEN

		SELECT LENGTH(dt_coleta_p)
		INTO STRICT qt_coleta_w
		;

		IF (qt_coleta_w > 10) THEN

			dt_coleta_w:= TO_DATE(dt_coleta_p, 'dd/mm/yyyy hh24:mi:ss');

		ELSE

			dt_coleta_w := dt_coleta_p;

	END IF;


SELECT cd_pessoa_fisica
INTO STRICT cd_pessoa_fisica_w
FROM atendimento_paciente
WHERE nr_atendimento = nr_atendimento_p;

INSERT INTO res_paciente_resultado(
		nr_sequencia,
		nr_seq_xml,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		cd_pessoa_fisica,
		ds_observacao,
		cd_profissional_dest,
		ie_tipo_consulta,
		ie_tipo,
		ie_privacidade,
		ie_empresa,
		dt_informacao,
		ds_informacao,
		ds_macro,
		ds_valor,
		ds_unidade,
		dt_coleta,
		ds_result1,
		ds_result2,
		ds_result3,
		ds_result4,
		ds_result5,
		ds_result6,
		ds_result7,
		ds_result8,
		ds_result9,
		ds_result10,
		ds_result11,
		ds_result12,
		ds_result13,
		ds_result14,
		ds_result15,
		ds_result16,
		ds_result17,
		ds_result18,
		ds_result19,
		ds_result20)
		VALUES (
		nextval('res_paciente_resultado_seq'),
		nr_seq_xml_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		cd_pessoa_fisica_w,
		ds_observacao_p,
		cd_pf_usuario_p,
		ie_tipo_consulta_w,
		ie_tipo_w,
		'N',
		'UNI',
		dt_registro_w,
		ds_parametros_p,
		ds_macro_p,
		cd_magnitude_p,
		ds_unidade_medida_p,
		dt_coleta_w,
		ds_result1_p,
		ds_result2_p,
		ds_result3_p,
		ds_result4_p,
		ds_result5_p,
		ds_result6_p,
		ds_result7_p,
		ds_result8_p,
		ds_result9_p,
		ds_result10_p,
		ds_result11_p,
		ds_result12_p,
		ds_result13_p,
		ds_result14_p,
		ds_result15_p,
		ds_result16_p,
		ds_result17_p,
		ds_result18_p,
		ds_result19_p,
		ds_result20_p);

COMMIT;

END IF;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_consulta_res ( nr_atendimento_p text, cd_pf_usuario_p text, ie_tipo_consulta_p text, ie_tipo_area_p text, ds_parametros_p text DEFAULT NULL, dt_registro_p text DEFAULT NULL, ds_macro_p text DEFAULT NULL, nm_usuario_p text DEFAULT NULL, dt_coleta_p text DEFAULT NULL, cd_magnitude_p text DEFAULT NULL, ds_unidade_medida_p text DEFAULT NULL, nr_seq_xml_p text DEFAULT NULL, ds_observacao_p text DEFAULT NULL, ds_result1_p text DEFAULT NULL, ds_result2_p text DEFAULT NULL, ds_result3_p text DEFAULT NULL, ds_result4_p text DEFAULT NULL, ds_result5_p text DEFAULT NULL, ds_result6_p text DEFAULT NULL, ds_result7_p text DEFAULT NULL, ds_result8_p text DEFAULT NULL, ds_result9_p text DEFAULT NULL, ds_result10_p text DEFAULT NULL, ds_result11_p text DEFAULT NULL, ds_result12_p text DEFAULT NULL, ds_result13_p text DEFAULT NULL, ds_result14_p text DEFAULT NULL, ds_result15_p text DEFAULT NULL, ds_result16_p text DEFAULT NULL, ds_result17_p text DEFAULT NULL, ds_result18_p text DEFAULT NULL, ds_result19_p text DEFAULT NULL, ds_result20_p text DEFAULT NULL) FROM PUBLIC;

