-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tipo_medico_externo (cd_pessoa_fisica_paciente_p text, cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE


    c_obter_desc_padrao CURSOR FOR
        SELECT  substr(Obter_Descricao_Padrao('TIPO_MEDICO_EXTERNO','DS_TIPO_MEDICO',nr_seq_tipo_medico),1,255) ds_padrao
        FROM    pf_medico_externo 	
        WHERE	cd_pessoa_fisica    = cd_pessoa_fisica_paciente_p
        AND     cd_medico           = cd_pessoa_fisica_p;

    r_obter_desc_padrao     c_obter_desc_padrao%ROWTYPE;
    ds_tipo_medico_w        varchar(4000) := NULL;


BEGIN
    IF (cd_pessoa_fisica_paciente_p IS NOT NULL AND cd_pessoa_fisica_paciente_p::text <> '' AND cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') THEN
        OPEN c_obter_desc_padrao;
        LOOP
            FETCH c_obter_desc_padrao INTO r_obter_desc_padrao;
            EXIT WHEN NOT FOUND; /* apply on c_obter_desc_padrao */
                IF (coalesce(ds_tipo_medico_w::text, '') = '') THEN
                    ds_tipo_medico_w := r_obter_desc_padrao.ds_padrao;
                ELSE
                    ds_tipo_medico_w := ds_tipo_medico_w||' / '||r_obter_desc_padrao.ds_padrao;
                END IF;
        END LOOP;
    END IF;

    RETURN ds_tipo_medico_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tipo_medico_externo (cd_pessoa_fisica_paciente_p text, cd_pessoa_fisica_p text) FROM PUBLIC;

