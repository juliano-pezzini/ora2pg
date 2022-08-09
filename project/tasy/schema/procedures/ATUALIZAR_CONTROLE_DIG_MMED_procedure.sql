-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_controle_dig_mmed (ds_lista_exames_p text, ie_opcao_p text, cd_pessoa_fisica_p text, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_prescricao_w bigint;
nr_prescricao_w	             bigint;
nr_seq_interno_w   	             bigint;
cd_pessoa_fisica_w             bigint;
ds_possib_w                         varchar(6000);
qt_controle_w                       bigint;
qt_pos_separador_w            bigint;


BEGIN
  cd_pessoa_fisica_w := cd_pessoa_fisica_p;
  ds_possib_w             := ds_lista_exames_p || ',';

  IF (position('(' in ds_possib_w) > 0 )
  AND (position(')' in ds_possib_w) > 0 ) THEN
    ds_possib_w := SUBSTR(ds_lista_exames_p,(position('(' in ds_lista_exames_p)+1),(position(')' in ds_lista_exames_p)-2));
  END IF;

  qt_controle_w      := 0;
  qt_pos_separador_w := position(',' in ds_possib_w);

  IF (qt_pos_separador_w = 0) THEN
    qt_pos_separador_w := -1;
  END IF;

  WHILE(qt_pos_separador_w >= 0)
  AND (qt_controle_w < 1000) LOOP
  BEGIN
    IF (qt_pos_separador_w = 0) THEN
      nr_seq_interno_w   := (ds_possib_w)::numeric;
      qt_pos_separador_w := -1;
    ELSE
      nr_seq_interno_w := (SUBSTR(ds_possib_w,1,qt_pos_separador_w-1))::numeric;
    END IF;

	  SELECT  MAX(a.nr_prescricao),
                       	  MAX(a.nr_sequencia)
	  INTO STRICT       nr_prescricao_w,
	                  nr_sequencia_prescricao_w
	  FROM	  prescr_procedimento a
	  WHERE	  a.nr_seq_interno = nr_seq_interno_w;

	  IF (ie_opcao_p = 'I') THEN
	    INSERT INTO controle_digitacao_laudo(
				nm_usuario,
				cd_pessoa_fisica,
				nr_prescricao,
				nr_seq_prescr)
		VALUES (	nm_usuario_p,
				cd_pessoa_fisica_p,
				nr_prescricao_w,
				nr_sequencia_prescricao_w);
	  ELSE
                    DELETE FROM controle_digitacao_laudo
	    WHERE nr_prescricao	= nr_prescricao_w
	    AND	   nr_seq_prescr	= nr_sequencia_prescricao_w;
	  END IF;

	  IF (qt_pos_separador_w > 0 ) THEN
                    ds_possib_w        := SUBSTR(ds_possib_w,qt_pos_separador_w+1,length(ds_possib_w));
                    qt_pos_separador_w := position(',' in ds_possib_w);
                  END IF;

               qt_controle_w := qt_controle_w + 1;

    END;
    END LOOP;

COMMIT;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_controle_dig_mmed (ds_lista_exames_p text, ie_opcao_p text, cd_pessoa_fisica_p text, nm_usuario_p text) FROM PUBLIC;
