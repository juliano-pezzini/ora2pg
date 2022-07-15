-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_corrigi_duplic_conta_sus ( nr_seq_protocolo_p bigint) AS $body$
DECLARE

 
 
nr_conta_origem_w		bigint;
nr_conta_destino_w		bigint;
nr_conta_aih_w			bigint;
cd_convenio_w			integer;
nr_atendimento_w		bigint;
qt_proc_w			integer	:= 0;
qt_mat_w			integer	:= 0;
qt_contas_w			integer	:= 0;
nr_sequencia_w			bigint;
nr_aih_w			bigint;
nr_seq_aih_w			bigint;
cd_convenio_parametro_w		integer;
cd_categoria_parametro_w	varchar(100);
dt_acerto_conta_w		timestamp;

 
C01 CURSOR FOR 
	SELECT	nr_interno_conta, 
		cd_convenio_parametro, 
		nr_atendimento 
	from	conta_paciente 
	where	nr_seq_protocolo	= nr_seq_protocolo_p 
	and	coalesce(ie_cancelamento::text, '') = '';

C02 CURSOR FOR 
	SELECT	nr_sequencia, 
		nr_aih, 
		nr_seq_aih 
	from	procedimento_paciente 
	where	nr_interno_conta	= nr_conta_origem_w 
	and	(nr_aih IS NOT NULL AND nr_aih::text <> '') 
	order by 2,3;


BEGIN 
 
OPEN C01;
LOOP 
FETCH C01 into 
	nr_conta_destino_w, 
	cd_convenio_w, 
	nr_atendimento_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
	select	count(*) 
	into STRICT	qt_contas_w 
	from 	conta_paciente 
	where	nr_atendimento 		= nr_atendimento_w 
	and 	nr_seq_protocolo	= nr_seq_protocolo_p;
 
	select	coalesce(max(nr_interno_conta),0) 
	into STRICT	nr_conta_origem_w 
	from	conta_paciente 
	where	ie_status_acerto	= 1 
	and	nr_atendimento		= nr_atendimento_w 
	and	cd_convenio_parametro	= cd_convenio_w 
	and	dt_mesano_referencia	> '11/02/2007' 
	and	obter_valor_conta(nr_interno_conta,0)	 > 0;
 
	if (nr_conta_origem_w	> 0) then	 
		if (qt_contas_w	= 1) then 
			CALL transferir_conta_paciente(nr_conta_origem_w, nr_conta_destino_w, 'Tasy');
			insert into log_tasy(dt_atualizacao, nm_usuario, cd_log, ds_log) 
				values (clock_timestamp(), 'Tasy', 688, 'Origem: ' || nr_conta_origem_w||' - Destino: '|| nr_conta_destino_w);
		elsif (qt_contas_w	> 1) then 
			select	cd_convenio_parametro, 
				cd_categoria_parametro, 
				dt_acerto_conta 
			into STRICT	cd_convenio_parametro_w, 
				cd_categoria_parametro_w, 
				dt_acerto_conta_w 
			from	conta_paciente 
			where	nr_interno_conta = nr_conta_destino_w;
 
			OPEN C02;
			LOOP 
			FETCH C02 into 
				nr_sequencia_w, 
				nr_aih_w, 
				nr_seq_aih_w;
			EXIT WHEN NOT FOUND; /* apply on c02 */
				begin 
				select	coalesce(max(nr_interno_conta),0) 
				into STRICT	nr_conta_aih_w 
				from	sus_aih 
				where	nr_aih 		= nr_aih_w 
				and	nr_sequencia	= nr_seq_aih_w;
 
				update	procedimento_paciente 
				set	nr_interno_conta	= nr_conta_aih_w, 
					cd_convenio 		= cd_convenio_parametro_w, 
					cd_categoria 		= cd_categoria_parametro_w, 
					dt_acerto_conta 	= dt_acerto_conta_w, 
					cd_motivo_exc_conta 	 = NULL, 
				    ds_compl_motivo_excon 	 = NULL, 
					nm_usuario 		= 'Tasy_Baca', 
					dt_atualizacao 		= clock_timestamp() 
				where	nr_interno_conta 	= nr_conta_origem_w 
				and	nr_sequencia		= nr_sequencia_w;
				end;
			END LOOP;
			CLOSE C02;
			insert into log_tasy(dt_atualizacao, nm_usuario, cd_log, ds_log) 
				values (clock_timestamp(), 'Tasy', 688, 'Origem: ' || nr_conta_origem_w||' - Destino: '|| nr_conta_destino_w);
		end if;
 
		select	count(*) 
		into STRICT	qt_proc_w 
		from	procedimento_paciente 
		where	nr_interno_conta	= nr_conta_origem_w;
 
		select	count(*) 
		into STRICT	qt_mat_w 
		from	material_atend_paciente 
		where	nr_interno_conta	= nr_conta_origem_w;
 
		if (qt_proc_w	= 0) and (qt_mat_w	= 0) then 
			delete from conta_paciente 
			where nr_interno_conta = nr_conta_origem_w;
			insert into log_tasy(dt_atualizacao, nm_usuario, cd_log, ds_log) 
			values (clock_timestamp(), 'Tasy', 689, 'Conta: ' || nr_conta_origem_w||' - Proc: '||qt_proc_w|| ' - Mat: ' ||qt_mat_w);
		end if;
	end if;
	commit;
	end;
END LOOP;
CLOSE C01;
 
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_corrigi_duplic_conta_sus ( nr_seq_protocolo_p bigint) FROM PUBLIC;

