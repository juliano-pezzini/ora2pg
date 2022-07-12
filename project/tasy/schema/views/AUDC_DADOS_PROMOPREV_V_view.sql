-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW audc_dados_promoprev_v (nm_programa, dt_inclusao, dt_exclusao, cd_pessoa_fisica, nr_sequencia) AS select  c.nm_programa,
        b.dt_inclusao,
        b.dt_exclusao,
	a.cd_pessoa_fisica,
	b.nr_sequencia
FROM    mprev_participante a,
   	mprev_programa_partic b,
        mprev_programa c
where   b.nr_seq_participante = a.nr_sequencia
and     b.nr_seq_programa = c.nr_sequencia
and    	b.dt_inclusao <= LOCALTIMESTAMP;

