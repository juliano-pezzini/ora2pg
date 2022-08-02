-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE rxt_copiar_transferir_agenda (cd_estabelecimento_p bigint, nr_seq_origem_p bigint, nr_seq_destino_p bigint, ie_acao_p text, nm_usuario_p text) AS $body$
DECLARE


/* variaveis registros */

cd_agenda_w                     		bigint;
cd_pessoa_fisica_w              	varchar(10);
hr_inicio_w			timestamp;
nr_minuto_duracao_w		bigint;
cd_medico_w                     		varchar(10);
nm_pessoa_contato_w             	varchar(50);
cd_procedimento_w               	bigint;
ds_observacao_w                 	varchar(2000);
cd_convenio_w                   		integer;
qt_idade_paciente_w             	smallint;
ie_origem_proced_w              	bigint;
ie_status_agenda_w              	varchar(3);
ds_senha_w                      		varchar(20);
nm_paciente_w                   		varchar(60);
nr_atendimento_w                	bigint;
cd_usuario_convenio_w           	varchar(30);
dt_agendamento_w		timestamp;
nm_usuario_orig_w		varchar(15);
qt_idade_mes_w                  	smallint;
cd_plano_w                      		varchar(10);
nr_telefone_w                   		varchar(80);
ie_autorizacao_w                		varchar(3);
vl_previsto_w                   		double precision;
nr_seq_age_cons_w               	bigint;
cd_medico_exec_w                	varchar(10);
nr_seq_classif_agenda_w         	bigint;
cd_procedencia_w                	integer;
cd_categoria_w                  		varchar(10);
cd_tipo_acomodacao_w            	smallint;
nr_doc_convenio_w             	  	varchar(20);
dt_validade_carteira_w          	timestamp;
nr_seq_proc_interno_w           	bigint;
nr_seq_status_pac_w           	  	bigint;
ie_lado_w                       		varchar(1);
ds_laboratorio_w                		varchar(80);
cd_doenca_cid_w                	 	varchar(10);
dt_nascimento_pac_w             	timestamp;
nr_seq_sala_w                  		bigint;
nm_medico_externo_w             	varchar(60);
ie_tipo_atendimento_w          	smallint;
cd_medico_req_w                 	varchar(10);
nr_seq_pq_proc_w                	bigint;
nr_seq_indicacao_w              	bigint;
cd_pessoa_indicacao_w           	varchar(10);
qt_prescricao_w			bigint;
nr_seq_proced_w			integer;
ds_cirurgia_w			varchar(500);
qt_peso_w			real;
nr_seq_status_pac_dest_w		bigint;
qt_altura_cm_w			real;
qt_autorizacoes_w			bigint;
ie_tipo_trat_w     varchar(1);

/* variaveis parametros */

ie_manut_proced_w		varchar(1);
ie_duracao_copia_w		varchar(1);
ie_duracao_transf_w		varchar(1);
ie_user_orig_transf_w		varchar(1);
ie_atend_copia_w			varchar(1);
ie_atend_transf_w			varchar(1);
ie_status_copia_w			varchar(1);
ie_status_transf_w			varchar(1);
nr_seq_status_pac_copia_w		bigint;
nr_seq_status_pac_transf_w		bigint;
ie_classif_orig_transf_w		varchar(1);
ie_canc_agenda_transf_w		varchar(1)	:= 'N';

/* variaveis complementares */

ie_manter_duracao_w		varchar(1) := 'N';
ie_manter_usuario_w		varchar(1) := 'N';
ie_manter_atend_w		varchar(1) := 'S';
ie_manter_status_w		varchar(1) := 'N';
cd_agenda_destino_w		bigint;
hr_destino_w			timestamp;

/* variaveis historico */

atrib_oldvalue_w			varchar(50);
atrib_newvalue_w			varchar(50);
IE_FORMA_AGENDAMENTO_w	bigint;

cd_empresa_ref_w	bigint;
cd_Setor_atendimento_w	integer;

nr_seq_tratamento_w	bigint;
nr_seq_equipamento_w	bigint;
dt_agenda_w		timestamp;
nr_seq_classif_w	bigint;
dt_tratamento_w		timestamp;
nr_seq_fase_w		bigint;
nr_seq_dia_w		bigint;
nr_seq_dia_fase_w	bigint;
ie_tipo_agenda_w	varchar(1);

nr_seq_fase_param_w	bigint;
nr_seq_dia_param_w      bigint;
nr_seq_dia_fase_param_w	bigint;
nr_seq_volume_w         bigint;
nr_seq_campo_roentgen_w bigint;

ie_considera_volume_w	varchar(1);

C01 CURSOR FOR
	SELECT	nr_seq_fase,
		nr_seq_dia,
		nr_seq_dia_fase,
		nr_seq_volume,
		nr_seq_campo_roentgen
	from	rxt_agenda_fase
	where	nr_seq_agenda_rxt = nr_seq_origem_p;


BEGIN

if (cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') and (nr_seq_origem_p IS NOT NULL AND nr_seq_origem_p::text <> '') and (nr_seq_destino_p IS NOT NULL AND nr_seq_destino_p::text <> '') and (ie_acao_p IS NOT NULL AND ie_acao_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then

	select	coalesce(max(ie_considera_tratamento_volume),'N')
	into STRICT	ie_considera_volume_w
	from 	rxt_parametro;

	/* obter dados origem */

	select	nr_seq_tratamento,
		nr_seq_equipamento,
		dt_agenda,
		ie_status_agenda,
		dt_agendamento,
		nr_seq_classif,
		nr_seq_fase,
		nr_seq_dia,
		nr_seq_dia_fase,
		ie_tipo_agenda,
		cd_pessoa_fisica,
		nr_atendimento,
		nr_minuto_duracao
	into STRICT	nr_seq_tratamento_w,
		nr_seq_equipamento_w,
		dt_agenda_w,
		ie_status_agenda_w,
		dt_agendamento_w,
		nr_seq_classif_w,
		nr_seq_fase_w,
		nr_seq_dia_w,
		nr_seq_dia_fase_w,
		ie_tipo_agenda_w,
		cd_pessoa_fisica_w,
		nr_atendimento_w,
		nr_minuto_duracao_w
	from	rxt_agenda
	where	nr_sequencia = nr_seq_origem_p;

	if (ie_acao_p = 'T') then
		begin
		if (ie_status_agenda_w = 'C') then
			CALL Wheb_mensagem_pck.exibir_mensagem_abort(248852);
		end if;

		end;
	end if;

	update	rxt_Agenda
	set	nr_seq_tratamento	= nr_seq_tratamento_w,
		--nr_seq_equipamento	= nr_seq_equipamento_w,
		ie_status_agenda	= CASE WHEN ie_acao_p='C' THEN 'M'  ELSE ie_status_agenda_w END ,
		nr_seq_classif		= nr_seq_classif_w,
		nr_seq_fase		= nr_seq_fase_w,
		nr_seq_dia		= nr_seq_dia_w,
		nr_seq_dia_fase		= nr_seq_dia_fase_w,
		ie_tipo_agenda		= ie_tipo_agenda_w,
		cd_pessoa_fisica	= cd_pessoa_fisica_w,
		nr_atendimento		= nr_atendimento_w,
		nr_minuto_duracao	= nr_minuto_duracao_w
	where	nr_sequencia		= nr_seq_destino_p;

	if (ie_considera_volume_w = 'S') then

		if (ie_acao_p = 'T') then


			open C01;
			loop
			fetch C01 into
				nr_seq_fase_param_w,
				nr_seq_dia_param_w,
				nr_seq_dia_fase_param_w,
				nr_seq_volume_w,
				nr_seq_campo_roentgen_w;
			EXIT WHEN NOT FOUND; /* apply on C01 */
				begin


				update	rxt_agenda_fase
				set	nr_seq_fase            = nr_seq_fase_param_w,
					nr_seq_dia             = nr_seq_dia_param_w,
					nr_seq_dia_fase        = nr_seq_dia_fase_param_w,
					nr_seq_volume          = nr_seq_volume_w,
					nr_seq_campo_roentgen  = nr_seq_campo_roentgen_w,
					nr_seq_agenda_rxt      = nr_seq_destino_p,
					nm_usuario	       = nm_usuario_p,
					dt_atualizacao	       = clock_timestamp()
				where	nr_seq_agenda_rxt      = nr_seq_origem_p;

				end;
			end loop;
			close C01;

		elsif (ie_acao_p = 'C') then

			insert into rxt_agenda_fase(nr_sequencia,
						    nr_seq_fase,
						    nr_seq_dia,
						    nr_seq_dia_fase,
						    nr_seq_volume,
						    nr_seq_campo_roentgen,
						    nr_seq_agenda_rxt,
						    nm_usuario_nrec,
						    nm_usuario,
						    dt_atualizacao_nrec,
						    dt_atualizacao)
					(SELECT	    nextval('rxt_agenda_fase_seq'),
						    nr_seq_fase,
						    nr_seq_dia,
						    nr_seq_dia_fase,
						    nr_seq_volume,
						    nr_seq_campo_roentgen,
						    nr_seq_destino_p,
						    nm_usuario_p,
						    nm_usuario_p,
						    clock_timestamp(),
						    clock_timestamp()
					from	rxt_agenda_fase
					where	nr_seq_agenda_rxt      = nr_seq_origem_p);

		end if;

	end if;

	if (ie_acao_p = 'T') then

	select coalesce(max(rxt_obter_tipo_trat_prot(nr_seq_protocolo)),'X')
	into STRICT ie_tipo_trat_w
	from rxt_tratamento
	where nr_sequencia = nr_seq_tratamento_w;

	if (ie_tipo_trat_w = 'B') then
		update RXT_BRAQ_CAMPO_APLIC_TRAT
		set nr_seq_agenda = nr_seq_destino_p
		where nr_seq_agenda = nr_seq_origem_p;
	end if;

	update	rxt_agenda
	set	ie_status_agenda	= 'C',
		dt_atualizacao		= clock_timestamp(),
		nm_usuario		= nm_usuario_p
	where	nr_sequencia 		= nr_seq_origem_p;

	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE rxt_copiar_transferir_agenda (cd_estabelecimento_p bigint, nr_seq_origem_p bigint, nr_seq_destino_p bigint, ie_acao_p text, nm_usuario_p text) FROM PUBLIC;

