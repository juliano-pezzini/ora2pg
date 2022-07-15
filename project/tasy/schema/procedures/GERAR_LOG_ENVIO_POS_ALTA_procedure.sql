-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_log_envio_pos_alta ( cd_pessoa_fisica_p text, nr_atendimento_p bigint, cd_medico_p text, ds_email_p text, nm_usuario_p text) AS $body$
DECLARE

 
nr_periodo_w		varchar(10);
ie_envio_w		varchar(1);
ds_observacao_w		varchar(255);
nr_seq_log_w		bigint;
nr_cirurgia_w		bigint;
dt_alta_w		timestamp;
qt_dif_atual_alta_w	integer;
ie_gravar_w		varchar(1);
qt_periodo_ref_w	integer;

C01 CURSOR FOR 
	SELECT	nr_cirurgia 
	from	cirurgia 
	where	nr_atendimento = nr_atendimento_p 
	order by nr_cirurgia;
				

BEGIN 
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then 
 
	select	dt_alta 
	into STRICT	dt_alta_w 
	from	atendimento_paciente 
	where	nr_atendimento = nr_atendimento_p;
	 
	qt_dif_atual_alta_w	:= clock_timestamp() - dt_alta_w;
	 
	if (qt_dif_atual_alta_w < 119) then 
	 
		qt_periodo_ref_w := trunc(qt_dif_atual_alta_w/30);
				 
		select	CASE WHEN count(*)=0 THEN 'S'  ELSE 'N' END  
		into STRICT	ie_gravar_w 
		from	cih_log_pos_alta 
		where	nr_atendimento = nr_atendimento_p 
		and	nr_periodo = qt_periodo_ref_w;
 
		select 	CASE WHEN obter_se_alta_obito(nr_atendimento_p)='S' THEN 'N' WHEN obter_se_alta_obito(nr_atendimento_p)='N' THEN 'S' END  
		into STRICT	ie_envio_w 
		;
		 
		if (ie_envio_w = 'N') then 
			ds_observacao_w := obter_desc_expressao(776977);
		else 
			ds_observacao_w := '';
		end if;
		 
		if (ie_gravar_w = 'S') then 
			select	nextval('cih_log_pos_alta_seq') 
			into STRICT	nr_seq_log_w 
			;
			 
			insert into cih_log_pos_alta(	nr_sequencia, 
							dt_atualizacao, 
							nm_usuario, 
							dt_atualizacao_nrec, 
							nm_usuario_nrec, 
							ie_situacao, 
							dt_log, 
							cd_medico, 
							ds_email, 
							cd_paciente, 
							nr_atendimento, 
							nr_periodo, 
							ie_envio, 
							ds_observacao) 
						values (	nr_seq_log_w, 
							clock_timestamp(), 
							nm_usuario_p, 
							clock_timestamp(), 
							nm_usuario_p, 
							'A', 
							clock_timestamp(), 
							cd_medico_p, 
							ds_email_p, 
							cd_pessoa_fisica_p, 
							nr_atendimento_p, 
							qt_periodo_ref_w, 
							ie_envio_w, 
							ds_observacao_w);
							 
			open C01;
			loop 
			fetch C01 into	 
				nr_cirurgia_w;
			EXIT WHEN NOT FOUND; /* apply on C01 */
				begin 
				insert into cih_log_pos_alta_cirurgia(	nr_sequencia, 
									dt_atualizacao, 
									nm_usuario, 
									dt_atualizacao_nrec, 
									nm_usuario_nrec, 
									nr_seq_log, 
									nr_cirurgia) 
								values (	nextval('cih_log_pos_alta_cirurgia_seq'), 
									clock_timestamp(), 
									nm_usuario_p, 
									clock_timestamp(), 
									nm_usuario_p, 
									nr_seq_log_w, 
									nr_cirurgia_w);
				end;
			end loop;
			close C01;
		end if;	
	end if;
end if;
	 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_log_envio_pos_alta ( cd_pessoa_fisica_p text, nr_atendimento_p bigint, cd_medico_p text, ds_email_p text, nm_usuario_p text) FROM PUBLIC;

