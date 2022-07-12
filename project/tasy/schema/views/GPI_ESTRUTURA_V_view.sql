-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW gpi_estrutura_v (nivel, ds_estrutura_apres, nr_sequencia, cd_empresa, dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, ds_estrutura, nr_seq_superior, ie_situacao, cd_classificacao, ie_tipo, cd_estab_exclusivo) AS WITH RECURSIVE cte AS (
select	1 nivel,(lpad(' ', 3* (1-1)) || ds_estrutura) ds_estrutura_apres,a.NR_SEQUENCIA,a.CD_EMPRESA,a.DT_ATUALIZACAO,a.NM_USUARIO,a.DT_ATUALIZACAO_NREC,a.NM_USUARIO_NREC,a.DS_ESTRUTURA,a.NR_SEQ_SUPERIOR,a.IE_SITUACAO,a.CD_CLASSIFICACAO,a.IE_TIPO,a.CD_ESTAB_EXCLUSIVO
FROM	gpi_estrutura a WHERE a.nr_seq_superior is null
  UNION ALL
select	(c.level+1) nivel,(lpad(' ', 3* ((c.level+1)-1)) || ds_estrutura) ds_estrutura_apres,a.NR_SEQUENCIA,a.CD_EMPRESA,a.DT_ATUALIZACAO,a.NM_USUARIO,a.DT_ATUALIZACAO_NREC,a.NM_USUARIO_NREC,a.DS_ESTRUTURA,a.NR_SEQ_SUPERIOR,a.IE_SITUACAO,a.CD_CLASSIFICACAO,a.IE_TIPO,a.CD_ESTAB_EXCLUSIVO
FROM	gpi_estrutura a JOIN cte c ON (c.prior nr_sequencia = a.nr_seq_superior)

) SELECT * FROM cte;


