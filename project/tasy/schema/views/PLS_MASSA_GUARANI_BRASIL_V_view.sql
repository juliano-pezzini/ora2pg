-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_massa_guarani_brasil_v (nr_seq_lote, nr_linha, ie_titularidade, cd_usuario_plano, nr_contrato, nr_protocolo_ans, ds_branco, ie_agregado, dt_geracao_arquivo, ie_estado_civil, dt_contratacao, nr_cpf, nm_beneficiario, dt_nascimento, ie_sexo, ie_grau_parentesco, cd_cep, ds_endereco, nr_endereco, ds_complemento, ds_bairro, ds_municipio, sg_estado, nr_telefone, nr_telefone_comercial, nr_telefone_celular, nm_mae, dt_rescisao) AS select	a.nr_seq_lote,
	0 nr_linha,
	CASE WHEN a.nr_seq_titular IS NULL THEN '00'  ELSE '01' END  ie_titularidade,
	substr(a.CD_USUARIO_PLANO,2,16) CD_USUARIO_PLANO,
	SUBSTR(c.nr_contrato,1,4) nr_contrato,
	d.nr_protocolo_ans,
	' ' ds_branco,
	CASE WHEN a.nr_seq_titular IS NULL THEN 'N'  ELSE CASE WHEN e.IE_TIPO_PARENTESCO='2' THEN 'S'  ELSE 'N' END  END  ie_agregado,
	LOCALTIMESTAMP dt_geracao_arquivo,
	CASE WHEN a.IE_ESTADO_CIVIL='2' THEN 'C' WHEN a.IE_ESTADO_CIVIL='1' THEN 'S' WHEN a.IE_ESTADO_CIVIL='3' THEN 'D'  ELSE 'O' END  ie_estado_civil,
	a.dt_contratacao,
	a.nr_cpf,
	A.NM_BENEFICIARIO,
	a.dt_nascimento,
	a.ie_sexo,
	CASE WHEN a.nr_seq_titular IS NULL THEN '1'  ELSE CASE WHEN e.CD_PTU='1' THEN '1' WHEN e.CD_PTU='10' THEN '2' WHEN e.CD_PTU='50' THEN '3'  ELSE '5' END  END  IE_GRAU_PARENTESCO,
	A.CD_CEP,
	a.DS_ENDERECO,
	a.NR_ENDERECO,
	a.DS_COMPLEMENTO,
	a.DS_BAIRRO,
	a.DS_MUNICIPIO,
	a.SG_ESTADO,
	trim(both a.nr_telefone) nr_telefone,
	substr((select	elimina_caracteres_especiais(max(x.nr_telefone))
		FROM	compl_pessoa_fisica x
		where	x.cd_pessoa_fisica = b.cd_pessoa_fisica
		and	x.ie_tipo_complemento = 2),1,11) nr_telefone_comercial,
	a.nr_telefone_celular,
	a.nm_mae,
	a.dt_rescisao
FROM pls_plano d, pls_contrato c, pls_segurado b, pls_movimentacao_benef a
LEFT OUTER JOIN grau_parentesco e ON (a.nr_seq_parentesco = e.nr_sequencia)
WHERE a.nr_seq_segurado	= b.nr_sequencia and b.nr_seq_contrato	= c.nr_sequencia and b.nr_seq_plano		= d.nr_sequencia;
