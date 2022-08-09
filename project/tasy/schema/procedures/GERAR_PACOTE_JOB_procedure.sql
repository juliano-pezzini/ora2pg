-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_pacote_job (nm_usuario_p text) AS $body$
DECLARE

			
ie_alta_w			varchar(1);
cd_convenio_regra_w		integer;
ie_tipo_atendimento_w		smallint;	
nr_interno_conta_w		bigint;
cd_convenio_conta_w		bigint;
cd_categoria_conta_w		varchar(10);
ie_permite_gerar_pacote_w	varchar(1);
nr_atendimento_w		bigint;
nr_seq_w_atend_pacote_w		bigint;
nr_seq_pacote_w			bigint;
nr_seq_proc_origem_w		bigint;
qt_job_auto_w			bigint;
ie_erro_w			varchar(1);
ie_prioridade_pacote_job_w	convenio_estabelecimento.ie_prioridade_pacote_job%type;
cd_estabelecimento_w		conta_paciente.cd_estabelecimento%type;
ie_prioridade_w			w_atendimento_pacote.ie_prioridade%type;
ie_prioridade_ant_w		w_atendimento_pacote.ie_prioridade%type;
SQL_C02_w			varchar(4000);

c02 REFCURSOR;
nr_interno_conta_ant_w		conta_paciente.nr_interno_conta%type;
ie_calcular_w       		varchar(1);

/*

OS 504887

*/
C01 CURSOR FOR
	SELECT	cd_convenio,
		ie_tipo_atendimento,
		ie_alta
	from	regra_pacote_automatico
	where	ie_situacao = 'A'
	order by cd_convenio,
		ie_tipo_atendimento;
		
C03 CURSOR FOR
	SELECT	nr_sequencia,
		nr_seq_pacote,
		nr_seq_proc_origem,
		coalesce(ie_prioridade, 999)
	from 	w_atendimento_pacote
	where 	nr_atendimento	= nr_atendimento_w
	and 	ie_erro_w = 'N'
	order by coalesce(ie_prioridade, 999);


BEGIN

open C01;
loop
fetch C01 into	
	cd_convenio_regra_w,
	ie_tipo_atendimento_w,
	ie_alta_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	ie_calcular_w := 'N';
	
	SQL_C02_w := ' select	a.nr_interno_conta, ' ||
		     '		a.cd_convenio_parametro,  ' ||
		     '		a.cd_categoria_parametro, ' ||
		     '		a.nr_atendimento, ' ||
		     '		a.cd_estabelecimento ' ||
		     ' from	conta_paciente a, ' ||
		     '		atendimento_paciente b ' ||
		     ' where	a.ie_status_acerto = 1 ' ||
		     ' and 	a.nr_atendimento = b.nr_atendimento' || 
		     ' and 	((( ''' || ie_alta_w || ''' = ''S'') and (b.dt_alta is not null)) or ((''' || ie_alta_w || ''' = ''N'') and (b.dt_alta is null)) or (''' || ie_alta_w || ''' = ''A'')) ' ||		     
		     ' and 	a.dt_mesano_referencia > sysdate - 90';
		
        if (ie_tipo_atendimento_w IS NOT NULL AND ie_tipo_atendimento_w::text <> '') then 
		SQL_C02_w := SQL_C02_w || 
      		     ' and 	b.ie_tipo_atendimento = ' || ie_tipo_atendimento_w;
	end if;

        if (cd_convenio_regra_w IS NOT NULL AND cd_convenio_regra_w::text <> '') then
		SQL_C02_w := SQL_C02_w || 
      		     ' and 	a.cd_convenio_parametro = ' || cd_convenio_regra_w;
	end if;

	SQL_C02_w := SQL_C02_w || 
		     ' order by a.nr_interno_conta ';
	
	open C02 for EXECUTE SQL_C02_w;
	loop
	fetch C02 into	
		nr_interno_conta_w,
		cd_convenio_conta_w,
		cd_categoria_conta_w,
		nr_atendimento_w,
		cd_estabelecimento_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		select	coalesce(max(ie_permite_gerar_pacote),'S')
		into STRICT	ie_permite_gerar_pacote_w
		from	categoria_convenio
		where  	cd_convenio  = cd_convenio_conta_w
		and    	cd_categoria = cd_categoria_conta_w;
		
		if (ie_permite_gerar_pacote_w = 'S') then
			begin
			
			select	coalesce(max(ie_prioridade_pacote_job), 'N')
			into STRICT	ie_prioridade_pacote_job_w
			from	convenio_estabelecimento
			where	cd_convenio	   = cd_convenio_conta_w
			and	cd_estabelecimento = cd_estabelecimento_w;
		
			ie_erro_w:= 'N';

			-- 1 - Listar os pacotes
			CALL calcular_pacote(nr_atendimento_w,
					nr_interno_conta_w,
					cd_convenio_conta_w,
					cd_categoria_conta_w,
					nm_usuario_p,
					'N',	-- ie_define_pacote_p
					'N',	-- ie_atualiza_procedimento_p
					'N',	-- ie_atualiza_material_p
					'N',	-- ie_ratear_valores_p
					'S');	-- ie_lista_pacote_p
			exception
				when others then
				ie_erro_w:= 'S';
			end;

			-- 2 - Marcar os pacotes que devem gerar e os que nao devem
			update	w_atendimento_pacote
			set 	ie_gerar = 'N'
			where 	nr_atendimento = nr_atendimento_w;
		
			if (nr_interno_conta_w <> nr_interno_conta_ant_w) then
				ie_prioridade_ant_w := null;
				ie_calcular_w := 'N';
			end if;
			
			open C03;
			loop
			fetch C03 into	
				nr_seq_w_atend_pacote_w,
				nr_seq_pacote_w,
				nr_seq_proc_origem_w,
				ie_prioridade_w;
			EXIT WHEN NOT FOUND; /* apply on C03 */
				begin
				
				if (coalesce(ie_prioridade_ant_w::text, '') = '') then
					ie_prioridade_ant_w := ie_prioridade_w;
				end if;
				
				if	(ie_prioridade_pacote_job_w <> 'N' AND ie_prioridade_w <> ie_prioridade_ant_w) and (ie_calcular_w = 'S') then
					if (ie_erro_w = 'N') then
						--3 Gerar os pacotes.
						begin
						
						ie_calcular_w := 'N';
						CALL calcular_pacote(nr_atendimento_w,
								nr_interno_conta_w,
								cd_convenio_conta_w,
								cd_categoria_conta_w,
								nm_usuario_p,
								'S',	-- ie_define_pacote_p
								'S',	-- ie_atualiza_procedimento_p
								'S',	-- ie_atualiza_material_p
								'S',	-- ie_ratear_valores_p
								'N');	-- ie_lista_pacote_p
						exception
							when others then
							ie_erro_w:= 'S';
						end;
						ie_prioridade_ant_w := ie_prioridade_w;
					end if;	
				end if;
					
				select	count(*)
				into STRICT	qt_job_auto_w
				from	procedimento_paciente a,
					pacote b
				where	a.nr_interno_conta = nr_interno_conta_w
				and 	a.nr_sequencia     = nr_seq_proc_origem_w
				and 	b.nr_seq_pacote    = nr_seq_pacote_w
				and 	b.cd_convenio 	   = cd_convenio_conta_w
				and 	a.cd_procedimento  = b.cd_proced_pacote
				and 	a.ie_origem_proced = b.ie_origem_proced
				and (coalesce(b.ie_prioridade::text, '') = '' or (ie_prioridade_pacote_job_w <> 'N' and coalesce(a.nr_seq_proc_pacote::text, '') = ''))
				and 	coalesce(b.ie_pacote_automatico,'N') = 'S';

				if (qt_job_auto_w > 0) then
					update	w_atendimento_pacote
					set 	ie_gerar = 'S'
					where 	nr_sequencia = nr_seq_w_atend_pacote_w
					and 	nr_seq_pacote = nr_seq_pacote_w
					and 	nr_seq_proc_origem = nr_seq_proc_origem_w
					and 	nr_atendimento = nr_atendimento_w;
					
					ie_calcular_w := 'S';
				end if;
				
				end;
			end loop;
			close C03;
			
			if	(ie_erro_w = 'N' AND (ie_calcular_w = 'S' or ie_prioridade_pacote_job_w = 'N')) then
			
				--3 Gerar os pacotes.
				begin
				
				CALL calcular_pacote(nr_atendimento_w,
						nr_interno_conta_w,
						cd_convenio_conta_w,
						cd_categoria_conta_w,
						nm_usuario_p,
						'S',	-- ie_define_pacote_p
						'S',	-- ie_atualiza_procedimento_p
						'S',	-- ie_atualiza_material_p
						'S',	-- ie_ratear_valores_p
						'N');	-- ie_lista_pacote_p				
				exception
					when others then
					ie_erro_w:= 'S';					
				end;	
				
			end if;
		end if;		
		end;
		nr_interno_conta_ant_w := nr_interno_conta_w;
	end loop;
	close C02;
	
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_pacote_job (nm_usuario_p text) FROM PUBLIC;
