-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_status_dia_ciclo (nr_seq_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_status_atendimento_w	varchar(4000);
dt_cancelamento_w timestamp;
ie_presc_liberada_w varchar(1);
nr_status_paciente_w varchar(10);


BEGIN

SELECT 	a.dt_cancelamento,
		obter_se_prescricao_liberada(a.nr_prescricao,'E') prescricao,
		Obter_status_Paciente_qt(a.nr_seq_atendimento, a.dt_inicio_adm, a.dt_fim_adm, a.nr_seq_local, a.ie_exige_liberacao, a.dt_chegada,'C') status_paciente 
INTO STRICT 	dt_cancelamento_w,
		ie_presc_liberada_w,
		nr_status_paciente_w
FROM paciente_atendimento a
WHERE a.nr_seq_atendimento = nr_seq_atendimento_p;

IF (dt_cancelamento_w IS NOT NULL AND dt_cancelamento_w::text <> '') THEN
	ds_status_atendimento_w := obter_desc_expressao(330795); --Dia cancelado
END IF;

IF (coalesce(ds_status_atendimento_w::text, '') = '') AND (nr_status_paciente_w = 83) THEN
	ds_status_atendimento_w := obter_desc_expressao(330793); --Dia atendido
END IF;

IF (coalesce(ds_status_atendimento_w::text, '') = '') AND (ie_presc_liberada_w = 'S') THEN
	ds_status_atendimento_w := obter_desc_expressao(331421); --Prescrição liberada
END IF;
		
IF (coalesce(ds_status_atendimento_w::text, '') = '') THEN
	ds_status_atendimento_w := obter_desc_expressao(321258); --Aguardando atendimento
END IF;
	
RETURN ds_status_atendimento_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_status_dia_ciclo (nr_seq_atendimento_p bigint) FROM PUBLIC;
