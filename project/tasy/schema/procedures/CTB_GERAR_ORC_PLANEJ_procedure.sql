-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_gerar_orc_planej ( nr_seq_planej_p ctb_orc_cenario.nr_sequencia%type, nm_usuario_p text) AS $body$
BEGIN

CALL ctb_gerar_orc_capex(nr_seq_planej_p, nm_usuario_p);

CALL ctb_gerar_orc_resultado(nr_seq_planej_p, nm_usuario_p);

CALL ctb_gerar_planej_orc_rec(nr_seq_planej_p, nm_usuario_p);

CALL ctb_gerar_planej_orc_gpi(nr_seq_planej_p, nm_usuario_p);

update ctb_orc_cenario a
set    a.dt_geracao_orc = clock_timestamp(),
       a.nm_usuario     = nm_usuario_p
where  a.nr_sequencia   = nr_seq_planej_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_gerar_orc_planej ( nr_seq_planej_p ctb_orc_cenario.nr_sequencia%type, nm_usuario_p text) FROM PUBLIC;
