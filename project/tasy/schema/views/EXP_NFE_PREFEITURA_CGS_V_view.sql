-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW exp_nfe_prefeitura_cgs_v (tp_registro, tp_arquivo, nr_inscricao_municipal, nr_versao, dt_geracao, ds_identificador, ie_codificacao, cd_servico, ie_status, vl_total, vl_base_calculo, vl_cofins, vl_csll, vl_inss, vl_irpj, vl_pis, cd_cpf_cnpj_tomador, nr_inscricao_munic_tomador, nr_inscricao_estad_tomador, nm_tomador, ds_endereco_tomador, nr_endereco_tomador, ds_complemento_tomador, ds_bairro_tomador, ds_municipio_tomador, sg_estado_tomador, cd_cep_tomador, ds_email_tomador, ds_servicos, qt_linhas, vl_total_servicos, vl_total_base_calculo, dt_emissao, cd_estabelecimento) AS select  1          tp_registro,
  'NFE_LOTE'        tp_arquivo, 
  a.cd_inscricao_municipal      nr_inscricao_municipal, 
  '010'          nr_versao, 
  to_char(LOCALTIMESTAMP, 'yyyymmdd')      dt_geracao, 
  null              ds_identificador, 
  null          ie_codificacao, 
  null          cd_servico, 
  ''          ie_status, 
  null          vl_total, 
  null          vl_base_calculo, 
  ''          vl_cofins, 
  ''          vl_csll, 
  ''          vl_inss, 
  ''          vl_irpj, 
  ''          vl_pis, 
  null          cd_cpf_cnpj_tomador, 
  null          nr_inscricao_munic_tomador, 
  null          nr_inscricao_estad_tomador, 
  ''          nm_tomador, 
  ''          ds_endereco_tomador, 
  ''          nr_endereco_tomador, 
  ''          ds_complemento_tomador, 
  ''          ds_bairro_tomador, 
  ''          ds_municipio_tomador, 
  ''          sg_estado_tomador, 
  ''          cd_cep_tomador, 
  ''          ds_email_tomador, 
  ''          ds_servicos, 
  0          qt_linhas, 
  null          vl_total_servicos, 
  null          vl_total_base_calculo, 
  null          dt_emissao, 
  a.cd_estabelecimento      cd_estabelecimento 
FROM  estabelecimento a 

union
 
select  2          tp_registro, 
  ''          tp_arquivo, 
  ''          nr_inscricao_municipal, 
  ''          nr_versao, 
  ''          dt_geracao, 
  lpad(n.nr_sequencia,12,0)    ds_identificador, 
  1          ie_codificacao, 
  /*lpad(elimina_caractere_especial(obter_dados_grupo_servico_item(obter_item_servico_proced(obter_procedimento_nfse(n.nr_sequencia,'P'), 
  obter_procedimento_nfse(n.nr_sequencia,'O')), 'CD')),7,0) cd_servico,*/
 
  403          cd_servico, 
  CASE WHEN n.ie_situacao=3 THEN  'C' WHEN n.ie_situacao=9 THEN  'C'  ELSE 'T' END   ie_status, 
  /*lpad(elimina_caractere_especial(campo_mascara_virgula(decode(n.ie_situacao,1, n.vl_mercadoria, 3, decode(n.ie_status_envio, null, n.vl_mercadoria, 0), 0))),15,0) VL_TOTAL,*/
 
  lpad(elimina_caractere_especial(campo_mascara_virgula(CASE WHEN n.ie_situacao=1 THEN n.vl_total_nota  ELSE 0 END )),15,0) VL_TOTAL, 
  lpad(elimina_caractere_especial(campo_mascara_virgula(coalesce(Obter_Valor_tipo_Tributo_Nota(n.nr_sequencia, 'B', 'ISS'),0))),15,0)  vl_base_calculo, 
  lpad(elimina_caractere_especial(nfe_obter_valores_totais_num(n.nr_sequencia, 'COFINS', 'VL')), 15, 0) vl_cofins, 
  lpad(elimina_caractere_especial(nfe_obter_valores_totais_num(n.nr_sequencia, '', 'VL')), 15, 0) vl_csll, 
  lpad(elimina_caractere_especial(nfe_obter_valores_totais_num(n.nr_sequencia, 'INSS', 'VL')), 15, 0) vl_inss, 
  lpad(elimina_caractere_especial(nfe_obter_valores_totais_num(n.nr_sequencia, 'IR', 'VL')), 15, 0) vl_irpj, 
  lpad(elimina_caractere_especial(nfe_obter_valores_totais_num(n.nr_sequencia, 'PIS', 'VL')), 15, 0) vl_pis, 
  rpad( 
    CASE WHEN substr(obter_dados_pf_pj(n.cd_pessoa_fisica,n.cd_cgc,'UF'),1,2)='IN' THEN '00000000000000'  ELSE CASE WHEN n.cd_pessoa_fisica IS NULL THEN n.cd_cgc  ELSE CASE WHEN obter_cpf_pessoa_fisica(n.cd_pessoa_fisica) IS NULL THEN 'PFNI'  ELSE obter_cpf_pessoa_fisica(n.cd_pessoa_fisica) END  END  END ,15,' ') cd_cpf_cnpj_tomador, 
  /*LPAD(decode(elimina_acentuacao(elimina_caracteres_especiais(upper(substr(obter_dados_pf_pj(null,n.cd_cgc,'CI'),1,50)))),'CAMPINA GRANDE DO SUL' ,substr(obter_dados_pf_pj(null,n.cd_cgc,'IM'),1,8),'    '),7,' ')'     ' nr_inscricao_munic_tomador,*/
 
  lpad(' ',8,' ') nr_inscricao_munic_tomador, 
  /*substr(obter_dados_pf_pj(null,n.cd_cgc,'IE'),1,20)'     ' nr_inscricao_estad_tomador,*/
 
  lpad(' ',10,' ') nr_inscricao_estad_tomador, 
  substr(obter_nome_pf_pj(n.cd_pessoa_fisica,n.cd_cgc),1,75) nm_tomador, 
  coalesce(CASE WHEN n.cd_pessoa_fisica IS NULL THEN CASE WHEN substr(obter_compl_pj(n.cd_cgc,1,'E'),1,40)='N/D' THEN substr(obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc, 'EN'),1,50)  ELSE substr(obter_compl_pj(n.cd_cgc,1,'E'),1,40) END   ELSE substr(obter_compl_pf(n.cd_pessoa_fisica, 1, 'EN'),1,50) END ,substr(obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc, 'EN'),1,50)) ds_endereco_tomador, 
  coalesce(CASE WHEN n.cd_pessoa_fisica IS NULL THEN CASE WHEN substr(obter_compl_pj(n.cd_cgc,1,'NR'),1,10)='N/D' THEN  substr(obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc, 'NR'),1,10)  ELSE substr(obter_compl_pj(n.cd_cgc,1,'NR'),1,10) END   ELSE substr(obter_compl_pf(n.cd_pessoa_fisica, 1, 'NR'),1,10) END ,substr(obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc, 'NR'),1,10)) nr_endereco_tomador, 
  coalesce(CASE WHEN n.cd_pessoa_fisica IS NULL THEN CASE WHEN substr(obter_compl_pj(n.cd_cgc,1,'CO'),1,30)='N/D' THEN  substr(obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc, 'CO'),1,30)  ELSE substr(obter_compl_pj(n.cd_cgc,1,'CO'),1,30) END   ELSE substr(obter_compl_pf(n.cd_pessoa_fisica, 1, 'CO'),1,30) END ,substr(obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc, 'CO'),1,30)) ds_complemento_tomador, 
  coalesce(CASE WHEN n.cd_pessoa_fisica IS NULL THEN CASE WHEN substr(obter_compl_pj(n.cd_cgc,1,'B'),1,30)='N/D' THEN substr(obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc, 'B'),1,30)  ELSE substr(obter_compl_pj(n.cd_cgc,1,'B'),1,30) END   ELSE substr(obter_compl_pf(n.cd_pessoa_fisica, 1, 'B'),1,30) END ,substr(obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc, 'B'),1,30)) ds_bairro_tomador, 
  coalesce(CASE WHEN n.cd_pessoa_fisica IS NULL THEN CASE WHEN substr(obter_compl_pj(n.cd_cgc,1,'CI'),1,50)='N/D' THEN substr(obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc, 'CI'),1,50)  ELSE substr(obter_compl_pj(n.cd_cgc,1,'CI'),1,50) END   ELSE substr(obter_compl_pf(n.cd_pessoa_fisica, 1, 'CI'),1,50) END ,substr(obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc, 'CI'),1,50)) ds_municipio_tomador, 
  coalesce(CASE WHEN n.cd_pessoa_fisica IS NULL THEN CASE WHEN substr(obter_compl_pj(n.cd_cgc,1,'UF'),1,2)=substr(obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc, 'UF'),1,2) THEN  substr(obter_compl_pj(n.cd_cgc,1,'UF'),1,2) END   ELSE substr(obter_compl_pf(n.cd_pessoa_fisica, 1, 'UF'),1,2) END ,substr(obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc, 'UF'),1,2)) sg_estado_tomador, 
  coalesce(to_char(CASE WHEN n.cd_pessoa_fisica IS NULL THEN CASE WHEN substr(obter_compl_pj(n.cd_cgc,1,'CEP'),1,8)='N/D' THEN to_char(somente_numero(substr(obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc, 'CEP'),1,8)))  ELSE substr(obter_compl_pj(n.cd_cgc,1,'CEP'),1,8) END   ELSE substr(obter_compl_pf(n.cd_pessoa_fisica, 1, 'CEP'),1,8) END ),to_char(somente_numero(substr(obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc, 'CEP'),1,8)))) cd_cep_tomador, 
  coalesce(CASE WHEN n.cd_pessoa_fisica IS NULL THEN substr(obter_dados_pf_pj_estab(n.cd_estabelecimento,n.cd_pessoa_fisica, n.cd_cgc, 'M'),1,60)  ELSE substr(obter_compl_pf(n.cd_pessoa_fisica, 1, 'M'),1,60) END ,'') ds_email_tomador, 
substr(Obter_select_concatenado( 
'select decode(a.cd_material, null, 
substr(obter_descricao_procedimento(a.cd_procedimento, ie_origem_proced),1,240), 
substr(obter_desc_material(a.cd_material),1,100)) 
    from nota_fiscal_item a, nota_fiscal b where a.nr_sequencia = b.nr_sequencia and a.nr_sequencia = ' || n.nr_sequencia,null,'|'),1,1000) ds_servicos, 
  0          qt_linhas, 
  null          vl_total_servicos, 
  null          vl_total_base_calculo, 
  trunc(n.dt_emissao)      dt_emissao, 
  n.cd_estabelecimento      cd_estabelecimento 
from  operacao_nota o, 
  nota_fiscal n 
where  exists ( 
  select  1 
  from  w_nota_fiscal x 
  where  x.nr_seq_nota_fiscal = n.nr_sequencia) 
and  o.cd_operacao_nf = n.cd_operacao_nf 
and  n.ie_situacao <> 2 

union
 
select  9          tp_registro, 
  ''          tp_arquivo, 
  ''          nr_inscricao_municipal, 
  ''          nr_versao, 
  ''          dt_geracao, 
  null          ds_identificador, 
  null          ie_codificacao, 
  null          cd_servico, 
  ''          ie_status, 
  null          VL_TOTAL, 
  null          vl_base_calculo, 
  ''          vl_cofins, 
  ''          vl_csll, 
  ''          vl_inss, 
  ''          vl_irpj, 
  ''          vl_pis, 
  null          cd_cpf_cnpj_tomador, 
  null          nr_inscricao_munic_tomador,-- 
  null          nr_inscricao_estad_tomador, 
  ''          nm_tomador, 
  ''          ds_endereco_tomador, 
  ''          nr_endereco_tomador, 
  ''          ds_complemento_tomador, 
  ''          ds_bairro_tomador, 
  ''          ds_municipio_tomador, 
  ''          sg_estado_tomador, 
  ''          cd_cep_tomador, 
  ''          ds_email_tomador, 
  ''          ds_servicos, 
  0          qt_linhas, 
  lpad(elimina_caractere_especial(campo_mascara_virgula(sum(CASE WHEN n.ie_situacao=1 THEN n.vl_total_nota  ELSE 0 END ))),15,0) vl_total_servicos, 
  lpad(elimina_caractere_especial(campo_mascara_virgula(coalesce(sum(Obter_Valor_tipo_Tributo_Nota(n.nr_sequencia, 'B', 'ISS')),0))),15,0)  vl_total_base_calculo, 
  null          dt_emissao, 
  n.cd_estabelecimento      cd_estabelecimento 
from  nota_fiscal n 
where  exists ( 
  select  1 
  from  w_nota_fiscal x 
  where  x.nr_seq_nota_fiscal = n.nr_sequencia) 
group by n.cd_estabelecimento;

