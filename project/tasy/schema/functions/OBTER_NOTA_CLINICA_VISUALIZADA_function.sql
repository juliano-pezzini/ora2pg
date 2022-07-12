-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nota_clinica_visualizada ( nr_atendimento_p bigint, nm_usuario_p text ) RETURNS varchar AS $body$
DECLARE


cd_evolucao_w               evolucao_paciente.cd_evolucao%type;
nr_notas_nao_visualizadas_w bigint := 0;
qt_total_w                  bigint := 0;

c01 CURSOR FOR
SELECT b.cd_evolucao
from   evolucao_paciente b
where  (b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '')
and trunc(b.DT_ATUALIZACAO) >= trunc(clock_timestamp() - interval '3 days')
and    not exists (select 1
                   from evo_pac_int_visualizado a 
                   where b.cd_evolucao = a.nr_seq_evo_paciente
                   and a.nm_usuario          = nm_usuario_p)
and     b.nr_atendimento = nr_atendimento_p;


BEGIN

open C01;
	loop
	   fetch C01 into
		 cd_evolucao_w;
	   EXIT WHEN NOT FOUND; /* apply on C01 */

     qt_total_w := qt_total_w + 1;

	end loop;
close C01;

return coalesce(qt_total_w, 0);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nota_clinica_visualizada ( nr_atendimento_p bigint, nm_usuario_p text ) FROM PUBLIC;
