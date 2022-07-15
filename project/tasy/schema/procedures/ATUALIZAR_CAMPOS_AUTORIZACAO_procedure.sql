-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_campos_autorizacao () AS $body$
DECLARE


/*
Variaveis da pessoa
*/
nr_atendimento_w		bigint;
nr_seq_agenda_w			    autorizacao_convenio.nr_seq_agenda%type;
nr_seq_agenda_consulta_w 	autorizacao_convenio.nr_seq_agenda_consulta%type;
nr_seq_gestao_w			bigint;
nr_seq_paciente_setor_w		bigint;
nr_seq_autorizacao_w		bigint;
cd_pessoa_fisica_w		varchar(10);
cd_pessoa_fisica_autor_w	varchar(10);
cd_estabelecimento_w		smallint;
nr_seq_age_integ_w		bigint;
nr_seq_autor_cirurgia_w		bigint;
contador_w			bigint:= 0;


/*
Variaveis da data
*/
dt_agenda_integ_w		timestamp;
dt_agenda_w			timestamp;
dt_agenda_consulta_w		timestamp;
dt_autorizacao_w		timestamp;

nr_seq_agenda_ww		    autorizacao_convenio.nr_seq_agenda%type;
nr_seq_agenda_consulta_ww	autorizacao_convenio.nr_seq_agenda_consulta%type;
nr_seq_age_integ_ww		bigint;
contador_ww			bigint;

C01 CURSOR FOR
	SELECT	nr_sequencia,
		nr_atendimento,
		nr_seq_agenda,
		nr_seq_agenda_consulta,
		nr_seq_gestao,
		nr_seq_paciente_setor,
		nr_seq_age_integ,
		cd_pessoa_fisica,
		nr_seq_autor_cirurgia,
		dt_autorizacao
	from	autorizacao_convenio where	((coalesce(cd_pessoa_fisica::text, '') = '') or (coalesce(cd_estabelecimento::text, '') = ''))
	and	((nr_atendimento IS NOT NULL AND nr_atendimento::text <> '') or (nr_seq_agenda IS NOT NULL AND nr_seq_agenda::text <> '') or (nr_seq_agenda_consulta IS NOT NULL AND nr_seq_agenda_consulta::text <> '') or (nr_seq_gestao IS NOT NULL AND nr_seq_gestao::text <> '') or (nr_seq_paciente_setor IS NOT NULL AND nr_seq_paciente_setor::text <> '') or (cd_pessoa_fisica IS NOT NULL AND cd_pessoa_fisica::text <> '') or (nr_seq_autor_cirurgia IS NOT NULL AND nr_seq_autor_cirurgia::text <> ''))
	order by dt_autorizacao desc,1,2,3,4,5,6 LIMIT 49999;


C02 CURSOR FOR
	SELECT	nr_seq_agenda,
		nr_seq_agenda_consulta,
		nr_seq_age_integ,
		dt_autorizacao
	from	autorizacao_convenio where	(((nr_seq_agenda IS NOT NULL AND nr_seq_agenda::text <> '') and coalesce(dt_agenda::text, '') = '') or ((nr_seq_agenda_consulta IS NOT NULL AND nr_seq_agenda_consulta::text <> '') and coalesce(dt_agenda_cons::text, '') = '') or ((nr_seq_age_integ IS NOT NULL AND nr_seq_age_integ::text <> '') and coalesce(dt_agenda_integ::text, '') = ''))
	order by dt_autorizacao desc, 1 LIMIT 49999;

BEGIN
open C01;
loop
fetch C01 into	
	nr_seq_autorizacao_w,
	nr_atendimento_w,
	nr_seq_agenda_w,
	nr_seq_agenda_consulta_w,
	nr_seq_gestao_w,
	nr_seq_paciente_setor_w,
	nr_seq_age_integ_w,
	cd_pessoa_fisica_autor_w,
	nr_seq_autor_cirurgia_w,
	dt_autorizacao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	
	if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') then
		begin
		select	cd_pessoa_fisica,
			cd_estabelecimento
		into STRICT	cd_pessoa_fisica_w,
			cd_estabelecimento_w
		from	atendimento_paciente
		where	nr_atendimento = nr_atendimento_w;
		exception
		when others then
			cd_pessoa_fisica_w 	:= null;
			cd_estabelecimento_w	:= null;
		end;
	elsif (nr_seq_agenda_w IS NOT NULL AND nr_seq_agenda_w::text <> '') then
		begin
		select	max(a.cd_pessoa_fisica),
			max(b.cd_estabelecimento)
		into STRICT	cd_pessoa_fisica_w,
			cd_estabelecimento_w
		from	agenda_paciente a,
			agenda b
		where	a.cd_agenda = b.cd_agenda
		and	a.nr_sequencia = nr_seq_agenda_w;
		exception
		when others then
			cd_pessoa_fisica_w 	:= null;
			cd_estabelecimento_w	:= null;
		end;
	elsif (nr_seq_agenda_consulta_w IS NOT NULL AND nr_seq_agenda_consulta_w::text <> '') then
		begin
		select	max(a.cd_pessoa_fisica),
			max(b.cd_estabelecimento)
		into STRICT	cd_pessoa_fisica_w,
			cd_estabelecimento_w
		from	agenda_consulta a,
			agenda b
 		where	nr_sequencia = nr_seq_agenda_consulta_w
		and	a.cd_agenda = b.cd_agenda;
		exception
		when others then
			cd_pessoa_fisica_w 	:= null;
			cd_estabelecimento_w	:= null;
		end;
	elsif (nr_seq_gestao_w IS NOT NULL AND nr_seq_gestao_w::text <> '') then
		begin
		select	cd_pessoa_fisica,
			cd_estabelecimento
		into STRICT	cd_pessoa_fisica_w,
			cd_estabelecimento_w
		from	gestao_vaga
		where	nr_sequencia = nr_seq_gestao_w;
		exception
		when others then
			cd_pessoa_fisica_w 	:= null;
			cd_estabelecimento_w	:= null;
		end;
	elsif (nr_seq_paciente_setor_w IS NOT NULL AND nr_seq_paciente_setor_w::text <> '') then	
		begin
		select 	cd_pessoa_fisica,
			cd_estabelecimento
		into STRICT	cd_pessoa_fisica_w,
			cd_estabelecimento_w
		from	paciente_setor
		where	nr_seq_paciente = nr_seq_paciente_setor_w;
		exception
		when others then
			cd_pessoa_fisica_w 	:= null;
			cd_estabelecimento_w	:= null;
		end;
	elsif (nr_seq_age_integ_w IS NOT NULL AND nr_seq_age_integ_w::text <> '') then
		begin
		select	cd_pessoa_fisica,
			cd_estabelecimento
		into STRICT	cd_pessoa_fisica_w,
			cd_estabelecimento_w
		from	agenda_integrada
		where	nr_sequencia = nr_seq_age_integ_w;
		exception
		when others then
			cd_pessoa_fisica_w 	:= null;
			cd_estabelecimento_w	:= null;
		end;
	elsif (cd_pessoa_fisica_autor_w IS NOT NULL AND cd_pessoa_fisica_autor_w::text <> '') then
		begin
		select	cd_estabelecimento
		into STRICT	cd_estabelecimento_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_autor_w;
		exception
		when others then			
			cd_estabelecimento_w	:= null;
		end;
		
	elsif (nr_seq_autor_cirurgia_w IS NOT NULL AND nr_seq_autor_cirurgia_w::text <> '') then
		begin
		select	cd_estabelecimento,
			cd_pessoa_fisica
		into STRICT	cd_estabelecimento_w,
			cd_pessoa_fisica_w
		from	autorizacao_cirurgia
		where	nr_sequencia = nr_seq_autor_cirurgia_w;
		exception
		when others then
			cd_pessoa_fisica_w 	:= null;
			cd_estabelecimento_w	:= null;
		end;
		
	end if;	
	
	if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') or (cd_estabelecimento_w IS NOT NULL AND cd_estabelecimento_w::text <> '') then
		
		update	autorizacao_convenio
		set	cd_estabelecimento = cd_estabelecimento_w,
			cd_pessoa_fisica   = cd_pessoa_fisica_w
		where	nr_sequencia       = nr_seq_autorizacao_w;
		
		CONTADOR_W := CONTADOR_W + 1;
		
		if (CONTADOR_W > 100) then
			begin
			commit;
			CONTADOR_W := 0;
			end;
		end if;
	end if;
	end;
end loop;
close C01;
commit;
contador_ww := 0;
open C02;
loop
fetch C02 into	
	nr_seq_agenda_ww,
	nr_seq_agenda_consulta_ww,
	nr_seq_age_integ_ww,
	dt_autorizacao_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin
	if (nr_seq_agenda_ww IS NOT NULL AND nr_seq_agenda_ww::text <> '') or (nr_seq_age_integ_ww IS NOT NULL AND nr_seq_age_integ_ww::text <> '') or (nr_seq_agenda_consulta_ww IS NOT NULL AND nr_seq_agenda_consulta_ww::text <> '') then
		
		if (nr_seq_agenda_ww IS NOT NULL AND nr_seq_agenda_ww::text <> '') then
			begin
			select	dt_agenda
			into STRICT	dt_agenda_w
			from	agenda_paciente
			where	nr_sequencia = nr_seq_agenda_ww;
			exception
			when others then
				dt_agenda_w := null;
			end;
			
			if (dt_agenda_w IS NOT NULL AND dt_agenda_w::text <> '') then
				update	autorizacao_convenio
				set	dt_agenda = dt_agenda_w
				where	nr_seq_agenda = nr_seq_agenda_ww;
			end if;
			
		end if;
		
		if (nr_seq_agenda_consulta_ww IS NOT NULL AND nr_seq_agenda_consulta_ww::text <> '') then
			begin
			select	dt_agenda
			into STRICT	dt_agenda_consulta_w
			from	agenda_consulta
			where	nr_sequencia = nr_seq_agenda_consulta_ww;
			exception
			when others then
				dt_agenda_consulta_w := null;
			end;
			if (dt_agenda_consulta_w IS NOT NULL AND dt_agenda_consulta_w::text <> '') then
			
				update	autorizacao_convenio
				set	dt_agenda_cons = coalesce(dt_agenda_cons,dt_agenda_consulta_w)
				where	nr_seq_agenda_consulta = nr_seq_agenda_consulta_ww;
				
			end if;
			
			
		end if;
		
		if (nr_seq_age_integ_ww IS NOT NULL AND nr_seq_age_integ_ww::text <> '') then
			begin
			select	dt_inicio_agendamento
			into STRICT	dt_agenda_integ_w
			from	agenda_integrada
			where	nr_sequencia = nr_seq_age_integ_ww;
			exception
			when others then
				dt_agenda_integ_w := null;
			end;
			if (dt_agenda_integ_w IS NOT NULL AND dt_agenda_integ_w::text <> '') then
			
				update	autorizacao_convenio
				set	dt_agenda_integ 	= coalesce(dt_agenda_integ,dt_agenda_integ_w)
				where	nr_seq_age_integ 	= nr_seq_age_integ_ww;
			
			end if;
			
		end if;
		
		
	end if;
	contador_ww := contador_ww + 1;
	
	if (contador_ww > 100) then
		begin
		commit;
		contador_ww := 0;
		end;
	end if;
	end;
end loop;
close C02;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_campos_autorizacao () FROM PUBLIC;

