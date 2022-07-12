-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pfcs_icu_dpts_v (ds_content, vl_pfcs, vl_target, cd_estabelecimento, nr_seq_indicator, ds_department, cd_department, qt_hora, ie_disabled) AS SELECT pfcs_get_indicator_name(90) DS_CONTENT, --> Capacity
    concat(to_char(pfcs_get_percentage_value(vl_indicator_help, vl_indicator)),'%') VL_PFCS,
    (pfcs_get_percentage_value(vl_indicator_help, vl_indicator))::numeric  VL_TARGET,
    nr_seq_operational_level CD_ESTABELECIMENTO,
    CASE WHEN cd_reference_aux='3' THEN  263 WHEN cd_reference_aux='SD' THEN  251 WHEN cd_reference_aux='4' THEN  90 END  NR_SEQ_INDICATOR,
    ds_reference_value DS_DEPARTMENT,
    cd_reference_value CD_DEPARTMENT,
    null QT_HORA,
    'S' IE_DISABLED
FROM pfcs_panel
WHERE nr_seq_indicator = 100
    and ie_situation = 'A'
    and cd_reference_aux in ('3', '4', 'SD')

UNION ALL

SELECT pfcs_get_indicator_name(91) DS_CONTENT, --> Census
    ( vl_indicator_help || '/' || vl_indicator ) VL_PFCS,
    (vl_indicator_help)::numeric  VL_TARGET,
    nr_seq_operational_level CD_ESTABELECIMENTO,
    CASE WHEN cd_reference_aux='3' THEN  264 WHEN cd_reference_aux='SD' THEN  252 WHEN cd_reference_aux='4' THEN  91 END  NR_SEQ_INDICATOR,
    ds_reference_value DS_DEPARTMENT,
    cd_reference_value CD_DEPARTMENT,
    null QT_HORA,
    'N' IE_DISABLED
FROM pfcs_panel
WHERE nr_seq_indicator = 100
    and ie_situation = 'A'
    and cd_reference_aux in ('3', '4', 'SD')

UNION ALL

SELECT pfcs_get_indicator_name(92) DS_CONTENT, --> Available Beds
    to_char(vl_indicator) VL_PFCS,
    (vl_indicator)::numeric  VL_TARGET,
    nr_seq_operational_level CD_ESTABELECIMENTO,
    CASE WHEN cd_reference_aux='3' THEN  255 WHEN cd_reference_aux='SD' THEN  243 WHEN cd_reference_aux='4' THEN  92 END  NR_SEQ_INDICATOR,
    ds_reference_value DS_DEPARTMENT,
    cd_reference_value CD_DEPARTMENT,
    null QT_HORA,
    'N' IE_DISABLED
FROM pfcs_panel
WHERE nr_seq_indicator = 102
    and ie_situation = 'A'
    and cd_reference_aux in ('3', '4', 'SD')

UNION ALL

SELECT pfcs_get_indicator_name(93) DS_CONTENT, --> Blocked Beds
    to_char(vl_indicator) VL_PFCS,
    (vl_indicator)::numeric  VL_TARGET,
    nr_seq_operational_level CD_ESTABELECIMENTO,
    CASE WHEN cd_reference_aux='3' THEN  256 WHEN cd_reference_aux='SD' THEN  244 WHEN cd_reference_aux='4' THEN  93 END  NR_SEQ_INDICATOR,
    ds_reference_value DS_DEPARTMENT,
    cd_reference_value CD_DEPARTMENT,
    null QT_HORA,
    'N' IE_DISABLED
FROM pfcs_panel
WHERE nr_seq_indicator = 111
    and ie_situation = 'A'
    and cd_reference_aux in ('3', '4', 'SD')

UNION ALL

SELECT pfcs_get_indicator_name(133) DS_CONTENT, --> Pred Beds Needed
    to_char(pfcs_pck_sim.get_simulation_value_unit(p.nr_seq_operational_level, aux.qt_hora, 'BED', p.cd_reference_value, 'Y', null)) VL_PFCS,
    (0)::numeric  VL_TARGET,
    p.nr_seq_operational_level CD_ESTABELECIMENTO,
    CASE WHEN p.cd_reference_aux='3' THEN  257 WHEN p.cd_reference_aux='SD' THEN  245 WHEN p.cd_reference_aux='4' THEN  133 END  NR_SEQ_INDICATOR,
    p.ds_reference_value DS_DEPARTMENT,
    p.cd_reference_value CD_DEPARTMENT,
    aux.qt_hora QT_HORA,
    'S' IE_DISABLED
FROM pfcs_panel p join(WITH RECURSIVE cte AS (
select (rownum-1) qt_hora  level <= 48  UNION ALL
select (rownum-1) qt_hora  level <= 48 JOIN cte c ON ()

) SELECT * FROM cte;
) aux on aux.qt_hora <= 48
WHERE p.nr_seq_indicator = 100
    and p.ie_situation = 'A'
    and pfcs_get_algorithm_visibility('SIM', obter_perfil_ativo, obter_estabelecimento_ativo, obter_usuario_ativo) = 'Y'

UNION ALL

SELECT pfcs_get_indicator_name(94) DS_CONTENT, --> Admission Orders
    to_char(vl_indicator) VL_PFCS,
    (vl_indicator)::numeric  VL_TARGET,
    nr_seq_operational_level CD_ESTABELECIMENTO,
    CASE WHEN cd_reference_aux='3' THEN  258 WHEN cd_reference_aux='SD' THEN  246 WHEN cd_reference_aux='4' THEN  94 END  NR_SEQ_INDICATOR,
    ds_reference_value DS_DEPARTMENT,
    cd_reference_value CD_DEPARTMENT,
    null QT_HORA,
    'N' IE_DISABLED
FROM pfcs_panel
WHERE nr_seq_indicator = 94
    and ie_situation = 'A'
    and cd_reference_aux in ('3', '4', 'SD')

UNION ALL

SELECT pfcs_get_indicator_name(95) DS_CONTENT, --> Special Requests
    to_char(pfcs_pck_census.get_special_requests(nr_seq_operational_level,cd_reference_value)) VL_PFCS,
    (pfcs_pck_census.get_special_requests(nr_seq_operational_level,cd_reference_value))::numeric  VL_TARGET,
    nr_seq_operational_level CD_ESTABELECIMENTO,
    CASE WHEN cd_reference_aux='3' THEN  259 WHEN cd_reference_aux='SD' THEN  247 WHEN cd_reference_aux='4' THEN  95 END  NR_SEQ_INDICATOR,
    ds_reference_value DS_DEPARTMENT,
    cd_reference_value CD_DEPARTMENT,
    null QT_HORA,
    'N' IE_DISABLED
FROM pfcs_panel
WHERE nr_seq_indicator = 100
    and ie_situation = 'A'
    and cd_reference_aux in ('3', '4', 'SD')

UNION ALL

SELECT pfcs_get_indicator_name(96) DS_CONTENT, --> Avg Wait Time
    to_char(get_time_by_minutes(
        pfcs_get_avg_request_time(nr_seq_indicator,nr_seq_operational_level,cd_reference_value)
    )) VL_PFCS,
    (trunc(pfcs_get_avg_request_time(
        nr_seq_indicator,nr_seq_operational_level,cd_reference_value)
    ))::numeric  VL_TARGET,
    nr_seq_operational_level CD_ESTABELECIMENTO,
    CASE WHEN cd_reference_aux='3' THEN  260 WHEN cd_reference_aux='SD' THEN  248 WHEN cd_reference_aux='4' THEN  96 END  NR_SEQ_INDICATOR,
    ds_reference_value DS_DEPARTMENT,
    cd_reference_value CD_DEPARTMENT,
    null QT_HORA,
    'S' IE_DISABLED
FROM pfcs_panel
WHERE nr_seq_indicator = 94
    and ie_situation = 'A'
    and cd_reference_aux in ('3', '4', 'SD')

UNION ALL

SELECT pfcs_get_indicator_name(97) DS_CONTENT, --> Transfer Orders
    to_char(vl_indicator) VL_PFCS,
    (vl_indicator)::numeric  VL_TARGET,
    nr_seq_operational_level CD_ESTABELECIMENTO,
    CASE WHEN cd_reference_aux='3' THEN  261 WHEN cd_reference_aux='SD' THEN  249 WHEN cd_reference_aux='4' THEN  97 END  NR_SEQ_INDICATOR,
    ds_reference_value DS_DEPARTMENT,
    cd_reference_value CD_DEPARTMENT,
    null QT_HORA,
    'N' IE_DISABLED
FROM pfcs_panel
WHERE nr_seq_indicator = 97
    and ie_situation = 'A'
    and cd_reference_aux in ('3', '4', 'SD')

UNION ALL

SELECT pfcs_get_indicator_name(98) DS_CONTENT, --> Delays
    to_char(vl_indicator) VL_PFCS,
    (vl_indicator)::numeric  VL_TARGET,
    nr_seq_operational_level CD_ESTABELECIMENTO,
    CASE WHEN cd_reference_aux='3' THEN  262 WHEN cd_reference_aux='SD' THEN  250 WHEN cd_reference_aux='4' THEN  98 END  NR_SEQ_INDICATOR,
    ds_reference_value DS_DEPARTMENT,
    cd_reference_value CD_DEPARTMENT,
    null QT_HORA,
    'N' IE_DISABLED
FROM pfcs_panel
WHERE nr_seq_indicator = 98
    and ie_situation = 'A'
    and cd_reference_aux in ('3', '4', 'SD');

