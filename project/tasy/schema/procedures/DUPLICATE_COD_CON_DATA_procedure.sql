-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duplicate_cod_con_data ( nr_sequencia_p COD_CON_DATA.NR_SEQUENCIA%TYPE, dt_inicio_p COD_CON_DATA.DT_INICIO%TYPE, dt_fim_p COD_CON_DATA.DT_FIM%TYPE) AS $body$
DECLARE


TYPE cod_con_medida_type IS TABLE OF COD_CON_MEDIDA%ROWTYPE INDEX BY integer;
cod_con_medida_row        cod_con_medida_type;

dt_atual_s                CONSTANT COD_CON_DATA.DT_ATUALIZACAO%TYPE := clock_timestamp();
cd_estabelecimento_w      COD_CON_DATA.CD_ESTABELECIMENTO%TYPE;
nr_seq_cod_con_data_w     COD_CON_DATA.NR_SEQUENCIA%TYPE;
			
BEGIN

  SELECT MAX(a.CD_ESTABELECIMENTO)
  INTO STRICT   cd_estabelecimento_w
  FROM   COD_CON_DATA a
  WHERE  a.NR_SEQUENCIA = nr_sequencia_p;

  SELECT nextval('cod_con_data_seq')
  INTO STRICT   nr_seq_cod_con_data_w
;

  INSERT INTO COD_CON_DATA(
      nr_sequencia,
      dt_atualizacao,
      nm_usuario,
      dt_atualizacao_nrec,
      nm_usuario_nrec,
      cd_estabelecimento,
      dt_inicio,
      dt_fim
  ) VALUES (
      nr_seq_cod_con_data_w,
      dt_atual_s,
      wheb_usuario_pck.get_nm_usuario,
      dt_atual_s,
      wheb_usuario_pck.get_nm_usuario,
      cd_estabelecimento_w,
      dt_inicio_p,
      dt_fim_p
  );

  SELECT *
  BULK COLLECT INTO STRICT cod_con_medida_row
  FROM COD_CON_MEDIDA a
  WHERE a.NR_SEQ_COD_CON_DATA = nr_sequencia_p
  ORDER BY CAST(a.CD_NUMMED as integer);

  IF (cod_con_medida_row.FIRST IS NOT NULL AND cod_con_medida_row.FIRST::text <> '') THEN
    FOR medida_index_w IN cod_con_medida_row.FIRST..cod_con_medida_row.LAST LOOP
        cod_con_medida_row[medida_index_w].nr_sequencia := obter_nextval_sequence('COD_CON_MEDIDA');
        cod_con_medida_row[medida_index_w].nr_seq_cod_con_data := nr_seq_cod_con_data_w;
    END LOOP;

    FORALL i IN cod_con_medida_row.FIRST..cod_con_medida_row.LAST
    INSERT INTO COD_CON_MEDIDA VALUES cod_con_medida_row(i);
  END IF;

COMMIT;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duplicate_cod_con_data ( nr_sequencia_p COD_CON_DATA.NR_SEQUENCIA%TYPE, dt_inicio_p COD_CON_DATA.DT_INICIO%TYPE, dt_fim_p COD_CON_DATA.DT_FIM%TYPE) FROM PUBLIC;
