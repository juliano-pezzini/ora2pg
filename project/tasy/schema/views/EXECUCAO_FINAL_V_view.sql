-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW execucao_final_v (nr_consistencia, nr_sequencia, ds_consistencia) AS select	5 nr_consistencia,
	a.nr_sequencia,
	substr(obter_valor_dominio(4958,5),1,255)ds_consistencia
FROM	proj_projeto a
where	exists (    select 	1
		    from	proj_ata x
		    where	a.nr_sequencia 	    	= x.nr_seq_projeto
		    and		x.nr_seq_classif	= 4);

