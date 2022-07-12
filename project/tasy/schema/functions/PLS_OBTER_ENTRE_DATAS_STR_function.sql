-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_entre_datas_str ( dt_periodo_inicial_p text, dt_periodo_final_p text, dt_inicial_p text) RETURNS varchar AS $body$
DECLARE

ie_retorno_w        varchar(1) := 'N';
dt_periodo_inicial_w    timestamp;
dt_periodo_final_w    timestamp;

BEGIN

if (coalesce(dt_periodo_inicial_p,'  /  /    ') <> '  /  /    ') and (coalesce(dt_periodo_inicial_p,'  /    ') <> '  /    ') and (coalesce(dt_periodo_inicial_p,' ') <> ' ') and -- portal
   (coalesce(dt_periodo_inicial_p, '0') <> '0')then --portal
    begin
        select    'S'
        into STRICT    ie_retorno_w

        where    trunc(to_date(dt_inicial_p)) between trunc(to_date(CASE WHEN dt_periodo_inicial_p='  /  /    ' THEN clock_timestamp()  ELSE dt_periodo_inicial_p END )) and trunc(to_date(CASE WHEN dt_periodo_final_p='  /  /    ' THEN clock_timestamp()  ELSE dt_periodo_final_p END ));
    exception
    when others then
        begin
            if (dt_periodo_inicial_p <> '  /    ') then
                dt_periodo_inicial_w := to_date((to_char(clock_timestamp(),'dd')||'/'||dt_periodo_inicial_p),'dd/mm/yyyy');
            end if;

            if (dt_periodo_final_p <> '  /    ') then
                dt_periodo_final_w := to_date((to_char(clock_timestamp(),'dd')||'/'||dt_periodo_final_p),'dd/mm/yyyy');
            end if;

            select    'S'
            into STRICT    ie_retorno_w

            where    trunc(to_date(dt_inicial_p),'month') between trunc(to_date(CASE WHEN dt_periodo_inicial_p='  /    ' THEN clock_timestamp()  ELSE dt_periodo_inicial_w END ),'month') and trunc(to_date(CASE WHEN dt_periodo_final_p='  /    ' THEN clock_timestamp()  ELSE dt_periodo_final_w END ),'month');
        exception
        when others then
            ie_retorno_w    := 'N';
        end;
    end;
else
    /*Se não existe o parametro*/

    ie_retorno_w := 'S';
end if;

return ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_entre_datas_str ( dt_periodo_inicial_p text, dt_periodo_final_p text, dt_inicial_p text) FROM PUBLIC;

