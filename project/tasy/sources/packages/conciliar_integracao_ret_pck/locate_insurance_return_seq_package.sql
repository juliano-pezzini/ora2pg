-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE conciliar_integracao_ret_pck.locate_insurance_return_seq ( protocolo_p protocolo, nr_seq_convenio_retorno_p INOUT convenio_retorno.nr_sequencia%type ) AS $body$
DECLARE

	
protocolo_w			protocolo := protocolo_p;
nr_seq_convenio_retorno_w	convenio_retorno.nr_sequencia%type;
idx integer;


BEGIN

	if current_setting('conciliar_integracao_ret_pck.ins_ret_loc_w')::ins_ret_loc_tbl.count > 0 then
		
		for idx in current_setting('conciliar_integracao_ret_pck.ins_ret_loc_w')::ins_ret_loc_tbl.first .. current_setting('conciliar_integracao_ret_pck.ins_ret_loc_w')::ins_ret_loc_tbl.last loop
		
			if current_setting('conciliar_integracao_ret_pck.ins_ret_loc_w')::ins_ret_loc_tbl[idx].cd_convenio = protocolo_w.cd_convenio
				and current_setting('conciliar_integracao_ret_pck.ins_ret_loc_w')::ins_ret_loc_tbl[idx].cd_estabelecimento = protocolo_w.cd_estabelecimento
				and current_setting('conciliar_integracao_ret_pck.ins_ret_loc_w')::ins_ret_loc_tbl[idx].dt_pagamento = protocolo_w.dt_pagamento then
				
				nr_seq_convenio_retorno_w := current_setting('conciliar_integracao_ret_pck.ins_ret_loc_w')::ins_ret_loc_tbl[idx].nr_seq_convenio_retorno;

				exit;
				
			end if;
		
		end loop;
		
	end if;
	
	if coalesce(nr_seq_convenio_retorno_w, 0) = 0 then
	
		select 	max(nr_sequencia)
		into STRICT	nr_seq_convenio_retorno_w
		from	convenio_retorno
		where	cd_convenio 		= protocolo_w.cd_convenio
		and	cd_estabelecimento 	= protocolo_w.cd_estabelecimento
		and	trunc(dt_retorno, current_setting('conciliar_integracao_ret_pck.trunc_day_c')::varchar(2))	= trunc(protocolo_w.dt_pagamento, current_setting('conciliar_integracao_ret_pck.trunc_day_c')::varchar(2))
		and	ie_status_retorno	= current_setting('conciliar_integracao_ret_pck.ins_ret_open_status_c')::varchar(1)
		and	nm_usuario_retorno	= current_setting('conciliar_integracao_ret_pck.integration_c')::varchar(11);
	
		if coalesce(nr_seq_convenio_retorno_w, 0) = 0 then
		
			$if dbms_db_version.version >= 11 $then
				nr_seq_convenio_retorno_w := nextval('convenio_retorno_seq');
			$else
				SELECT 	nextval('convenio_retorno_seq')
				INTO STRICT 	nr_seq_convenio_retorno_w 
				;
			$end
			
			conciliar_integracao_ret_pck.insert_convenio_retorno(
				nr_seq_convenio_retorno_w,
				protocolo_w.cd_convenio, 
				protocolo_w.cd_estabelecimento, 
				protocolo_w.dt_pagamento
			);
		
		end if;
		
		idx := current_setting('conciliar_integracao_ret_pck.ins_ret_loc_w')::ins_ret_loc_tbl.count + 1;
		
		current_setting('conciliar_integracao_ret_pck.ins_ret_loc_w')::ins_ret_loc_tbl[idx].cd_convenio 			:= protocolo_w.cd_convenio;
		current_setting('conciliar_integracao_ret_pck.ins_ret_loc_w')::ins_ret_loc_tbl[idx].cd_estabelecimento 		:= protocolo_w.cd_estabelecimento;
		current_setting('conciliar_integracao_ret_pck.ins_ret_loc_w')::ins_ret_loc_tbl[idx].dt_pagamento 		:= protocolo_w.dt_pagamento;
		current_setting('conciliar_integracao_ret_pck.ins_ret_loc_w')::ins_ret_loc_tbl[idx].nr_seq_convenio_retorno 	:= nr_seq_convenio_retorno_w;

	end if;

	nr_seq_convenio_retorno_p := nr_seq_convenio_retorno_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE conciliar_integracao_ret_pck.locate_insurance_return_seq ( protocolo_p protocolo, nr_seq_convenio_retorno_p INOUT convenio_retorno.nr_sequencia%type ) FROM PUBLIC;
