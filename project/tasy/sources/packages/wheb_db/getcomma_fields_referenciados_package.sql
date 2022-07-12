-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION wheb_db.getcomma_fields_referenciados (integridade_referencial_p INTEGRIDADE_REFERENCIAL) RETURNS varchar AS $body$
DECLARE

	field_w                varchar(30);
	fields_retorno_w       varchar(1000);
	indice_w               INDICE%rowtype;
	indice_atributo_w      INDICE_ATRIBUTO%rowtype;
	integridade_atributo_w INTEGRIDADE_ATRIBUTO%rowtype;
	
BEGIN
	fields_retorno_w := NULL;
	BEGIN
	  OPEN C_INTEGRIDADE_ATRIBUTOS(integridade_referencial_p.NM_TABELA, integridade_referencial_p.NM_INTEGRIDADE_REFERENCIAL);
	  LOOP
		FETCH C_INTEGRIDADE_ATRIBUTOS INTO integridade_atributo_w;
		EXIT WHEN NOT FOUND; /* apply on C_INTEGRIDADE_ATRIBUTOS */

		IF coalesce(integridade_atributo_w.NM_ATRIBUTO_REF::text, '') = '' THEN
		  BEGIN
			OPEN C_INDICES(integridade_referencial_p.NM_TABELA_REFERENCIA, 'PK');
			FETCH C_INDICES INTO indice_w;

			indice_atributo_w := wheb_db.get_indice_atributo(indice_w.NM_TABELA, indice_w.NM_INDICE, integridade_atributo_w.IE_SEQUENCIA_CRIACAO);

			field_w := indice_atributo_w.NM_ATRIBUTO;

			CLOSE WHEB_DB.C_INDICES;
		  EXCEPTION
			WHEN OTHERS THEN
			  CLOSE WHEB_DB.C_INDICES;
			  CALL WHEB_MENSAGEM_PCK.EXIBIR_MENSAGEM_ABORT(sqlerrm(SQLSTATE));
		  END;
		ELSE
		  field_w := integridade_atributo_w.NM_ATRIBUTO_REF;
		END IF;

		IF (fields_retorno_w IS NOT NULL AND fields_retorno_w::text <> '') THEN
		  fields_retorno_w := fields_retorno_w || ', ';
		END IF;

		fields_retorno_w := fields_retorno_w || field_w;
	  END LOOP;

	  CLOSE C_INTEGRIDADE_ATRIBUTOS;
	EXCEPTION
	  WHEN OTHERS THEN
		CLOSE C_INTEGRIDADE_ATRIBUTOS;
		CALL WHEB_MENSAGEM_PCK.EXIBIR_MENSAGEM_ABORT(sqlerrm(SQLSTATE));
	END;
	RETURN fields_retorno_w;
	END;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION wheb_db.getcomma_fields_referenciados (integridade_referencial_p INTEGRIDADE_REFERENCIAL) FROM PUBLIC;