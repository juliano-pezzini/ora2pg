-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW fosp_ficha_admissao_v (tipo, institu, adm, prontuar, nome, nomemae, escolari, tipodoc, numdoc, dtnasc, sexo, ufnasc, endereco, numero, cep, ibge, cateatend, dtconsult, clinica, diagprev, dtdiag, basediag, topo, morfo, ec, t, n, m, pt, pn, pm, s, g, localtnm, idmitotic, psa, gleason, naotrat, nenhum, radio, quimio, hormonio, tmo, imuno, outros, nenhumant, cirurant, radioant, quimioant, hormoant, tmoant, imunoant, outroant, nenhumapos, cirurapos, radioapos, quimioapos, hormoapos, tmoapos, imunoapos, outroapos, dtultinfo, ultinfo, laterali, nr_sequencia) AS select 'A' tipo,
cfa.ds_instituicao_origem institu,
cfa.nr_atend_estadiamento adm,
cfa.nr_prontuario prontuar,
pf.nm_pessoa_fisica nome,
obter_nome_mae_pf(pf.cd_pessoa_fisica) nomemae,
CASE WHEN obter_dados_pf(pf.cd_pessoa_fisica,'CGI')=2 THEN  3 WHEN obter_dados_pf(pf.cd_pessoa_fisica,'CGI')=3 THEN  4 WHEN obter_dados_pf(pf.cd_pessoa_fisica,'CGI')=4 THEN  5 WHEN obter_dados_pf(pf.cd_pessoa_fisica,'CGI')=6 THEN  5 WHEN obter_dados_pf(pf.cd_pessoa_fisica,'CGI')=7 THEN  2 WHEN obter_dados_pf(pf.cd_pessoa_fisica,'CGI')=8 THEN  4 WHEN obter_dados_pf(pf.cd_pessoa_fisica,'CGI')=9 THEN  5 WHEN obter_dados_pf(pf.cd_pessoa_fisica,'CGI')=10 THEN  2 WHEN obter_dados_pf(pf.cd_pessoa_fisica,'CGI')=11 THEN  1 WHEN obter_dados_pf(pf.cd_pessoa_fisica,'CGI')=12 THEN  5 WHEN obter_dados_pf(pf.cd_pessoa_fisica,'CGI')=13 THEN  5 WHEN obter_dados_pf(pf.cd_pessoa_fisica,'CGI')=14 THEN  9 WHEN obter_dados_pf(pf.cd_pessoa_fisica,'CGI')=15 THEN  4  ELSE 9 END  escolari,
4 as tipodoc,
pf.nr_cpf numdoc,
to_char(pf.dt_nascimento, 'DD/MM/YYYY') as dtnasc,
CASE WHEN pf.ie_sexo='M' THEN  1 WHEN pf.ie_sexo='I' THEN  1 WHEN pf.ie_sexo='D' THEN  1 WHEN pf.ie_sexo='F' THEN  2 END  sexo,
coalesce(substr(obter_dados_pf(pf.cd_pessoa_fisica,'UFP'),1,100), 'SI') ufnasc,
cpf.ds_endereco endereco,
cpf.nr_endereco numero,
cpf.cd_cep cep,
cpf.cd_municipio_ibge ibge,
CASE WHEN cfa.ie_custo_tratamento=2 THEN  1 WHEN cfa.ie_custo_tratamento=1 THEN  2  ELSE 3 END cateatend,
cfa.dt_consulta dtconsult,
cfa.cd_clinica_atendimento clinica,
cfa.ie_diag_trat_previo diagprev,
cfa.dt_diagnostico dtdiag,
cfa.cd_base_diag basediag,
cfa.cd_topog_tu_prim topo,
cfa.cd_morfologia_tu_prim morfo,
cfa.cd_estadio ec,
cfa.cd_tumor_primario t,
cfa.cd_linfonodo_regional n,
cfa.cd_metastase_distancia m,
cfa.cd_tumor_prim_pat pt,
cfa.cd_linfonodo_reg_pat pn,
cfa.cd_metastase_dist_pat pm,
cfa.cd_marc_serico s,
cfa.cd_grau_histo g,
9 as localtnm,
9 as idmitotic,
9 as psa,
9 as gleason,
cfa.cd_razao_nao_trat naotrat,
CASE WHEN cfa.ie_trat_instituicao='S' THEN  1  ELSE 0 END  as nenhum,
CASE WHEN cfa.ie_trat_inst_radio='S' THEN  1  ELSE 0 END  as radio,
CASE WHEN cfa.ie_trat_inst_quimio='S' THEN  1  ELSE 0 END  as quimio,
CASE WHEN cfa.ie_trat_inst_horm='S' THEN  1  ELSE 0 END  as hormonio,
CASE WHEN cfa.ie_trat_inst_tmo='S' THEN  1  ELSE 0 END  as tmo,
CASE WHEN cfa.ie_trat_inst_imuno='S' THEN  1  ELSE 0 END  as imuno,
CASE WHEN cfa.ie_trat_inst_outro='S' THEN  1  ELSE 0 END  as outros,
CASE WHEN cfa.ie_nenhum_ant='S' THEN  1  ELSE 0 END  as nenhumant,
CASE WHEN cfa.ie_cirurgi_ant='S' THEN  1  ELSE 0 END  as cirurant,
CASE WHEN cfa.ie_radio_ant='S' THEN  1  ELSE 0 END  as radioant,
CASE WHEN cfa.ie_quimio_ant='S' THEN  1  ELSE 0 END  as quimioant,
CASE WHEN cfa.ie_hormo_ant='S' THEN  1  ELSE 0 END  as hormoant,
CASE WHEN cfa.ie_tmo_ant='S' THEN  1  ELSE 0 END  as tmoant,
CASE WHEN cfa.ie_imuno_ant='S' THEN  1  ELSE 0 END  as imunoant,
CASE WHEN cfa.ie_outros_ant='S' THEN  1  ELSE 0 END  as outroant,
CASE WHEN cfa.ie_nenhum_ap='S' THEN  1  ELSE 0 END  as nenhumapos,
CASE WHEN cfa.ie_cirurgi_ap='S' THEN  1  ELSE 0 END  as cirurapos,
CASE WHEN cfa.ie_radio_ap='S' THEN  1  ELSE 0 END  as radioapos,
CASE WHEN cfa.ie_quimio_ap='S' THEN  1  ELSE 0 END  as quimioapos,
CASE WHEN cfa.ie_hormo_ap='S' THEN  1  ELSE 0 END  as hormoapos,
CASE WHEN cfa.ie_tmo_ap='S' THEN  1  ELSE 0 END  as tmoapos,
CASE WHEN cfa.ie_imuno_ap='S' THEN  1  ELSE 0 END  as imunoapos,
CASE WHEN cfa.ie_outros_ap='S' THEN  1  ELSE 0 END  as outroapos,
cfa.dt_preench_ficha dtultinfo,
CASE WHEN cfa.ie_estado_pac_fim_trat=1 THEN  2 WHEN cfa.ie_estado_pac_fim_trat=7 THEN  2 WHEN cfa.ie_estado_pac_fim_trat=9 THEN  2 WHEN cfa.ie_estado_pac_fim_trat=6 THEN  3  ELSE 1 END  as ultinfo,
cfa.cd_lateralidade laterali,
cfa.nr_sequencia
FROM pessoa_fisica pf
join can_ficha_admissao cfa on pf.cd_pessoa_fisica = cfa.cd_pessoa_fisica
left join compl_pessoa_fisica cpf on pf.cd_pessoa_fisica = cpf.cd_pessoa_fisica
                            and ie_tipo_complemento = 1;

