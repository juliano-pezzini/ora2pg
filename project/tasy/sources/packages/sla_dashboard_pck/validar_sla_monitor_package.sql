-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE sla_dashboard_pck.validar_sla_monitor () AS $body$
DECLARE



nr_seq_ordem_servico_w	            bigint;
nm_usuario_w		    	    varchar(255);
cd_estabelecimento_w		    bigint;


C01 CURSOR FOR
SELECT	a.nr_seq_ordem_servico,
	a.nm_usuario,
	a.cd_estabelecimento
from	man_sla_monitor a,
	man_ordem_servico b
where  a.nr_seq_ordem_servico = b.nr_sequencia
and  b.IE_STATUS_ORDEM <> '3';


BEGIN
open C01;
loop
fetch C01 into	
	nr_seq_ordem_servico_w,
	nm_usuario_w,
	cd_estabelecimento_w;		
EXIT WHEN NOT FOUND; /* apply on C01 */
	CALL sla_dashboard_pck.man_obter_tempo_sol(nr_seq_ordem_servico_w, nm_usuario_w, cd_estabelecimento_w);
	CALL sla_dashboard_pck.man_obter_tempo_resp(nr_seq_ordem_servico_w, nm_usuario_w, cd_estabelecimento_w);
End loop;
close C01;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sla_dashboard_pck.validar_sla_monitor () FROM PUBLIC;