-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_codigo_cross_leito (nr_atendimento_p bigint, nr_seq_interno_p bigint) RETURNS varchar AS $body$
DECLARE


nr_seq_interno_w		bigint;
nr_externo_w			bigint;
cd_unidade_basica_w		varchar(10);
cd_unidade_compl_w		varchar(10);
ds_retorno_w			varchar(255);
cd_setor_atendimento_w	bigint;
ie_temporario_w			varchar(1);


BEGIN
IF (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '')	THEN

	SELECT	MAX(nr_seq_interno),
			max(obter_temporario_unidade(cd_setor_atendimento, cd_unidade_basica, cd_unidade_compl))
	INTO STRICT	nr_seq_interno_w,
			ie_temporario_w
	FROM	atend_paciente_unidade
	WHERE	nr_atendimento		= nr_atendimento_p
	AND	dt_saida_unidade	= (
					SELECT	MAX(dt_entrada_unidade)
					FROM	atend_paciente_unidade
					WHERE	nr_atendimento	= nr_atendimento_p
					AND	nr_seq_interno	= nr_seq_interno_p);


	IF (nr_seq_interno_w IS NOT NULL AND nr_seq_interno_w::text <> '') THEN

		SELECT  MAX(cd_unidade_basica),
				MAX(cd_unidade_compl),
				MAX(cd_setor_atendimento),
				max(id_leito_temp_cross)
		INTO STRICT	cd_unidade_basica_w,
				cd_unidade_compl_w,
				cd_setor_atendimento_w,
				nr_externo_w
		FROM	atend_paciente_unidade
		WHERE	nr_seq_interno = nr_seq_interno_w;

		if (ie_temporario_w = 'N') then
			begin
			SELECT	MAX(nr_externo)
			INTO STRICT	nr_externo_w
			FROM	unidade_atendimento
			WHERE	cd_setor_atendimento = cd_setor_atendimento_w
			AND 	cd_unidade_basica = cd_unidade_basica_w
			AND		cd_unidade_compl	= cd_unidade_compl_w;
			end;
		end if;

	END IF;

END IF;

RETURN	nr_externo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_codigo_cross_leito (nr_atendimento_p bigint, nr_seq_interno_p bigint) FROM PUBLIC;
