-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION f_extract_utc_bb (data_p timestamp) RETURNS timestamp AS $body$
DECLARE


dt_timezone_utc_w       timestamp;
timezone_id_w           varchar(50);
current_timezone_w      varchar(10);


BEGIN

    BEGIN
        select Time_Zone_ID into STRICT timezone_id_w from global_settings;

    EXCEPTION WHEN OTHERS THEN
        timezone_id_w:= null;
    END;

    if (coalesce(timezone_id_w::text, '') = '') then
    
        begin
            select	ie_utc
            into STRICT	current_timezone_w
            from	estab_horario_verao
            where	cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento
            and	data_p between dt_inicial and dt_final;
        exception
            when others then
                current_timezone_w	:= null;
        end;

        if (coalesce(current_timezone_w::text, '') = '') then
            begin
                select	ie_utc
                into STRICT	current_timezone_w
                from	estabelecimento
                where	cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento;	
            exception
            when others then
                current_timezone_w	:= null;
            end;
        end	if;

        if (coalesce(current_timezone_w::text, '') = '') then
            current_timezone_w := TO_CHAR(CURRENT_TIMESTAMP,'TZR');
        end if;

        dt_timezone_utc_w:= ((data_p, current_timezone_w)::timestamp with time zone AT TIME ZONE 'UTC');

    else

        dt_timezone_utc_w:= data_p;

    end if;

    RETURN dt_timezone_utc_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION f_extract_utc_bb (data_p timestamp) FROM PUBLIC;
