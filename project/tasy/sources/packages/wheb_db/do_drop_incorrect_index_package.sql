-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE wheb_db.do_drop_incorrect_index (indice_p INDICE) AS $body$
DECLARE

	
  REC RECORD;

BEGIN
	FOR REC IN (SELECT TABLE_NAME,
					   INDEX_NAME
				  FROM USER_INDEXES UI
				 WHERE UI.TABLE_NAME = UPPER(indice_p.NM_TABELA)
				   AND UI.INDEX_NAME <> UPPER(indice_p.NM_INDICE)
		   and UI.INDEX_TYPE <> 'LOB'
				   AND (    NOT EXISTS (SELECT 1
										  FROM INDICE
										 WHERE NM_TABELA = UI.TABLE_NAME
										   AND NM_INDICE = UI.INDEX_NAME)
						 OR (     EXISTS (SELECT 1 FROM INDICE
												  WHERE NM_TABELA = UI.TABLE_NAME
													AND NM_INDICE = UI.INDEX_NAME
													AND IE_TIPO <> 'IF')
							  AND (SELECT COUNT(1)
									 FROM USER_IND_COLUMNS UIC
							   INNER JOIN INDICE_ATRIBUTO  IA
									   ON IA.NM_TABELA = UIC.TABLE_NAME AND IA.NM_INDICE = UIC.INDEX_NAME AND IA.NR_SEQUENCIA = UIC.COLUMN_POSITION AND IA.NM_ATRIBUTO = UIC.COLUMN_NAME
									WHERE UI.TABLE_NAME = UIC.TABLE_NAME
									  AND UI.INDEX_NAME = UIC.INDEX_NAME) <> (SELECT COUNT(1)
																				FROM INDICE_ATRIBUTO IA
																			   WHERE IA.NM_TABELA = UI.TABLE_NAME
																				 AND IA.NM_INDICE = UI.INDEX_NAME))))
	LOOP
	  IF wheb_db.is_index_of_constraint(REC.TABLE_NAME, REC.INDEX_NAME) THEN
		CALL wheb_db.do_drop_index_of_constraint(REC.TABLE_NAME, REC.INDEX_NAME);
	  ELSE
		CALL wheb_db.do_drop_index(REC.TABLE_NAME, REC.INDEX_NAME);
	  END IF;
	END LOOP;
	END;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE wheb_db.do_drop_incorrect_index (indice_p INDICE) FROM PUBLIC;