-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE bsc_enviar_comunic_calc ( nr_seq_calculo_p bigint, cd_estab_exclusivo_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
 
cd_ano_w			bigint;
cd_periodo_w			bigint;
nr_seq_regra_comunic_w		bigint;
ds_titulo_w			varchar(255)	:= ' ';
ds_comunicado_w			text;
ie_tipo_comunic_w			varchar(20);
cd_estab_exclusivo_w		bigint;
				
c01 CURSOR FOR 
SELECT	a.nr_sequencia, 
	a.ie_tipo_comunic, 
	a.ds_titulo, 
	a.ds_comunicado 
from	bsc_regra_comunic_calc a 
where	coalesce(a.cd_estab_exclusivo, cd_estab_exclusivo_w) = cd_estab_exclusivo_w 
and	a.ie_situacao	= 'A';

 
 

BEGIN 
 
cd_estab_exclusivo_w	:= coalesce(cd_estab_exclusivo_p,0);
 
select	max(a.cd_ano), 
	max(a.cd_periodo) 
into STRICT	cd_ano_w, 
	cd_periodo_w 
from	bsc_calculo a 
where	a.nr_sequencia	= nr_seq_calculo_p;
 
 
open C01;
loop 
fetch C01 into	 
	nr_seq_regra_comunic_w, 
	ie_tipo_comunic_w, 
	ds_titulo_w, 
	ds_comunicado_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	 
	 
	if (ie_tipo_comunic_w = 'CP') then 
	 
		CALL bsc_enviar_comunic_calc_geral(	nr_seq_regra_comunic_w, 
						cd_periodo_w, 
						cd_ano_w, 
						nm_usuario_p, 
						cd_estab_exclusivo_p);
	 
	elsif (ie_tipo_comunic_w = 'CI') then 
	 
		CALL bsc_enviar_comunic_calc_indic(	nr_seq_regra_comunic_w, 
						cd_periodo_w, 
						cd_ano_w, 
						nm_usuario_p, 
						cd_estab_exclusivo_p);
		 
	end if;
	 
	end;
end loop;
close C01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE bsc_enviar_comunic_calc ( nr_seq_calculo_p bigint, cd_estab_exclusivo_p bigint, nm_usuario_p text) FROM PUBLIC;

