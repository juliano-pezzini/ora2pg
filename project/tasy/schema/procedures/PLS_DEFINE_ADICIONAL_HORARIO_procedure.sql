-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_define_adicional_horario ( cd_estabelecimento_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_prestador_p bigint, dt_inicio_proc_p timestamp, dt_fim_proc_p timestamp, nm_usuario_p text, ie_carater_internacao_p text, dt_vigencia_p timestamp, ie_tipo_tabela_p text, ie_criterio_horario_p text, nr_seq_conta_p bigint, cd_edicao_amb_p bigint, nr_seq_conta_proc_p bigint, nr_seq_regra_p INOUT bigint, tx_medico_p INOUT bigint, tx_anestesista_p INOUT bigint, tx_auxiliares_p INOUT bigint, tx_custo_operacional_p INOUT bigint, tx_materiais_p INOUT bigint, tx_procedimento_p INOUT bigint) AS $body$
DECLARE


--Esta rotina foi descontinuada,  dando lugar a
--pls_cta_valorizacao_pck.pls_gerencia_regra_horario
BEGIN
null;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_define_adicional_horario ( cd_estabelecimento_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_prestador_p bigint, dt_inicio_proc_p timestamp, dt_fim_proc_p timestamp, nm_usuario_p text, ie_carater_internacao_p text, dt_vigencia_p timestamp, ie_tipo_tabela_p text, ie_criterio_horario_p text, nr_seq_conta_p bigint, cd_edicao_amb_p bigint, nr_seq_conta_proc_p bigint, nr_seq_regra_p INOUT bigint, tx_medico_p INOUT bigint, tx_anestesista_p INOUT bigint, tx_auxiliares_p INOUT bigint, tx_custo_operacional_p INOUT bigint, tx_materiais_p INOUT bigint, tx_procedimento_p INOUT bigint) FROM PUBLIC;

