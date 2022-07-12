-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION anzics_pck.get_slk581 ( cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE

    ds_nome_w           varchar(255);
    ds_sobrenome_w      varchar(255);
    dt_nascimento_w     timestamp;
    ie_sexo_w           varchar(2);
    ds_nome_mask_w      varchar(255);
    ds_sobrenome_mask_w varchar(255);

BEGIN
    ds_nome_w      := upper(elimina_caracteres_especiais(obter_nome_sobrenome_pessoa(cd_pessoa_fisica_p,'P')));
    ds_sobrenome_w := upper(elimina_caracteres_especiais(obter_nome_sobrenome_pessoa(cd_pessoa_fisica_p,'S')));
    SELECT dt_nascimento,
      CASE WHEN ie_sexo='M' THEN 1 WHEN ie_sexo='F' THEN 2 WHEN ie_sexo='I' THEN 3  ELSE 9 END
    INTO STRICT dt_nascimento_w,
      ie_sexo_w
    FROM pessoa_fisica
    WHERE cd_pessoa_fisica = cd_pessoa_fisica_p;
    IF (ds_sobrenome_w IS NOT NULL AND ds_sobrenome_w::text <> '') THEN
      ds_sobrenome_mask_w := rpad(SUBSTR(ds_sobrenome_w,2,1)||SUBSTR(ds_sobrenome_w,3,1)||SUBSTR(ds_sobrenome_w,5,1),3,'2');
    ELSE
      ds_sobrenome_mask_w := '999';
    END IF;
    IF (ds_nome_w IS NOT NULL AND ds_nome_w::text <> '') THEN
      ds_nome_mask_w := rpad(SUBSTR(ds_nome_w,2,1)||SUBSTR(ds_nome_w,3,1),2,'2');
    ELSE
      ds_nome_w := '99';
    END IF;
    RETURN ds_sobrenome_mask_w||ds_nome_mask_w||coalesce(TO_CHAR(dt_nascimento_w,'ddmmyyyy'),'01011900')|| ie_sexo_w;
  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION anzics_pck.get_slk581 ( cd_pessoa_fisica_p text) FROM PUBLIC;
