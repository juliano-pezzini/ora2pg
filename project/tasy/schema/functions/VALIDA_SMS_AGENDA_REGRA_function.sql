-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION valida_sms_agenda_regra (ie_classif_agenda_p text, cd_agenda_p bigint) RETURNS varchar AS $body$
DECLARE

	ie_retorno_w varchar(1);

BEGIN

	SELECT CASE WHEN COUNT(1)=0 THEN  'N'  ELSE 'S' END
	  INTO STRICT ie_retorno_w
	  FROM (SELECT ag1.cd_agenda,
						ag1.cd_setor_exclusivo,
						ag1.cd_estabelecimento,
						CASE WHEN ag1.cd_tipo_agenda=5 THEN  'S' WHEN ag1.cd_tipo_agenda=3 THEN  'C' WHEN ag1.cd_tipo_agenda=4 THEN  'C' WHEN ag1.cd_tipo_agenda=2 THEN  'E' WHEN ag1.cd_tipo_agenda=1 THEN  'CI'  ELSE 'x' END  ie_tipo_agendamento
				 FROM agenda ag1
				WHERE coalesce(ag1.ie_situacao, 'A') = 'A'
				  AND ag1.cd_agenda = cd_agenda_p) ag,
			 regra_envio_sms_agenda res
	 WHERE ag.cd_agenda = cd_agenda_p
		AND coalesce(ag.cd_setor_exclusivo, -1) = coalesce(res.cd_setor_atendimento, coalesce(ag.cd_setor_exclusivo, -1))
		AND ag.cd_estabelecimento = coalesce(res.cd_estabelecimento, ag.cd_estabelecimento)
		AND ag.ie_tipo_agendamento = coalesce(res.ie_tipo_agendamento, ag.ie_tipo_agendamento)
		AND ag.cd_agenda = coalesce(res.cd_agenda, ag.cd_agenda)
		AND ((coalesce(res.ie_classif_agenda, ie_classif_agenda_p) = ie_classif_agenda_p) or (coalesce(res.ie_classif_agenda::text, '') = ''))
		AND (NOT EXISTS (SELECT 1
								 FROM regra_exclusao_agenda_sms x
								WHERE x.cd_agenda = cd_agenda_p
								  AND x.ie_situacao = 'A'));

	RETURN ie_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION valida_sms_agenda_regra (ie_classif_agenda_p text, cd_agenda_p bigint) FROM PUBLIC;
