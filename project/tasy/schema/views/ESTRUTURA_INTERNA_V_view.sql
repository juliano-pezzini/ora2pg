-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW estrutura_interna_v (nr_seq_grupo, ds_grupo, nr_seq_especialidade, ds_especialidade, nr_seq_area, ds_area) AS select  a.nr_sequencia nr_seq_grupo,
        a.ds_grupo,
        b.nr_sequencia nr_seq_especialidade,
        b.ds_especialidade,
        c.nr_sequencia nr_seq_area,
        c.ds_area
FROM   	grupo_proc_interno a,
        especialidade_proc_interno b,
        area_proc_interno c
where 	c.nr_sequencia = b.nr_seq_area
and    	b.nr_sequencia = a.nr_seq_especialidade;

