-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_unidade2 ( nr_Seq_interno_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w varchar(4000) :=NULL;

/*
IE_OPCAO_P:
'NSUB' 	- Nome Setor + Cd_Unidade_Basica
'NSUBUC'	- Nome setor + Cd unidade basica + cd unidade compl
*/
BEGIN

if ie_opcao_p = 'NSUBUC' then

	IF (nr_Seq_interno_p IS NOT NULL AND nr_Seq_interno_p::text <> '') THEN

		SELECT 	MAX(obter_nome_setor(cd_setor_atendimento)||' - ('||cd_unidade_basica||'-'||cd_unidade_compl||')')
		INTO STRICT	ds_retorno_w
		FROM	unidade_atendimento
		WHERE	nr_Seq_interno = nr_Seq_interno_p;
		RETURN ds_retorno_w;
	END IF;
END IF;

RETURN	ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_unidade2 ( nr_Seq_interno_p bigint, ie_opcao_p text) FROM PUBLIC;

