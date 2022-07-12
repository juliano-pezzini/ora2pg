-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION bifrost_icca.getbifrostmessageid ( response utl_http.resp ) RETURNS varchar AS $body$
DECLARE

    responseHeader utl_http.resp;
    headerName varchar(256);
    headerValue varchar(4096);
    bifrostMessageId varchar(50) := null;
BEGIN
    responseHeader := response;
    for i in 1..utl_http.get_header_count(responseHeader) loop
        utl_http.get_header(responseHeader, i, headerName, headerValue);
        if headerName = 'BifrostMessageId' then
            bifrostMessageId := headerValue;
        end if;
    end loop;

    return bifrostMessageId;

END;

$body$
LANGUAGE PLPGSQL
;
-- REVOKE ALL ON FUNCTION bifrost_icca.getbifrostmessageid ( response utl_http.resp ) FROM PUBLIC;
