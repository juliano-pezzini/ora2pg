-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_proc_repetido (nr_interno_conta_p text) RETURNS varchar AS $body$
DECLARE


qt_proc_w               bigint;
ds_retorno_w    varchar(1) := 'N';

C01 CURSOR FOR
                SELECT  count(*)
                from    procedimento_paciente
                where   nr_interno_conta = nr_interno_conta_p
                and             (nr_doc_convenio IS NOT NULL AND nr_doc_convenio::text <> '')
                GROUP BY cd_procedimento,
                                 ie_origem_proced,
                                 nr_doc_convenio;


BEGIN

open C01;
loop
fetch C01 into
        qt_proc_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
        begin
        ds_retorno_w := 'S';
        end;
end loop;
close C01;

return  ds_retorno_w;

end obter_se_proc_repetido HAVING  count(*)  > 1
;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_proc_repetido (nr_interno_conta_p text) FROM PUBLIC;
