-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE wheb_exportar_hl7_pck.exportar ( nr_seq_mensagem_p bigint, nr_seq_log_p bigint, ds_parametros_p text) AS $body$
DECLARE

	nr_sequencia_w  bigint;
	ds_valor_p varchar(32000);
	ar_vazio_w	myArray;
	/*Contem os parametros do SQL*/

	ar_result_todos_sql_w myArray;
  ie_long_w varchar(5);

	c01 CURSOR FOR
		SELECT	NR_SEQUENCIA
		FROM 	hl7_segmento a
		WHERE 	nr_seq_mensagem = nr_seq_mensagem_p
		AND	ie_tipo in ('GRU','SEG')
		AND  NOT EXISTS (	
			SELECT	1
			FROM    hl7_atributo z,
				hl7_segmento x
			WHERE   x.nr_sequencia 		= z.nr_seq_segmento
			AND     x.nr_seq_mensagem 	= a.nr_seq_mensagem
			AND     z.nr_seq_atrib_segm 	= a.nr_sequencia)
		ORDER BY a.nr_seq_apresentacao;
	
BEGIN
    SELECT UPPER(coalesce(IE_LONG,'N'))
    INTO STRICT ie_long_w
    FROM HL7_MENSAGEM
    WHERE NR_SEQUENCIA = nr_seq_mensagem_p;
    
    if ( ie_long_w = 'S' )then
      CALL wheb_exportar_HL7_long_pck.exportar(nr_seq_mensagem_p, nr_seq_log_p, ds_parametros_p);
    else
      if (current_setting('wheb_exportar_hl7_pck.ie_limpar_param_w')::boolean ) then
        CALL CALL wheb_exportar_hl7_pck.limpa_parametros();
      end if;

      SELECT coalesce(MAX(DS_REGRA),' ')
      INTO STRICT current_setting('wheb_exportar_hl7_pck.ds_regra_w')::varchar(255)
      FROM CLIENTE_INTEGRACAO a,
            LOG_INTEGRACAO b
      WHERE b.NR_SEQ_INFORMACAO = a.NR_SEQ_INF_INTEGRACAO
      AND b.NR_SEQUENCIA = nr_seq_log_p;	
	
      PERFORM set_config('wheb_exportar_hl7_pck.nr_seq_log_w', nr_seq_log_p, false);
      PERFORM set_config('wheb_exportar_hl7_pck.nr_seq_mensagem_w', nr_seq_mensagem_p, false);
      PERFORM set_config('wheb_exportar_hl7_pck.ds_separador_w', '', false);
      PERFORM set_config('wheb_exportar_hl7_pck.ds_encoding_w', '', false);
      PERFORM set_config('wheb_exportar_hl7_pck.ds_hl7_w', '', false);
      PERFORM set_config('wheb_exportar_hl7_pck.ar_result_todos_sql_p', ar_vazio_w, false);
		
      PERFORM set_config('wheb_exportar_hl7_pck.ds_sep_bv_w', obter_separador_bv, false);
		
      /*Armazena em um Array os parametros do projeto*/

      CALL CALL wheb_exportar_hl7_pck.armazena_parametros(ds_parametros_p);

      OPEN c01;
      LOOP
      FETCH c01 INTO
        nr_sequencia_w;
      EXIT WHEN NOT FOUND; /* apply on c01 */
        ds_valor_p := wheb_exportar_hl7_pck.gerar_hl7_segmento(nr_sequencia_w, ar_vazio_w, null, ds_valor_p);
      END LOOP;

      CALL CALL wheb_exportar_hl7_pck.salvarhl7banco();
      CLOSE c01;
    end if;
	end;


$body$
LANGUAGE PLPGSQL
;
-- REVOKE ALL ON PROCEDURE wheb_exportar_hl7_pck.exportar ( nr_seq_mensagem_p bigint, nr_seq_log_p bigint, ds_parametros_p text) FROM PUBLIC;
