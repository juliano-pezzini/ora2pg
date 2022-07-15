-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_atendimento_triagem ( nr_seq_triagem_p bigint, nm_usuario_p text) AS $body$
DECLARE

					
nr_seq_classif_w		bigint;					
nr_atendimento_w		bigint;
dt_inicio_triagem_w		timestamp;
dt_fim_triagem_w		timestamp;
cd_pessoa_fisica_w		varchar(10);
nr_seq_queixa_w			bigint;
nr_seq_queixa_atend_w		bigint;	
cd_procedencia_atend_w		integer;
cd_procedencia_w		integer;
cd_setor_atend_w		integer;
cd_setor_atendimento_w		integer;
ie_tolife_w			varchar(1) := 'N';
nr_seq_earq_w			bigint;
gerar_motivo_lib_precaucao_w	varchar(1);
ie_isolamento_w			varchar(1);
cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;
qt_idade_w			bigint;
ie_gerar_alerta_w		varchar(1);	
ie_finalizar_triagem_w		varchar(10);

c01 CURSOR FOR
	SELECT nr_sequencia
	from   escala_earq
	where  nr_seq_triagem 	= nr_seq_triagem_p;

C02 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.nr_seq_motivo_isol,
		a.dt_inicio,
		a.nr_seq_precaucao,
		a.dt_liberacao
	from	atendimento_precaucao a
	where	a.nr_seq_triagem = nr_seq_triagem_p
	and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	order by a.nr_sequencia;

C03 CURSOR FOR
	SELECT	nr_seq_evento
	from	regra_envio_sms
	where	cd_estabelecimento	= wheb_usuario_pck.get_cd_estabelecimento
	and	ie_evento_disp = 'LCH'
	and	qt_idade_w between coalesce(qt_idade_min,0)	and coalesce(qt_idade_max,9999)
	and	coalesce(ie_situacao,'A') = 'A';
	
C04 CURSOR(nr_seq_atend_precaucao_p atendimento_precaucao.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia,
		a.cd_estabelecimento,
		a.cd_pessoa_fisica,
		a.dt_alerta,
		a.dt_atualizacao,
		a.nm_usuario,
		a.ds_alerta,
		a.ie_situacao,
		a.dt_fim_alerta,
		a.cd_funcao,
		a.dt_liberacao,
		a.dt_inativacao,
		a.nm_usuario_inativacao,
		a.ds_justificativa,
		a.nr_seq_precaucao
	from	alerta_paciente a
	where	a.nr_seq_precaucao = nr_seq_atend_precaucao_p
	and	a.ie_situacao = 'A'
	order by a.nr_sequencia;

BEGIN
/*Ao liberar a precaucao, gerar motivo de isolamento do atendimento*/

gerar_motivo_lib_precaucao_w := Obter_param_Usuario(281, 955, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, gerar_motivo_lib_precaucao_w);
ie_finalizar_triagem_w := Obter_param_Usuario(281, 1567, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_finalizar_triagem_w);

select	max(coalesce(obter_ultimo_atendimento(cd_pessoa_fisica),0)),
	max(nr_seq_classif),
	max(dt_inicio_triagem),
	max(dt_fim_triagem),
	max(cd_pessoa_fisica),
	coalesce(max(nr_seq_queixa),0),
	coalesce(max(cd_procedencia),0),
	coalesce(max(cd_setor_atendimento),0)
into STRICT	nr_atendimento_w,
	nr_seq_classif_w,
	dt_inicio_triagem_w,
	dt_fim_triagem_w,
	cd_pessoa_fisica_w,
	nr_seq_queixa_w,
	cd_procedencia_w,
	cd_setor_atendimento_w
from	triagem_pronto_atend
where	nr_sequencia = nr_seq_triagem_p;


select coalesce(max('S'), 'N')
into STRICT   ie_tolife_w
from   to_life_log_importacao
where  nr_atendimento = nr_atendimento_w;

if (nr_atendimento_w > 0) then

	select	coalesce(max(cd_procedencia),0),
			max(substr(obter_setor_atendimento(nr_atendimento),1,5)),
			coalesce(max(nr_seq_queixa),0)
	into STRICT	cd_procedencia_atend_w,
			cd_setor_atend_w,
			nr_seq_queixa_atend_w
	from	atendimento_paciente
	where	nr_atendimento = nr_atendimento_w;

	
	update  triagem_pronto_atend
	set     nr_atendimento     	= nr_atendimento_w--,
		--Ie_status_paciente	= 'A'	
	where   nr_sequencia       	= nr_seq_triagem_p;
	
	if (dt_inicio_triagem_w IS NOT NULL AND dt_inicio_triagem_w::text <> '') and (ie_finalizar_triagem_w <> 'N')	 then
		update  triagem_pronto_atend
		set     Ie_status_paciente	= 'A'	
		where   nr_sequencia       	= nr_seq_triagem_p;
		
	end if;
	
	if (cd_procedencia_w = 0) and (cd_procedencia_atend_w > 0) then
		update	triagem_pronto_atend
		set		cd_procedencia	= cd_procedencia_atend_w
		where	nr_sequencia 	= nr_seq_triagem_p;
	end if;
	
	if (cd_setor_atendimento_w = 0) then
		update	triagem_pronto_atend
		set		cd_setor_atendimento 	= cd_setor_atend_w
		where	nr_sequencia 	= nr_seq_triagem_p;
	end if;

	if (nr_seq_queixa_w = 0) and (nr_seq_queixa_atend_w > 0) then
		update	triagem_pronto_atend
		set		nr_seq_queixa = nr_seq_queixa_atend_w
		where	nr_sequencia = nr_seq_triagem_p;
	elsif (nr_seq_queixa_w <> 0) then
		update	atendimento_paciente
		set		nr_seq_queixa	= coalesce(nr_seq_queixa_w,nr_seq_queixa)
		where	nr_atendimento = nr_atendimento_w;
	end if;

	if (coalesce(dt_fim_triagem_w::text, '') = '') and (dt_inicio_triagem_w IS NOT NULL AND dt_inicio_triagem_w::text <> '') and (ie_finalizar_triagem_w <> 'N')	then
	
		update  triagem_pronto_atend
		set     dt_fim_triagem     	= clock_timestamp(),
				Ie_status_paciente	= 'A'
		where   nr_sequencia       	= nr_seq_triagem_p;
	end if;

	CALL atualiza_triagem_pep(nr_atendimento_w,nr_seq_triagem_p);
	
	update	atendimento_precaucao
	set	nr_atendimento = nr_atendimento_w
	where	nr_seq_triagem	= nr_seq_triagem_p;
	
	open c01;
	loop
	fetch c01 into	
		nr_seq_earq_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin

		update pep_item_pendente
		set	   nr_atendimento = nr_atendimento_w
		where  nr_seq_escala = nr_seq_earq_w
		and	   ie_escala = '94';
		
		end;
	end loop;
	close c01;

	if ie_tolife_w = 'N' then 
		if (dt_fim_triagem_w IS NOT NULL AND dt_fim_triagem_w::text <> '') and (nr_seq_classif_w IS NOT NULL AND nr_seq_classif_w::text <> '') and (dt_inicio_triagem_w IS NOT NULL AND dt_inicio_triagem_w::text <> '') then
			update	atendimento_paciente 
			set 	nr_seq_triagem 		= nr_seq_classif_w,
					dt_inicio_atendimento 	= dt_inicio_triagem_w,
					dt_fim_triagem		= dt_fim_triagem_w,
					dt_atualizacao		= clock_timestamp(),
					nm_usuario		= nm_usuario_p
			where	nr_atendimento		= nr_atendimento_w;
		else
			if (dt_fim_triagem_w IS NOT NULL AND dt_fim_triagem_w::text <> '') then
				update	atendimento_paciente 
				set 	dt_fim_triagem		= dt_fim_triagem_w,
						dt_atualizacao		= clock_timestamp(),
						nm_usuario		= nm_usuario_p
				where	nr_atendimento		= nr_atendimento_w;
			end if;
			if (nr_seq_classif_w IS NOT NULL AND nr_seq_classif_w::text <> '') then
				update	atendimento_paciente
				set 	nr_seq_triagem 		= nr_seq_classif_w,
						dt_atualizacao		= clock_timestamp(),
						nm_usuario		= nm_usuario_p
				where	nr_atendimento		= nr_atendimento_w;
			end if;
			if (dt_inicio_triagem_w IS NOT NULL AND dt_inicio_triagem_w::text <> '') then
				update	atendimento_paciente
				set 	dt_inicio_atendimento 	= dt_inicio_triagem_w,
						dt_atualizacao		= clock_timestamp(),
						nm_usuario		= nm_usuario_p
				where	nr_atendimento		= nr_atendimento_w;
			end if;			
		end if;
    end if;

	commit;
	
	update	atendimento_sinal_vital
	set      nr_atendimento 	= nr_atendimento_w
	where    cd_paciente 	= cd_pessoa_fisica_w
	and	coalesce(nr_Atendimento::text, '') = ''
	and	dt_sinal_vital between clock_timestamp() - interval '1 days' and clock_timestamp();
	
	
	update	evolucao_paciente
	set      nr_atendimento 	= nr_atendimento_w
	where    cd_pessoa_fisica 	= cd_pessoa_fisica_w
	and	coalesce(nr_Atendimento::text, '') = ''
	and	dt_evolucao between clock_timestamp() - interval '1 days' and clock_timestamp();
	
	cd_estabelecimento_w		:= wheb_usuario_pck.get_cd_estabelecimento;
	qt_idade_w			:= coalesce(obter_idade_pf(cd_pessoa_fisica_w,clock_timestamp(),'A'),0);
	
	for r_C02_w in C02 loop
		begin
			/*INICIO - Acoes realizadas ao Liberar_Informacao no PEP  Tag 609*/

			select 	max(coalesce(a.ie_isolamento, 'N')),
				max(coalesce(a.ie_gerar_alerta,'N'))
			into STRICT	ie_isolamento_w,
				ie_gerar_alerta_w
			from	cih_precaucao a
			where	a.nr_sequencia = r_C02_w.nr_seq_precaucao;

			if (ie_isolamento_w = 'S') then
				/*Para funcinar a atualizacao do atendimento na EUP apos o update, deve ser alterado o parametro 1148 da EUP para 'Sim'.*/

				update	atendimento_paciente
				set	ie_paciente_isolado = 'S',
					dt_atualizacao = clock_timestamp()
				where	nr_atendimento = nr_atendimento_w
				and	coalesce(ie_paciente_isolado, 'N') = 'N';
				
				if (coalesce(gerar_motivo_lib_precaucao_w, 'N') = 'S') and (r_C02_w.nr_seq_motivo_isol IS NOT NULL AND r_C02_w.nr_seq_motivo_isol::text <> '') then
					CALL gerar_motivo_isolamento(nr_atendimento_w, r_C02_w.nr_seq_motivo_isol, nm_usuario_p,
								'I', null, null, 
								null, r_C02_w.dt_liberacao, null, 
								r_C02_w.nr_sequencia, r_C02_w.nr_sequencia);
				end if;
			end if;
			
			CALL gerar_evento_isolamento(nr_atendimento_w, nm_usuario_p);
			/*FIM - Acoes realizadas ao Liberar_Informacao no PEP  Tag 609*/


			
			/* INICIO - Acoes realizadas na procedure liberar_informacao*/

			for r_C03_w in C03 loop
				begin
					begin
					CALL gerar_evento_precaucao(r_C03_w.nr_seq_evento, nr_atendimento_w, cd_pessoa_fisica_w, r_C02_w.nr_sequencia, nm_usuario_p);	
					exception
					when others then
						null;
					end;
				end;
			end loop;
			
			begin
			CALL gerar_lancamento_automatico(nr_atendimento_w, null, 559, nm_usuario_p, null, null, null, null, null, null);
			exception
			when others then
				null;
			end;
			/* FIM - Acoes realizadas na procedure liberar_informacao*/

			
			for r_C04_w in C04(r_C02_w.nr_sequencia) loop
				begin
				
				update	alerta_paciente
				set	ie_situacao = 'I',
					dt_fim_alerta = clock_timestamp(),
					dt_inativacao = clock_timestamp(),
					nm_usuario_inativacao = nm_usuario_p
				where	nr_sequencia = r_C04_w.nr_sequencia;
				
				insert into atendimento_alerta(
					nr_sequencia,
					nr_atendimento,
					dt_alerta,
					dt_atualizacao,
					nm_usuario,
					ds_alerta,
					ie_situacao,
					dt_fim_alerta,
					dt_liberacao,
					dt_inativacao,
					nm_usuario_inativacao,
					ds_justificativa,
					nr_seq_precaucao)
				values (
					nextval('atendimento_alerta_seq'),
					nr_atendimento_w,
					r_C04_w.dt_alerta,
					clock_timestamp(),
					r_C04_w.nm_usuario,
					r_C04_w.ds_alerta,
					'A',
					null,
					r_C04_w.dt_liberacao,
					null,
					null,
					null,
					r_C02_w.nr_sequencia);
				
				end;
			end loop;
			
		end;
	end loop;
	
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_atendimento_triagem ( nr_seq_triagem_p bigint, nm_usuario_p text) FROM PUBLIC;

