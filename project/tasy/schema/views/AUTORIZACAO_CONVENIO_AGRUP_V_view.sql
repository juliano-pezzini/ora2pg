-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW autorizacao_convenio_agrup_v (nr_sequencia, ds_estagio, ds_tipo_autor, dt_autorizacao, ds_convenio, dt_inicio_vigencia, ds_observacao, ie_tipo_autor, ds_procedimento, nr_seq_estagio, nr_atendimento, nr_seq_agenda, nr_seq_agenda_consulta, nr_seq_gestao) AS select	a.nr_sequencia,
	substr(obter_descricao_padrao('ESTAGIO_AUTORIZACAO', 'DS_ESTAGIO', nr_seq_estagio),1,254) ds_estagio,
	substr(obter_valor_dominio(1377, ie_tipo_autorizacao),1,254) ds_tipo_autor,
	a.dt_autorizacao,
	substr(obter_nome_convenio(a.cd_convenio),1,254) ds_convenio,
	a.dt_inicio_vigencia,
	substr(a.ds_observacao,1,200) ds_observacao,
	a.ie_tipo_autorizacao ie_tipo_autor,
	(select	min(substr(obter_desc_prescr_proc(cd_procedimento,ie_origem_proced,nr_seq_proc_interno),1,255))
	 FROM	procedimento_autorizado x
	 where	x.nr_sequencia_autor	= a.nr_sequencia) ds_procedimento,
	a.nr_seq_estagio nr_seq_estagio,
	a.nr_atendimento nr_atendimento,
	a.nr_seq_agenda nr_seq_agenda,
	a.nr_seq_agenda_consulta nr_seq_agenda_consulta,
	a.nr_seq_gestao nr_seq_gestao
from	autorizacao_convenio a

union

select	a.nr_sequencia,
	substr(obter_descricao_padrao('ESTAGIO_AUTORIZACAO', 'DS_ESTAGIO', nr_seq_estagio),1,254) ds_estagio,
	substr(obter_valor_dominio(1377, ie_tipo_autorizacao),1,254) ds_tipo_autor,
	a.dt_autorizacao,
        substr(obter_nome_convenio(a.cd_convenio),1,254) ds_convenio,
	a.dt_inicio_vigencia,
	substr(a.ds_observacao,1,200) ds_observacao,
	a.ie_tipo_autorizacao ie_tipo_autor,
	(select	min(substr(obter_desc_prescr_proc(cd_procedimento,ie_origem_proced,nr_seq_proc_interno),1,255))
	 from	procedimento_autorizado x
	 where	x.nr_sequencia_autor	= a.nr_sequencia) ds_procedimento,
	a.nr_seq_estagio nr_seq_estagio,
	a.nr_atendimento nr_atendimento,
	a.nr_seq_agenda nr_seq_agenda,
	a.nr_seq_agenda_consulta nr_seq_agenda_consulta,
	a.nr_seq_gestao nr_seq_gestao
from	autorizacao_convenio a

union

select	a.nr_sequencia,
   	substr(obter_descricao_padrao('ESTAGIO_AUTORIZACAO', 'DS_ESTAGIO', nr_seq_estagio),1,254) ds_estagio,
	substr(obter_valor_dominio(1377, ie_tipo_autorizacao),1,254) ds_tipo_autor,
	a.dt_autorizacao,
        substr(obter_nome_convenio(a.cd_convenio),1,254) ds_convenio,
	a.dt_inicio_vigencia,
	substr(a.ds_observacao,1,200) ds_observacao,
	a.ie_tipo_autorizacao ie_tipo_autor,
	(select	min(substr(obter_desc_prescr_proc(cd_procedimento,ie_origem_proced,nr_seq_proc_interno),1,255))
	 from	procedimento_autorizado x
	 where	x.nr_sequencia_autor	= a.nr_sequencia) ds_procedimento,
	a.nr_seq_estagio nr_seq_estagio,
	a.nr_atendimento nr_atendimento,
	a.nr_seq_agenda nr_seq_agenda,
	a.nr_seq_agenda_consulta nr_seq_agenda_consulta,
	a.nr_seq_gestao nr_seq_gestao
from	autorizacao_convenio a

union

select	a.nr_sequencia,
	substr(obter_descricao_padrao('ESTAGIO_AUTORIZACAO', 'DS_ESTAGIO', nr_seq_estagio),1,254) ds_estagio,
	substr(obter_valor_dominio(1377, ie_tipo_autorizacao),1,254) ds_tipo_autor,
	a.dt_autorizacao,
        substr(obter_nome_convenio(a.cd_convenio),1,254) ds_convenio,
	a.dt_inicio_vigencia,
	substr(a.ds_observacao,1,200) ds_observacao,
	a.ie_tipo_autorizacao ie_tipo_autor,
	(select	min(substr(obter_desc_prescr_proc(cd_procedimento,ie_origem_proced,nr_seq_proc_interno),1,255))
	 from	procedimento_autorizado x
	 where	x.nr_sequencia_autor	= a.nr_sequencia) ds_procedimento,
	a.nr_seq_estagio nr_seq_estagio,
	a.nr_atendimento nr_atendimento,
	a.nr_seq_agenda nr_seq_agenda,
	a.nr_seq_agenda_consulta nr_seq_agenda_consulta,
	a.nr_seq_gestao nr_seq_gestao
from    autorizacao_convenio a

union

select  a.nr_sequencia,
	substr(obter_descricao_padrao('ESTAGIO_AUTORIZACAO', 'DS_ESTAGIO', nr_seq_estagio),1,254) ds_estagio,
	substr(obter_valor_dominio(1377, ie_tipo_autorizacao),1,254) ds_tipo_autor,
	a.dt_autorizacao,
        substr(obter_nome_convenio(a.cd_convenio),1,254) ds_convenio,
	a.dt_inicio_vigencia,
	substr(a.ds_observacao,1,200) ds_observacao,
	a.ie_tipo_autorizacao ie_tipo_autor,
	(select	min(substr(obter_desc_prescr_proc(cd_procedimento,ie_origem_proced,nr_seq_proc_interno),1,255))
	 from	procedimento_autorizado x
	 where	x.nr_sequencia_autor	= a.nr_sequencia) ds_procedimento,
	a.nr_seq_estagio nr_seq_estagio,
	a.nr_atendimento nr_atendimento,
	a.nr_seq_agenda nr_seq_agenda,
	a.nr_seq_agenda_consulta nr_seq_agenda_consulta,
	a.nr_seq_gestao nr_seq_gestao
from    autorizacao_convenio a;

