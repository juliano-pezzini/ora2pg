-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE popula_agenda_build (nm_usuario_p text) AS $body$
DECLARE


dt_agendamento_w		timestamp;
ie_periodo_w		varchar(2);
ie_status_w		varchar(2);
qt_registro_w		bigint;
nm_usuario_gerente_w	varchar(20);
ds_motivo_agendamento_w	varchar(2000);
ds_feriado_w		varchar(2000);
nr_seq_ordem_serv_w	bigint;
cd_versao_w	varchar(15);
dt_liberacao_w	timestamp;
nr_sequencia_w	bigint;
nr_maior_w		bigint;
ds_hotfix_w		varchar(25);

C01 CURSOR FOR
SELECT	a.dt_agendamento,
	a.ie_periodo
from	(SELECT	trunc(clock_timestamp())+(rownum-1) dt_agendamento,
		'M' ie_periodo
	from	ajuste_versao_cliente a
	where	1 = 1
	
union all

	select	trunc(clock_timestamp())+(rownum-1) dt_agendamento,
		'V' ie_periodo
	from	ajuste_versao_cliente a
	where	1 = 1 
	
union all

	select	trunc(clock_timestamp())+(rownum-1) dt_agendamento,
		'A' ie_periodo
	from	ajuste_versao_cliente a
	where	1 = 1 
	
union all

	select	trunc(clock_timestamp())+(rownum-1) dt_agendamento,
		'B' ie_periodo
	from	ajuste_versao_cliente a
	where	1 = 1  LIMIT 19) a
order by a.dt_agendamento;

C02 CURSOR FOR
SELECT	a.nr_sequencia,
		a.nm_usuario nm_usuario_gerente,
		a.ie_status,
		a.ds_motivo_agendamento,
		a.nr_seq_ordem_serv,
		a.ie_periodo,
		a.cd_versao,
		a.dt_liberacao,
		a.ds_hotfix
from	agendamento_build a
where	trunc(dt_agendamento) = trunc(dt_agendamento_w)
and	a.ie_periodo = ie_periodo_w
and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
and a.ie_status <> 'C';

C03 CURSOR FOR
SELECT	a.nr_sequencia,
		a.nm_usuario nm_usuario_gerente,
		a.ie_status,
		a.ds_motivo_agendamento,
		a.nr_seq_ordem_serv,
		a.ie_periodo,
		a.cd_versao,
		a.dt_liberacao,
		a.ds_hotfix
from	agendamento_build a
where	trunc(dt_agendamento) = trunc(dt_agendamento_w)
and	a.ie_periodo = 'P'
and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
and a.ie_status <> 'C';


BEGIN

select	max(coalesce(nr_sequencia,0))+1000
into STRICT	nr_maior_w
from	agendamento_build;

delete from w_agenda_build;
commit;

open C01;
loop
fetch C01 into	
	dt_agendamento_w,
	ie_periodo_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	ds_feriado_w:= '';	
	if (obter_se_dia_util(trunc(dt_agendamento_w),1) = 'N') then
		ds_feriado_w:= 'Feriado';
	else
		ds_feriado_w:= Obter_Dia_Semana(dt_agendamento_w);
	end if;
	
	select	count(*)
	into STRICT	qt_registro_w
	from	agendamento_build a
	where	trunc(dt_agendamento) = trunc(dt_agendamento_w)
	and	a.ie_periodo = ie_periodo_w
	and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and a.ie_status <> 'C';
	
	if (qt_registro_w > 0) then
		open C02;
		loop
		fetch C02 into	
			nr_sequencia_w,
			nm_usuario_gerente_w,
			ie_status_w,
			ds_motivo_agendamento_w,
			nr_seq_ordem_serv_w,
			ie_periodo_w,
			cd_versao_w,
			dt_liberacao_w,
			ds_hotfix_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin
			insert into w_agenda_build(nr_sequencia,
					dt_atualizacao,
					dt_atualizacao_nrec,
					nm_usuario,
					nm_usuario_nrec,
					dt_agendamento,
					ie_periodo,
					nm_usuario_gerente,
					ie_status,
					ds_motivo_agendamento,
					ds_feriado,
					nr_seq_ordem_serv,
					cd_versao,
					dt_liberacao,
					ds_hotfix)
				values (	nr_sequencia_w,
						clock_timestamp(),
						clock_timestamp(),
						nm_usuario_p,
						nm_usuario_p,
						dt_agendamento_w,
						ie_periodo_w,
						nm_usuario_gerente_w,
						ie_status_w,
						ds_motivo_agendamento_w,
						ds_feriado_w,
						nr_seq_ordem_serv_w,
						cd_versao_w,
						dt_liberacao_w,
						ds_hotfix_w);
			commit;
			end;
		end loop;
		close C02;
	else
		nr_maior_w:= nr_maior_w+1;
		insert into w_agenda_build(nr_sequencia,
					dt_atualizacao,
					dt_atualizacao_nrec,
					nm_usuario,
					nm_usuario_nrec,
					dt_agendamento,
					ie_periodo,
					nm_usuario_gerente,
					ie_status,
					ds_motivo_agendamento,
					ds_feriado,
					nr_seq_ordem_serv,
					cd_versao,
					dt_liberacao,
					ds_hotfix)
			values (	nr_maior_w,
					clock_timestamp(),
					clock_timestamp(),
					nm_usuario_p,
					nm_usuario_p,
					dt_agendamento_w,
					ie_periodo_w,
					null,
					'LV',
					null,
					ds_feriado_w,
					null,
					null,
					null,
					null);
		commit;	
	end if;
		
	select	count(*)
	into STRICT	qt_registro_w
	from	agendamento_build a
	where	trunc(dt_agendamento) = trunc(dt_agendamento_w)
	and	a.ie_periodo = 'P'
	and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and a.ie_status <> 'C';
	
	if (ie_periodo_w = 'M') and (qt_registro_w > 0) then	
	
		open C03;
		loop
		fetch C03 into	
			nr_sequencia_w,
			nm_usuario_gerente_w,
			ie_status_w,
			ds_motivo_agendamento_w,
			nr_seq_ordem_serv_w,
			ie_periodo_w,
			cd_versao_w,
			dt_liberacao_w,
			ds_hotfix_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
			begin
				insert into w_agenda_build(nr_sequencia,
						dt_atualizacao,
						dt_atualizacao_nrec,
						nm_usuario,
						nm_usuario_nrec,
						dt_agendamento,
						ie_periodo,
						nm_usuario_gerente,
						ie_status,
						ds_motivo_agendamento,
						ds_feriado,
						nr_seq_ordem_serv,
						cd_versao,
						dt_liberacao,
						ds_hotfix)
					values (	nr_sequencia_w,
							clock_timestamp(),
							clock_timestamp(),
							nm_usuario_p,
							nm_usuario_p,
							dt_agendamento_w,
							ie_periodo_w,
							nm_usuario_gerente_w,
							ie_status_w,
							ds_motivo_agendamento_w,
							ds_feriado_w,
							nr_seq_ordem_serv_w,
							cd_versao_w,
							dt_liberacao_w,
							ds_hotfix_w);
				commit;
			end;
		end loop;
		close C03;
	end if;
	
	end;
end loop;
close C01;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE popula_agenda_build (nm_usuario_p text) FROM PUBLIC;
