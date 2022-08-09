-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_desfecho_aval_pa ( nr_atendimento_p bigint, ds_erro_p INOUT text, nm_usuario_p text) AS $body$
DECLARE

 
ds_erro_w	varchar(2000) := null;
ds_erro2_w	varchar(2000) := null;
item_posicionar_w	varchar(1);

BEGIN
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then 
	begin 
	SELECT * FROM consistir_desfecho_pa(nr_atendimento_p, nm_usuario_p, ds_erro_w, item_posicionar_w, ds_erro2_w) INTO STRICT ds_erro_w, item_posicionar_w, ds_erro2_w;
	 
	if (coalesce(ds_erro_w::text, '') = '') then 
		begin 
		select	obter_se_avaliacao_desfecho(nr_atendimento_p) 
		into STRICT	ds_erro_w 
		;
		end;
	end if;	
	end;
end if;
ds_erro_p := ds_erro_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_desfecho_aval_pa ( nr_atendimento_p bigint, ds_erro_p INOUT text, nm_usuario_p text) FROM PUBLIC;
