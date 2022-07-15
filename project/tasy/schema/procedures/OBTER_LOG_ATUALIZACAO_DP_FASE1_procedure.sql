-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_log_atualizacao_dp_fase1 (NR_SEQ_ATUALIZACAO_P bigint) AS $body$
DECLARE

 v_arqarq utl_file.file_type;
 v_nomarq varchar(30);
 v_linarq varchar(32767) := null;
 n_linarq numeric(20) := 0;


BEGIN
  v_nomarq  := 'imp_expwhebDP.log';
  v_linarq	:= null;

  begin
  v_arqarq := utl_file.fopen('PHILIPS_DATA_PUMP_DIR',v_nomarq,'r',32767);
  exception when others then
    CALL WHEB_MENSAGEM_PCK.EXIBIR_MENSAGEM_ABORT(OBTER_DESC_EXPRESSAO(778032),null,-20200);
    return;
  end;

  IF utl_file.is_open(v_arqarq) THEN
    LOOP
      BEGIN
        utl_file.get_line(V_ARQARQ, v_linarq);
        INSERT INTO LOG_ATUALIZACAO_DP_FASE1(NR_SEQ_ATUALIZACAO, LOG_ARQUIVO, SEQ_LEITURA_ARQUIVO)
        VALUES (NR_SEQ_ATUALIZACAO_P, V_LINARQ, N_LINARQ);
        n_linarq := n_linarq + 1;
        EXCEPTION
        WHEN no_data_found THEN
          EXIT;
      END;
    end loop;
    COMMIT;
    utl_file.fclose(v_arqarq);
  end if;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_log_atualizacao_dp_fase1 (NR_SEQ_ATUALIZACAO_P bigint) FROM PUBLIC;

