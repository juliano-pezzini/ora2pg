-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW grafico_gest_cirurgia_v (tipo, nr_atendimento, nr_cirurgia, nm_paciente, cd_medico, nm_medico, ds_procedimento, proc_ops, dt_inicio_real_grid, dt_inicio_real, dt_termino, duracao_cirurgia, somatorio, media) AS SELECT
   'PRINCIPAL' tipo,
    a.nr_atendimento,
    a.nr_cirurgia,
    SUBSTR(obter_nome_pessoa_fisica(a.cd_pessoa_fisica, NULL),1,150) nm_paciente,
 a.cd_medico_cirurgiao cd_medico,
    SUBSTR(obter_nome_pessoa_fisica(a.cd_medico_cirurgiao, NULL),1,150) nm_medico,
    SUBSTR(obter_exame_agenda(cd_procedimento_princ, a.ie_origem_proced, NULL),1,240) ds_procedimento,
    obter_cod_proc_loc(cd_procedimento_princ, a.ie_origem_proced) PROC_OPS,
    PKG_DATE_FORMATERS.to_varchar(a.dt_inicio_real,'shortDate', wheb_usuario_pck.get_cd_estabelecimento,wheb_usuario_pck.get_nm_usuario) dt_inicio_real_grid,
	a.dt_inicio_real,
    a.dt_termino,
    ROUND(((a.dt_termino - a.dt_inicio_real)  * 24 * 60) ,2) duracao_cirurgia,
    1 somatorio,
    ROUND((((a.dt_termino - a.dt_inicio_real)  * 24 * 60) /1),2) media
FROM    cirurgia a
WHERE  1 = 1
AND     dt_inicio_real IS NOT NULL
AND     dt_termino IS NOT NULL

UNION ALL

SELECT  'SECUNDARIO' tipo,
    a.nr_atendimento,
    a.nr_cirurgia,
    SUBSTR(obter_nome_pessoa_fisica(a.cd_pessoa_fisica, NULL),1,150) nm_paciente,
 a.cd_medico_cirurgiao cd_medico,
    SUBSTR(obter_nome_pessoa_fisica(b.cd_medico_exec, NULL),1,150) nm_medico,
    SUBSTR(obter_exame_agenda(b.cd_procedimento, b.ie_origem_proced, NULL),1,240),
    obter_cod_proc_loc(b.cd_procedimento, b.ie_origem_proced),
	PKG_DATE_FORMATERS.to_varchar(b.dt_inicio,'shortDate', wheb_usuario_pck.get_cd_estabelecimento,wheb_usuario_pck.get_nm_usuario),
    b.dt_inicio,
    b.dt_fim,
    ROUND(((b.dt_fim - b.dt_inicio)  * 24 * 60),2) duracao_cirurgia,
    1 somatorio,
    ROUND((((b.dt_fim - b.dt_inicio)  * 24 * 60) / 1),2) media
FROM   prescr_procedimento b,
       cirurgia a
WHERE   1 = 1
AND     a.nr_prescricao = b.nr_prescricao
AND     a.dt_inicio_real IS NOT NULL
AND     a.dt_termino IS NOT NULL
AND  b.dt_fim IS NOT NULL
AND  b.dt_inicio IS NOT NULL
ORDER BY 2,3;

