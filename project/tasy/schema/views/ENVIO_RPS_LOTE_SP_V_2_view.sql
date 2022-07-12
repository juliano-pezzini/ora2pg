-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW envio_rps_lote_sp_v_2 (tp_registro, nr_inscricao_municipal, ds_tipo_rps, cd_serie_nf, nr_nota_fiscal, dt_emissao, ie_situacao, ie_situacao_nf, vl_servico, vl_descontos, cd_servico, vl_aliquota, ie_iss_retido, ie_cpf_cnpj, cd_cpf_cnpj, nr_inscricao_munic_tomador, nr_inscricao_estad_tomador, nm_tomador, ds_tipo_logradouro, ds_endereco, nr_endereco, ds_complemento, ds_bairro, ds_municipio, sg_estado, cd_cep, ds_email, ds_servicos, ds_observacao, vl_total_servicos, vl_total_descontos, qt_linhas, nr_sequencia, cd_operacao_nf, cd_estabelecimento, ds_natureza_operacao, vl_deducoes, vl_total_deducoes, vl_nota_fiscal, vl_total_nota_fiscal, cd_pessoa_fisica, vl_pis, vl_cofins, vl_inss, vl_ir, vl_cssl, vl_carga_tributaria, tx_carga_tributaria, ds_carga_tributaria, cd_cei, cd_matricula_obra, cd_municipio_prestacao, nr_encapsulamento, ds_campo_reservado, vl_recebido, ds_campo_reservado_2) AS select  1          tp_registro,
  a.cd_inscricao_municipal      nr_inscricao_municipal,
  ''          ds_tipo_rps,
  ''          cd_serie_nf,
  '0'          nr_nota_fiscal,
  null          dt_emissao,
  ''          ie_situacao,
  ''          ie_situacao_nf,
  0          vl_servico,
  0          vl_descontos,
  ''          cd_servico,
  0          vl_aliquota,
  ''          ie_iss_retido,
  0          ie_cpf_cnpj,
  ''          cd_cpf_cnpj,
  ''          nr_inscricao_munic_tomador,
  ''          nr_inscricao_estad_tomador,
  ''          nm_tomador,
  ''          ds_tipo_logradouro,
  ''          ds_endereco,
  ''          nr_endereco,
  ''          ds_complemento,
  ''          ds_bairro,
  ''          ds_municipio,
  ''          sg_estado,
  ''          cd_cep,
  ''          ds_email,
  ' '          ds_servicos,
  ''          ds_observacao,
  0          vl_total_servicos,
  0          vl_total_descontos,
  0          qt_linhas,
  0          nr_sequencia,
  0          cd_operacao_nf,
  a.cd_estabelecimento,
  ''          ds_natureza_operacao,
  0          vl_deducoes,
  0          vl_total_deducoes,
  0          vl_nota_fiscal,
  0          vl_total_nota_fiscal,
  ''          cd_pessoa_fisica,
  0          vl_pis,
  0          vl_cofins,
  0			 vl_inss,
  0          vl_ir,
  0          vl_cssl,
  0			 vl_carga_tributaria,
  0			 tx_carga_tributaria,
  ''		 ds_carga_tributaria,
  ''		 cd_cei,
  ''		 cd_matricula_obra,
  ''		 cd_municipio_prestacao,
  ''		 nr_encapsulamento,
  ''		 ds_campo_reservado,
  ''		 vl_recebido,
  ''		 ds_campo_reservado_2
FROM  estabelecimento a

union

select  6          tp_registro,
  ''          nr_inscricao_municipal,
  'RPS'          ds_tipo_rps,
  n.cd_serie_nf        cd_serie_nf,
  n.nr_nota_fiscal        nr_nota_fiscal,
  trunc(n.dt_emissao)        dt_emissao,
  CASE WHEN  n.ie_situacao=1 THEN  'T'  ELSE 'C' END   ie_situacao,
  n.ie_situacao        ie_situacao_nf,
  CASE WHEN n.ie_situacao=1 THEN  n.vl_mercadoria WHEN n.ie_situacao=3 THEN  CASE WHEN n.ie_status_envio IS NULL THEN  n.vl_mercadoria  ELSE 0 END   ELSE 0 END  vl_servico,
  n.vl_descontos        vl_descontos,
  substr(lpad(obter_dados_pf_pj_estab(n.cd_estabelecimento, null, n.cd_cgc_emitente, 'ATIV'),5,'0'), 1, 5) cd_servico,
  0          vl_aliquota,
  CASE WHEN substr(obter_se_nf_retem_iss(n.nr_sequencia),1,1)='S' THEN '1'  ELSE '2' END  ie_iss_retido,
  CASE WHEN substr(obter_dados_pf_pj(n.cd_pessoa_fisica,n.cd_cgc,'UF'),1,2)='IN' THEN 3  ELSE CASE WHEN n.cd_pessoa_fisica IS NULL THEN 2  ELSE CASE WHEN obter_cpf_pessoa_fisica(n.cd_pessoa_fisica) IS NULL THEN 3 WHEN obter_cpf_pessoa_fisica(n.cd_pessoa_fisica)='00000000000' THEN 3  ELSE 1 END  END  END  ie_cpf_cnpj,
  substr(CASE WHEN substr(obter_dados_pf_pj(n.cd_pessoa_fisica,n.cd_cgc,'UF'),1,2)='IN' THEN '00000000000000'  ELSE CASE WHEN   n.cd_pessoa_fisica IS NULL THEN n.cd_cgc  ELSE CASE WHEN obter_cpf_pessoa_fisica(n.cd_pessoa_fisica) IS NULL THEN '00000000000000'  ELSE obter_cpf_pessoa_fisica(n.cd_pessoa_fisica) END  END  END ,1,50) cd_cpf_cnpj,
    /*decode(  n.cd_pessoa_fisica,null,n.cd_cgc,
    decode(obter_cpf_pessoa_fisica(n.cd_pessoa_fisica),null,'00000000000000',obter_cpf_pessoa_fisica(n.cd_pessoa_fisica))) cd_cpf_cnpj,  */

  CASE WHEN elimina_acentuacao(elimina_caracteres_especiais(upper(substr(obter_dados_pf_pj(null,n.cd_cgc,'CI'),1,50))))='SAOPAULO' THEN  substr(obter_dados_pf_pj(null,n.cd_cgc,'IM'),1,8)  ELSE '00000000' END  nr_inscricao_munic_tomador,
  substr(obter_dados_pf_pj(null,n.cd_cgc,'IE'),1,20) nr_inscricao_estad_tomador,
  substr(obter_nome_pf_pj(n.cd_pessoa_fisica,n.cd_cgc),1,75) nm_tomador,
  'Rua'          ds_tipo_logradouro,
  coalesce(CASE WHEN n.cd_pessoa_fisica IS NULL THEN CASE WHEN substr(obter_compl_pj(n.cd_cgc,1,'E'),1,40)='N/D' THEN       substr(obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc, 'EN'),1,50)  ELSE substr(obter_compl_pj(n.cd_cgc,1,'E'),1,40) END   ELSE substr(obter_compl_pf(n.cd_pessoa_fisica, 1, 'EN'),1,50) END ,
    substr(obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc, 'EN'),1,50)) ds_endereco,
  coalesce(CASE WHEN n.cd_pessoa_fisica IS NULL THEN CASE WHEN substr(obter_compl_pj(n.cd_cgc,1,'NR'),1,10)='N/D' THEN       substr(obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc,  'NR'),1,10)  ELSE substr(obter_compl_pj(n.cd_cgc,1,'NR'),1,10) END   ELSE substr(obter_compl_pf(n.cd_pessoa_fisica, 1, 'NR'),1,10) END ,
    substr(obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc, 'NR'),1,10)) nr_endereco,
  coalesce(CASE WHEN n.cd_pessoa_fisica IS NULL THEN CASE WHEN substr(obter_compl_pj(n.cd_cgc,1,'CO'),1,30)='N/D' THEN       substr(obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc, 'CO'),1,30)  ELSE substr(obter_compl_pj(n.cd_cgc,1,'CO'),1,30) END   ELSE substr(obter_compl_pf(n.cd_pessoa_fisica, 1, 'CO'),1,30) END ,
    substr(obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc, 'CO'),1,30)) ds_complemento,
  coalesce(CASE WHEN n.cd_pessoa_fisica IS NULL THEN CASE WHEN substr(obter_compl_pj(n.cd_cgc,1,'B'),1,30)='N/D' THEN       substr(obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc, 'B'),1,30)  ELSE substr(obter_compl_pj(n.cd_cgc,1,'B'),1,30) END   ELSE substr(obter_compl_pf(n.cd_pessoa_fisica, 1, 'B'),1,30) END ,
    substr(obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc, 'B'),1,30)) ds_bairro,
  coalesce(CASE WHEN n.cd_pessoa_fisica IS NULL THEN CASE WHEN substr(obter_compl_pj(n.cd_cgc,1,'CI'),1,50)='N/D' THEN       substr(obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc, 'CI'),1,50)  ELSE substr(obter_compl_pj(n.cd_cgc,1,'CI'),1,50) END   ELSE substr(obter_compl_pf(n.cd_pessoa_fisica, 1, 'CI'),1,50) END ,
    substr(obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc, 'CI'),1,50)) ds_municipio,
  coalesce(CASE WHEN n.cd_pessoa_fisica IS NULL THEN CASE WHEN substr(obter_compl_pj(n.cd_cgc,1,'UF'),1,2)='N/D' THEN       substr(obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc, 'UF'),1,2)  ELSE substr(obter_compl_pj(n.cd_cgc,1,'UF'),1,2) END   ELSE substr(obter_compl_pf(n.cd_pessoa_fisica, 1, 'UF'),1,2) END ,
    substr(obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc, 'UF'),1,2)) sg_estado,
  coalesce(to_char(CASE WHEN n.cd_pessoa_fisica IS NULL THEN CASE WHEN substr(obter_compl_pj(n.cd_cgc,1,'CEP'),1,15)='N/D' THEN       to_char(somente_numero(substr(obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc, 'CEP'),1,15)))  ELSE substr(obter_compl_pj(n.cd_cgc,1,'CEP'),1,15) END   ELSE substr(obter_compl_pf(n.cd_pessoa_fisica, 1, 'CEP'),1,15) END ),
    to_char(somente_numero(substr(obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc, 'CEP'),1,15)))) cd_cep,
  coalesce(CASE WHEN n.cd_pessoa_fisica IS NULL THEN substr(obter_compl_pj(n.cd_cgc,1,'M'),1,80)  ELSE substr(obter_compl_pf(n.cd_pessoa_fisica, 1, 'M'),1,60) END ,
    substr(obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc, 'M'),1,60)) ds_email,
  CASE WHEN  n.ie_situacao=1 THEN   CASE WHEN     nr_seq_protocolo IS NULL THEN     substr(      (select  substr(obter_nome_pf(a.cd_pessoa_fisica),1,150)      from  atendimento_paciente a,        conta_paciente c      where  a.nr_atendimento = c.nr_atendimento      and  c.nr_interno_conta = n.nr_interno_conta)      ||  '   '  ||      (select  substr(obter_dados_pf(a.cd_pessoa_fisica,'CPF'),1,11)      from  atendimento_paciente a,        conta_paciente c      where  a.nr_atendimento = c.nr_atendimento      and  c.nr_interno_conta = n.nr_interno_conta)      || ' |'  ||      substr(obter_descricao_rps(n.cd_estabelecimento, n.nr_sequencia, 'DS_SERVICOS'), 1, 1000)      || '   ' || 'Per?odo de fechamento ' ||      (select  c.dt_periodo_inicial      from  atendimento_paciente a,        conta_paciente c      where  a.nr_atendimento = c.nr_atendimento      and  c.nr_interno_conta = n.nr_interno_conta)      || ' a '  ||      (select  c.dt_periodo_final      from  atendimento_paciente a,        conta_paciente c      where  a.nr_atendimento = c.nr_atendimento      and  c.nr_interno_conta = n.nr_interno_conta),      1, 1000)  ELSE -- substr(obter_descricao_rps(n.cd_estabelecimento, n.nr_sequencia, 'DS_SERVICOS'), 1, 1000)

    -- ALTERADO POR JULIANA HOLSTEIN, QUANDO RPS CANCELADA, DS_SERVICO DEVE SER NULO.

    -- replace(replace(substr(obter_descricao_rps(n.cd_estabelecimento, n.nr_sequencia, 'DS_SERVICOS'), 1, 1000), chr(13), ' '), chr(10), ' ')) ds_servicos,
  CASE WHEN  n.ie_situacao=1 THEN replace(replace(substr(obter_descricao_rps(n.cd_estabelecimento, n.nr_sequencia, 'DS_SERVICOS'), 1, 1000), chr(13), ' '), chr(10), ' ')   ELSE '' END  END   ELSE '' END  ds_servico,
  n.ds_observacao        ds_observacao,
  0          vl_total_servicos,
  0          vl_total_descontos,
  0          qt_linhas,
  n.nr_sequencia        nr_sequencia,
  n.cd_operacao_nf         cd_operacao_nf,
  n.cd_estabelecimento,
  substr(obter_desc_natureza_operacao(n.cd_natureza_operacao),1,100) ds_natureza_operacao,
  coalesce(Obter_Valor_tipo_Tributo_Nota(n.nr_sequencia, 'V', 'ISS'),0) vl_deducoes,
  0          vl_total_deducoes,
  CASE WHEN n.ie_situacao=1 THEN n.vl_total_nota  ELSE 0 END  vl_nota_fiscal,
  0          vl_total_nota_fiscal,
  n.cd_pessoa_fisica,
  coalesce(Obter_Valor_tipo_Tributo_Nota(n.nr_sequencia, 'V', 'PIS'),0) vl_pis,
  coalesce(Obter_Valor_tipo_Tributo_Nota(n.nr_sequencia, 'V', 'COFINS'),0) vl_cofins,
  coalesce(Obter_Valor_tipo_Tributo_Nota(n.nr_sequencia, 'V', 'INSS'),0) vl_inss,
  coalesce(Obter_Valor_tipo_Tributo_Nota(n.nr_sequencia, 'V', 'IR'),0) vl_ir,
  coalesce(Obter_Valor_tipo_Tributo_Nota(n.nr_sequencia, 'V', 'CSSL'),0) vl_cssl,
  0			 vl_carga_tributaria,
  0			 tx_carga_tributaria,
  ''		 ds_carga_tributaria,
  ''		 cd_cei,
  ''		 cd_matricula_obra,
  ''		 cd_municipio_prestacao,
  ''		 nr_encapsulamento,
  ''		 ds_campo_reservado,
  ''		 vl_recebido,
  ''		 ds_campo_reservado_2
from  operacao_nota o,
  nota_fiscal n
where  exists (
  select  1
  from  w_nota_fiscal x
  where  x.nr_seq_nota_fiscal = n.nr_sequencia)
and  o.cd_operacao_nf = n.cd_operacao_nf
and  n.vl_total_nota > 0

union

select  9          tp_registro,
  ''          nr_inscricao_municipal,
  'RPS'          ds_tipo_rps,
  ''          cd_serie_nf,
  '0'          nr_nota_fiscal,
  null          dt_emissao,
  ''          ie_situacao,
  ''          ie_situacao_nf,
  0          vl_servico,
  0          vl_descontos,
  ''          cd_servico,
  0          vl_aliquota,
  ''          ie_iss_retido,
  0          ie_cpf_cnpj,
  ''          cd_cpf_cnpj,
  ''          nr_inscricao_munic_tomador,
  ''          nr_inscricao_estad_tomador,
  ''          nm_tomador,
  ''          ds_tipo_logradouro,
  ''          ds_endereco,
  ''          nr_endereco,
  ''          ds_complemento,
  ''          ds_bairro,
  ''          ds_municipio,
  ''          sg_estado,
  ''          cd_cep,
  ''          ds_email,
  ' '          ds_servicos,
  ''          ds_observacao,
  sum(CASE WHEN n.ie_situacao=1 THEN  n.vl_mercadoria WHEN n.ie_situacao=3 THEN  CASE WHEN n.ie_status_envio IS NULL THEN  n.vl_mercadoria  ELSE 0 END   ELSE 0 END ) vl_total_servicos,
  sum(n.vl_descontos)      vl_total_descontos,
  0          qt_linhas,
  0          nr_sequencia,
  0           cd_operacao_nf,
  n.cd_estabelecimento,
  ''          ds_natureza_operacao,
  0          vl_deducoes,
  sum(coalesce(Obter_Valor_tipo_Tributo_Nota(n.nr_sequencia, 'V', 'ISS'),0))  vl_total_deducoes,
  0          vl_nota_fiscal,
  sum(coalesce(CASE WHEN n.ie_situacao=1 THEN n.vl_total_nota  ELSE 0 END ,0)) vl_total_nota_fiscal,
  ''          cd_pessoa_fisica,
  max(coalesce(Obter_Valor_tipo_Tributo_Nota(n.nr_sequencia, 'V', 'PIS'),0)) vl_pis,
  max(coalesce(Obter_Valor_tipo_Tributo_Nota(n.nr_sequencia, 'V', 'COFINS'),0)) vl_cofins,
  max(coalesce(Obter_Valor_tipo_Tributo_Nota(n.nr_sequencia, 'V', 'INSS'),0)) vl_inss,
  max(coalesce(Obter_Valor_tipo_Tributo_Nota(n.nr_sequencia, 'V', 'IR'),0)) vl_ir,
  max(coalesce(Obter_Valor_tipo_Tributo_Nota(n.nr_sequencia, 'V', 'CSSL'),0)) vl_cssl,
  0			 vl_carga_tributaria,
  0			 tx_carga_tributaria,
  ''		 ds_carga_tributaria,
  ''		 cd_cei,
  ''		 cd_matricula_obra,
  ''		 cd_municipio_prestacao,
  ''		 nr_encapsulamento,
  ''		 ds_campo_reservado,
  ''		 vl_recebido,
  ''		 ds_campo_reservado_2
from  nota_fiscal n
where  exists (
  select  1
  from  w_nota_fiscal x
  where  x.nr_seq_nota_fiscal = n.nr_sequencia)
and  n.vl_total_nota > 0
group by n.cd_estabelecimento;

