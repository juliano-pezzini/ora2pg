-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW tre_relat_atendimento_v (nr_atendimento, dt_entrada, nm_paciente, dt_nascto, ds_tipo_atend, ds_convenio, ds_categoria, ie_tipo_atendimento, cd_procedencia, cd_usuario_convenio) AS select  a.nr_atendimento,
        a.dt_entrada,
        SUBSTR(obter_nome_pf(a.cd_pessoa_fisica),1,60) nm_paciente,
        SubStr(OBTER_DATA_NASCTO_PF(a.cd_pessoa_fisica),0,40) dt_nascto,
        substr(obter_nome_tipo_atend(a.IE_TIPO_ATENDIMENTO),1,50) ds_tipo_atend,
        substr(obter_nome_convenio(b.CD_CONVENIO),1,50) ds_convenio,
        substr(obter_categoria_convenio(b.CD_CONVENIO,b.CD_CATEGORIA),1,50) ds_categoria,
        a.IE_TIPO_ATENDIMENTO,
        a.cd_procedencia,
        b.CD_USUARIO_CONVENIO
FROM    atendimento_paciente a,
        atend_categoria_convenio b
where   a.nr_atendimento = b.nr_atendimento;

