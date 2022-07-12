-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION is_integration_exist ( nr_seq_evento_int_p integration_call_log.nr_seq_evento_int%type, cd_event_parent_seq_p integration_call_log.cd_event_parent_seq%type ) RETURNS varchar AS $body$
DECLARE

ie_exist_w bigint;

BEGIN
    select count(nr_sequencia)
    into STRICT ie_exist_w
    from integration_call_log
    where nr_seq_evento_int = nr_seq_evento_int_p
        and cd_event_parent_seq = cd_event_parent_seq_p
        and ie_status in ( 'T', 'S' );

    if ( ie_exist_w > 0 ) then
        return 'S';
    else
        return 'N';
    end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION is_integration_exist ( nr_seq_evento_int_p integration_call_log.nr_seq_evento_int%type, cd_event_parent_seq_p integration_call_log.cd_event_parent_seq%type ) FROM PUBLIC;
