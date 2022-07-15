-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_gerar_planej_orc_valor ( nr_seq_planej_p ctb_planej_orc_valor.nr_seq_planej%type, cd_conta_contabil_p ctb_planej_orc_valor.cd_conta_contabil%type, cd_conta_financ_p ctb_planej_orc_valor.cd_conta_financ%type, cd_centro_custo_p ctb_planej_orc_valor.cd_centro_custo%type, nr_seq_contrato_p ctb_planej_orc_valor.nr_seq_contrato%type, nr_seq_proj_gpi_p ctb_planej_orc_valor.nr_seq_proj_gpi%type, cd_cnpj_p ctb_planej_orc_valor.cd_cnpj%type, cd_estabelecimento_p ctb_planej_orc_valor.cd_estabelecimento%type, nm_usuario_p text) AS $body$
BEGIN


insert into ctb_planej_orc_valor(
       nr_sequencia,
       nr_seq_planej,
       nr_seq_mes_ref,
       cd_estabelecimento,
       cd_centro_custo,
       cd_conta_contabil,
       cd_conta_financ,
       nr_seq_contrato,
       nr_seq_proj_gpi,
       cd_cnpj,
       dt_atualizacao,
       nm_usuario,
       dt_atualizacao_nrec,
       nm_usuario_nrec,
       VL_PLANEJ)
SELECT nextval('ctb_planej_orc_valor_seq'),
       nr_seq_planej_p,
       nr_seq_mes_ref,
       cd_estabelecimento_p,
       cd_centro_custo_p,
       cd_conta_contabil_p,
       cd_conta_financ_p,
       nr_seq_contrato_p,
       nr_seq_proj_gpi_p,
       cd_cnpj_p,
       clock_timestamp(),
       nm_usuario_p,
       clock_timestamp(),
       nm_usuario_p,
       0
from   ctb_mes_planejamento_v
where  nr_sequencia = nr_seq_planej_p;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_gerar_planej_orc_valor ( nr_seq_planej_p ctb_planej_orc_valor.nr_seq_planej%type, cd_conta_contabil_p ctb_planej_orc_valor.cd_conta_contabil%type, cd_conta_financ_p ctb_planej_orc_valor.cd_conta_financ%type, cd_centro_custo_p ctb_planej_orc_valor.cd_centro_custo%type, nr_seq_contrato_p ctb_planej_orc_valor.nr_seq_contrato%type, nr_seq_proj_gpi_p ctb_planej_orc_valor.nr_seq_proj_gpi%type, cd_cnpj_p ctb_planej_orc_valor.cd_cnpj%type, cd_estabelecimento_p ctb_planej_orc_valor.cd_estabelecimento%type, nm_usuario_p text) FROM PUBLIC;

