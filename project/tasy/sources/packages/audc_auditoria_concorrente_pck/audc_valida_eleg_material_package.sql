-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE audc_auditoria_concorrente_pck.audc_valida_eleg_material ( nr_seq_regra_eleg_p audc_regra_elegibilidade.nr_sequencia%type, nr_seq_audc_atend_imp_p audc_atendimento_imp.nr_sequencia%type, ie_gera_regra_p INOUT text ) AS $body$
DECLARE



ie_gera_regra_w		varchar(1) := 'S';
ie_grupo_valido_w 	varchar(1) := 'S';


C01 CURSOR( nr_seq_regra_eleg_pc	audc_regra_elegibilidade.nr_sequencia%type) FOR
	SELECT  nr_seq_material,
	        nr_seq_grupo_material
	from    audc_regra_eleg_material
	where   nr_seq_regra_eleg = nr_seq_regra_eleg_pc
	and     ie_situacao = 'A';

C02 CURSOR( nr_seq_audc_atend_imp_pc	audc_atendimento_imp.nr_sequencia%type ) FOR
	SELECT  nr_seq_material
	from    audc_atend_mat_imp
	where   nr_seq_audc_atend_imp = nr_seq_audc_atend_imp_pc;

BEGIN

for c01_w in C01( nr_seq_regra_eleg_p ) loop
	ie_gera_regra_w := 'N';

	for c02_w in C02( nr_seq_audc_atend_imp_p ) loop
		ie_gera_regra_w := 'N';

		if ( (c01_w.nr_seq_material IS NOT NULL AND c01_w.nr_seq_material::text <> '') and c01_w.nr_seq_material = c02_w.nr_seq_material ) then
			ie_gera_regra_w := 'S';
		end if;

		if (c01_w.nr_seq_grupo_material IS NOT NULL AND c01_w.nr_seq_grupo_material::text <> '') then
			ie_gera_regra_w := 'N';
			ie_grupo_valido_w := pls_se_grupo_preco_material(c01_w.nr_seq_grupo_material, c02_w.nr_seq_material);

			if ( ie_grupo_valido_w = 'S' ) then
				ie_gera_regra_w := 'S';
			end if;
		end if;

		if ( ie_gera_regra_w = 'S' ) then
			exit;
		end if;

	end loop;

	if ( ie_gera_regra_w = 'S' ) then
		exit;
	end if;
end loop;

ie_gera_regra_p := ie_gera_regra_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE audc_auditoria_concorrente_pck.audc_valida_eleg_material ( nr_seq_regra_eleg_p audc_regra_elegibilidade.nr_sequencia%type, nr_seq_audc_atend_imp_p audc_atendimento_imp.nr_sequencia%type, ie_gera_regra_p INOUT text ) FROM PUBLIC;
