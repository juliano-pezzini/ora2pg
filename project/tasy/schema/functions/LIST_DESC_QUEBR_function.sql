-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION list_desc_quebr ( nr_prescricao_p bigint ) RETURNS varchar AS $body$
DECLARE


    retorno_list   varchar(4000) := '';
    list_desc_cursor CURSOR FOR
        SELECT obter_desc_procedimento(b.cd_procedimento,b.ie_origem_proced) || ' - ' || a.ds_informacao as ds_informacao
        from prescr_proced_inf_adic a,
            prescr_procedimento b
        where b.nr_prescricao = a.nr_prescricao
        and a.nr_prescricao = nr_prescricao_p
        order by a.nr_sequencia;

         list_desc_record   list_desc_cursor%rowtype;


BEGIN
    OPEN list_desc_cursor;
    FETCH list_desc_cursor INTO list_desc_record;
    WHILE list_desc_cursor%found LOOP
        IF (list_desc_record.ds_informacao IS NOT NULL AND list_desc_record.ds_informacao::text <> '')  THEN
           retorno_list := SUBSTR(list_desc_record.ds_informacao||chr(10)||retorno_list, 1, 4000);
        END IF;
        FETCH list_desc_cursor INTO list_desc_record;
    END LOOP;

    CLOSE list_desc_cursor;
    RETURN retorno_list;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION list_desc_quebr ( nr_prescricao_p bigint ) FROM PUBLIC;
