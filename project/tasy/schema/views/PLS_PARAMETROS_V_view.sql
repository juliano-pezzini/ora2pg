-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_parametros_v (nr_sequencia, cd_estabelecimento, ie_sip_contagem_evento, ie_vinc_internacao) AS SELECT 	nr_sequencia, cd_estabelecimento, ie_sip_contagem_evento, ie_vinc_internacao  /* Gerada em tempo de execução pela pls_cria_pls_parametro_v(to_date('01/01/2000')); */
FROM	pls_parametros;

