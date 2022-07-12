-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION tosho_presc_injection_pck.jpn_prescription_chk (NR_PRESCRICAO_P bigint) RETURNS varchar AS $body$
DECLARE


			DS_RETORNO_W varchar(1);

			
BEGIN

			SELECT coalesce(MAX('S'),'N')
			  INTO STRICT DS_RETORNO_W
			  FROM CPOE_TIPO_PEDIDO
			 WHERE NR_SEQ_SUB_GRP = 'PR'
			   AND NR_SEQUENCIA IN (SELECT NR_SEQ_CPOE_TIPO_PEDIDO
			 						  FROM CPOE_ORDER_UNIT
			 						 WHERE NR_SEQUENCIA IN (SELECT NR_SEQ_CPOE_ORDER_UNIT
			 						 						  FROM CPOE_MATERIAL
			 						 						 WHERE NR_SEQUENCIA IN (SELECT NR_SEQ_MAT_CPOE
			 						 						 						  FROM PRESCR_MATERIAL
			 						 						 						 WHERE NR_PRESCRICAO = NR_PRESCRICAO_P)));

			RETURN DS_RETORNO_W;

			END;			

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION tosho_presc_injection_pck.jpn_prescription_chk (NR_PRESCRICAO_P bigint) FROM PUBLIC;
