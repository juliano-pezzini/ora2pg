-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_congenere_v (nr_sequencia, cd_cooperativa, ds_razao_social) AS select nr_sequencia,
	cd_cooperativa, 
	obter_nome_pf_pj(null, cd_cgc) ds_razao_social 
 FROM 	pls_congenere a 
 where	ie_situacao = 'A';

