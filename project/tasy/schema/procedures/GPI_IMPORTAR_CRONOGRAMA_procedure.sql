-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gpi_importar_cronograma ( nr_seq_cronograma_p bigint, dt_inicio_prev_p text, dt_fim_prev_p text, qt_hora_prev_p text, qt_hora_real_p text, nm_etapa_p text, ie_fase_p text, ds_objetivo_p text, cd_classificacao_p text, nr_seq_tipo_etapa_p text, nm_usuario_p text) AS $body$
DECLARE


cd_classificacao_w			varchar(255);
ds_erro_w			varchar(4000);
ds_campos_w			varchar(255);
dt_inicio_prev_w			varchar(30);
dt_inicio_prev_ww		timestamp;
dt_fim_prev_w			varchar(30);
dt_fim_prev_ww			timestamp;
ie_fase_w			varchar(1);
ie_modulo_w			varchar(1);
nr_seq_apres_w			bigint;
nr_seq_superior_w			bigint;
qt_hora_prev_w			double precision;
qt_hora_real_w			double precision;
qt_nivel_w			bigint;
dia_w				varchar(2);
mes_w				varchar(2);
ano_w				varchar(10);
minutos_w			varchar(10);


BEGIN

begin
dt_inicio_prev_w	:= replace(dt_inicio_prev_p,'T','');
dt_inicio_prev_w	:= replace(dt_inicio_prev_w,'-','');
dt_inicio_prev_w	:= replace(dt_inicio_prev_w,':','');
dt_inicio_prev_w	:= replace(dt_inicio_prev_w,' ','');

ano_w			:= substr(dt_inicio_prev_w,1,4);
mes_w			:= substr(dt_inicio_prev_w,5,2);
dia_w			:= substr(dt_inicio_prev_w,7,2);
minutos_w		:= substr(dt_inicio_prev_w,9,length(dt_inicio_prev_w));
dt_inicio_prev_w	:= dia_w || mes_w || ano_w || minutos_w;
dt_inicio_prev_ww	:= to_date(dt_inicio_prev_w,'dd/mm/yyyy hh24:mi:ss');

dt_fim_prev_w	:= replace(dt_fim_prev_p,'T','');
dt_fim_prev_w	:= replace(dt_fim_prev_w,'-','');
dt_fim_prev_w	:= replace(dt_fim_prev_w,':','');
dt_fim_prev_w	:= replace(dt_fim_prev_w,' ','');
ano_w		:= substr(dt_fim_prev_w,1,4);
mes_w		:= substr(dt_fim_prev_w,5,2);
dia_w		:= substr(dt_fim_prev_w,7,2);
minutos_w	:= substr(dt_fim_prev_w,9,length(dt_fim_prev_w));
dt_fim_prev_w	:= dia_w || mes_w || ano_w || minutos_w;
dt_fim_prev_ww	:= to_date(dt_fim_prev_w,'dd/mm/yyyy hh24:mi:ss');
exception when others then
	ds_erro_w		:= sqlerrm(SQLSTATE);

	CALL wheb_mensagem_pck.exibir_mensagem_abort(186967,'dt_inicio_prev=' || dt_inicio_prev_w || ';' || 'dt_fim_prev=' || dt_fim_prev_w || ';' ||  'ds_erro=' || ds_erro_w);

end;

select	CASE WHEN ie_fase_p=1 THEN 'S'  ELSE 'N' END ,
	coalesce(proj_converte_hora_tempo_cron(qt_hora_prev_p),0),
	coalesce(proj_converte_hora_tempo_cron(qt_hora_real_p),0),
	ctb_obter_nivel_classif_conta(cd_classificacao_p),
	'N'
into STRICT	ie_fase_w,
	qt_hora_prev_w,
	qt_hora_real_w,
	qt_nivel_w,
	ie_modulo_w
;

begin
if (qt_nivel_w = 1) then

	nr_seq_superior_w	:= null;
else
	select	max(a.nr_sequencia)
	into STRICT	nr_seq_superior_w
	from	gpi_cron_etapa a
	where	a.nr_seq_cronograma 	= nr_seq_cronograma_p
	and	(ctb_obter_nivel_classif_conta(gpi_obter_classif_etapa(a.nr_sequencia)))::numeric  = (ctb_obter_nivel_classif_conta(cd_classificacao_p) - 1)::numeric;
end if;

select	coalesce(max(a.nr_seq_apres),0) + 10
into STRICT	nr_seq_apres_w
from	gpi_cron_etapa a
where	ctb_obter_nivel_classif_conta(gpi_obter_classif_etapa(a.nr_sequencia)) = qt_nivel_w
and	a.nr_seq_cronograma		= nr_seq_cronograma_p
and	a.nr_seq_superior		= nr_seq_superior_w;

insert	into gpi_cron_etapa(
	nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_seq_apres,
	nm_etapa,
	ds_objetivo,
	dt_inicio_prev,
	dt_fim_prev,
	qt_hora_prev,
	qt_hora_real,
	pr_etapa,
	nr_seq_cronograma,
	nr_seq_superior,
	nr_seq_tipo_etapa)
values (	nextval('gpi_cron_etapa_seq'),
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_apres_w,
	substr(nm_etapa_p,1,100),
	substr(ds_objetivo_p,1,4000),
	dt_inicio_prev_ww,
	dt_fim_prev_ww,
	qt_hora_prev_w,
	qt_hora_real_w,
	0,
	nr_seq_cronograma_p,
	nr_seq_superior_w,
	nr_seq_tipo_etapa_p);

exception when others then
	ds_erro_w		:= sqlerrm(SQLSTATE);
	ds_campos_w		:= 	substr(	nr_seq_apres_w		|| chr(10) || chr(13) ||
						nm_etapa_p		|| chr(10) || chr(13) ||
						ds_objetivo_p		|| chr(10) || chr(13) ||
						dt_inicio_prev_w		|| chr(10) || chr(13) ||
						dt_fim_prev_w		|| chr(10) || chr(13) ||
						qt_hora_prev_w		|| chr(10) || chr(13) ||
						qt_hora_real_w		|| chr(10) || chr(13) ||
						nr_seq_cronograma_p	|| chr(10) || chr(13) ||
						nr_seq_superior_w, 1, 255);



	CALL wheb_mensagem_pck.exibir_mensagem_abort(186966,'ds_erro=' ||  ds_erro_w || ';' || 'ds_campos=' || ds_campos_w);
end;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gpi_importar_cronograma ( nr_seq_cronograma_p bigint, dt_inicio_prev_p text, dt_fim_prev_p text, qt_hora_prev_p text, qt_hora_real_p text, nm_etapa_p text, ie_fase_p text, ds_objetivo_p text, cd_classificacao_p text, nr_seq_tipo_etapa_p text, nm_usuario_p text) FROM PUBLIC;

