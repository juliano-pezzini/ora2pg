-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hem_obter_num_coron ( nr_sequencia_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*
ie_opcao_p
V = VASO
I = IMPORTANCIA
L = LESAO
S = SEGMENTO

Referente ao Laudo padrão onde utiliza-se a tabela HEM_PADRAO_CORONARIOGRAFIA
VP = VASO
IP = IMPORTANCIA
LP = LESAO
SP = SEGMENTO
 :)
*/
ds_retorno_w	varchar(255);

BEGIN
IF (coalesce(nr_sequencia_p,0) > 0 ) THEN
	IF (ie_opcao_p = 'V') THEN

		SELECT	MAX(b.cd_vaso)||''
		INTO STRICT	ds_retorno_w
		FROM	hem_coronariografia a,
			hem_vaso b
		WHERE	a.nr_sequencia =  nr_sequencia_p
		AND	b.nr_sequencia = a.nr_seq_vaso;

	END IF;

	IF (ie_opcao_p = 'I') THEN

		SELECT	MAX(b.cd_importancia)||''
		INTO STRICT	ds_retorno_w
		FROM	hem_coronariografia a,
			hem_importancia_vaso b
		WHERE	a.nr_sequencia =  nr_sequencia_p
		AND	b.nr_sequencia = a.nr_seq_importancia;

	END IF;

	IF (ie_opcao_p = 'L') THEN

		SELECT	MAX(b.cd_lesao)||''
		INTO STRICT	ds_retorno_w
		FROM	hem_coronariografia a,
			hem_tipo_lesao b
		WHERE	a.nr_sequencia = nr_sequencia_p
		AND	b.nr_sequencia = a.nr_seq_tipo_lesao;

	END IF;

	IF (ie_opcao_p = 'S') THEN

		SELECT	MAX(b.cd_segmento)||''
		INTO STRICT	ds_retorno_w
		FROM	hem_coronariografia a,
			hem_segmento_princ b
		WHERE	a.nr_sequencia =  nr_sequencia_p
		AND	b.nr_sequencia = a.nr_seq_segmento;

	END IF;

--Referente ao Laudo padrão onde utiliza-se a tabela HEM_PADRAO_CORONARIOGRAFIA
	IF (ie_opcao_p = 'VP') THEN

		SELECT	MAX(b.cd_vaso)||''
		INTO STRICT	ds_retorno_w
		FROM	hem_padrao_coronariografia a,
			hem_vaso b
		WHERE	a.nr_sequencia =  nr_sequencia_p
		AND	b.nr_sequencia = a.nr_seq_vaso;

	END IF;

	IF (ie_opcao_p = 'IP') THEN

		SELECT	MAX(b.cd_importancia)||''
		INTO STRICT	ds_retorno_w
		FROM	hem_padrao_coronariografia a,
			hem_importancia_vaso b
		WHERE	a.nr_sequencia =  nr_sequencia_p
		AND	b.nr_sequencia = a.nr_seq_importancia;

	END IF;

	IF (ie_opcao_p = 'LP') THEN

		SELECT	MAX(b.cd_lesao)||''
		INTO STRICT	ds_retorno_w
		FROM	hem_padrao_coronariografia a,
			hem_tipo_lesao b
		WHERE	a.nr_sequencia = nr_sequencia_p
		AND	b.nr_sequencia = a.nr_seq_tipo_lesao;

	END IF;

	IF (ie_opcao_p = 'SP') THEN

		SELECT	MAX(b.cd_segmento)||''
		INTO STRICT	ds_retorno_w
		FROM	hem_padrao_coronariografia a,
			hem_segmento_princ b
		WHERE	a.nr_sequencia =  nr_sequencia_p
		AND	b.nr_sequencia = a.nr_seq_segmento;

	END IF;

END IF;

RETURN	ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hem_obter_num_coron ( nr_sequencia_p bigint, ie_opcao_p text) FROM PUBLIC;

