-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_diagnostico_pai ( cd_doenca_p diagnostico_doenca.cd_doenca%type, nr_atendimento_p diagnostico_doenca.nr_atendimento%type, dt_diagnostico_p diagnostico_doenca.dt_diagnostico%type, ie_lado_p diagnostico_doenca.ie_lado%type, ie_classificacao_doenca_p diagnostico_doenca.ie_classificacao_doenca%type, ie_tipo_diagnostico_p diagnostico_doenca.ie_tipo_diagnostico%type, ie_tipo_doenca_p diagnostico_doenca.ie_tipo_doenca%type, nr_seq_etiologia_p diagnostico_doenca.nr_seq_etiologia%type, nr_seq_classif_adic_p diagnostico_doenca.nr_seq_classif_adic%type, dt_cid_p diagnostico_doenca.dt_cid%type, dt_inicio_p diagnostico_doenca.dt_inicio%type, dt_fim_p diagnostico_doenca.dt_fim%type, dt_manifestacao_p diagnostico_doenca.dt_manifestacao%type, qt_tempo_p diagnostico_doenca.qt_tempo%type, ie_unidade_tempo_p diagnostico_doenca.ie_unidade_tempo%type, ds_diagnostico_p diagnostico_doenca.ds_diagnostico%type, nm_usuario_p diagnostico_doenca.nm_usuario%type, cd_perfil_ativo_p diagnostico_doenca.cd_perfil_ativo%type, nr_seq_interno_pai_p INOUT diagnostico_doenca.nr_seq_interno_pai%type ) AS $body$
DECLARE

    qt_registros_w bigint:= null;

BEGIN

    select  nr_seq_interno
    into STRICT    nr_seq_interno_pai_p
    from    diagnostico_doenca
    where   nr_atendimento = nr_atendimento_p
    and     cd_doenca      = cd_doenca_p
    and     coalesce(dt_inativacao::text, '') = ''
    and ((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
    or (coalesce(dt_liberacao::text, '') = ''
    and     nm_usuario     = nm_usuario_p));

exception

    when others then
    
        select count(*) 
        into STRICT   qt_registros_w
        from   diagnostico_doenca 
        where  nr_atendimento = nr_atendimento_p
        and    dt_diagnostico = dt_diagnostico_p
        and    cd_doenca      = cd_doenca_p;

        if qt_registros_w = 0 then

            select nextval('diagnostico_doenca_seq')
            into STRICT   nr_seq_interno_pai_p
;

            insert into diagnostico_doenca( nr_seq_interno,
                                            nm_usuario,
                                            dt_diagnostico,
                                            cd_doenca,
                                            dt_atualizacao,
                                            nr_atendimento,
                                            cd_perfil_ativo,
                                            ie_lado,
                                            ie_classificacao_doenca,
                                            ie_tipo_diagnostico,
                                            ie_tipo_doenca,
                                            nr_seq_etiologia,
                                            nr_seq_classif_adic,
                                            dt_cid,
                                            dt_inicio,
                                            dt_fim,
                                            dt_manifestacao,
                                            qt_tempo,
                                            ie_unidade_tempo,
                                            ds_diagnostico,
                                            ie_situacao,
                                            ie_rn,
                                            ie_diag_admissao,
                                            ie_diag_alta,
                                            ie_diag_cirurgia,
                                            ie_diag_obito,
                                            ie_diag_pre_cir,
                                            ie_diag_princ_depart,
                                            ie_diag_princ_episodio,
                                            ie_diag_referencia,
                                            ie_diag_tratamento,
                                            ie_diag_trat_cert,
                                            ie_convenio,
                                            ie_nivel_atencao )
                                   values ( nr_seq_interno_pai_p,
                                            nm_usuario_p,
                                            dt_diagnostico_p,
                                            cd_doenca_p,
                                            clock_timestamp(),
                                            nr_atendimento_p,
                                            cd_perfil_ativo_p,
                                            ie_lado_p,
                                            ie_classificacao_doenca_p,
                                            ie_tipo_diagnostico_p,
                                            ie_tipo_doenca_p,
                                            nr_seq_etiologia_p,
                                            nr_seq_classif_adic_p,
                                            dt_cid_p,
                                            dt_inicio_p,
                                            dt_fim_p,
                                            dt_manifestacao_p,
                                            qt_tempo_p,
                                            ie_unidade_tempo_p,
                                            ds_diagnostico_p,
                                            'A',
                                            'N',
                                            'N',
                                            'N',
                                            'N',
                                            'N',
                                            'N',
                                            'N',
                                            'N',
                                            'N',
                                            'N',
                                            'N',
                                            'N',
                                            'T' );
            end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_diagnostico_pai ( cd_doenca_p diagnostico_doenca.cd_doenca%type, nr_atendimento_p diagnostico_doenca.nr_atendimento%type, dt_diagnostico_p diagnostico_doenca.dt_diagnostico%type, ie_lado_p diagnostico_doenca.ie_lado%type, ie_classificacao_doenca_p diagnostico_doenca.ie_classificacao_doenca%type, ie_tipo_diagnostico_p diagnostico_doenca.ie_tipo_diagnostico%type, ie_tipo_doenca_p diagnostico_doenca.ie_tipo_doenca%type, nr_seq_etiologia_p diagnostico_doenca.nr_seq_etiologia%type, nr_seq_classif_adic_p diagnostico_doenca.nr_seq_classif_adic%type, dt_cid_p diagnostico_doenca.dt_cid%type, dt_inicio_p diagnostico_doenca.dt_inicio%type, dt_fim_p diagnostico_doenca.dt_fim%type, dt_manifestacao_p diagnostico_doenca.dt_manifestacao%type, qt_tempo_p diagnostico_doenca.qt_tempo%type, ie_unidade_tempo_p diagnostico_doenca.ie_unidade_tempo%type, ds_diagnostico_p diagnostico_doenca.ds_diagnostico%type, nm_usuario_p diagnostico_doenca.nm_usuario%type, cd_perfil_ativo_p diagnostico_doenca.cd_perfil_ativo%type, nr_seq_interno_pai_p INOUT diagnostico_doenca.nr_seq_interno_pai%type ) FROM PUBLIC;

