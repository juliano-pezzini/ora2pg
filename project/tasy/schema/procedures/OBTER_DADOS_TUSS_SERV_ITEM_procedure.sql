-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_dados_tuss_serv_item ( cd_proc_tuss_p bigint, dt_referencia_p timestamp, ds_proc_tuss_p INOUT text, nr_seq_tuss_item_p INOUT bigint) AS $body$
DECLARE

				
C01 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.ds_procedimento
	from	tuss_servico_item a,
		tuss_servico b
	where	a.nr_seq_carga_tuss = b.nr_sequencia
	and	(b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '')
	and	ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_referencia_p) between coalesce(dt_inicio_vigencia,dt_referencia_p) and coalesce(dt_fim_vigencia,dt_referencia_p)
	and	cd_procedimento = cd_proc_tuss_p
	order by dt_inicio_vigencia;

c01_w	c01%rowtype;
	

BEGIN

open C01;
loop
fetch C01 into	
	c01_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	nr_seq_tuss_item_p := c01_w.nr_sequencia;
	ds_proc_tuss_p	   := c01_w.ds_procedimento;	
	end;
end loop;
close C01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_dados_tuss_serv_item ( cd_proc_tuss_p bigint, dt_referencia_p timestamp, ds_proc_tuss_p INOUT text, nr_seq_tuss_item_p INOUT bigint) FROM PUBLIC;

