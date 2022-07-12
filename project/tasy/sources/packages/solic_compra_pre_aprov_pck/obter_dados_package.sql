-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION solic_compra_pre_aprov_pck.obter_dados ( ie_mostrar_p text, dt_inicial_p timestamp, dt_final_p timestamp, nm_usuario_p text) RETURNS SETOF T_OBJETO_ROW_DATA AS $body$
DECLARE

 
	current_setting('solic_compra_pre_aprov_pck.t_objeto_row_w')::t_objeto_row			t_objeto_row;
				
	c01 CURSOR FOR 
	SELECT	nr_solic_compra, 
		dt_liberacao, 
		obter_nome_pf(cd_pessoa_solicitante) ds_solicitante, 
		ie_urgente, 
		dt_pre_aprovacao 
	from	solic_compra 
	where  obter_se_pre_aprovacao(nr_solic_compra) = 'S'		 
	order by nr_solic_compra;
	
	c02 CURSOR FOR 
	SELECT	nr_solic_compra, 
		dt_liberacao, 
		obter_nome_pf(cd_pessoa_solicitante) ds_solicitante, 
		ie_urgente, 
		dt_pre_aprovacao 
	from	solic_compra 
	where  nm_usuario_pre_aprov = nm_usuario_p 
	and 	dt_pre_aprovacao between pkg_date_utils.start_of(dt_inicial_p,'DD') AND pkg_date_utils.end_of(dt_final_p,'DAY') 
	order by nr_solic_compra;
	
				 
				 
	
BEGIN 
 
	if (ie_mostrar_p = '0') then 
	 
		for r_c01_w in c01 loop 
			current_setting('solic_compra_pre_aprov_pck.t_objeto_row_w')::t_objeto_row.nr_solic_compra	:= r_c01_w.nr_solic_compra;
			current_setting('solic_compra_pre_aprov_pck.t_objeto_row_w')::t_objeto_row.dt_liberacao	:= r_c01_w.dt_liberacao;
			current_setting('solic_compra_pre_aprov_pck.t_objeto_row_w')::t_objeto_row.ds_solicitante	:= r_c01_w.ds_solicitante;
			current_setting('solic_compra_pre_aprov_pck.t_objeto_row_w')::t_objeto_row.ie_urgente	:= r_c01_w.ie_urgente;
			current_setting('solic_compra_pre_aprov_pck.t_objeto_row_w')::t_objeto_row.dt_pre_aprovacao := r_c01_w.dt_pre_aprovacao;
			 
			RETURN NEXT current_setting('solic_compra_pre_aprov_pck.t_objeto_row_w'::t_objeto_row);
 
		end loop;
	 
	elsif (ie_mostrar_p = '1') then 
	 
		for r_c02_w in c02 loop 
			current_setting('solic_compra_pre_aprov_pck.t_objeto_row_w')::t_objeto_row.nr_solic_compra	:= r_c02_w.nr_solic_compra;
			current_setting('solic_compra_pre_aprov_pck.t_objeto_row_w')::t_objeto_row.dt_liberacao	:= r_c02_w.dt_liberacao;
			current_setting('solic_compra_pre_aprov_pck.t_objeto_row_w')::t_objeto_row.ds_solicitante	:= r_c02_w.ds_solicitante;
			current_setting('solic_compra_pre_aprov_pck.t_objeto_row_w')::t_objeto_row.ie_urgente	:= r_c02_w.ie_urgente;
			current_setting('solic_compra_pre_aprov_pck.t_objeto_row_w')::t_objeto_row.dt_pre_aprovacao := r_c02_w.dt_pre_aprovacao;
			 
			RETURN NEXT current_setting('solic_compra_pre_aprov_pck.t_objeto_row_w'::t_objeto_row);
 
		end loop;
	end if;
 
	return;
 
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION solic_compra_pre_aprov_pck.obter_dados ( ie_mostrar_p text, dt_inicial_p timestamp, dt_final_p timestamp, nm_usuario_p text) FROM PUBLIC;
