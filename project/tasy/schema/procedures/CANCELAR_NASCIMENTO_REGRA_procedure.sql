-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cancelar_nascimento_regra ( nr_atend_rn_p bigint, nm_usuario_p text) AS $body$
DECLARE
										
cd_estabelecimento_w	bigint;
ie_canc_atend_rn_w	varchar(10);										
										 

BEGIN 
cd_estabelecimento_w	:= wheb_usuario_pck.get_cd_estabelecimento;	
  
select	max(ie_canc_atend_rn) 
into STRICT	ie_canc_atend_rn_w 
from	parametro_medico 
where	cd_estabelecimento	= cd_estabelecimento_w;
 
if (ie_canc_atend_rn_w	= 'S') and (nr_atend_rn_p IS NOT NULL AND nr_atend_rn_p::text <> '') then 
	 
	CALL cancelar_atend_rn(nr_atend_rn_p,nm_usuario_p);
		 
end if;
	  
end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cancelar_nascimento_regra ( nr_atend_rn_p bigint, nm_usuario_p text) FROM PUBLIC;
