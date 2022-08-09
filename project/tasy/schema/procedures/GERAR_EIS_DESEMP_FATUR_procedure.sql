-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_eis_desemp_fatur ( dt_parametro_P timestamp, NM_USUARIO_P text) AS $body$
DECLARE

 
dt_parametro_fim_w		timestamp;
dt_referencia_w			timestamp;
ie_historico_w			varchar(01);
dt_mesano_referencia_w		timestamp;
cd_estabelecimento_w		smallint;
cd_convenio_parametro_w		integer;
ie_tipo_atendimento_w		smallint;
ie_complexidade_w		varchar(01);
hr_fechamento_w			varchar(02);
nm_usuario_fecha_w		varchar(15);
ie_etapa_w			varchar(15);
qt_conta_w			integer;
qt_minuto_w			bigint;
dt_fechamento_w			timestamp;
vl_conta_w			double precision;
ds_convenio_w			varchar(255);
qt_reg_w			bigint;
qt_atend_w			bigint;
cd_responsavel_w		varchar(10);
nr_sequencia_w			bigint;	
ds_erro_w			varchar(255);		
cd_setor_usuario_w		bigint;
cd_medico_resp_w		bigint;
nr_seq_etapa_w			bigint;
cd_estab_w			smallint;
ie_tipo_protocolo_w		protocolo_convenio.ie_tipo_protocolo%type;

/* Utilizar a cláusula NO_QUERY_TRANSFORMATION  no Hint dos comandos OS 409029*/
 
 
C01 CURSOR FOR 
/* selecionar as contas inseridas em protocolo de atendimentos com alta identificar o tempo entre a alta e o protocolo definitivo */
 
SELECT 
	trunc(a.dt_mesano_referencia,'month') dt_referencia, 
	coalesce(a.cd_estabelecimento, t.cd_estabelecimento) cd_estabelecimento, 
	a.cd_convenio_parametro, 
	t.ie_tipo_atendimento, 
	coalesce(a.ie_complexidade,'B') ie_complexidade, 
	to_char(coalesce(p.dt_definitivo, a.dt_atualizacao),'hh24') hr_fechamento, 
	CASE WHEN ie_historico_w='N' THEN  p.nm_usuario  ELSE substr(coalesce(obter_usuario_conta_hist(a.nr_interno_conta,10),p.nm_usuario),1,15) END  nm_usuario_fecha, 
	'T' ie_etapa, 
	count(*) qt_conta, 
	max((SELECT count(x.nr_atendimento) from atendimento_paciente x where x.nr_atendimento = t.nr_atendimento)) qt_atend, 
	trunc(sum((coalesce(p.dt_definitivo, a.dt_atualizacao) - t.dt_alta) * 1440)) qt_minuto, 
	trunc(coalesce(p.dt_definitivo,a.dt_atualizacao)) dt_fechamento, 
	coalesce(sum(a.vl_conta),0) vl_conta, 
	a.cd_responsavel, 
	t.cd_medico_resp, 
	substr(obter_conta_paciente_etapa(a.nr_interno_conta, 'C'),1,254) nr_seq_etapa, 
	p.ie_tipo_protocolo ie_tipo_protocolo 
from 	Protocolo_convenio p, 
	atendimento_paciente t, 
	conta_paciente a 
where 	a.dt_mesano_referencia between dt_referencia_w and dt_parametro_fim_w 
and 	a.nr_atendimento	= t.nr_atendimento 
and	a.nr_seq_protocolo	= p.nr_seq_protocolo 
and	(t.dt_alta IS NOT NULL AND t.dt_alta::text <> '') 
group by 
	trunc(a.dt_mesano_referencia,'month'), 
	coalesce(a.cd_estabelecimento, t.cd_estabelecimento), 
	a.cd_convenio_parametro, 
	t.ie_tipo_atendimento, 
	coalesce(a.ie_complexidade,'B'), 
	to_char(coalesce(p.dt_definitivo, a.dt_atualizacao),'hh24'), 
	CASE WHEN ie_historico_w='N' THEN  p.nm_usuario  ELSE substr(coalesce(obter_usuario_conta_hist(a.nr_interno_conta,10),p.nm_usuario),1,15) END , 
	trunc(coalesce(p.dt_definitivo,a.dt_atualizacao)), 
	a.cd_responsavel, 
	t.cd_medico_resp, 
	substr(obter_conta_paciente_etapa(a.nr_interno_conta, 'C'),1,254), 
	p.ie_tipo_protocolo 

union all
 
/* selecionar as contas inseridas em protocolo de atendimentos com alta identificar o tempo entre o fechamento da conta e o protocolo definitivo */
 
select 
	trunc(a.dt_mesano_referencia,'month') dt_referencia, 
	coalesce(a.cd_estabelecimento, t.cd_estabelecimento) cd_estabelecimento, 
	a.cd_convenio_parametro, 
	t.ie_tipo_atendimento, 
	coalesce(a.ie_complexidade,'B') ie_complexidade, 
	to_char(p.dt_definitivo,'hh24') hr_fechamento, 
	CASE WHEN ie_historico_w='N' THEN  p.nm_usuario  ELSE substr(coalesce(obter_usuario_conta_hist(a.nr_interno_conta,10),p.nm_usuario),1,15) END  nm_usuario_fecha, 
	'P' ie_etapa, 
	count(*) qt_conta, 
	max((select count(x.nr_atendimento) from atendimento_paciente x where x.nr_Atendimento = t.nr_atendimento)) qt_atend, 
	trunc(sum(p.dt_definitivo - a.dt_conta_definitiva) * 1440) qt_minuto, 
	trunc(coalesce(p.dt_definitivo,a.dt_atualizacao)) dt_fechamento, 
	coalesce(sum(a.vl_conta),0) vl_conta, 
	a.cd_responsavel, 
	t.cd_medico_resp, 
	substr(obter_conta_paciente_etapa(a.nr_interno_conta, 'C'),1,254) nr_seq_etapa, 
	p.ie_tipo_protocolo ie_tipo_protocolo 
from 	Protocolo_convenio p, 
	atendimento_paciente t, 
	conta_paciente a 
where 	a.dt_mesano_referencia between dt_referencia_w and dt_parametro_fim_w 
and 	a.nr_atendimento	= t.nr_atendimento 
and	a.nr_seq_protocolo	= p.nr_seq_protocolo 
and	(t.dt_alta IS NOT NULL AND t.dt_alta::text <> '') 
and	(a.dt_conta_definitiva IS NOT NULL AND a.dt_conta_definitiva::text <> '') 
and	(p.dt_definitivo IS NOT NULL AND p.dt_definitivo::text <> '') 
group by 
	trunc(a.dt_mesano_referencia,'month'), 
	coalesce(a.cd_estabelecimento, t.cd_estabelecimento), 
	a.cd_convenio_parametro, 
	t.ie_tipo_atendimento, 
	coalesce(a.ie_complexidade,'B'), 
	to_char(p.dt_definitivo,'hh24'), 
	CASE WHEN ie_historico_w='N' THEN  p.nm_usuario  ELSE substr(coalesce(obter_usuario_conta_hist(a.nr_interno_conta,10),p.nm_usuario),1,15) END , 
	trunc(coalesce(p.dt_definitivo,a.dt_atualizacao)), 
	a.cd_responsavel, 
	t.cd_medico_resp, 
	substr(obter_conta_paciente_etapa(a.nr_interno_conta, 'C'),1,254), 
	p.ie_tipo_protocolo 

union all
 
/* selecionar as contas de atendimento com alta para identificar o tempo entre a alta e a conta definitiva */
 
select 
	trunc(a.dt_mesano_referencia,'month') dt_referencia, 
	coalesce(a.cd_estabelecimento, t.cd_estabelecimento) cd_estabelecimento, 
	a.cd_convenio_parametro, 
	t.ie_tipo_atendimento, 
	coalesce(a.ie_complexidade,'B') ie_complexidade, 
	to_char(a.dt_conta_definitiva,'hh24') hr_fechamento, 
	CASE WHEN ie_historico_w='N' THEN  a.nm_usuario  ELSE substr(coalesce(obter_usuario_conta_hist(a.nr_interno_conta,6),a.nm_usuario),1,15) END  nm_usuario_fecha, 
	'C' ie_etapa, 
	count(*) qt_conta, 
	max((select count(x.nr_atendimento) from atendimento_paciente x where x.nr_atendimento = t.nr_atendimento)) qt_atend, 
	trunc(sum(a.dt_conta_definitiva - t.dt_alta) * 1440) qt_minuto, 
	trunc(coalesce(a.dt_conta_definitiva,a.dt_atualizacao)) dt_fechamento, 
	coalesce(sum(a.vl_conta),0) vl_conta, 
	a.cd_responsavel, 
	t.cd_medico_resp, 
	substr(obter_conta_paciente_etapa(a.nr_interno_conta, 'C'),1,254) nr_seq_etapa, 
	null ie_tipo_protocolo 
from 	atendimento_paciente t, 
	conta_paciente a 
where 	a.dt_mesano_referencia between dt_referencia_w and dt_parametro_fim_w 
and 	a.nr_atendimento	= t.nr_atendimento 
and	(t.dt_alta IS NOT NULL AND t.dt_alta::text <> '') 
and	(a.dt_conta_definitiva IS NOT NULL AND a.dt_conta_definitiva::text <> '') 
group by 
	trunc(a.dt_mesano_referencia,'month'), 
	coalesce(a.cd_estabelecimento, t.cd_estabelecimento), 
	a.cd_convenio_parametro, 
	t.ie_tipo_atendimento, 
	coalesce(a.ie_complexidade,'B'), 
	to_char(a.dt_conta_definitiva,'hh24'), 
	CASE WHEN ie_historico_w='N' THEN  a.nm_usuario  ELSE substr(coalesce(obter_usuario_conta_hist(a.nr_interno_conta,6),a.nm_usuario),1,15) END , 
	trunc(coalesce(a.dt_conta_definitiva,a.dt_atualizacao)), 
	a.cd_responsavel, 
	t.cd_medico_resp, 
	substr(obter_conta_paciente_etapa(a.nr_interno_conta, 'C'),1,254);


BEGIN 
--Gravar_Log_Indicador(41, 'Desempenho_Faturamento', sysdate, trunc(dt_parametro_p), nm_usuario_p, nr_sequencia_w); 
nr_sequencia_w := Gravar_Log_Indicador(41, wheb_mensagem_pck.get_texto(304109), clock_timestamp(), trunc(dt_parametro_p), nm_usuario_p, nr_sequencia_w);
 
dt_parametro_fim_w			:= trunc(last_day(dt_parametro_p),'dd') + 86399/86400;
dt_referencia_w          	:= trunc(dt_parametro_p,'month');
cd_estab_w				:= coalesce(wheb_usuario_pck.get_cd_estabelecimento,1);
 
delete from eis_Desempenho_fatur 
where dt_referencia = dt_referencia_w;
commit;
 
select 	coalesce(max(ie_historico_conta),'N') 
into STRICT	ie_historico_w 
from	parametro_faturamento 
where 	cd_estabelecimento = cd_estab_w;
 
qt_reg_w:= 0;
Open C01;
Loop 
	fetch C01 into	dt_mesano_referencia_w, 
			cd_estabelecimento_w, 
			cd_convenio_parametro_w, 
			ie_tipo_atendimento_w, 
			ie_complexidade_w, 
			hr_fechamento_w, 
			nm_usuario_fecha_w, 
			ie_etapa_w, 
			qt_conta_w, 
			qt_atend_w, 
			qt_minuto_w, 
			dt_fechamento_w, 
			vl_conta_w, 
			cd_responsavel_w, 
			cd_medico_resp_w, 
			nr_seq_etapa_w, 
			ie_tipo_protocolo_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
 
begin 
select 	substr(obter_nome_convenio(cd_convenio_parametro_w),1,255) 
into STRICT	ds_convenio_w
;	
exception 
	when others then 
	ds_convenio_w:= '';
end;
 
 
begin 
select 	obter_setor_usuario(nm_usuario_fecha_W) 
into STRICT	cd_setor_usuario_w
;	
exception 
	when others then 
	cd_setor_usuario_w:= null;
end;
 
begin 
insert into eis_Desempenho_fatur( 
	dt_referencia, 
	cd_estabelecimento, 
	cd_convenio, 
	ie_tipo_atendimento, 
	ie_complexidade, 
	hr_fechamento, 
	nm_usuario_fecha, 
	ie_etapa, 
	qt_conta, 
	qt_minuto, 
	dt_fechamento, 
	cd_setor_usuario, 
	vl_conta, 
	ds_conv, 
	qt_atend, 
	cd_responsavel, 
	cd_medico_resp, 
	nr_seq_etapa, 
	ie_tipo_protocolo) 
values (	dt_mesano_referencia_w, 
	cd_estabelecimento_w, 
	cd_convenio_parametro_w, 
	ie_tipo_atendimento_w, 
	ie_complexidade_w, 
	hr_fechamento_w, 
	nm_usuario_fecha_w, 
	ie_etapa_w, 
	qt_conta_w, 
	qt_minuto_w, 
	dt_fechamento_w, 
	cd_setor_usuario_w, 
	vl_conta_w, 
	ds_convenio_w, 
	qt_atend_w, 
	cd_responsavel_w, 
	cd_medico_resp_w, 
	nr_seq_etapa_w, 
	ie_tipo_protocolo_w);
exception 
	when others then 
		--ds_erro_w:= 'Erro Insert Desempenho faturamento'; 
		ds_erro_w:= wheb_mensagem_pck.get_texto(304110);
end;
 
qt_reg_w:= qt_reg_w + 1;
 
if (qt_reg_w > 200) then 
	commit;
	qt_reg_w:= 0;
end if;
 
end loop;
Close C01;
 
CALL Atualizar_Log_Indicador(clock_timestamp(), nr_sequencia_w);
 
commit;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_eis_desemp_fatur ( dt_parametro_P timestamp, NM_USUARIO_P text) FROM PUBLIC;
