-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW tws_pessoa_juridica_v (cd_cgc, dt_atualizacao, ds_razao_social, nm_fantasia, cd_pf_resp_tecnico, cd_municipio_ibge, cd_cep, ds_endereco, ds_bairro, ds_complemento, ds_municipio, sg_estado, nr_ddi_telefone, nr_ddd_telefone, nr_seq_ident_cnes, nr_telefone, nr_ddi_fax, nr_ddd_fax, nr_fax, ie_situacao, cd_operadora_empresa, cd_cnes) AS select 	cd_cgc,
	dt_atualizacao,
	ds_razao_social,
	nm_fantasia,
	cd_pf_resp_tecnico,
	cd_municipio_ibge,
	cd_cep,
	ds_endereco,
	ds_bairro,
	ds_complemento,
	ds_municipio,
	sg_estado,
	nr_ddi_telefone,
	nr_ddd_telefone,
	nr_seq_ident_cnes,
	nr_telefone,
	nr_ddi_fax,
	nr_ddd_fax,
	nr_fax,
	ie_situacao,
	cd_operadora_empresa,
	cd_cnes
FROM 	pessoa_juridica;

