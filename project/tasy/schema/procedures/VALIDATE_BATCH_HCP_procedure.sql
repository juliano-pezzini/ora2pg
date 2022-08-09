-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE validate_batch_hcp (nr_seq_batch_p bigint, nm_usuario_p text, nr_atendimento_p bigint) AS $body$
DECLARE

  qt_erro_w    bigint;
  qt_alerta_w  bigint;
  qt_arquivo_w bigint;
  c00 CURSOR FOR
    SELECT a.nr_sequencia 
    FROM   hcp_files a 
    WHERE  a.nr_file_batch_seq = nr_seq_batch_p;
  c00_w        c00%ROWTYPE;
  c01 CURSOR FOR
    SELECT a.nr_sequencia, a.nr_atendimento,
           a.ie_dataset 
    FROM   hcp_dataset_send a 
    WHERE  a.nr_seq_file = c00_w.nr_sequencia;
  c01_w        c01%ROWTYPE;

BEGIN
    UPDATE hcp_batch_sending 
    SET    dt_intial_consistency = clock_timestamp() 
    WHERE  nr_sequencia = nr_seq_batch_p;
              
    OPEN c00;
    LOOP 
        FETCH c00 INTO c00_w;
        EXIT WHEN NOT FOUND; /* apply on c00 */
        OPEN c01;
        LOOP 
            FETCH c01 INTO c01_w;

            EXIT WHEN NOT FOUND; /* apply on c01 */
    CALL Validate_dataset_hcp(c01_w.nr_sequencia, c01_w.ie_dataset, nm_usuario_p, c01_w.nr_atendimento);
    END LOOP;
    CLOSE c01;
    BEGIN 
    SELECT 1 
    INTO STRICT   qt_erro_w 
    FROM   hcp_dataset_send 
    WHERE  nr_seq_file = c00_w.nr_sequencia 
           AND ie_validation_status = 'E'  LIMIT 1;
    EXCEPTION 
    WHEN OTHERS THEN 
      qt_erro_w := 0;
    END;
	
    BEGIN 
    SELECT 1 
    INTO STRICT   qt_alerta_w 
    FROM   hcp_dataset_send 
    WHERE  nr_seq_file = c00_w.nr_sequencia 
           AND ie_validation_status = 'A'  LIMIT 1;
    EXCEPTION 
    WHEN OTHERS THEN 
      qt_alerta_w := 0;
    END;
	
    IF ( qt_erro_w > 0 ) THEN 
    UPDATE hcp_files 
    SET    ie_validity_status = 'E' 
    WHERE  nr_sequencia = c00_w.nr_sequencia;
    ELSIF ( qt_alerta_w > 0 ) THEN 
    UPDATE hcp_files 
    SET    ie_validity_status = 'A' 
    WHERE  nr_sequencia = c00_w.nr_sequencia;
    ELSE 
    UPDATE hcp_files 
    SET    ie_validity_status = 'V', 
         ie_sending_status = 'P' 
    WHERE  nr_sequencia = c00_w.nr_sequencia;
    END IF;
    END LOOP;
      
    CLOSE c00;

    qt_alerta_w := 0;

    qt_erro_w := 0;

    BEGIN 
        SELECT 1 
        INTO STRICT   qt_arquivo_w 
        FROM   hcp_files 
        WHERE  nr_file_batch_seq = nr_seq_batch_p  LIMIT 1;
    EXCEPTION 
        WHEN OTHERS THEN 
          qt_arquivo_w := 0;
    END;

    BEGIN 
        SELECT 1 
        INTO STRICT   qt_erro_w 
        FROM   hcp_files 
        WHERE  nr_file_batch_seq = nr_seq_batch_p 
               AND ie_validity_status = 'E'  LIMIT 1;
    EXCEPTION 
        WHEN OTHERS THEN 
          qt_erro_w := 0;
    END;

    BEGIN 
        SELECT 1 
        INTO STRICT   qt_alerta_w 
        FROM   hcp_files 
        WHERE  nr_file_batch_seq = nr_seq_batch_p 
               AND ie_validity_status = 'A'  LIMIT 1;
    EXCEPTION 
        WHEN OTHERS THEN 
          qt_alerta_w := 0;
    END;

    IF ( qt_erro_w > 0 ) THEN 
      UPDATE hcp_batch_sending 
      SET    ie_validation_status = 'E' 
      WHERE  nr_sequencia = nr_seq_batch_p;
    ELSIF ( qt_alerta_w > 0 ) THEN 
      UPDATE hcp_batch_sending 
      SET    ie_validation_status = 'A' 
      WHERE  nr_sequencia = nr_seq_batch_p;
    ELSIF ( qt_arquivo_w > 0 ) THEN 
      UPDATE hcp_batch_sending 
      SET    ie_validation_status = 'V', 
             ie_sending_status = 'P' 
      WHERE  nr_sequencia = nr_seq_batch_p;
    ELSE 
      UPDATE hcp_batch_sending 
      SET    ie_validation_status = 'P' 
      WHERE  nr_sequencia = nr_seq_batch_p;
    END IF;

    UPDATE hcp_batch_sending 
    SET    dt_final_consistency = clock_timestamp() 
    WHERE  nr_sequencia = nr_seq_batch_p;

   
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE validate_batch_hcp (nr_seq_batch_p bigint, nm_usuario_p text, nr_atendimento_p bigint) FROM PUBLIC;
