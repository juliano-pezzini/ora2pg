-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_gerar_proc_interno_unif (nm_usuario_p text) AS $body$
DECLARE

 
 
nr_seq_proc_interno_w		bigint;
cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
cd_proc_unif_w			bigint;
qt_reg_w				bigint;
nr_seq_proc_conv_w		bigint;
cd_convenio_w			integer;

c01 CURSOR FOR 
	SELECT	a.nr_seq_proc_interno, 
		a.cd_procedimento, 
		a.ie_origem_proced, 
		a.cd_convenio 
	from	proc_interno_conv a 
	where	a.ie_origem_proced in (2,3);


BEGIN 
 
open	c01;
loop 
fetch	c01 into 
	nr_seq_proc_interno_w, 
	cd_procedimento_w, 
	ie_origem_proced_w, 
	cd_convenio_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
 
	begin 
	select	cd_proc_unif 
	into STRICT	cd_proc_unif_w 
	from	sus_origem 
	where	cd_procedimento		= cd_procedimento_w 
	and	ie_origem_proced	= ie_origem_proced_w;
	exception 
		when no_data_found then 
		cd_proc_unif_w := 0;
	end;
 
	if (cd_proc_unif_w > 0) then 
	 
		select	count(*) 
		into STRICT	qt_reg_w 
		from	proc_interno_conv 
		where	cd_procedimento	= cd_proc_unif_w 
		and	cd_convenio	= cd_convenio_w;
 
		if (qt_reg_w	= 0) then 
			begin 
 
			select	nextval('proc_interno_conv_seq') 
			into STRICT	nr_seq_proc_conv_w 
			;
 
			insert	into proc_interno_conv(NR_SEQUENCIA, 
				NR_SEQ_PROC_INTERNO, 
				DT_ATUALIZACAO, 
				NM_USUARIO, 
				CD_CONVENIO, 
				CD_PROCEDIMENTO, 
				IE_ORIGEM_PROCED, 
				CD_EDICAO_AMB, 
				IE_TIPO_ATENDIMENTO, 
				IE_SITUACAO, 
				DT_ATUALIZACAO_NREC, 
				NM_USUARIO_NREC) 
			values (nr_seq_proc_conv_w, 
				nr_seq_proc_interno_w, 
				clock_timestamp(), 
				nm_usuario_p, 
				cd_convenio_w, 
				cd_proc_unif_w, 
				7, 
				null, null, 'A', clock_timestamp(), nm_usuario_p);
			end;
		end if;
	end if;
	end;
end loop;
close c01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_gerar_proc_interno_unif (nm_usuario_p text) FROM PUBLIC;
