-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION bifrost.convertcontent ( content text ) RETURNS text AS $body$
DECLARE

    charsetType varchar(30);
    type vararray IS TABLE OF varchar(30);
    multibyteCodes vararray := vararray('JA16EUCTILDE', 'ZHT16MSWIN950', 'ZHT16BIG5', 'ZHS16DBCS', 'JA16DBCS', 'ZHT32EUC', 'KO16DBCS', 'ZHT16CCDC', 'JA16EBCDIC930', 'JA16MACSJIS', 'ZHS16MACCGB231280', 'JA16SJIS', 'AL16UTF16', 'ZHT16DBCS', 'ZHS16GBK', 'JA16VMS', 'ZHT16DBT', 'JA16SJISTILDE', 'KO16MSWIN949', 'KO16KSCCS', 'AL32UTF8', 'ZHT16HKSCS', 'ZHS16CGB231280', 'JA16EUC', 'ZHT32TRIS', 'JA16SJISYEN', 'KO16KSC5601', 'ZHT16HKSCS31', 'UTF8', 'ZHT32SOPS', 'UTFE', 'JA16EUCYEN', 'ZHS32GB18030');

BEGIN
    select value as valueSet into STRICT charsetType from nls_database_parameters where parameter = 'NLS_CHARACTERSET';

    If charsetType member of multibyteCodes Then
        return convert(content, 'AL32UTF8');
    end if;

    return convert(content, 'WE8ISO8859P1');

END;

$body$
LANGUAGE PLPGSQL
;
-- REVOKE ALL ON FUNCTION bifrost.convertcontent ( content text ) FROM PUBLIC;
