-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE swcf_submit_dl_template (nr_sequencia_p bigint, nm_usuario_p text, ie_action_p bigint) AS $body$
BEGIN
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
    if (ie_action_p = 1) then    	
        update  dl_template
        set	dt_liberacao    = clock_timestamp(),
            nm_usuario_liberacao    = nm_usuario_p,
            ie_status   = 'L',
            dt_atualizacao = clock_timestamp(),
            nm_usuario = nm_usuario_p
        where   nr_sequencia = nr_sequencia_p;
    elsif (ie_action_p = 2) then
        update  dl_template
        set	dt_liberacao     = NULL,
            nm_usuario_liberacao     = NULL,
            ie_status    = NULL,
            dt_atualizacao = clock_timestamp(),
            nm_usuario = nm_usuario_p
        where   nr_sequencia = nr_sequencia_p;
    end if;

    commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE swcf_submit_dl_template (nr_sequencia_p bigint, nm_usuario_p text, ie_action_p bigint) FROM PUBLIC;
