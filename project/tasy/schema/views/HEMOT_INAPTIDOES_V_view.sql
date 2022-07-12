-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW hemot_inaptidoes_v (nr_sequencia, ds_motivo_inaptidao, cd_pessoa_fisica, nr_motivo_desistencia) AS SELECT
        a.nr_sequencia nr_sequencia,
        c.ds_impedimento ds_motivo_inaptidao,
        a.cd_pessoa_fisica cd_pessoa_fisica,
        NULL nr_motivo_desistencia
    FROM
        san_impedimento    c,
        san_questionario   b,
        san_doacao         a
    WHERE
        b.nr_seq_impedimento = c.nr_sequencia
        AND b.nr_seq_doacao = a.nr_sequencia
        AND b.ie_impede_doacao = 'S'

UNION

    SELECT
        x.nr_sequencia nr_sequencia,
        'D' ds_motivo_inaptidao,
		x.cd_pessoa_fisica cd_pessoa_fisica,
        x.nr_motivo_desistencia nr_motivo_desistencia
    FROM
        san_doacao x
    WHERE
        x.nr_motivo_desistencia IS NOT NULL    
	
UNION

    SELECT
        a.nr_seq_doacao nr_sequencia,
        'T' ds_motivo_inaptidao,
        b.cd_pessoa_fisica cd_pessoa_fisica,
        NULL nr_motivo_desistencia
    FROM
        san_inapto_sinal_vital   a,
		san_doacao b
    WHERE
        b.nr_sequencia = a.nr_seq_doacao
    
UNION

    SELECT
        d.nr_seq_doacao nr_sequencia,
        'S' ds_motivo_inaptidao,
        e.cd_pessoa_fisica cd_pessoa_fisica,
        NULL nr_motivo_desistencia
    FROM
        san_impedimento_sorologia   d,
		san_doacao e
    WHERE
        d.nr_seq_doacao = e.nr_sequencia
        AND d.ie_inapto_definitivo = 'S'
        OR ( ie_inapto_definitivo = 'N'
             AND TO_DATE(d.dt_liberacao, 'DD-MM-YYYY') >= TO_DATE(LOCALTIMESTAMP::text, 'DD-MM-YYYY') )
    ORDER BY
        nr_sequencia;

