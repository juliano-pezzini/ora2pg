-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE link_pamec_insert_hist ( nr_seq_nao_conformidade_p QUA_NAO_CONFORMIDADE.NR_SEQUENCIA%TYPE, nr_seq_pamec_p QUA_NAO_CONFORMIDADE.NR_SEQ_QUA_PAMEC%TYPE ) AS $body$
DECLARE


dt_atualizacao_w    CONSTANT QUA_NAO_CONFORMIDADE.DT_ATUALIZACAO%TYPE := clock_timestamp();
nm_usuario_w        CONSTANT QUA_NAO_CONFORMIDADE.NM_USUARIO%TYPE     := wheb_usuario_pck.get_nm_usuario;
ie_origem_w         CONSTANT QUA_NAO_CONFORM_HIST.IE_ORIGEM%TYPE      := 'S';
ds_expressao_w      CONSTANT QUA_NAO_CONFORM_HIST.DS_HISTORICO%TYPE   := obter_desc_expressao(1077853);


BEGIN

UPDATE  QUA_NAO_CONFORMIDADE a
SET     a.NR_SEQ_QUA_PAMEC = nr_seq_pamec_p,
        a.NM_USUARIO       = nm_usuario_w,
        a.DT_ATUALIZACAO   = dt_atualizacao_w
WHERE   a.NR_SEQUENCIA     = nr_seq_nao_conformidade_p;

INSERT INTO QUA_NAO_CONFORM_HIST(
    nr_sequencia,
    nr_seq_nao_conform,
    dt_atualizacao,
    dt_atualizacao_nrec,
    dt_historico,
    nm_usuario,
    nm_usuario_nrec,
    cd_pessoa_fisica,
    ie_origem,
    ds_historico
) VALUES (
    nextval('qua_nao_conform_hist_seq'),
    nr_seq_nao_conformidade_p,
    dt_atualizacao_w,
    dt_atualizacao_w,
    dt_atualizacao_w,
    nm_usuario_w,
    nm_usuario_w,
    obter_pf_usuario(nm_usuario_w,'C'),
    ie_origem_w,
    ds_expressao_w
);

COMMIT;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE link_pamec_insert_hist ( nr_seq_nao_conformidade_p QUA_NAO_CONFORMIDADE.NR_SEQUENCIA%TYPE, nr_seq_pamec_p QUA_NAO_CONFORMIDADE.NR_SEQ_QUA_PAMEC%TYPE ) FROM PUBLIC;

