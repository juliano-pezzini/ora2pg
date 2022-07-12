-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_height_last_vital_sign (cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE

    result_w varchar(20);

BEGIN
    select to_char(CASE WHEN ie_unid_med_altura='cm' THEN  qt_altura_cm  ELSE qt_altura_m END ) || ie_unid_med_altura
    into STRICT   result_w
    from   atendimento_sinal_vital	
    where  nr_sequencia = (SELECT coalesce(max(nr_sequencia), 0)
                from  atendimento_sinal_vital
                where (qt_altura_cm IS NOT NULL AND qt_altura_cm::text <> '')
                and   coalesce(ie_situacao, 'A') = 'A'
                and   cd_paciente = cd_pessoa_fisica_p);
    RETURN result_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_height_last_vital_sign (cd_pessoa_fisica_p text) FROM PUBLIC;
