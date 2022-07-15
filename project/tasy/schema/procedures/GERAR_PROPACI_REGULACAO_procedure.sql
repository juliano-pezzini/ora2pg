-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_propaci_regulacao ( nr_seq_eme_regulacao_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_sequencia_w		bigint;
nr_seq_proc_interno_w	bigint;
cd_procedimento_w	bigint;
qt_proced_w		integer;
ie_origem_proced_w	bigint;
nr_atendimento_w	bigint;
nr_seq_atepacu_w	bigint;
cd_setor_atend_w	integer;
dt_entrada_unidade_w	timestamp;
nr_seq_atend_unid_w	bigint;
cd_convenio_w		integer;
cd_categoria_w		varchar(10);
nr_seq_reg_proced_w	bigint;
ds_observacao_w		varchar(255);
ds_origem_w		varchar(80);
ds_destino_w		varchar(80);
					
C01 CURSOR FOR 
	SELECT	nr_seq_proc_interno, 
		cd_procedimento, 
		coalesce(qt_proced,1), 
		ie_origem_proced, 
		nr_sequencia 
	from	eme_regulacao_proced 
	where	nr_seq_serv_eme = nr_seq_eme_regulacao_p 
	and	coalesce(dt_liberacao::text, '') = '';
					

BEGIN 
 
if (nr_seq_eme_regulacao_p IS NOT NULL AND nr_seq_eme_regulacao_p::text <> '') then 
 
	select	substr(obter_eme_origem_destino(max(nr_seq_origem),'D'),1,80), 
		substr(obter_eme_origem_destino(max(nr_seq_destino),'D'),1,80) 
	into STRICT	ds_origem_w, 
		ds_destino_w 
	from	eme_reg_resposta 
	where	nr_seq_reg = nr_seq_eme_regulacao_p;
	 
	ds_observacao_w := wheb_mensagem_pck.get_texto(307500,'DS_ORIGEM='||ds_origem_w||';DS_DESTINO='||ds_destino_w);
	 
	select 	nr_atendimento 
	into STRICT	nr_atendimento_w 
	from	eme_regulacao 
	where	nr_sequencia = nr_seq_eme_regulacao_p;
	 
	select 	max(nr_sequencia) 
	into STRICT	nr_seq_atend_unid_w 
	from 	atend_paciente_unidade 
	where	nr_atendimento = nr_atendimento_w;
 
	select	cd_setor_atendimento, 
		dt_entrada_unidade, 
		nr_seq_interno 
	into STRICT	cd_setor_atend_w, 
		dt_entrada_unidade_w, 
		nr_seq_atepacu_w 
	from	atend_paciente_unidade 
	where	nr_atendimento = nr_atendimento_w 
	and	nr_sequencia = nr_seq_atend_unid_w;
 
	select	cd_convenio, 
		cd_categoria 
	into STRICT	cd_convenio_w, 
		cd_categoria_w 
	from	atendimento_paciente_v 
	where	nr_atendimento = nr_atendimento_w;
 
	open C01;
	loop 
	fetch C01 into	 
		nr_seq_proc_interno_w, 
		cd_procedimento_w, 
		qt_proced_w, 
		ie_origem_proced_w, 
		nr_seq_reg_proced_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		 
		if (nr_seq_proc_interno_w IS NOT NULL AND nr_seq_proc_interno_w::text <> '') then 
			SELECT * FROM Obter_Proc_Tab_Interno(nr_seq_proc_interno_w, null, nr_atendimento_w, null, cd_procedimento_w, ie_origem_proced_w, null, null) INTO STRICT cd_procedimento_w, ie_origem_proced_w;
		end if;
		 
		if (cd_procedimento_w IS NOT NULL AND cd_procedimento_w::text <> '') then 
			select nextval('procedimento_paciente_seq') 
			into STRICT nr_sequencia_w 
			;
			 
			insert into procedimento_paciente(nr_sequencia, 
						nr_atendimento,     
						dt_entrada_unidade, 
						cd_procedimento, 
						dt_procedimento, 
						qt_procedimento, 
						dt_atualizacao, 
						nm_usuario, 
						cd_setor_atendimento, 
						ie_origem_proced, 
						nr_seq_atepacu, 
						nr_seq_proc_interno, 
						cd_convenio, 
						cd_categoria, 
						nr_seq_reg_proced, 
						ds_observacao) 
					values (nr_sequencia_w, 
						nr_atendimento_w, 
						dt_entrada_unidade_w, 
						cd_procedimento_w, 
						clock_timestamp(), 
						qt_proced_w, 
						clock_timestamp(), 
						nm_usuario_p, 
						cd_setor_atend_w, 
						ie_origem_proced_w, 
						nr_seq_atepacu_w, 
						nr_seq_proc_interno_w, 
						cd_convenio_w, 
						cd_categoria_w, 
						nr_seq_reg_proced_w, 
						ds_observacao_w);
 
			CALL atualiza_preco_procedimento(nr_sequencia_w, cd_convenio_w, nm_usuario_p);
		end if;
		end;
	end loop;
	close C01;
 
	update	eme_regulacao_proced 
	set	dt_liberacao = clock_timestamp() 
	where	nr_seq_serv_eme = nr_seq_eme_regulacao_p;
end if;
	 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_propaci_regulacao ( nr_seq_eme_regulacao_p bigint, nm_usuario_p text) FROM PUBLIC;

