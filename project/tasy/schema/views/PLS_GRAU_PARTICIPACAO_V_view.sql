-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_grau_participacao_v (cd, ds, ordena, cd_estabelecimento) AS select 	nr_sequencia cd,
      	SUBSTR(CD_TISS||' - '||ds_grau_participacao,1,255) ds,
	coalesce(cd_tiss,999) ordena,
       cd_estabelecimento
FROM   pls_grau_participacao
where  ie_situacao = 'A'
order by 3,2;
