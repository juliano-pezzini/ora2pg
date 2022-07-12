-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW tws_pls_consulta_carencia_v (nr_seq_classif_carencia, ds_classificacao, ds_carencia, nr_seq_segurado, nr_seq_contrato, nr_seq_plano_contrato, nr_seq_plano, nr_seq_carencia) AS SELECT 	to_char(coalesce(b.nr_seq_classif_carencia,0)) nr_seq_classif_carencia,
	c.ds_classificacao ds_classificacao,
	b.ds_carencia,
	a.nr_seq_segurado,
	a.nr_seq_contrato,
	a.nr_seq_plano_contrato,
	a.nr_seq_plano,
	a.nr_sequencia nr_seq_carencia
FROM	pls_carencia a,
	pls_tipo_carencia b,
	pls_classificacao_carencia c
WHERE 	a.nr_seq_tipo_carencia		= b.nr_sequencia       
AND	b.nr_seq_classif_carencia	= c.nr_sequencia       
AND	a.ie_cpt	= 'N'  

UNION ALL
          
SELECT	'0' nr_seq_classif_carencia,
	'Classificação não informada' ds_classificacao,
	b.ds_carencia,
	a.nr_seq_segurado,
	a.nr_seq_contrato,
	a.nr_seq_plano_contrato,
	a.nr_seq_plano,
	a.nr_sequencia nr_seq_carencia
FROM	pls_carencia a,
	pls_tipo_carencia b        
WHERE	a.nr_seq_tipo_carencia	= b.nr_sequencia       
AND	b.nr_seq_classif_carencia is null        
AND	a.ie_cpt = 'N'  

UNION ALL
          
SELECT	'00' nr_seq_classif_carencia,			
	'Grupo de carências' ds_classificacao,
	b.ds_grupo,
	a.nr_seq_segurado,
	a.nr_seq_contrato,
	a.nr_seq_plano_contrato,
	a.nr_seq_plano,
	a.nr_sequencia nr_seq_carencia
FROM	pls_carencia a,
	pls_grupo_carencia b        
WHERE	a.nr_seq_grupo_carencia	= b.nr_sequencia;

