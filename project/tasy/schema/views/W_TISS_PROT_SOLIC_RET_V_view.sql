-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW w_tiss_prot_solic_ret_v (nr_seq_retorno, nr_protocolo_1, nr_protocolo_2, nr_protocolo_3, nr_protocolo_4, nr_protocolo_5, nr_protocolo_6, nr_protocolo_7, nr_protocolo_8, nr_protocolo_9, nr_protocolo_10, nr_protocolo_11, nr_protocolo_12, nr_protocolo_13, nr_protocolo_14, nr_protocolo_15, nr_protocolo_16, nr_protocolo_17, nr_protocolo_18, nr_protocolo_19, nr_protocolo_20, nr_protocolo_21, nr_protocolo_22, nr_protocolo_23, nr_protocolo_24, nr_protocolo_25, nr_protocolo_26, nr_protocolo_27, nr_protocolo_28, nr_protocolo_29, nr_protocolo_30) AS SELECT a.nr_seq_retorno,
	OBTER_VALOR_CAMPO_SEPARADOR(Obter_select_concatenado_bv('select nvl(nr_protocolo_tiss,nr_seq_protocolo) NR_SEQ_PROTOCOLO_RET from w_tiss_prot_solic_ret where nr_seq_retorno = :nr_seq_retorno', 
					':nr_seq_retorno='||a.nr_seq_retorno||';',',')||',',1,',') nr_protocolo_1, 
	OBTER_VALOR_CAMPO_SEPARADOR(Obter_select_concatenado_bv('select nvl(nr_protocolo_tiss,nr_seq_protocolo) NR_SEQ_PROTOCOLO_RET from w_tiss_prot_solic_ret where nr_seq_retorno = :nr_seq_retorno', 
					':nr_seq_retorno='||a.nr_seq_retorno||';',',')||',',2,',') nr_protocolo_2, 
	OBTER_VALOR_CAMPO_SEPARADOR(Obter_select_concatenado_bv('select nvl(nr_protocolo_tiss,nr_seq_protocolo) NR_SEQ_PROTOCOLO_RET from w_tiss_prot_solic_ret where nr_seq_retorno = :nr_seq_retorno', 
					':nr_seq_retorno='||a.nr_seq_retorno||';',',')||',',3,',') nr_protocolo_3, 
	OBTER_VALOR_CAMPO_SEPARADOR(Obter_select_concatenado_bv('select nvl(nr_protocolo_tiss,nr_seq_protocolo) NR_SEQ_PROTOCOLO_RET from w_tiss_prot_solic_ret where nr_seq_retorno = :nr_seq_retorno', 
					':nr_seq_retorno='||a.nr_seq_retorno||';',',')||',',4,',') nr_protocolo_4, 
	OBTER_VALOR_CAMPO_SEPARADOR(Obter_select_concatenado_bv('select nvl(nr_protocolo_tiss,nr_seq_protocolo) NR_SEQ_PROTOCOLO_RET from w_tiss_prot_solic_ret where nr_seq_retorno = :nr_seq_retorno', 
					':nr_seq_retorno='||a.nr_seq_retorno||';',',')||',',5,',') nr_protocolo_5, 
	OBTER_VALOR_CAMPO_SEPARADOR(Obter_select_concatenado_bv('select nvl(nr_protocolo_tiss,nr_seq_protocolo) NR_SEQ_PROTOCOLO_RET from w_tiss_prot_solic_ret where nr_seq_retorno = :nr_seq_retorno', 
					':nr_seq_retorno='||a.nr_seq_retorno||';',',')||',',6,',') nr_protocolo_6, 
	OBTER_VALOR_CAMPO_SEPARADOR(Obter_select_concatenado_bv('select nvl(nr_protocolo_tiss,nr_seq_protocolo) NR_SEQ_PROTOCOLO_RET from w_tiss_prot_solic_ret where nr_seq_retorno = :nr_seq_retorno', 
					':nr_seq_retorno='||a.nr_seq_retorno||';',',')||',',7,',') nr_protocolo_7, 
	OBTER_VALOR_CAMPO_SEPARADOR(Obter_select_concatenado_bv('select nvl(nr_protocolo_tiss,nr_seq_protocolo) NR_SEQ_PROTOCOLO_RET from w_tiss_prot_solic_ret where nr_seq_retorno = :nr_seq_retorno', 
					':nr_seq_retorno='||a.nr_seq_retorno||';',',')||',',8,',') nr_protocolo_8, 
	OBTER_VALOR_CAMPO_SEPARADOR(Obter_select_concatenado_bv('select nvl(nr_protocolo_tiss,nr_seq_protocolo) NR_SEQ_PROTOCOLO_RET from w_tiss_prot_solic_ret where nr_seq_retorno = :nr_seq_retorno', 
					':nr_seq_retorno='||a.nr_seq_retorno||';',',')||',',9,',') nr_protocolo_9, 
	OBTER_VALOR_CAMPO_SEPARADOR(Obter_select_concatenado_bv('select nvl(nr_protocolo_tiss,nr_seq_protocolo) NR_SEQ_PROTOCOLO_RET from w_tiss_prot_solic_ret where nr_seq_retorno = :nr_seq_retorno', 
					':nr_seq_retorno='||a.nr_seq_retorno||';',',')||',',10,',') nr_protocolo_10, 
	OBTER_VALOR_CAMPO_SEPARADOR(Obter_select_concatenado_bv('select nvl(nr_protocolo_tiss,nr_seq_protocolo) NR_SEQ_PROTOCOLO_RET from w_tiss_prot_solic_ret where nr_seq_retorno = :nr_seq_retorno', 
					':nr_seq_retorno='||a.nr_seq_retorno||';',',')||',',11,',') nr_protocolo_11, 
	OBTER_VALOR_CAMPO_SEPARADOR(Obter_select_concatenado_bv('select nvl(nr_protocolo_tiss,nr_seq_protocolo) NR_SEQ_PROTOCOLO_RET from w_tiss_prot_solic_ret where nr_seq_retorno = :nr_seq_retorno', 
					':nr_seq_retorno='||a.nr_seq_retorno||';',',')||',',12,',') nr_protocolo_12, 
	OBTER_VALOR_CAMPO_SEPARADOR(Obter_select_concatenado_bv('select nvl(nr_protocolo_tiss,nr_seq_protocolo) NR_SEQ_PROTOCOLO_RET from w_tiss_prot_solic_ret where nr_seq_retorno = :nr_seq_retorno', 
					':nr_seq_retorno='||a.nr_seq_retorno||';',',')||',',13,',') nr_protocolo_13, 
	OBTER_VALOR_CAMPO_SEPARADOR(Obter_select_concatenado_bv('select nvl(nr_protocolo_tiss,nr_seq_protocolo) NR_SEQ_PROTOCOLO_RET from w_tiss_prot_solic_ret where nr_seq_retorno = :nr_seq_retorno', 
					':nr_seq_retorno='||a.nr_seq_retorno||';',',')||',',14,',') nr_protocolo_14, 
	OBTER_VALOR_CAMPO_SEPARADOR(Obter_select_concatenado_bv('select nvl(nr_protocolo_tiss,nr_seq_protocolo) NR_SEQ_PROTOCOLO_RET from w_tiss_prot_solic_ret where nr_seq_retorno = :nr_seq_retorno', 
					':nr_seq_retorno='||a.nr_seq_retorno||';',',')||',',15,',') nr_protocolo_15, 
	OBTER_VALOR_CAMPO_SEPARADOR(Obter_select_concatenado_bv('select nvl(nr_protocolo_tiss,nr_seq_protocolo) NR_SEQ_PROTOCOLO_RET from w_tiss_prot_solic_ret where nr_seq_retorno = :nr_seq_retorno', 
					':nr_seq_retorno='||a.nr_seq_retorno||';',',')||',',16,',') nr_protocolo_16, 
	OBTER_VALOR_CAMPO_SEPARADOR(Obter_select_concatenado_bv('select nvl(nr_protocolo_tiss,nr_seq_protocolo) NR_SEQ_PROTOCOLO_RET from w_tiss_prot_solic_ret where nr_seq_retorno = :nr_seq_retorno', 
					':nr_seq_retorno='||a.nr_seq_retorno||';',',')||',',17,',') nr_protocolo_17, 
	OBTER_VALOR_CAMPO_SEPARADOR(Obter_select_concatenado_bv('select nvl(nr_protocolo_tiss,nr_seq_protocolo) NR_SEQ_PROTOCOLO_RET from w_tiss_prot_solic_ret where nr_seq_retorno = :nr_seq_retorno', 
					':nr_seq_retorno='||a.nr_seq_retorno||';',',')||',',18,',') nr_protocolo_18, 
	OBTER_VALOR_CAMPO_SEPARADOR(Obter_select_concatenado_bv('select nvl(nr_protocolo_tiss,nr_seq_protocolo) NR_SEQ_PROTOCOLO_RET from w_tiss_prot_solic_ret where nr_seq_retorno = :nr_seq_retorno', 
					':nr_seq_retorno='||a.nr_seq_retorno||';',',')||',',19,',') nr_protocolo_19, 
	OBTER_VALOR_CAMPO_SEPARADOR(Obter_select_concatenado_bv('select nvl(nr_protocolo_tiss,nr_seq_protocolo) NR_SEQ_PROTOCOLO_RET from w_tiss_prot_solic_ret where nr_seq_retorno = :nr_seq_retorno', 
					':nr_seq_retorno='||a.nr_seq_retorno||';',',')||',',20,',') nr_protocolo_20, 
	OBTER_VALOR_CAMPO_SEPARADOR(Obter_select_concatenado_bv('select nvl(nr_protocolo_tiss,nr_seq_protocolo) NR_SEQ_PROTOCOLO_RET from w_tiss_prot_solic_ret where nr_seq_retorno = :nr_seq_retorno', 
					':nr_seq_retorno='||a.nr_seq_retorno||';',',')||',',21,',') nr_protocolo_21, 
	OBTER_VALOR_CAMPO_SEPARADOR(Obter_select_concatenado_bv('select nvl(nr_protocolo_tiss,nr_seq_protocolo) NR_SEQ_PROTOCOLO_RET from w_tiss_prot_solic_ret where nr_seq_retorno = :nr_seq_retorno', 
					':nr_seq_retorno='||a.nr_seq_retorno||';',',')||',',22,',') nr_protocolo_22, 
	OBTER_VALOR_CAMPO_SEPARADOR(Obter_select_concatenado_bv('select nvl(nr_protocolo_tiss,nr_seq_protocolo) NR_SEQ_PROTOCOLO_RET from w_tiss_prot_solic_ret where nr_seq_retorno = :nr_seq_retorno', 
					':nr_seq_retorno='||a.nr_seq_retorno||';',',')||',',23,',') nr_protocolo_23,					 
	OBTER_VALOR_CAMPO_SEPARADOR(Obter_select_concatenado_bv('select nvl(nr_protocolo_tiss,nr_seq_protocolo) NR_SEQ_PROTOCOLO_RET from w_tiss_prot_solic_ret where nr_seq_retorno = :nr_seq_retorno', 
					':nr_seq_retorno='||a.nr_seq_retorno||';',',')||',',24,',') nr_protocolo_24, 
	OBTER_VALOR_CAMPO_SEPARADOR(Obter_select_concatenado_bv('select nvl(nr_protocolo_tiss,nr_seq_protocolo) NR_SEQ_PROTOCOLO_RET from w_tiss_prot_solic_ret where nr_seq_retorno = :nr_seq_retorno', 
					':nr_seq_retorno='||a.nr_seq_retorno||';',',')||',',25,',') nr_protocolo_25, 
	OBTER_VALOR_CAMPO_SEPARADOR(Obter_select_concatenado_bv('select nvl(nr_protocolo_tiss,nr_seq_protocolo) NR_SEQ_PROTOCOLO_RET from w_tiss_prot_solic_ret where nr_seq_retorno = :nr_seq_retorno', 
					':nr_seq_retorno='||a.nr_seq_retorno||';',',')||',',26,',') nr_protocolo_26, 
	OBTER_VALOR_CAMPO_SEPARADOR(Obter_select_concatenado_bv('select nvl(nr_protocolo_tiss,nr_seq_protocolo) NR_SEQ_PROTOCOLO_RET from w_tiss_prot_solic_ret where nr_seq_retorno = :nr_seq_retorno', 
					':nr_seq_retorno='||a.nr_seq_retorno||';',',')||',',27,',') nr_protocolo_27, 
	OBTER_VALOR_CAMPO_SEPARADOR(Obter_select_concatenado_bv('select nvl(nr_protocolo_tiss,nr_seq_protocolo) NR_SEQ_PROTOCOLO_RET from w_tiss_prot_solic_ret where nr_seq_retorno = :nr_seq_retorno', 
					':nr_seq_retorno='||a.nr_seq_retorno||';',',')||',',28,',') nr_protocolo_28, 
	OBTER_VALOR_CAMPO_SEPARADOR(Obter_select_concatenado_bv('select nvl(nr_protocolo_tiss,nr_seq_protocolo) NR_SEQ_PROTOCOLO_RET from w_tiss_prot_solic_ret where nr_seq_retorno = :nr_seq_retorno', 
					':nr_seq_retorno='||a.nr_seq_retorno||';',',')||',',29,',') nr_protocolo_29, 
	OBTER_VALOR_CAMPO_SEPARADOR(Obter_select_concatenado_bv('select nvl(nr_protocolo_tiss,nr_seq_protocolo) NR_SEQ_PROTOCOLO_RET from w_tiss_prot_solic_ret where nr_seq_retorno = :nr_seq_retorno', 
					':nr_seq_retorno='||a.nr_seq_retorno||';',',')||',',30,',') nr_protocolo_30 
FROM 	w_tiss_prot_solic_ret a;

