-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_cpoe_reg_ordem_subgru ( nr_seq_ordem_grupo_p cpoe_regra_ordem_subgrupo.nr_seq_ordem_grupo%type, ie_subgrupo_p cpoe_regra_ordem_subgrupo.ie_subgrupo%type, nm_usuario_p cpoe_regra_ordem_subgrupo.nm_usuario%type) AS $body$
DECLARE


nr_sequencia_w		cpoe_regra_ordem_subgrupo.nr_sequencia%type;

BEGIN

if (nr_seq_ordem_grupo_p IS NOT NULL AND nr_seq_ordem_grupo_p::text <> '') and (ie_subgrupo_p IS NOT NULL AND ie_subgrupo_p::text <> '') then

	select	nextval('cpoe_regra_ordem_subgrupo_seq')
	into STRICT	nr_sequencia_w
	;

	insert into	cpoe_regra_ordem_subgrupo(
					nr_sequencia,
					ie_subgrupo,
					nr_seq_apresentacao,
					nr_seq_ordem_grupo,
					dt_atualizacao,
					dt_atualizacao_nrec,
					nm_usuario,
					nm_usuario_nrec)
			values (
					nr_sequencia_w,
					ie_subgrupo_p,
					1,
					nr_seq_ordem_grupo_p,
					clock_timestamp(),
					clock_timestamp(),
					nm_usuario_p,
					nm_usuario_p);

	commit;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_cpoe_reg_ordem_subgru ( nr_seq_ordem_grupo_p cpoe_regra_ordem_subgrupo.nr_seq_ordem_grupo%type, ie_subgrupo_p cpoe_regra_ordem_subgrupo.ie_subgrupo%type, nm_usuario_p cpoe_regra_ordem_subgrupo.nm_usuario%type) FROM PUBLIC;
