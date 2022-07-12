-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW cadastro_mat_med_v (cd_estab, cd_material, descricao, descricao_reduzida, tipo_material, um_compra, um_estoque, um_consumo, um_solicitacao, cd_um_estoque, nome_generico, material_estoque, cd_classe, ds_classe, via_administracao, ficha_tecnica, concentracao, medicamento_cih, liberacao_antimicrobiano, pode_comp_sol, obriga_justificativa, padrao_adm_cpoe, tipo_soluc_cpoe, setor_atendimento, prim_horario, via_aplicacao, intervalo_pad_prescr, unid_medida_prescricao, dose_prescr, regra_diluicao, dispositivo_infusao, reconstituinte, unidade_med_diluete, quantidade_diluicao, diluente, unidade_med_diluente, qtde_diluicao, via_aplic_dil, regra_dil, dose_lim_max, dose_lim_max_um, dose_lim_max_per, un_medida, ie_priorid, qt_conv, via_adm, nr_seq_apresent, intervalo) AS SELECT
DISTINCT
--PASTA CADASTRO--
E.CD_ESTABELECIMENTO CD_ESTAB,
A.CD_MATERIAL CD_MATERIAL,
A.DS_MATERIAL DESCRICAO,
A.DS_REDUZIDA DESCRICAO_REDUZIDA,
obter_valor_dominio(29, A.IE_TIPO_MATERIAL) TIPO_MATERIAL,
(SELECT DISTINCT B.DS_UNIDADE_MEDIDA FROM UNIDADE_MEDIDA B WHERE A.CD_UNIDADE_MEDIDA_COMPRA=B.CD_UNIDADE_MEDIDA) UM_COMPRA,
(SELECT DISTINCT B.DS_UNIDADE_MEDIDA FROM UNIDADE_MEDIDA B WHERE A.CD_UNIDADE_MEDIDA_ESTOQUE=B.CD_UNIDADE_MEDIDA) UM_ESTOQUE,
(SELECT DISTINCT B.DS_UNIDADE_MEDIDA FROM UNIDADE_MEDIDA B WHERE A.CD_UNIDADE_MEDIDA_CONSUMO=B.CD_UNIDADE_MEDIDA) UM_CONSUMO,
(SELECT DISTINCT B.DS_UNIDADE_MEDIDA FROM UNIDADE_MEDIDA B WHERE A.CD_UNIDADE_MEDIDA_SOLIC=B.CD_UNIDADE_MEDIDA) UM_SOLICITACAO,
A.CD_UNIDADE_MEDIDA_ESTOQUE CD_UM_ESTOQUE,
OBTER_DESC_MATERIAL(A.CD_MATERIAL_GENERICO) NOME_GENERICO,
OBTER_DESC_MATERIAL(A.CD_MATERIAL_ESTOQUE) MATERIAL_ESTOQUE,
A.CD_CLASSE_MATERIAL CD_CLASSE,
OBTER_DESC_CLASSE_MAT(A.CD_CLASSE_MATERIAL) DS_CLASSE,
obter_ds_ie_via_aplicacao(A.IE_VIA_APLICACAO) VIA_ADMINISTRACAO,
--PASTA MEDIC--
OBTER_DESC_FICHA_TECNICA(A.NR_SEQ_FICHA_TECNICA) FICHA_TECNICA,
A.QT_CONVERSAO_MG||A.CD_UNID_MED_CONCETRACAO CONCENTRACAO,
coalesce((SELECT B.DS_MEDICAMENTO FROM CIH_MEDICAMENTO B WHERE B.CD_MEDICAMENTO=A.CD_MEDICAMENTO),'Não CIH') MEDICAMENTO_CIH,
--PASTA PRESCR--
OBTER_VALOR_DOMINIO(1281,A.IE_CONTROLE_MEDICO) LIBERACAO_ANTIMICROBIANO,
OBTER_VALOR_DOMINIO(2987,A.IE_SOLUCAO) PODE_COMP_SOL,
A.IE_OBRIGA_JUSTIFICATIVA OBRIGA_JUSTIFICATIVA,
coalesce((OBTER_VALOR_DOMINIO(7179,A.IE_PADRAO_CPOE)),'Não inform.') PADRAO_ADM_CPOE,
coalesce((CASE WHEN A.IE_TIPO_SOLUCAO_CPOE='C' THEN 'Contínua'
WHEN A.IE_TIPO_SOLUCAO_CPOE='I' THEN 'Intermitente'
WHEN A.IE_TIPO_SOLUCAO_CPOE='V' THEN 'Veloc Infusão Variável'
WHEN A.IE_TIPO_SOLUCAO_CPOE='P' THEN 'PCA'
END),'Não inform.') TIPO_SOLUC_CPOE,
--DOSE TERAUPÊTICAS PADRÕES--
coalesce( (SELECT OBTER_NOME_SETOR(C.CD_SETOR_ATENDIMENTO) FROM  MATERIAL_PRESCR C WHERE C.NR_SEQUENCIA=
(SELECT MIN(B.NR_SEQUENCIA)
FROM MATERIAL_PRESCR B
WHERE B.CD_MATERIAL=A.CD_MATERIAL
AND B.CD_ESTABELECIMENTO IS NOT NULL
AND B.cd_estabelecimento=E.CD_ESTABELECIMENTO
AND B.ie_tipo=1)),'Não inform.') SETOR_ATENDIMENTO,
coalesce( (SELECT C.HR_PRIM_HORARIO FROM  MATERIAL_PRESCR C WHERE C.NR_SEQUENCIA=
(SELECT MIN(B.NR_SEQUENCIA)
FROM MATERIAL_PRESCR B
WHERE B.CD_MATERIAL=A.CD_MATERIAL
AND B.CD_ESTABELECIMENTO IS NOT NULL
AND B.cd_estabelecimento=E.CD_ESTABELECIMENTO
AND B.ie_tipo=1)),'Não inform.') PRIM_HORARIO,
coalesce((SELECT obter_ds_ie_via_aplicacao(C.IE_VIA_APLIC_PADRAO) FROM  MATERIAL_PRESCR C WHERE C.NR_SEQUENCIA=
(SELECT MIN(B.NR_SEQUENCIA)
FROM MATERIAL_PRESCR B
WHERE B.CD_MATERIAL=A.CD_MATERIAL
AND B.CD_ESTABELECIMENTO IS NOT NULL
AND B.cd_estabelecimento=E.CD_ESTABELECIMENTO
AND B.ie_tipo=1)),'Não inform.') VIA_APLICACAO,
coalesce((SELECT OBTER_DESC_INTERVALO(C.CD_INTERVALO) FROM  MATERIAL_PRESCR C WHERE C.NR_SEQUENCIA=
(SELECT MIN(B.NR_SEQUENCIA)
FROM MATERIAL_PRESCR B
WHERE B.CD_MATERIAL=A.CD_MATERIAL
AND B.CD_ESTABELECIMENTO IS NOT NULL
AND B.cd_estabelecimento=E.CD_ESTABELECIMENTO
AND B.ie_tipo=1)),'Não inform.') INTERVALO_PAD_PRESCR,
coalesce((SELECT DISTINCT D.DS_UNIDADE_MEDIDA FROM UNIDADE_MEDIDA D WHERE D.CD_UNIDADE_MEDIDA=
(SELECT C.CD_UNIDADE_MEDIDA FROM  MATERIAL_PRESCR C WHERE C.NR_SEQUENCIA=
(SELECT MIN(B.NR_SEQUENCIA)
FROM MATERIAL_PRESCR B
WHERE B.CD_MATERIAL=A.CD_MATERIAL
AND B.CD_ESTABELECIMENTO IS NOT NULL
AND B.cd_estabelecimento=E.CD_ESTABELECIMENTO
AND B.ie_tipo=1))),'Não inform.') UNID_MEDIDA_PRESCRICAO,
coalesce((to_char((SELECT C.QT_DOSE FROM  MATERIAL_PRESCR C WHERE C.NR_SEQUENCIA=
(SELECT MIN(B.NR_SEQUENCIA)
FROM MATERIAL_PRESCR B
WHERE B.CD_MATERIAL=A.CD_MATERIAL
AND B.CD_ESTABELECIMENTO IS NOT NULL
AND B.cd_estabelecimento=E.CD_ESTABELECIMENTO
AND B.ie_tipo=1)))),'Não inform.') DOSE_PRESCR,
coalesce((SELECT OBTER_VALOR_DOMINIO(1571,C.IE_DILUICAO) FROM  MATERIAL_PRESCR C WHERE C.NR_SEQUENCIA=
(SELECT MIN(B.NR_SEQUENCIA)
FROM MATERIAL_PRESCR B
WHERE B.CD_MATERIAL=A.CD_MATERIAL
AND B.CD_ESTABELECIMENTO IS NOT NULL
AND B.cd_estabelecimento=E.CD_ESTABELECIMENTO
AND B.ie_tipo=1)),'Não inform.') REGRA_DILUICAO,
coalesce((SELECT OBTER_VALOR_DOMINIO(1537,C.IE_DISPOSITIVO_INFUSAO) FROM  MATERIAL_PRESCR C WHERE C.NR_SEQUENCIA=
(SELECT MIN(B.NR_SEQUENCIA)
FROM MATERIAL_PRESCR B
WHERE B.CD_MATERIAL=A.CD_MATERIAL
AND B.CD_ESTABELECIMENTO IS NOT NULL
AND B.cd_estabelecimento=E.CD_ESTABELECIMENTO
AND B.ie_tipo=1)),'Não inform.') DISPOSITIVO_INFUSAO,
--RECONSTITUIÇÃO
coalesce((SELECT OBTER_DESC_MATERIAL(c.cd_diluente)
 FROM  MATERIAL_DILUICAO C WHERE C.NR_SEQUENCIA=
(SELECT MIN(B.NR_SEQUENCIA)
FROM MATERIAL_DILUICAO B
WHERE B.CD_MATERIAL=A.cd_material
AND B.CD_DILUENTE IS NOT NULL
AND B.cd_estabelecimento=E.CD_ESTABELECIMENTO
AND B.IE_RECONSTITUICAO='S')
AND C.cd_material=A.cd_material),'Não inform.') RECONSTITUINTE,
coalesce(to_char((SELECT OBTER_UNIDADE_MEDIDA(c.CD_UNID_MED_DILUENTE)
 FROM  MATERIAL_DILUICAO C WHERE C.NR_SEQUENCIA=
(SELECT MIN(B.NR_SEQUENCIA)
FROM MATERIAL_DILUICAO B
WHERE B.CD_MATERIAL=A.cd_material
AND B.CD_DILUENTE IS NOT NULL
AND B.cd_estabelecimento=E.CD_ESTABELECIMENTO
AND B.IE_RECONSTITUICAO='S')
AND C.cd_material=A.cd_material)),'Não inform.') UNIDADE_MED_DILUETE,
coalesce(to_char((SELECT C.QT_DILUICAO
 FROM  MATERIAL_DILUICAO C WHERE C.NR_SEQUENCIA=
(SELECT MIN(B.NR_SEQUENCIA)
FROM MATERIAL_DILUICAO B
WHERE B.CD_MATERIAL=A.cd_material
AND B.CD_DILUENTE IS NOT NULL
AND B.cd_estabelecimento=E.CD_ESTABELECIMENTO
AND B.IE_RECONSTITUICAO='S')
AND C.cd_material=A.cd_material)),'Não inform.') QUANTIDADE_DILUICAO,
--DILUIÇÃO
coalesce(to_char((SELECT OBTER_DESC_MATERIAL(c.cd_diluente)
 FROM  MATERIAL_DILUICAO C WHERE C.NR_SEQUENCIA=
(SELECT MIN(B.NR_SEQUENCIA)
FROM MATERIAL_DILUICAO B
WHERE B.CD_MATERIAL=A.cd_material
AND B.CD_DILUENTE IS NOT NULL
AND B.cd_estabelecimento=E.CD_ESTABELECIMENTO
AND B.IE_RECONSTITUICAO='N')
AND C.cd_material=A.cd_material)),'Não inform.') DILUENTE,
coalesce(to_char((SELECT OBTER_UNIDADE_MEDIDA(c.CD_UNID_MED_DILUENTE)
 FROM  MATERIAL_DILUICAO C WHERE C.NR_SEQUENCIA=
(SELECT MIN(B.NR_SEQUENCIA)
FROM MATERIAL_DILUICAO B
WHERE B.CD_MATERIAL=A.cd_material
AND B.CD_DILUENTE IS NOT NULL
AND B.cd_estabelecimento=E.CD_ESTABELECIMENTO
AND B.IE_RECONSTITUICAO='N')
AND C.cd_material=A.cd_material)),'Não inform.') UNIDADE_MED_DILUENTE,
coalesce(to_char((SELECT C.QT_DILUICAO
 FROM  MATERIAL_DILUICAO C WHERE C.NR_SEQUENCIA=
(SELECT MIN(B.NR_SEQUENCIA)
FROM MATERIAL_DILUICAO B
WHERE B.CD_MATERIAL=A.cd_material
AND B.CD_DILUENTE IS NOT NULL
AND B.cd_estabelecimento=E.CD_ESTABELECIMENTO
AND B.IE_RECONSTITUICAO='N')
AND C.cd_material=A.cd_material)),'Não inform.') QTDE_DILUICAO,
coalesce((SELECT obter_ds_ie_via_aplicacao(C.IE_VIA_APLICACAO)
 FROM  MATERIAL_DILUICAO C WHERE C.NR_SEQUENCIA=
(SELECT MIN(B.NR_SEQUENCIA)
FROM MATERIAL_DILUICAO B
WHERE B.CD_MATERIAL=A.cd_material
AND B.CD_DILUENTE IS NOT NULL
AND B.cd_estabelecimento=E.CD_ESTABELECIMENTO
AND B.IE_RECONSTITUICAO='N')
AND C.cd_material=A.cd_material),'Não inform.') VIA_APLIC_DIL,
coalesce((SELECT OBTER_VALOR_DOMINIO(2298,C.IE_PROPORCAO)
 FROM  MATERIAL_DILUICAO C WHERE C.NR_SEQUENCIA=
(SELECT MIN(B.NR_SEQUENCIA)
FROM MATERIAL_DILUICAO B
WHERE B.CD_MATERIAL=A.cd_material
AND B.CD_DILUENTE IS NOT NULL
AND B.cd_estabelecimento=E.CD_ESTABELECIMENTO
AND B.IE_RECONSTITUICAO='N')
AND C.cd_material=A.cd_material),'Não inform.') REGRA_DIL,
--LIMITES TERAUP
coalesce((to_char((SELECT C.QT_LIMITE_PESSOA FROM MATERIAL_PRESCR C WHERE C.NR_SEQUENCIA=
(SELECT MIN(B.NR_SEQUENCIA) FROM MATERIAL_PRESCR B
WHERE B.CD_MATERIAL=A.CD_MATERIAL
AND B.QT_LIMITE_PESSOA IS NOT NULL
AND B.IE_TIPO=2
AND B.CD_ESTABELECIMENTO=E.CD_ESTABELECIMENTO)))),'Não inform.') DOSE_LIM_MAX,
coalesce((SELECT C.CD_UNID_MED_LIMITE FROM MATERIAL_PRESCR C WHERE C.NR_SEQUENCIA=
(SELECT MIN(B.NR_SEQUENCIA) FROM MATERIAL_PRESCR B
WHERE B.CD_MATERIAL=A.CD_MATERIAL
AND B.QT_LIMITE_PESSOA IS NOT NULL
AND B.IE_TIPO=2
AND B.CD_ESTABELECIMENTO=E.CD_ESTABELECIMENTO)),'Não inform.') DOSE_LIM_MAX_UM,
coalesce((SELECT OBTER_VALOR_DOMINIO(1851,C.IE_DOSE_LIMITE) FROM MATERIAL_PRESCR C WHERE C.NR_SEQUENCIA=
(SELECT MIN(B.NR_SEQUENCIA) FROM MATERIAL_PRESCR B
WHERE B.CD_MATERIAL=A.CD_MATERIAL
AND B.QT_LIMITE_PESSOA IS NOT NULL
AND B.IE_TIPO=2
AND B.CD_ESTABELECIMENTO=E.CD_ESTABELECIMENTO)),'Não inform.') DOSE_LIM_MAX_PER,
--CONVERSÃO DE DOSE
coalesce(TO_CHAR((SELECT DISTINCT C.CD_UNIDADE_MEDIDA
FROM MATERIAL_CONVERSAO_UNIDADE C
WHERE C.CD_MATERIAL= A.CD_MATERIAL
AND C.IE_PRIORIDADE=(SELECT MIN(B.IE_PRIORIDADE) FROM MATERIAL_CONVERSAO_UNIDADE B WHERE B.CD_MATERIAL=A.CD_MATERIAL)  LIMIT 1)),'Não inform.') UN_MEDIDA,
coalesce(TO_CHAR((SELECT C.IE_PRIORIDADE
FROM MATERIAL_CONVERSAO_UNIDADE C
WHERE C.CD_MATERIAL= A.CD_MATERIAL
AND C.IE_PRIORIDADE=(SELECT MIN(B.IE_PRIORIDADE) FROM MATERIAL_CONVERSAO_UNIDADE B WHERE B.CD_MATERIAL=A.CD_MATERIAL)  LIMIT 1)),'Não inform.') IE_PRIORID,
coalesce(TO_CHAR((SELECT C.QT_CONVERSAO
FROM MATERIAL_CONVERSAO_UNIDADE C
WHERE C.CD_MATERIAL= A.CD_MATERIAL
AND C.IE_PRIORIDADE=(SELECT MIN(B.IE_PRIORIDADE) FROM MATERIAL_CONVERSAO_UNIDADE B WHERE B.CD_MATERIAL=A.CD_MATERIAL)  LIMIT 1)),'Não inform.') QT_CONV,
--VIA ADMINISTRACAO
coalesce((SELECT OBTER_SELECT_CONCATENADO_BV('SELECT IE_VIA_APLICACAO FROM MAT_VIA_APLIC WHERE CD_MATERIAL=:cd_mat',
'cd_mat='||A.CD_MATERIAL,
';') ),'Não inform.') VIA_ADM,
--INTERVALOS SUGERIDOS
coalesce(to_char((SELECT DISTINCT C.NR_SEQ_APRESENT
FROM REP_INTERVALO_SUGERIDO C
WHERE C.CD_MATERIAL=A.CD_MATERIAL
AND C.NR_SEQ_APRESENT=
(SELECT MIN(B.NR_SEQ_APRESENT) FROM REP_INTERVALO_SUGERIDO B WHERE B.CD_MATERIAL=A.CD_MATERIAL)
AND C.DT_ATUALIZACAO_NREC =
(SELECT MIN(B.DT_ATUALIZACAO_NREC) FROM REP_INTERVALO_SUGERIDO B WHERE B.CD_MATERIAL=A.CD_MATERIAL))),'Não inform.') NR_SEQ_APRESENT,
coalesce((SELECT DISTINCT substr(obter_desc_intervalo(C.cd_intervalo),1,255)INTERVALO
FROM REP_INTERVALO_SUGERIDO C
WHERE C.CD_MATERIAL=A.CD_MATERIAL
AND C.NR_SEQ_APRESENT=
(SELECT MIN(B.NR_SEQ_APRESENT) FROM REP_INTERVALO_SUGERIDO B WHERE B.CD_MATERIAL=A.CD_MATERIAL)
AND C.DT_ATUALIZACAO_NREC =
(SELECT MIN(B.DT_ATUALIZACAO_NREC) FROM REP_INTERVALO_SUGERIDO B WHERE B.CD_MATERIAL=A.CD_MATERIAL)),'Não inform.') INTERVALO
FROM MATERIAL A, MATERIAL_ESTAB E
WHERE A.IE_SITUACAO='A'
AND A.CD_MATERIAL=E.CD_MATERIAL
and obter_estrutura_material(a.cd_material, 'G')=1
AND A.CD_UNIDADE_MEDIDA_ESTOQUE IN
((SELECT V.CD_UNIDADE_MEDIDA FROM UNIDADE_MEDIDA V
WHERE lower(V.DS_UNIDADE_MEDIDA) LIKE '%rasco%ampola%'
AND V.ie_situacao='A')
UNION
(SELECT V.CD_UNIDADE_MEDIDA FROM UNIDADE_MEDIDA V
WHERE lower(V.DS_UNIDADE_MEDIDA) LIKE 'ampola%'
AND V.ie_situacao='A' 
UNION

SELECT V.CD_UNIDADE_MEDIDA FROM UNIDADE_MEDIDA V
WHERE lower(V.DS_UNIDADE_MEDIDA) LIKE '%tubete%'
AND V.ie_situacao='A') 
UNION
(SELECT V.CD_UNIDADE_MEDIDA FROM UNIDADE_MEDIDA V
WHERE lower(V.DS_UNIDADE_MEDIDA) LIKE '%bolsa%'
AND V.ie_situacao='A') 
union
(SELECT V.CD_UNIDADE_MEDIDA FROM UNIDADE_MEDIDA V
WHERE lower(V.DS_UNIDADE_MEDIDA) LIKE '%cápsula%'
AND V.ie_situacao='A') 
union
(SELECT V.CD_UNIDADE_MEDIDA FROM UNIDADE_MEDIDA V
WHERE lower(V.DS_UNIDADE_MEDIDA) LIKE '%capsula%'
AND V.ie_situacao='A') 
UNION
(SELECT V.CD_UNIDADE_MEDIDA FROM UNIDADE_MEDIDA V
WHERE lower(V.DS_UNIDADE_MEDIDA) LIKE '%comprimid%'
AND V.ie_situacao='A') 
UNION
(SELECT V.CD_UNIDADE_MEDIDA FROM UNIDADE_MEDIDA V
WHERE lower(V.DS_UNIDADE_MEDIDA) LIKE '%dragea%'
AND V.ie_situacao='A') 
UNION
(SELECT V.CD_UNIDADE_MEDIDA FROM UNIDADE_MEDIDA V
WHERE lower(V.DS_UNIDADE_MEDIDA) LIKE '%drágea%'
AND V.ie_situacao='A') 
UNION
(SELECT V.CD_UNIDADE_MEDIDA FROM UNIDADE_MEDIDA V
WHERE lower(V.DS_UNIDADE_MEDIDA) LIKE '%envelope%'
AND V.ie_situacao='A') 
UNION
(SELECT V.CD_UNIDADE_MEDIDA FROM UNIDADE_MEDIDA V
WHERE lower(V.DS_UNIDADE_MEDIDA) LIKE '%flaconete%'
AND V.ie_situacao='A') 
UNION
(SELECT V.CD_UNIDADE_MEDIDA FROM UNIDADE_MEDIDA V
WHERE lower(V.DS_UNIDADE_MEDIDA) LIKE '%sach%'
AND V.ie_situacao='A') 
UNION
(SELECT V.CD_UNIDADE_MEDIDA FROM UNIDADE_MEDIDA V
WHERE lower(V.DS_UNIDADE_MEDIDA) LIKE '%seringa%'
AND V.ie_situacao='A') 
UNION
(SELECT V.CD_UNIDADE_MEDIDA FROM UNIDADE_MEDIDA V
WHERE lower(V.DS_UNIDADE_MEDIDA) LIKE 'frasco'
AND V.ie_situacao='A') 
UNION
(SELECT V.CD_UNIDADE_MEDIDA FROM UNIDADE_MEDIDA V
WHERE lower(V.DS_UNIDADE_MEDIDA) LIKE 'suposit%'
AND V.ie_situacao='A') 
UNION
(SELECT V.CD_UNIDADE_MEDIDA FROM UNIDADE_MEDIDA V
WHERE lower(V.DS_UNIDADE_MEDIDA) LIKE 'suspens%nasal%'
AND V.ie_situacao='A') 
UNION
(SELECT V.CD_UNIDADE_MEDIDA FROM UNIDADE_MEDIDA V
WHERE lower(V.DS_UNIDADE_MEDIDA) LIKE 'tubo%'
AND V.ie_situacao='A') 
UNION
(SELECT V.CD_UNIDADE_MEDIDA FROM UNIDADE_MEDIDA V
WHERE lower(V.DS_UNIDADE_MEDIDA) LIKE 'bisnaga%'
AND V.ie_situacao='A') 
UNION
(SELECT V.CD_UNIDADE_MEDIDA FROM UNIDADE_MEDIDA V
WHERE lower(V.DS_UNIDADE_MEDIDA) LIKE 'pomada%'
AND V.ie_situacao='A') 
UNION
(SELECT V.CD_UNIDADE_MEDIDA FROM UNIDADE_MEDIDA V
WHERE lower(V.DS_UNIDADE_MEDIDA) LIKE 'creme%'
AND V.ie_situacao='A') 
UNION
(SELECT V.CD_UNIDADE_MEDIDA FROM UNIDADE_MEDIDA V
WHERE lower(V.DS_UNIDADE_MEDIDA) LIKE 'pote%'
AND V.ie_situacao='A') 
UNION
(SELECT V.CD_UNIDADE_MEDIDA FROM UNIDADE_MEDIDA V
WHERE lower(V.DS_UNIDADE_MEDIDA) LIKE 'adesivo%'
AND V.ie_situacao='A') 
UNION
(SELECT V.CD_UNIDADE_MEDIDA FROM UNIDADE_MEDIDA V
WHERE lower(V.DS_UNIDADE_MEDIDA) LIKE 'aerossol%'
AND V.ie_situacao='A'));

