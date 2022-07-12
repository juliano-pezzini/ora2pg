-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW get_all_birth_statistics_v (nm_establishmento, qt_feto, qt_nasc_vivos, qt_nasc_mortos, ie_sexo, total_transferred, dt_atualizacao) AS SELECT
        OBTER_NOME_ESTABELECIMENTO(A.CD_ESTABELECIMENTO) NM_ESTABLISHMENTO,
        P.QT_FETO,
        P.QT_NASC_VIVOS,
        P.QT_NASC_MORTOS,
        N.IE_SEXO,
        N.DS_TRANSFERRED + P.IE_TRANSFERRED_TO TOTAL_TRANSFERRED,
        N.DT_ATUALIZACAO																					
    FROM
        NASCIMENTO             N
        INNER JOIN PARTO                  P ON N.NR_ATENDIMENTO = P.NR_ATENDIMENTO
        INNER JOIN ATENDIMENTO_PACIENTE   A ON A.NR_ATENDIMENTO = P.NR_ATENDIMENTO
                                             AND A.NR_ATENDIMENTO = N.NR_ATENDIMENTO;

