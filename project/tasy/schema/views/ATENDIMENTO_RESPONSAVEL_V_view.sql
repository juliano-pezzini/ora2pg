-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW atendimento_responsavel_v (nr_atendimento, cd_pessoa_responsavel, nm_responsavel, ds_end_responsavel, nr_fone_responsavel, nr_cpf_responsavel) AS SELECT A.NR_ATENDIMENTO,
	A.CD_PESSOA_RESPONSAVEL, 
	SUBSTR(OBTER_DADOS_RESPONSAVEL(A.NR_ATENDIMENTO, 'N'),1,60) NM_RESPONSAVEL, 
	SUBSTR(OBTER_DADOS_RESPONSAVEL(A.NR_ATENDIMENTO, 'EC'),1,255) DS_END_RESPONSAVEL, 
	SUBSTR(OBTER_DADOS_RESPONSAVEL(A.NR_ATENDIMENTO, 'T'),1,20) NR_FONE_RESPONSAVEL, 
	SUBSTR(OBTER_DADOS_RESPONSAVEL(A.NR_ATENDIMENTO, 'C'),1,12) NR_CPF_RESPONSAVEL 
FROM ATENDIMENTO_PACIENTE A;

