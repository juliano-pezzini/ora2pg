-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_tempo_lib_grupo ( nm_usuario_p text, dt_ini_p timestamp, dt_fim_p timestamp, nr_seq_grupo_p bigint, tipo_calculo_p text) RETURNS varchar AS $body$
/*M para media do grupo, S para soma do grupo, A para tempo lib da auditoria*/
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Retornar a média ou soma de tempo de liberação do grupo de auditoria, ou a soma
total da auditoria .
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [ x]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:Performance.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
qt_intervalo_w		bigint;
qt_segundos_w		bigint;
dt_liberacao_w		timestamp;
dt_inicio_auditoria_w	timestamp;
ds_retorno_w		varchar(60);
qt_registros_w		bigint;
nr_seq_grupo_auditor_w	bigint;
nr_seq_auditoria_w	bigint;
nr_tot_temp_auditoria_w	bigint;
nr_seq_ordem_w		bigint;
ie_status_w		varchar(2);
dt_liberacao_ant_w	timestamp;
dt_atualizacao_nrec_w	timestamp;
qt_grupo_w		smallint;

C01 CURSOR FOR
SELECT
	coalesce(b.dt_Liberacao,clock_timestamp()) 		dt_liberacao,
	coalesce(b.dt_inicio_auditoria,clock_timestamp())	dt_inicio_auditoria
from 	pls_auditoria a,
	pls_auditoria_grupo b
where (a.nr_sequencia = b.nr_seq_auditoria)
and (a.dt_auditoria between dt_ini_p and dt_fim_p )
and (b.nr_seq_grupo = nr_seq_grupo_p or nr_seq_grupo_p = 0)
and (b.nm_usuario_exec = nm_usuario_p or coalesce(nm_usuario_p::text, '') = '')
and (b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '')
and (b.dt_inicio_auditoria IS NOT NULL AND b.dt_inicio_auditoria::text <> '')
and (a.ie_status = 'F');


C02 CURSOR FOR
SELECT
	b.nr_sequencia nr_sequencia,
	b.nr_seq_auditoria nr_seq_auditoria
from 	pls_auditoria a,
	pls_auditoria_grupo b
where (a.nr_sequencia = b.nr_seq_auditoria)
and (a.dt_auditoria between dt_ini_p and dt_fim_p )
and (b.nr_seq_grupo = nr_seq_grupo_p or nr_seq_grupo_p = 0)
and (b.nm_usuario_exec = nm_usuario_p or coalesce(nm_usuario_p::text, '') = '')
and (b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '')
and (b.dt_inicio_auditoria IS NOT NULL AND b.dt_inicio_auditoria::text <> '')
and (a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
and (a.ie_status = 'F');


BEGIN
	qt_registros_w	:= 0;
	qt_segundos_w 	:= 0;
	nr_tot_temp_auditoria_w :=0;
if (tipo_calculo_p = 'M' or tipo_calculo_p = 'S')then

	open C01;
	loop
	fetch C01 into
		dt_liberacao_w,
		dt_inicio_auditoria_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		qt_registros_w := qt_registros_w + 1;
		qt_segundos_w  := qt_segundos_w + ((dt_liberacao_w - dt_inicio_auditoria_w)*86400);
		end;
		end loop;
		close C01;

	if (tipo_calculo_p = 'M') then
		if (qt_registros_w > 0)then
			qt_segundos_w	:= qt_segundos_w / qt_registros_w;
		else
			qt_segundos_w	:= 0;
		end if;
	end if;

	ds_retorno_w := trim(both replace(to_char(floor(dividir(dividir(qt_segundos_w,60),60)),'999,999,900'),',','.'))
			|| ':' || substr(to_char(floor(mod(dividir(qt_segundos_w,60),60)),'00'),2,2)
			|| ':' || substr(to_char(mod(qt_segundos_w,60),'00'),2,2);
end if;
if (tipo_calculo_p ='A')then

	open C02;
	loop
	fetch C02 into
		nr_seq_grupo_auditor_w,
		nr_seq_auditoria_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
	begin
		select	nr_seq_ordem,
			ie_status,
			dt_liberacao,
			dt_atualizacao_nrec
		into STRICT	nr_seq_ordem_w,
			ie_status_w,
			dt_liberacao_w,
			dt_atualizacao_nrec_w
		from	pls_auditoria_grupo
		where	nr_sequencia = nr_seq_grupo_auditor_w;

		select	count(1)
		into STRICT	qt_grupo_w
		from	pls_auditoria_grupo
		where	nr_seq_ordem < nr_seq_ordem_w
		and	coalesce(dt_liberacao::text, '') = ''
		and	nr_seq_auditoria = nr_seq_auditoria_w;

		select	max(dt_liberacao)
		into STRICT	dt_liberacao_ant_w
		from	pls_auditoria_grupo
		where	nr_seq_ordem < nr_seq_ordem_w
		and	nr_seq_auditoria = nr_seq_auditoria_w;


		if (qt_grupo_w = 0) then

			if (coalesce(dt_liberacao_ant_w::text, '') = '') then
				dt_liberacao_ant_w := dt_atualizacao_nrec_w;
			end if;
			if (ie_status_w = 'P')  then
				nr_tot_temp_auditoria_w := nr_tot_temp_auditoria_w + (coalesce(dt_liberacao_w, clock_timestamp()) - dt_liberacao_ant_w) * 86400;
			else
				nr_tot_temp_auditoria_w := nr_tot_temp_auditoria_w + (clock_timestamp() - dt_liberacao_ant_w) * 86400;
			end if;
		end if;
	end;
	end loop;
	close C02;
	ds_retorno_w := trim(both replace(to_char(floor(dividir(dividir(nr_tot_temp_auditoria_w,60),60)),'999,999,900'),',','.'))
		|| ':' || substr(to_char(floor(mod(dividir(nr_tot_temp_auditoria_w,60),60)),'00'),2,2)
		|| ':' || substr(to_char(mod(nr_tot_temp_auditoria_w,60),'00'),2,2);
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_tempo_lib_grupo ( nm_usuario_p text, dt_ini_p timestamp, dt_fim_p timestamp, nr_seq_grupo_p bigint, tipo_calculo_p text) FROM PUBLIC;

