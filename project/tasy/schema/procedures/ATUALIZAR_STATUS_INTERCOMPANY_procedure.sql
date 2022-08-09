-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_status_intercompany ( nr_seq_lote_protocolo_p bigint, ie_acao_p text, nm_usuario_p text) AS $body$
DECLARE

 
-- 	Atenção apenas documentação incial		 
--	L - Liberar Faturamento Intercompany			 
--	D - Desliberar Faturamento Intercompany	 
 
nr_seq_protocolo_w 	protocolo_convenio.nr_seq_protocolo%type;

c01 CURSOR FOR 
	SELECT 	nr_seq_protocolo 
	from 	protocolo_convenio 
	where 	nr_seq_lote_protocolo = nr_seq_lote_protocolo_p;
	

BEGIN 
 
if (ie_acao_p = 'L') then 
	open c01;
	loop 
	fetch c01 into nr_seq_protocolo_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		update w_tmp_carga_hosp_intern		set dt_lib_intercompany = clock_timestamp(), ie_lib_intercompany = 'S' where nr_seq_protocolo = nr_seq_protocolo_w and coalesce(ie_lib_intercompany,'N') = 'N';
		update w_tmp_carga_hosp_int_item	set dt_lib_intercompany = clock_timestamp(), ie_lib_intercompany = 'S' where nr_seq_protocolo = nr_seq_protocolo_w and coalesce(ie_lib_intercompany,'N') = 'N';
		update w_tmp_carga_hosp_guia		set dt_lib_intercompany = clock_timestamp(), ie_lib_intercompany = 'S' where nr_seq_protocolo = nr_seq_protocolo_w and coalesce(ie_lib_intercompany,'N') = 'N';
		update w_tmp_carga_hosp_guia_item	set dt_lib_intercompany = clock_timestamp(), ie_lib_intercompany = 'S' where nr_seq_protocolo = nr_seq_protocolo_w and coalesce(ie_lib_intercompany,'N') = 'N';
		update w_tmp_atend_terc_proprio	 	set dt_lib_intercompany = clock_timestamp(), ie_lib_intercompany = 'S' where nr_seq_protocolo = nr_seq_protocolo_w and coalesce(ie_lib_intercompany,'N') = 'N';
		update w_tmp_atend_terc_prop_item	set dt_lib_intercompany = clock_timestamp(), ie_lib_intercompany = 'S' where nr_seq_protocolo = nr_seq_protocolo_w and coalesce(ie_lib_intercompany,'N') = 'N';
		update w_tmp_tcmo_cga_mtl_mdc_omm	set dt_lib_intercompany = clock_timestamp(), ie_lib_intercompany = 'S' where nr_seq_protocolo = nr_seq_protocolo_w and coalesce(ie_lib_intercompany,'N') = 'N';
	end loop;
	close c01;	
elsif (ie_acao_p = 'D') then 
	open c01;
	loop 
	fetch c01 into nr_seq_protocolo_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		update w_tmp_carga_hosp_intern		set dt_lib_intercompany  = NULL, ie_lib_intercompany = 'N' where nr_seq_protocolo = nr_seq_protocolo_w and coalesce(ie_lib_intercompany,'N') = 'S';
		update w_tmp_carga_hosp_int_item	set dt_lib_intercompany  = NULL, ie_lib_intercompany = 'N' where nr_seq_protocolo = nr_seq_protocolo_w and coalesce(ie_lib_intercompany,'N') = 'S';
		update w_tmp_carga_hosp_guia		set dt_lib_intercompany  = NULL, ie_lib_intercompany = 'N' where nr_seq_protocolo = nr_seq_protocolo_w and coalesce(ie_lib_intercompany,'N') = 'S';
		update w_tmp_carga_hosp_guia_item	set dt_lib_intercompany  = NULL, ie_lib_intercompany = 'N' where nr_seq_protocolo = nr_seq_protocolo_w and coalesce(ie_lib_intercompany,'N') = 'S';
		update w_tmp_atend_terc_proprio		set dt_lib_intercompany  = NULL, ie_lib_intercompany = 'N' where nr_seq_protocolo = nr_seq_protocolo_w and coalesce(ie_lib_intercompany,'N') = 'S';
		update w_tmp_atend_terc_prop_item	set dt_lib_intercompany  = NULL, ie_lib_intercompany = 'N' where nr_seq_protocolo = nr_seq_protocolo_w and coalesce(ie_lib_intercompany,'N') = 'S';
		update w_tmp_tcmo_cga_mtl_mdc_omm	set dt_lib_intercompany  = NULL, ie_lib_intercompany = 'N' where nr_seq_protocolo = nr_seq_protocolo_w and coalesce(ie_lib_intercompany,'N') = 'S';
	end loop;
	close c01;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_status_intercompany ( nr_seq_lote_protocolo_p bigint, ie_acao_p text, nm_usuario_p text) FROM PUBLIC;
