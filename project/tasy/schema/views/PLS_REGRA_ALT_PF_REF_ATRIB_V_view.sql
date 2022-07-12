-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_regra_alt_pf_ref_atrib_v (cd, ds) AS select	nm_atributo cd,
	nm_atributo ds
FROM	tabela_atributo
where	nm_tabela = 'COMPL_PESSOA_FISICA'
and	nm_atributo in ('CD_MUNICIPIO_IBGE', 'CD_CEP', 'DS_COMPLEMENTO', 'DS_BAIRRO',
			'SG_ESTADO', 'NR_RAMAL', 'CD_EMPRESA_REFER', 'CD_PROFISSAO',
			'DS_ENDERECO', 'NR_TELEFONE', 'DS_EMAIL', 'NM_CONTATO',
			'DS_COMPL_END', 'DS_OBSERVACAO', 'NR_SEQ_PARENTESCO', 'DS_FONE_ADIC',
			'DS_FAX', 'NR_SEQ_PAIS', 'DS_FONETICA', 'NR_DDD_TELEFONE',
			'NR_DDI_TELEFONE', 'NR_DDI_FAX', 'NR_DDD_FAX', 'CD_TIPO_LOGRADOURO',
			'DS_WEBSITE', 'NM_CONTATO_PESQUISA', 'IE_NF_CORREIO', 'CD_ZONA_PROCEDENCIA',
			'IE_MALA_DIRETA', 'IE_FATOR_RH', 'IE_TIPO_SANGUE', 'NR_SEQ_LOCAL_ATEND_MED',
			'IE_OBRIGA_EMAIL', 'NR_SEQ_IDENT_CNES', 'DS_MUNICIPIO', 'NR_DDD_FONE_ADIC',
			'NR_DDI_FONE_ADIC', 'NR_ENDERECO')
order by
	nm_atributo;

