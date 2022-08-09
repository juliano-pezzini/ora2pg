-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_gerar_aihunif_pror_atend ( nr_aih_p bigint, nr_sequencia_p bigint, nr_atendimento_p bigint, nm_usuario_p text) AS $body$
DECLARE



nr_seq_aih_w	bigint;
ie_medico_autorizador_w	varchar(100);



BEGIN

select	coalesce(max(nr_sequencia),0) + 1
into STRICT	nr_seq_aih_w
from	sus_aih_unif
where	nr_aih 		= nr_aih_p
and	nr_sequencia	= nr_sequencia_p;

ie_medico_autorizador_w		:= coalesce(Obter_Valor_Param_Usuario(1123, 242, obter_perfil_ativo, nm_usuario_p,0),'N');

insert into sus_aih_unif(
		nr_aih, nr_sequencia, dt_atualizacao, nm_usuario, dt_atualizacao_nrec,
		nm_usuario_nrec, cd_estabelecimento, ie_identificacao_aih, nr_proxima_aih, nr_anterior_aih,
		dt_emissao, ie_mudanca_proc, cd_procedimento_solic, ie_origem_proc_solic, cd_procedimento_real,
		ie_origem_proc_real, cd_medico_solic, cd_cid_principal, cd_cid_secundario, cd_cid_causa_compl,
		cd_cid_causa_morte, nr_interno_conta, nr_atendimento, cd_medico_responsavel, cd_modalidade,
		cd_carater_internacao, cd_motivo_cobranca, cd_especialidade_aih, ie_codigo_autorizacao, qt_nascido_vivo,
		qt_nascido_morto, qt_saida_alta, qt_saida_transferencia, qt_saida_obito, nr_gestante_prenatal,
		cd_orgao_emissor_aih, cd_medico_autorizador)
SELECT		nr_aih, nr_seq_aih_w, clock_timestamp(), nm_usuario_p, clock_timestamp(),
		nm_usuario_p, cd_estabelecimento, '05', nr_proxima_aih, nr_anterior_aih,
		dt_emissao, ie_mudanca_proc, cd_procedimento_solic, ie_origem_proc_solic, cd_procedimento_real,
		ie_origem_proc_real, cd_medico_solic, cd_cid_principal, cd_cid_secundario, cd_cid_causa_compl,
		cd_cid_causa_morte, null, nr_atendimento_p, cd_medico_responsavel, cd_modalidade,
		cd_carater_internacao, cd_motivo_cobranca, cd_especialidade_aih, ie_codigo_autorizacao, qt_nascido_vivo,
		qt_nascido_morto, qt_saida_alta, qt_saida_transferencia, qt_saida_obito, nr_gestante_prenatal,
		cd_orgao_emissor_aih, CASE WHEN ie_medico_autorizador_w='S' THEN cd_medico_autorizador  ELSE '' END
from		sus_aih_unif
where		nr_aih			= nr_aih_p
and 		nr_sequencia		= nr_sequencia_p;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_gerar_aihunif_pror_atend ( nr_aih_p bigint, nr_sequencia_p bigint, nr_atendimento_p bigint, nm_usuario_p text) FROM PUBLIC;
