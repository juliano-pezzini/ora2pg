-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_excluir_planej_orc_mat (nr_seq_planej_p ctb_planej_orc_material.nr_seq_planej%type, cd_material_p ctb_planej_orc_material.cd_material%type, cd_conta_contabil_p ctb_planej_orc_material.cd_conta_contabil%type, cd_conta_financ_p ctb_planej_orc_material.cd_conta_financ%type, cd_centro_custo_p ctb_planej_orc_material.cd_centro_custo%type, nr_seq_contrato_p ctb_planej_orc_material.nr_seq_contrato%type, nr_seq_proj_gpi_p ctb_planej_orc_material.nr_seq_proj_gpi%type, cd_cnpj_p ctb_planej_orc_material.cd_cnpj%type, cd_estabelecimento_p ctb_planej_orc_material.cd_estabelecimento%type, nm_usuario_p text) AS $body$
BEGIN

    delete FROM ctb_planej_orc_material a
    where  a.nr_seq_planej = nr_seq_planej_p
    and    a.cd_material = cd_material_p
    and    a.cd_centro_custo = cd_centro_custo_p
    and    a.cd_conta_contabil = cd_conta_contabil_p
    and    a.cd_estabelecimento = cd_estabelecimento_p
    and    coalesce(a.cd_conta_financ, 0) = coalesce(cd_conta_financ_p, 0)
    and    coalesce(a.nr_seq_contrato, 0) = coalesce(nr_seq_contrato_p, 0)
    and    coalesce(a.nr_seq_proj_gpi, 0) = coalesce(nr_seq_proj_gpi_p, 0)
    and    coalesce(a.cd_cnpj, 0) = coalesce(cd_cnpj_p, 0);

    commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_excluir_planej_orc_mat (nr_seq_planej_p ctb_planej_orc_material.nr_seq_planej%type, cd_material_p ctb_planej_orc_material.cd_material%type, cd_conta_contabil_p ctb_planej_orc_material.cd_conta_contabil%type, cd_conta_financ_p ctb_planej_orc_material.cd_conta_financ%type, cd_centro_custo_p ctb_planej_orc_material.cd_centro_custo%type, nr_seq_contrato_p ctb_planej_orc_material.nr_seq_contrato%type, nr_seq_proj_gpi_p ctb_planej_orc_material.nr_seq_proj_gpi%type, cd_cnpj_p ctb_planej_orc_material.cd_cnpj%type, cd_estabelecimento_p ctb_planej_orc_material.cd_estabelecimento%type, nm_usuario_p text) FROM PUBLIC;

