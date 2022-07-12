-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_peso_ideal_ajust_pac ( cd_pessoa_fisica_p text, qt_peso_p bigint, qt_fator_correcao_p bigint, qt_altura_cm_p bigint) RETURNS double precision AS $body$
DECLARE


qt_peso_ideal_paciente_w	double precision(10) := 0.0;
qt_peso_ideal_ajustado_w	double precision(10) := 0.0;
sql_w                       varchar(250);


BEGIN
    select 	obter_peso_ideal_pac(cd_pessoa_fisica_p, qt_altura_cm_p)
    into STRICT 	qt_peso_ideal_paciente_w
;
    --INICIO MD 1
    -- OBTER_PESO_IDAL_AJUST_MD
    begin
        sql_w := 'CALL OBTER_PESO_IDEAL_AJUST_MD(:1, :2, :3) INTO :qt_peso_ideal_ajustado_w';
        EXECUTE sql_w USING IN qt_peso_ideal_paciente_w, IN qt_fator_correcao_p, qt_peso_p, OUT qt_peso_ideal_ajustado_w;
    exception
        when others then
            qt_peso_ideal_ajustado_w := null;
    end;
    --FIM MD 1
    return qt_peso_ideal_ajustado_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_peso_ideal_ajust_pac ( cd_pessoa_fisica_p text, qt_peso_p bigint, qt_fator_correcao_p bigint, qt_altura_cm_p bigint) FROM PUBLIC;

