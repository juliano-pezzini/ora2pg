-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW exp_nre_pref_capanema_v (nr_nota, ie_situacao, dt_emissao, dt_emissao2, dt_nota_servico, nr_nota_substituta, cd_natureza_operacao, nr_rps, numero_serie_rps, ds_tipo_rps, dt_emissao_rps, ie_situacao_rps, nr_rps_substituido, numero_serie_rps_substituido, vl_servico, codigocnae, ident_atividade, vl_base_aliquota, vl_aliquota, vl_iss, ie_iss_retido, disc_servicos_prestados, cd_municipio, qtd_servicos_prestados, vl_unitario_serv_prestado, nr_cmc_empresa, razao_social_prest, nm_fantasia_prest, cpf_cnpj_prest, endereco_prest, numero_prest, complemento_prest, bairro_prest, codigocidade_prest, uf_prest, cep_prest, email_prest, telefone_prest, cpf_cnpj_tomador, tp_pessoa_tomador_servico, razao_social_tomador, endereco_tomador, numero_tomador, complemento_tomador, bairro_tomador, codigocidade_tomador, uf_tomador, cep_tomador, email_tomador, telefone_tomador, dt_cancelamento, ie_sincronizacao, valordeducoes, valorpis, valorcofins, valorinss, valorir, valorcsll, vl_total_deducoes, cd_estabelecimento) AS SELECT
    LPAD(n.nr_nota_fiscal, 15, '0')                   nr_nota,
    CASE WHEN n.ie_situacao=1 THEN  1  ELSE 2 END                       ie_situacao,
    n.dt_emissao   				      dt_emissao,
    TO_CHAR( n.dt_emissao, 'DD/MM/YYYY HH24:MI:SS')   dt_emissao2,
    TO_CHAR( n.dt_emissao, 'YYYYMM')	              dt_nota_servico,
    LPAD(0, 15, '0')	                              nr_nota_substituta,
    SUBSTR(n.cd_natureza_operacao,1,1)                cd_natureza_operacao,
    LPAD(coalesce(n.nr_nota_fiscal, '0'), 15, '0')         nr_rps,
    LPAD(coalesce(n.cd_serie_nf,'0'),5, '0')               numero_serie_rps,
    '1'					              ds_tipo_rps,
    TO_CHAR( n.dt_emissao, 'DD/MM/YYYY')              dt_emissao_rps,
    CASE WHEN n.ie_situacao=1 THEN  1  ELSE 2 END                       ie_situacao_rps,
    '000000000000000'                                 nr_rps_substituido,
    '00000'                                           numero_serie_rps_substituido,
     LPAD(n.vl_mercadoria, 16, '0')    vl_servico,
     LPAD(coalesce(pls_obter_cd_cnae(obter_dados_pf_pj(NULL, n.cd_cgc_emitente, 'CNAE')), '0'),7,'0') CodigoCnae,
     LPAD(coalesce(obter_dados_grupo_servico_item(obter_item_servico_proced(obter_procedimento_nfse(n.nr_sequencia,'P'), obter_procedimento_nfse(n.nr_sequencia,'O')), 'GR'),'0'),15,'0') ident_atividade,
     LPAD(obter_dados_trib_item_nf(n.nr_sequencia,'ISS', 'BC'),16,'0') vl_base_aliquota,
     LPAD(coalesce(obter_dados_trib_item_nf(n.nr_sequencia,'ISS', 'AL'),'0'),16,'0') vl_aliquota,
     LPAD(elimina_caractere_especial(coalesce(nfe_obter_valores_totais_num(n.nr_sequencia, 'ISS', 'VL'),'0')), 16, 0) vl_iss,
     CASE WHEN SUBSTR(obter_se_nf_retem_iss(n.nr_sequencia),1,1)='S' THEN '1'  ELSE '2' END  ie_iss_retido,
     SUBSTR(obter_descricao_rps(n.cd_estabelecimento, n.nr_sequencia, 'DS_SERVICOS'), 1, 2000) disc_servicos_prestados,
     LPAD(SUBSTR(coalesce(CASE WHEN cd_cgc_emitente IS NULL THEN  obter_compl_pf(cd_pessoa_fisica, 1, 'CDMDV')  ELSE nfe_obter_dados_pj(cd_cgc_emitente, 'IBGE') END ,'0'), 1, 15), 15, '0') cd_municipio,
     LPAD((	SELECT	COUNT(b.cd_procedimento)
		FROM   nota_fiscal_item b
		WHERE  b.nr_sequencia = n.nr_sequencia),15,0) qtd_servicos_prestados,
     LPAD(sip_campo_mascara_virgula(CASE WHEN nfse_obter_regra('VL', n.cd_estabelecimento)=1 THEN  n.vl_total_nota WHEN nfse_obter_regra('VL', n.cd_estabelecimento)=2 THEN  n.vl_total_nota - n.vl_descontos WHEN nfse_obter_regra('VL', n.cd_estabelecimento)=3 THEN n.vl_mercadoria WHEN nfse_obter_regra('VL', n.cd_estabelecimento)=4 THEN  n.vl_mercadoria - n.vl_descontos END ),16,0) vl_unitario_serv_prestado,
     LPAD(obter_dados_pf_pj(NULL,n.cd_cgc_emitente, 'IM'),15,0) nr_cmc_empresa,
     RPAD(SUBSTR(coalesce(obter_dados_pf_pj(cd_pessoa_fisica, cd_cgc_emitente, 'N'), ' '),1,115),115,' ')	razao_social_prest,
     RPAD(SUBSTR(coalesce(obter_dados_pf_pj(cd_pessoa_fisica, cd_cgc_emitente, 'N'), ' '),1,60),60,' ')	 nm_fantasia_prest,
     LPAD(coalesce(n.cd_cgc_emitente,'0'),14,'0') cpf_cnpj_prest,
     RPAD(SUBSTR(coalesce(tiss_eliminar_caractere(elimina_acentuacao(obter_dados_pf_pj(cd_pessoa_fisica, cd_cgc_emitente, 'EN'))), ' '), 1, 125),125, ' ') Endereco_prest,
     LPAD(SUBSTR(coalesce(obter_dados_pf_pj(cd_pessoa_fisica, cd_cgc_emitente, 'NR'), '0'), 1, 10),10 ,'0') Numero_prest,
     RPAD(SUBSTR(coalesce(tiss_eliminar_caractere(elimina_acentuacao(obter_dados_pf_pj(cd_pessoa_fisica, cd_cgc_emitente, 'CO'))),' '), 1, 60),60 ,' ') Complemento_prest,
     RPAD(SUBSTR(coalesce(tiss_eliminar_caractere(elimina_acentuacao(obter_dados_pf_pj(cd_pessoa_fisica, cd_cgc_emitente, 'B'))),' '), 1, 60),60 ,' ') Bairro_prest,
     LPAD(SUBSTR(coalesce(nfse_obter_dados_pf_pj(cd_pessoa_fisica, cd_cgc_emitente, 'CDMNF'),'0'), 1, 15), 15, '0') Codigocidade_prest,
     SUBSTR(obter_dados_pf_pj(cd_pessoa_fisica, cd_cgc_emitente, 'UF'), 1, 2) Uf_prest,
     LPAD(somente_numero(SUBSTR(obter_dados_pf_pj(cd_pessoa_fisica, cd_cgc_emitente, 'CEP'), 1, 15)),8,'0') Cep_prest,
     RPAD(coalesce(CASE WHEN cd_pessoa_fisica='' THEN coalesce(SUBSTR(tiss_eliminar_caractere(elimina_acentuacao(obter_dados_pf_pj_estab(cd_estabelecimento, '', cd_cgc_emitente, 'M'))), 1, 80), '')  ELSE coalesce(SUBSTR(tiss_eliminar_caractere(elimina_acentuacao(obter_dados_pf_pj(cd_pessoa_fisica, '', 'M'))), 1, 80), '') END ,' '),80,' ' )Email_prest,
     RPAD(CASE WHEN cd_pessoa_fisica='' THEN coalesce(SUBSTR(elimina_caracteres_telefone(tiss_eliminar_caractere(obter_dados_pf_pj('', cd_cgc_emitente, 'DDT') || obter_dados_pf_pj('', cd_cgc_emitente, 'T'))), 1, 11), '')  ELSE coalesce(SUBSTR(elimina_caracteres_telefone(tiss_eliminar_caractere(obter_dados_pf_pj(cd_pessoa_fisica, NULL, 'DDT') || obter_dados_pf_pj(cd_pessoa_fisica, '', 'T'))), 		1, 11), '') END ,11,'0') Telefone_prest,
     LPAD(coalesce(n.cd_cgc,'0'),14,'0') cpf_cnpj_tomador,
	CASE WHEN n.cd_pessoa_fisica IS NULL THEN  2  ELSE 1 END   Tp_pessoa_tomador_servico,
	RPAD(SUBSTR(coalesce(obter_dados_pf_pj(cd_pessoa_fisica, cd_cgc, 'N'), ' '),1,115),115,' ')	razao_social_tomador,
    RPAD(SUBSTR(coalesce(tiss_eliminar_caractere(elimina_acentuacao(obter_dados_pf_pj(cd_pessoa_fisica, cd_cgc, 'EN'))), ' '), 1, 125),125, ' ') Endereco_tomador,
	RPAD(SUBSTR(coalesce(obter_dados_pf_pj(cd_pessoa_fisica, cd_cgc, 'NR'), '0'), 1, 10),10 ,'0') Numero_tomador,
	RPAD(SUBSTR(coalesce(tiss_eliminar_caractere(elimina_acentuacao(obter_dados_pf_pj(cd_pessoa_fisica, cd_cgc, 'CO'))),' '), 1, 60),60 ,' ') Complemento_tomador,
	RPAD(SUBSTR(coalesce(tiss_eliminar_caractere(elimina_acentuacao(obter_dados_pf_pj(cd_pessoa_fisica, cd_cgc, 'B'))),' '), 1, 60),60 ,' ') Bairro_tomador,
	LPAD(SUBSTR(coalesce(nfse_obter_dados_pf_pj(cd_pessoa_fisica, cd_cgc, 'CDMNF'),'0'), 1, 15), 15, '0') Codigocidade_tomador,
	SUBSTR(obter_dados_pf_pj(cd_pessoa_fisica, cd_cgc, 'UF'), 1, 2) Uf_tomador,
	RPAD(somente_numero(SUBSTR(obter_dados_pf_pj(cd_pessoa_fisica, cd_cgc, 'CEP'), 1, 15)),8,'0') Cep_tomador,
	RPAD(coalesce(CASE WHEN cd_pessoa_fisica='' THEN coalesce(SUBSTR(tiss_eliminar_caractere(elimina_acentuacao(obter_dados_pf_pj_estab(cd_estabelecimento, '', cd_cgc, 'M'))), 1, 80), '')  ELSE coalesce(SUBSTR(tiss_eliminar_caractere(elimina_acentuacao(obter_dados_pf_pj(cd_pessoa_fisica, '', 'M'))), 1, 80), '') END ,' '),80,' ' )Email_tomador,
    RPAD(CASE WHEN cd_pessoa_fisica='' THEN coalesce(SUBSTR(elimina_caracteres_telefone(tiss_eliminar_caractere(obter_dados_pf_pj('', cd_cgc, 'DDT') || obter_dados_pf_pj('', cd_cgc, 'T'))), 1, 11), '')  ELSE coalesce(SUBSTR(elimina_caracteres_telefone(tiss_eliminar_caractere(obter_dados_pf_pj(cd_pessoa_fisica, NULL, 'DDT') || obter_dados_pf_pj(cd_pessoa_fisica, '', 'T'))), 		1, 11), '') END ,11,'0') Telefone_tomador,
	coalesce(TO_CHAR(n.dt_cancelamento, 'DD/MM/YYYY'), '          ')     dt_cancelamento,
	0 ie_sincronizacao,
    LPAD(obter_valor_tipo_tributo_nota(nr_sequencia, 'C', 'ISSST'),16, '0') ValorDeducoes,
	LPAD(obter_valor_tipo_tributo_nota(nr_sequencia, 'V', 'PIS'),16, '0') ValorPis,
	LPAD(obter_valor_tipo_tributo_nota(nr_sequencia, 'V', 'COFINS'),16, '0') ValorCofins,
	LPAD(obter_valor_tipo_tributo_nota(nr_sequencia, 'V', 'INSS'),16, '0') ValorInss,
	LPAD(obter_valor_tipo_tributo_nota(nr_sequencia, 'V', 'IR'),16, '0') ValorIr,
	LPAD(obter_valor_tipo_tributo_nota(nr_sequencia, 'V', 'CSLL'),16, '0') ValorCsll,
	LPAD(coalesce(Obter_Valor_tipo_Tributo_Nota(n.nr_sequencia, 'V', 'ISS'),0),16, '0')  vl_total_deducoes,
       n.cd_estabelecimento cd_estabelecimento
FROM OPERACAO_NOTA o,
     NOTA_FISCAL n
WHERE
 n.CD_OPERACAO_NF = o.CD_OPERACAO_NF
AND
EXISTS (
	SELECT	1
	FROM	w_nota_fiscal x
	WHERE	x.nr_seq_nota_fiscal = n.nr_sequencia);

