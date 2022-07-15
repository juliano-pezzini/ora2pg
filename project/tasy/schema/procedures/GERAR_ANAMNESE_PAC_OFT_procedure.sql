-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_anamnese_pac_oft ( nr_seq_anamnese_p bigint, nr_atendimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


expressao1_w	varchar(255) := obter_desc_expressao_idioma(293519, null, wheb_usuario_pck.get_nr_seq_idioma);--Motivo da consulta
expressao2_w	varchar(255) := obter_desc_expressao_idioma(291319, null, wheb_usuario_pck.get_nr_seq_idioma);--Hist oftalmológica prévia
expressao3_w	varchar(255) := obter_desc_expressao_idioma(293085, null, wheb_usuario_pck.get_nr_seq_idioma);--Medicamentos:
expressao4_w	varchar(255) := obter_desc_expressao_idioma(283346, null, wheb_usuario_pck.get_nr_seq_idioma);--Alergias
BEGIN

if (nr_seq_anamnese_p IS NOT NULL AND nr_seq_anamnese_p::text <> '') then

   insert into ANAMNESE_PACIENTE(
		nr_sequencia,
		DT_ANANMESE,
		dt_atualizacao,
		nm_usuario,
		nr_atendimento,
		dt_liberacao,
		CD_MEDICO,
		ie_situacao,
		DS_ANAMNESE)
	SELECT  nextval('anamnese_paciente_seq'),
		DT_ANAMNESE,
		clock_timestamp(),
		nm_usuario_p,
		nr_atendimento_p,
		dt_liberacao,
		cd_profissional,
		'A',
		expressao1_w || ': '|| substr(DS_ANAMNESE,1,1000) || chr(13) || chr(10) || expressao2_w || ': ' || substr(DS_HISTORIA_OCULAR,1,1000) || chr(13) || chr(10) || expressao3_w || ': '|| substr(DS_MEDICAMENTOS,1,1000) || chr(13) || chr(10) || expressao4_w || ': '|| substr(DS_ALERGIA,1,920)
	from    OFT_ANAMNESE
	where   nr_sequencia = nr_seq_anamnese_p;

commit;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_anamnese_pac_oft ( nr_seq_anamnese_p bigint, nr_atendimento_p bigint, nm_usuario_p text) FROM PUBLIC;

