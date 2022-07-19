-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE proj_gerar_ativ_por_req ( nr_seq_cronograma_p bigint, nm_usuario_p text ) AS $body$
DECLARE


nr_seq_proj_w			proj_cronograma.nr_seq_proj%type;
nr_seq_proj_cron_etapa_sup_w	proj_cron_etapa.nr_sequencia%type;
nr_seq_proj_cron_etapa_w	proj_cron_etapa.nr_sequencia%type;
nr_seq_requisito_w		des_requisito.nr_sequencia%type;
ds_requisito_w			des_requisito.ds_titulo%type;
nr_seq_apresentacao_w		proj_cron_etapa.nr_seq_apres%type;
pr_etapa_w			des_requisito_item.pr_realizacao%type;
qt_hora_prev_w			proj_cron_etapa.qt_hora_prev%type;
ds_atividade_w			des_requisito_item.ds_titulo%type;
ds_etapa_w			proj_cron_etapa.ds_etapa%type;
pr_realizacao_w			proj_cron_etapa.pr_etapa%type;
qt_previsto_w			proj_cron_etapa.qt_hora_prev%type;

C01 CURSOR FOR
SELECT	a.nr_sequencia,
	a.ds_titulo,
	coalesce(round((c.pr_realizacao)::numeric, 2), 0),
	coalesce(round((c.qt_hora_prev)::numeric, 0), 0)
from	des_requisito a,
	(	select	b.nr_seq_requisito,
			coalesce((sum(b.pr_realizacao) / CASE WHEN count(b.nr_sequencia)=0 THEN  1  ELSE count(b.nr_sequencia) END ), 0) pr_realizacao,
			coalesce(sum(b.qt_previsto), 0) qt_hora_prev
		from	des_requisito_item b
		where	b.ie_tipo_requisito = 'RF'
		group by b.nr_seq_requisito	) c
where	a.nr_sequencia = c.nr_seq_requisito
and	a.nr_seq_projeto = nr_seq_proj_w
and exists ( 	SELECT 	1
		from	des_requisito_item x
		where	a.nr_sequencia = x.nr_seq_requisito
		and	x.ie_tipo_requisito = 'RF'	)
order by a.nr_sequencia;

C02 CURSOR FOR
SELECT	ds_titulo,
	ds_item,
	coalesce(round((pr_realizacao)::numeric, 2), 0),
	coalesce(round((qt_previsto)::numeric, 0), 0)
from	des_requisito_item
where	nr_seq_requisito = nr_seq_requisito_w
and	ie_tipo_requisito = 'RF'
order by nr_sequencia;


BEGIN

select	nr_seq_proj
into STRICT 	nr_seq_proj_w
from	proj_cronograma
where	nr_sequencia = nr_seq_cronograma_p;

select 	coalesce(max(a.nr_seq_apres)+5, 1)
into STRICT	nr_seq_apresentacao_w
from	proj_cron_etapa a
where 	a.nr_seq_cronograma = nr_seq_cronograma_p;

open C01;
loop
fetch C01 into
	nr_seq_requisito_w,
	ds_requisito_w,
	pr_etapa_w,
	qt_hora_prev_w;
EXIT WHEN NOT FOUND; /* apply on C01 */

	select 	nextval('proj_cron_etapa_seq')
	into STRICT	nr_seq_proj_cron_etapa_sup_w
	;

	insert into proj_cron_etapa( 	nr_sequencia,
					nr_seq_cronograma,
					nr_seq_apres,
					dt_atualizacao,
					nm_usuario,
					ie_fase,
					ie_modulo,
					pr_etapa,
					qt_hora_prev,
					ds_atividade	)
	values (	nr_seq_proj_cron_etapa_sup_w,
					nr_seq_cronograma_p,
					nr_seq_apresentacao_w,
					clock_timestamp(),
					nm_usuario_p,
					'N',
					'N',
					pr_etapa_w,
					qt_hora_prev_w,
					ds_requisito_w	);

	nr_seq_apresentacao_w := nr_seq_apresentacao_w + 5;

	open C02;
	loop
	fetch C02 into
		ds_atividade_w,
		ds_etapa_w,
		pr_realizacao_w,
		qt_previsto_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */

	select 	nextval('proj_cron_etapa_seq')
	into STRICT	nr_seq_proj_cron_etapa_w
	;

	insert into proj_cron_etapa(	nr_sequencia,
					nr_seq_cronograma,
					nr_seq_apres,
					nr_seq_superior,
					ds_atividade,
					ds_etapa,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					ie_fase,
					ie_modulo,
					pr_etapa,
					qt_hora_prev	)
	values (	nr_seq_proj_cron_etapa_w,
					nr_seq_cronograma_p,
					nr_seq_apresentacao_w,
					nr_seq_proj_cron_etapa_sup_w,
					ds_atividade_w,
					ds_etapa_w,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					'N',
					'N',
					pr_realizacao_w,
					qt_previsto_w	);

	nr_seq_apresentacao_w := nr_seq_apresentacao_w + 5;

	end loop;
	close C02;

end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE proj_gerar_ativ_por_req ( nr_seq_cronograma_p bigint, nm_usuario_p text ) FROM PUBLIC;

