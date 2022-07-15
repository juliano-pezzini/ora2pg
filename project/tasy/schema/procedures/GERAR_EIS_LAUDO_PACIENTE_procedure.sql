-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_eis_laudo_paciente ( dt_parametro_P timestamp, nm_usuario_p text) AS $body$
DECLARE

 
dt_parametro_fim_w		timestamp;
dt_parametro_w			timestamp;
dt_parametro_dia_w		timestamp;
cd_estabelecimento_w		integer;
cd_convenio_w			integer;
cd_medico_w			varchar(10);
cd_setor_atendimento_w		integer;
cd_tipo_procedimento_w		smallint;
nr_sequencia_w			bigint;

BEGIN
 
nr_sequencia_w := Gravar_Log_Indicador(52, obter_desc_expressao(307540), clock_timestamp(), PKG_DATE_UTILS.start_of(dt_parametro_p,'dd',0), nm_usuario_p, nr_sequencia_w);
 
dt_parametro_fim_w	:= PKG_DATE_UTILS.ADD_MONTH(PKG_DATE_UTILS.start_of(dt_parametro_p, 'MONTH', 0), 1,0) - (1/86400);
dt_parametro_w		:= PKG_DATE_UTILS.start_of(dt_parametro_p,'month', 0);
dt_parametro_dia_w	:= PKG_DATE_UTILS.start_of(dt_parametro_p,'dd', 0);
 
delete from eis_Laudo_paciente 
where dt_referencia between dt_parametro_w and dt_parametro_fim_w;
 
insert into Eis_Laudo_Paciente( 
	cd_estabelecimento, 
	dt_referencia, 
	dt_atualizacao, 
	nm_usuario, 
	cd_convenio, 
	cd_medico_laudo, 
	cd_setor_atendimento, 
	qt_hora_atraso, 
	ie_tipo_atendimento, 
	qt_ocorrencia, 
	cd_tipo_procedimento, 
	nm_usuario_digitacao, 
	nm_usuario_seg_aprov, 
	cd_medico_prescr, 
	cd_tecnico_resp, 
	dt_desaprovacao, 
	cd_residente, 
	nr_seq_proc_interno) 
SELECT	c.cd_estabelecimento, 
	PKG_DATE_UTILS.start_of(a.dt_laudo,'dd',0), 
	clock_timestamp(), 
	nm_usuario_p, 
	obter_convenio_atendimento(a.nr_atendimento), 
	a.cd_medico_resp, 
	b.cd_setor_atendimento, 
	obter_hora_atraso_laudo(a.nr_sequencia), 
	c.ie_tipo_atendimento, 
	count(*), 
	coalesce(p.cd_tipo_procedimento,99), 
	a.nm_usuario_digitacao, 
	a.nm_usuario_seg_aprov, 
	d.cd_medico, 
	a.cd_tecnico_resp, 
	PKG_DATE_UTILS.start_of(a.dt_desaprovacao,'dd', 0), 
	a.cd_residente, 
	b.nr_seq_proc_interno 
from	procedimento p, 
	atendimento_paciente c, 
	Procedimento_Paciente b, 
	prescr_medica d, 
	laudo_paciente a 
where 	a.dt_laudo between dt_parametro_w and dt_parametro_fim_w 
 and	a.nr_prescricao		= d.nr_prescricao 
 and	a.nr_atendimento	= c.nr_atendimento 
 and 	b.cd_procedimento	= p.cd_procedimento 
 and	b.ie_origem_proced	= p.ie_origem_proced 
 and	a.nr_sequencia		= b.nr_laudo 
 and	(a.cd_medico_resp IS NOT NULL AND a.cd_medico_resp::text <> '') 
group by 
	c.cd_estabelecimento, 
	d.cd_medico, 
	a.dt_laudo, 
	obter_convenio_atendimento(a.nr_atendimento), 
	a.cd_medico_resp, 
	b.cd_setor_atendimento, 
	PKG_DATE_UTILS.start_of(a.dt_desaprovacao,'dd', 0), 
	obter_hora_atraso_laudo(a.nr_sequencia), 
	c.ie_tipo_atendimento, 
	p.cd_tipo_procedimento, 
	a.nm_usuario_digitacao, 
	nm_usuario_seg_aprov, 
	a.cd_tecnico_resp, 
	a.cd_residente, 
	b.nr_seq_proc_interno;
 
COMMIT;
 
CALL Atualizar_Log_Indicador(clock_timestamp(), nr_sequencia_w);
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_eis_laudo_paciente ( dt_parametro_P timestamp, nm_usuario_p text) FROM PUBLIC;

