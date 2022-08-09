-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copiar_proc_interno_conv ( cd_convenio_origem_p bigint, cd_convenio_destino_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
C01 CURSOR FOR 
	SELECT	a.* 
	from	proc_interno_conv a, 
		proc_interno b 
	where	a.nr_seq_proc_interno = b.nr_sequencia 
	and	a.cd_convenio = cd_convenio_origem_p 
	order by 1;
	
c01_w c01%rowtype;
			

BEGIN 
 
if (cd_convenio_origem_p IS NOT NULL AND cd_convenio_origem_p::text <> '' AND cd_convenio_destino_p IS NOT NULL AND cd_convenio_destino_p::text <> '') then	 
	open C01;
	loop 
	fetch C01 into	 
		c01_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		insert into proc_interno_conv( 
			nr_sequencia, nr_seq_proc_interno, dt_atualizacao, 
			nm_usuario, cd_convenio, cd_procedimento, 
			ie_origem_proced, cd_edicao_amb, ie_tipo_atendimento, 
			ie_situacao, dt_atualizacao_nrec, nm_usuario_nrec, 
			qt_procedimento, ie_origem_proc_filtro, cd_setor_atendimento, 
			cd_estabelecimento, ie_tipo_setor, dt_inicio_vigencia, dt_final_vigencia ) 
			 values ( 
			nextval('proc_interno_conv_seq'), c01_w.nr_seq_proc_interno, clock_timestamp(), 
			nm_usuario_p, cd_convenio_destino_p, c01_w.cd_procedimento, 
			c01_w.ie_origem_proced, c01_w.cd_edicao_amb, c01_w.ie_tipo_atendimento, 
			c01_w.ie_situacao, clock_timestamp(), nm_usuario_p, 
			c01_w.qt_procedimento, c01_w.ie_origem_proc_filtro, c01_w.cd_setor_atendimento, 
			c01_w.cd_estabelecimento, c01_w.IE_TIPO_SETOR, c01_w.dt_inicio_vigencia, c01_w.dt_final_vigencia );
		end;
	end loop;
	close C01;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copiar_proc_interno_conv ( cd_convenio_origem_p bigint, cd_convenio_destino_p bigint, nm_usuario_p text) FROM PUBLIC;
