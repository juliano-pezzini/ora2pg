-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE insert_update_report_controler ( nr_sequencia_p INOUT bigint, nr_ip_p text, nr_port_p bigint, ds_server_name_p text, ds_application_name_p text, ds_application_version_p text) AS $body$
BEGIN

if (coalesce(nr_sequencia_p::text, '') = '') then

    select  nextval('system_application_info_seq')
    into STRICT    nr_sequencia_p
;

    insert into SYSTEM_APPLICATION_INFO(    NR_SEQUENCIA,
                                            NR_IP,
                                            NR_PORT,
                                            DT_UP_TIME,
                                            DS_APP_SERVER_NAME,
                                            DS_APPLICATION_NAME,
                                            DS_APPLICATION_VERSION)
                                values (   nr_sequencia_p,
                                            nr_ip_p,
                                            nr_port_p,
                                            clock_timestamp(),
                                            ds_server_name_p,
                                            ds_application_name_p,
                                            ds_application_version_p
                                            );
else

    update  SYSTEM_APPLICATION_INFO
    set     DT_LAST_TIME = clock_timestamp()
    where   NR_SEQUENCIA = nr_sequencia_p;

end if;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE insert_update_report_controler ( nr_sequencia_p INOUT bigint, nr_ip_p text, nr_port_p bigint, ds_server_name_p text, ds_application_name_p text, ds_application_version_p text) FROM PUBLIC;

